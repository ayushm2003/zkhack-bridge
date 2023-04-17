// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract IHeader {
    struct BlockHeader {
        uint height;
        address [] validators;
    }
}
