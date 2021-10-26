// SPDX-License-Identifier: GNU
pragma solidity 0.8.3;

import { Bytecode } from "../utils/Bytecode.sol";

/** 
    @title Common
*/
contract CommonGuess{
  function bytes32ToString(bytes32 x) public returns (string memory) {
    bytes memory bytesString = new bytes(32);
    uint charCount = 0;
    for (uint j = 0; j < 32; j++) {
        bytes1 char = bytes1(bytes32(uint(x) * 2 ** (8 * j)));
        if (char != 0) {
            bytesString[charCount] = char;
            charCount++;
        }
    }
    bytes memory bytesStringTrimmed = new bytes(charCount);
    for (uint j = 0; j < charCount; j++) {
        bytesStringTrimmed[j] = bytesString[j];
    }
    return string(bytesStringTrimmed);
}
  function readPasswordList(address _addr) public returns (string memory) {
    bytes32 bc = Bytecode.codeAt(_addr, 0, 32);
    string memory out = bytes32ToString(bc);
      
    return out;
  }
  
}
contract Common {
    /** 
        @dev Adress of a contract that stores our password list.
        The list is stored in the contract bytecode, rather than storage
        so we only need to use EXTCODECOPY (The external code copy opcode)
        to access it, as storing and reading it from storage cost more.
    */
    address public passwordList;

    function setPasswordList(bytes memory list) external  {    
    bytes memory code = Bytecode.creationCodeFor(
      abi.encodePacked(
        hex'00',
        list
      )
    );

    address _passwordList;

    // Deploy contract using create
    assembly {

         _passwordList := create(0, add(code, 32), mload(code))
     }

    // Address MUST be non-zero
    if (_passwordList == address(0)) revert("Failed to deploy contract");
        
    passwordList = _passwordList;
    
    }
}