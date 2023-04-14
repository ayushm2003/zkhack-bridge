// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Updater.sol";
import "../src/IUpdater.sol";

contract UpdaterTest is Test {
    Updater public updater;
    mapping(uint => IUpdater.BlockHeader) internal headers;

    function setUp() public {
        address[] memory validators = new address[](1);
        validators[0] = address(this);
        IUpdater.BlockHeader memory header = IUpdater.BlockHeader({height : 0, validators : validators});
        headers[0] = header;
        updater = new Updater(address(this), header);
    }

    function testUpdateHeader() public {
        assertEq(updater.lastHeight(), 0);
        address[] memory validators = new address[](1);
        validators[0] = address(this);
        IUpdater.BlockHeader memory header = IUpdater.BlockHeader({height : 1, validators : validators});
        updater.headerUpdate("null", header, headers[0]);
        assertEq(updater.lastHeight(), 1);
    }
}
