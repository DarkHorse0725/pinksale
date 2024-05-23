// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

abstract contract BaseToken {
    enum TokenType {
        standard,
        antiBotStandard,
        liquidityGenerator,
        antiBotLiquidityGenerator,
        baby,
        antiBotBaby,
        buybackBaby,
        antiBotBuybackBaby
    }
    event TokenCreated(
        address indexed owner,
        address indexed token,
        TokenType tokenType,
        uint256 version
    );
}
