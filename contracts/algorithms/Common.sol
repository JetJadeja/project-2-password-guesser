// SPDX-License-Identifier: GNU
pragma solidity 0.8.3;

import { Bytecode } from "../utils/Bytecode.sol";

/** 
    @title Common
*/
contract CommonGuess{
  function readPassword(address _addr, uint pos) public returns (string memory) {
    bytes32 bc = Bytecode.codeAt(_addr, pos*32, pos*32 + 31);
    return Bytecode.bytes32ToString(bc);
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