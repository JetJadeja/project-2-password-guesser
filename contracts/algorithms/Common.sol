// SPDX-License-Identifier: GNU
pragma solidity 0.8.3;

import { SSTORE2, Bytecode } from "../libraries/SSTORE2.sol";

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
    @param password A byte array that represents the password that the algorithm must try to guess.
  */
  function guess(bytes memory password) external view returns (bool, uint256) {
    // Store value in memory to save gas.
    uint256 _listSize = listSize;

    for (uint256 i; i < _listSize; i++) {
      // Get the password from the list.
      bytes memory _password = readPassword(passwordList, i);

      if (keccak256(abi.encode(password)) == keccak256(abi.encode(_password))) {
        return (true, i + 1);
      }
    }

    return (false, _listSize);
  }

  /**
    @notice Deploy and set a new password list.
    @param passwords The password strings that are being stored.
  */
  function setPasswordList(bytes memory passwords, uint256 _listSize) external {
    // Write the data to the contract.
    passwordList = SSTORE2.write(passwords);
    listSize = _listSize;
  }

  /**
    @notice Read a 32 bit string from the password list contract address.
  */
  function readPassword(address addr, uint256 pos)
    internal
    view
    returns (bytes memory)
  {
    return SSTORE2.read(addr, pos * 32, pos * 32 + 32);
  }
}
