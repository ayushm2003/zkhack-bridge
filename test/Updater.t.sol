// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/IHeader.sol";
import "../src/Updater.sol";
import "../src/LightClient.sol";

contract UpdaterTest is Test {
    Updater public updater;
    mapping(uint => IHeader.BlockHeader) internal headers;
    LightClient lightClient;
    function setUp() public {
        address[] memory validators = new address[](1);
        validators[0] = address(this);
        IHeader.BlockHeader memory header = IHeader.BlockHeader({height : 0, validators : validators});
        headers[0] = header;
        lightClient = new LightClient();
        updater = new Updater(address(this),address(lightClient), header);
    }

    function testUpdateHeader() public {
        assertEq(updater.lastHeight(), 0);
        address[] memory validators = new address[](1);
        validators[0] = address(this);
        IHeader.BlockHeader memory header = IHeader.BlockHeader({height : 1, validators : validators});
        updater.headerUpdate("null", header, headers[0]);
        assertEq(updater.lastHeight(), 1);
    }
}
