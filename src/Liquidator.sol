pragma solidity ^0.4.24;

import "sai/tub.sol";
import "ds-math/math.sol";
import "ds-value/value.sol";

contract Liquidator is DSMath {

    // sai-wad 0.05
    uint fivePercentWad = 0x00000000000000000000000000000000000000000000000000b1a2bc2ec50000;

    SaiTub tub;

    constructor(SaiTub _tub) public {
        tub = _tub;
    }

    function close(bytes32 _cup) public {
        // reject underwater cdps
        assert(tub.safe(_cup));

        // can only operate on cdps that it controls
        assert(tub.lad(_cup) == address(this));

        // calcuate surplus collateral
        uint collateral = tub.ink(_cup);
        uint debt = tub.tab(_cup);
        uint price = tub.tag();

        uint totalValue = wmul(collateral, price);
        uint fee = wmul(totalValue, fivePercentWad);

        uint surplus = sub(sub(totalValue, fee), debt);

        // close the cdp
        tub.shut(_cup);

        // transfer the surplus
        tub.skr().transfer(msg.sender, surplus);
    }
}
