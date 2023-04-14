// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract IUpdater {
    struct BlockHeader {
        uint height;
        address [] validators;
    }
}
