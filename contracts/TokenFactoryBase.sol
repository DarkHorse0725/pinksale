// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "./interfaces/IFactoryManager.sol";

contract TokenFactoryBase is Ownable, ReentrancyGuard {
  using Address for address payable;

  address public factoryManager;
  address public implementation;
  address public feeTo;
  uint256 public flatFee;

  event TokenCreated(
      address indexed owner,
      address indexed token,
      uint8 tokenType
  );

  modifier enoughFee() {
    require(msg.value >= flatFee, "Flat fee");
    _;
  }

  constructor(address factoryManager_, address implementation_, address initialOwner_) Ownable(initialOwner_) {
    factoryManager = factoryManager_;
    implementation = implementation_;
    feeTo = msg.sender;
    flatFee = 10_000_000 gwei;
  }

  function setImplementation(address implementation_) external onlyOwner {
    implementation = implementation_;
  }

  function setFeeTo(address feeReceivingAddress) external onlyOwner {
    feeTo = feeReceivingAddress;
  }

  function setFlatFee(uint256 fee) external onlyOwner {
    flatFee = fee;
  }

  function assignTokenToOwner(address owner, address token, uint8 tokenType) internal {
    IFactoryManager(factoryManager).assignTokensToOwner(owner, token, tokenType);
  }

  function refundExcessiveFee() internal {
    uint256 refund = msg.value - flatFee;
    if (refund > 0) {
      payable(msg.sender).sendValue(refund);
    }
  }
}