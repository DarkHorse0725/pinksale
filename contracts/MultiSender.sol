// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MultiSender {
    using SafeERC20 for IERC20;

    function sendTokenToMany(
        IERC20 token,
        address payable[] memory recipients,
        uint[] memory amounts
    ) public {
        require(
            recipients.length == amounts.length,
            "Invalid number of recipients"
        );

        // Now send to multiple recipients
        for (uint i = 0; i < recipients.length; i++) {
            token.safeTransferFrom(msg.sender, recipients[i], amounts[i]);
        }
    }
}
