pragma solidity ^0.4.24;

import "ds-test/test.sol";

import "./Liquidator.sol";

contract LiquidatorTest is DSTest {
    Liquidator liquidator;

    function setUp() public {
        liquidator = new Liquidator();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
