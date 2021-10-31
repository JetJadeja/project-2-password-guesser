// SPDX-License-Identifier: GNU
pragma solidity 0.8.3;

interface IAlgorithm {
  function guess(bytes memory) external returns (bool, uint256);
}
