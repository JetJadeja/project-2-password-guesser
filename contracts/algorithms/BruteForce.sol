// SPDX-License-Identifier: GNU
pragma solidity 0.8.3;

contract BruteForce {
  bytes32 pass = 0x0;

  function Guess() public returns (bytes32) {
    pass = bytes32(uint256(pass) + 1);
    return pass;
  }
}
