// SPDX-License-Identifier: GNU
pragma solidity 0.8.3;
//import { Bytecode } from "../utils/Bytecode.sol";
contract BruteForce{
    
    function stringToBytes32(string memory source) public pure returns (bytes32 result) {
    bytes memory tempEmptyStringTest = bytes(source);
    if (tempEmptyStringTest.length == 0) {
        return 0x0;
    }

    assembly {
        result := mload(add(source, 32))
    }
}   
    bytes32 pass = 0x0;
    function Guess(string calldata cPass) public returns(uint){
        uint numRuns = 0;
        bytes32 cPassE = stringToBytes32(cPass);
        while(keccak256(abi.encodePacked(pass)) != keccak256(abi.encodePacked(cPassE))){
            pass = bytes32(uint(pass) + 1);
            numRuns++;
        }
        return numRuns;
    }
}