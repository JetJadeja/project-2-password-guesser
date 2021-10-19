// SPDX-License-Identifier: GNU
pragma solidity 0.8.3;

/* Internal Interfaces */
import { IGuesser } from "./interfaces/IGuesser.sol";

/**
    @title Guesser
    @author Connor Molinski and Jet Jadeja
    @notice Guesses passwords
*/
contract Guesser {
  function guess() external pure returns (uint256) {
    return 100;
  }
}
