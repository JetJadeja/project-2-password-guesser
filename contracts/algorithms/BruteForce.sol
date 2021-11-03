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
          break;
        }

        counter++;
      }
    }

    return (true, counter);
  }

}

/*
  
*/
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
  /*
  function guess(bytes memory password) external view returns (bool, uint256) {
    // Allocate memory to store the guessed password.
    bytes memory currentPassword = new bytes(password.length);
    
    // Locally store maxRuns to save gas,
    uint256 counter = 0;
  while (keccak256(abi.encodePacked(password)) != keccak256(abi.encodePacked(currentPassword))){
      for (uint256 i = 0; i < password.length; i++) {
          uint256 maxNumber = 1 << 8; //this equals 2^nBits or in java: Math.pow(2,nbits)
          //ArrayList<String> binaries = new ArrayList<>();
          for (uint j = 0; j < maxNumber; j++) {
              bytes1 binary = bytes1(uint8(j));
              while (binary.length != 8) {
                  binary = bytes1("0") ^ binary;
              }
              currentPassword[i+1] = binary;
          }
        }
      
    counter++;
  }
    return (false, counter);
  }
  */

