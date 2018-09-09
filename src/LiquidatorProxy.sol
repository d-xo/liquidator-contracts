pragma solidity ^0.4.24;

import "sai/tub.sol";
import "ds-math/math.sol";
import "ds-value/value.sol";

import "./Liquidator.sol";

contract LiquidatorProxy is DSMath {
    function giveAndClose(address _tub, bytes32 cdpId, address _liquidator) public {
        SaiTub tub = SaiTub(_tub);
        Liquidator liquidator = Liquidator(_liquidator);

        tub.give(cdpId, liquidator);
        liquidator.close(cdpId);
    }
}
