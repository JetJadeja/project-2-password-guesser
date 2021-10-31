// SPDX-License-Identifier: GNU
pragma solidity 0.8.3;

import "hardhat/console.sol";

contract Random {
  function guess(bytes memory password) external returns (bool, uint256) {
    // Allocate memory to store the guessed password.
    bytes memory currentPassword = new bytes(password.length);

    // Locally store maxRuns to save gas,
    uint256 counter = 0;

    for (uint256 i = 0; i < password.length; i++) {
      while (currentPassword[i] != password[i]) {
        bytes32 randomBytes = bytes32(gasleft());

        if (bytes32(gasleft())[31] == password[i]) {
          currentPassword[i] = bytes1(randomBytes[31]);
        }

        counter++;
      }
    }
  }
}
