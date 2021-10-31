// SPDX-License-Identifier: GNU
pragma solidity 0.8.3;

import { Bytecode } from "../libraries/utils/Bytecode.sol";

contract BruteForce {
  /** @notice Use a brute force algorithm to guess the password. */
  function guess(bytes memory password) external view returns (bool, uint256) {
    // Allocate memory to store the guessed password.
    bytes memory currentPassword = new bytes(password.length);

    // Locally store maxRuns to save gas,
    uint256 counter = 0;

    for (uint256 i = 0; i < password.length; i++) {
      for (uint8 j = 0; j < 255; j++) {
        if (bytes1(j) == password[i]) {
          currentPassword[i] = bytes1(j);
        }

        counter++;
      }
    }

    return (true, counter);
  }

  // function Guess(string memory password) public returns (bool, uint256) {
  //   bytes32 pass;

  //   uint256 numRuns = 0;
  //   bytes32 encodedPassword = Bytecode.bytesToBytes32(bytes(password));

  //   while (
  //     keccak256(abi.encodePacked(pass)) !=
  //     keccak256(abi.encodePacked(encodedPassword))
  //   ) {
  //     pass = bytes32(pass + 0x01);
  //     numRuns++;
  //   }

  //   return (true, numRuns);
  // }
}
