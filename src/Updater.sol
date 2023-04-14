// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./IHeader.sol";
import "./LightClient.sol";

/**
 * @title Updater contract
 * @dev This contract exposes two main functions, add the header to the list of verified header, get a specified header
 */
contract Updater {

    address relayer;
    LightClient lightClient;
    address owner;
    uint public lastHeight;
    mapping(uint => IHeader.BlockHeader) public verifiedHeaders;

    constructor(address _relayer, address _lightClient, IHeader.BlockHeader memory _genesis) public {
        relayer = _relayer;
        owner = msg.sender;
        verifiedHeaders[_genesis.height] = _genesis;
        lastHeight = 0;
        lightClient = LightClient(_lightClient);
    }

    /**
    @dev only the relayer can continue
    */
    modifier onlyRelayer(){
        require(msg.sender == relayer);
        _;
    }

    /**
    @notice Append the header to the list of verified header after verifying the proof.
    @param proof the validity proof of the block header
    @param blkHr the block header to append
    @param blkHrmin the parent block header
    */
    function headerUpdate(bytes memory proof, IHeader.BlockHeader memory blkHr, IHeader.BlockHeader memory blkHrmin) public onlyRelayer {
        require(verifiedHeaders[blkHrmin.height].height == blkHrmin.height, "no block header parent known");
        require(verifiedHeaders[blkHr.height].height == blkHr.height, "a header with this height already exists");
        compareBlkHrs(blkHrmin, verifiedHeaders[blkHrmin.height]);
        bool result = lightClient.verifyProof(proof);
        require(result, "Proof cannot be verified");
        verifiedHeaders[blkHr.height] = blkHr;
        lastHeight = blkHr.height;
    }

    /**
    @dev compare two block headers
    @dev TODO more efficient/elegant way to compare structs in solidity
    */
    function compareBlkHrs(IHeader.BlockHeader memory blk1, IHeader.BlockHeader memory blk2) internal returns (bool){
        require(keccak256(abi.encodePacked(blk1.validators)) == keccak256(abi.encodePacked(blk2.validators)), "validators");
        require(blk1.height == blk2.height, "validators");
        // keccak256(abi.encodePacked(blk1.height, keccak256(blk1.validators));
    }

    /**
    @notice Get header from the verified headers list
    @param t height of the header to look for
    */
    function getHeader(uint t) public returns (IHeader.BlockHeader memory){
        require(verifiedHeaders[t].height == t, "no header verifier for this height, wait a bit");
        return verifiedHeaders[t];
    }
}
