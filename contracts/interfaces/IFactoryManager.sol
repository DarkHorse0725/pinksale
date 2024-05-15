// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IFactoryManager {
  function assignTokensToOwner(address owner, address token, uint8 tokenType) external;
}