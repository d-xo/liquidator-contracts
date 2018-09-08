pragma solidity ^0.4.24;

import "sai/tub.sol";
import "ds-math/math.sol";
import "ds-value/value.sol";

contract Liquidator is DSMath {

    SaiTub tub;

    // five percent
    uint cut = 5 * 10 ** 16;

    constructor(SaiTub _tub) public {
        tub = _tub;
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
        uint collateral = tub.ink(_cup);
        uint debt = tub.tab(_cup);
        uint price = tub.tag();
        emit RetrievedData(collateral, debt, price);

        uint totalValue = wmul(collateral, price);
        uint fee = wmul(totalValue, cut);
        uint surplus = sub(sub(totalValue, fee), debt);
        emit Calucated(totalValue, fee, surplus);

        // close the cdp
        tub.shut(_cup);
        emit Shut();

        // transfer the surplus
        tub.skr().transfer(msg.sender, surplus);
        emit Transfered();
    }
}
