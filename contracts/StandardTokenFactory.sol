// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

import "./TokenFactoryBase.sol";

import "./interfaces/IStandardERC20.sol";

contract StandardTokenFactory is TokenFactoryBase {
    using Address for address payable;

    constructor(
        address factoryManager_,
        address implementation_,
        address initialOwner_
    ) TokenFactoryBase(factoryManager_, implementation_, initialOwner_) {}

    function create(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 totalSupply
    ) external payable enoughFee nonReentrant returns (address token) {
        refundExcessiveFee();
        payable(feeTo).sendValue(flatFee);
        token = Clones.clone(implementation);
        IStandardERC20(token).initialize(
            msg.sender,
            name,
            symbol,
            decimals,
            totalSupply
        );
        assignTokenToOwner(msg.sender, token, 0);
        emit TokenCreated(msg.sender, token, 0);
    }
}
