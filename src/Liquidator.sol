pragma solidity ^0.4.24;

import 'sai/tub.sol';
import 'maker-otc/matching_market.sol';

contract Liquidator {

    MatchingMarket oasis;
    SaiTub tub;

    constructor(SaiTub _tub, MatchingMarket _oasis) public {
        tub = _tub;
        oasis = _oasis;
    }
}
