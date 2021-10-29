// SPDX-License-Identifier: GNU
pragma solidity 0.8.3;

import { Bytecode } from "../utils/Bytecode.sol";

contract Common {
  /** 
        @dev Adress of a contract that stores our password list.
        The list is stored in the contract bytecode, rather than storage
        so we only need to use EXTCODECOPY (The external code copy opcode)
        to access it, as storing and reading it from storage cost more.
    */
  address public passwordList;

  /**
    @dev The size of the password list.
  */
  uint256 public listSize;

  /**
    @notice Attempt to guess the password by testing it against other passwords stored in the password list.
    @param password The password that the algorithm must try to guess.
  */
  function guess(string memory password) external view returns (bool, uint256) {
    // Store value in memory to save gas.
    uint256 _listSize = listSize;

    for (uint256 i = 0; i < _listSize; i++) {
      // Get the password from the list.
      string memory _password = readPassword(passwordList, i);

      if (
        keccak256(abi.encodePacked(password)) ==
        keccak256(abi.encodePacked(_password))
      ) {
        return (true, i);
      }
    }
  }

  /**
    @notice Deploy and set a new password list.
    @param list An encoded list of passwords that will be converted to bytecode and read from.
  */
  function setPasswordList(bytes memory list, uint256 _listSize) external {
    bytes memory code = Bytecode.creationCodeFor(
      abi.encodePacked(hex"00", list)
    );

    address _passwordList;

    // Deploy contract using create
    assembly {
      _passwordList := create(0, add(code, 32), mload(code))
    }

    // Address MUST be non-zero
    if (_passwordList == address(0)) revert("Failed to deploy contract");

    passwordList = _passwordList;
    listSize = _listSize;
  }

  /**
    @notice Read a 32 bit string from the password list contract address.
  */
  function readPassword(address addr, uint256 pos)
    internal
    view
    returns (string memory)
  {
    bytes32 bc = Bytecode.codeAt(addr, pos * 32, pos * 32 + 31);
    return Bytecode.bytes32ToString(bc);
  }
}
