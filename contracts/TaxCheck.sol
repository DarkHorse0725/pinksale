// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TaxCheck {
    using SafeERC20 for IERC20;

    address public presaleTokenAddr;
    address public presale;
    uint256 public tokenBalance;

    constructor(
        address _presaleTokenAddr,
        address _presale,
        uint256 _tokenBalance
    ) {
        presaleTokenAddr = _presaleTokenAddr;
        presale = _presale;
        tokenBalance = _tokenBalance;
        IERC20(presaleTokenAddr).approve(presale, tokenBalance);
    }

    function transferBack() public {
        IERC20(presaleTokenAddr).safeTransfer(presale, tokenBalance);
    }
}
