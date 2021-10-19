// SPDX-License-Identifier: GNU
pragma solidity 0.8.3;

interface IAlgorithm {
  function run(bytes calldata) external returns (uint256);
}
