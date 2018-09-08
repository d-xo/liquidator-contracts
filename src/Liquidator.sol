pragma solidity ^0.4.24;

import "sai/tub.sol";
import "ds-math/math.sol";
import "ds-value/value.sol";

contract Liquidator is DSMath {

    SaiTub tub;
    uint256 public collateral;
    uint256 public debt;
    uint256 public price;
    uint256 public totalValue;
    uint256 public fee;
    uint256 public surplus;

    // five percent as a ray
    uint cut = 5 * 10 ** 25;

    constructor(SaiTub _tub) public {
        tub = _tub;
        tub.gem().approve(address(tub), uint256(-1));
        tub.skr().approve(address(tub), uint256(-1));
    }

    event Owner();
    event RetrievedData(uint collateral, uint debt, uint price);
    event Calucated(uint totalValue, uint fee, uint surplus);
    event Shut();
    event Transfered();

    function close(bytes32 _cup) public {
        // can only operate on cdps that it controls
        assert(tub.lad(_cup) == address(this));
        emit Owner();

        // calcuate surplus collateral
        collateral = tub.ink(_cup);
        debt = tub.tab(_cup);
        price = tub.tag();
        emit RetrievedData(collateral, debt, price);

        // dollars :)
        totalValue = rmul(collateral, price);
        fee = rmul(totalValue, cut);
        surplus = sub(sub(totalValue, fee), debt);
        emit Calucated(totalValue, fee, surplus);

        // close the cdp
        tub.shut(_cup);
        emit Shut();

        // transfer the surplus
        tub.skr().transfer(msg.sender, rdiv(surplus, price));
        emit Transfered();
    }
}
