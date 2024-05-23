// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./interfaces/IPresaleFactory.sol";

import "./Presale.sol";

contract PresaleGenerator is Ownable {
    using SafeERC20 for IERC20;
    event FeesUpdated(uint256 creationFee);

    struct PresaleParams {
        uint256 presaleRate;
        uint256 minSpendPerBuyer;
        uint256 maxSpendPerBuyer;
        uint256 softcap;
        uint256 hardcap;
        uint256 liquidityPercent;
        uint256 listingRate;
        uint256 startBlock; //unix timestamp
        uint256 endBlock; //unix timestamp
        uint256 lockPeriod; //unix timestamp
    }

    IPresaleFactory public presaleFactory;
    ISmartLockForwarder public smartLockForwarder;
    uint256 public creationFee;
    address public devAddr;
    bool private firstPresale;

    constructor(
        IPresaleFactory _presaleFactory,
        ISmartLockForwarder _smartLockForwarder,
        address _devAddr,
        address initialOwner
    ) Ownable(initialOwner) {
        presaleFactory = _presaleFactory;
        smartLockForwarder = _smartLockForwarder;
        devAddr = _devAddr;
        firstPresale = true;
    }

    function updateFees(uint256 _totalFee) public onlyOwner {
        creationFee = (_totalFee * 750) / 1000;

        emit FeesUpdated(creationFee);
    }

    function calculateAmountRequired(
        uint256 _hardcap,
        uint256 _presaleRate,
        uint256 _listingRate,
        uint256 _liquidityPercent,
        uint256 _baseDecimals
    ) internal pure returns (uint256) {
        uint256 amount = (_hardcap * _presaleRate) /
            uint256(10 ** _baseDecimals);
        uint256 liquidityRequired = (_hardcap * _liquidityPercent) /
            _listingRate /
            (10 ** (_baseDecimals + 3));
        uint256 tokensRequiredForPresale = amount + liquidityRequired;
        return tokensRequiredForPresale;
    }

    function createPresale(
        address payable _presaleOwner,
        IERC20 _presaleToken,
        IERC20Metadata _baseToken,
        uint256[10] memory uint_params
    ) public payable {
        //Presale Params
        PresaleParams memory params;
        params.presaleRate = uint_params[0];
        params.minSpendPerBuyer = uint_params[1];
        params.maxSpendPerBuyer = uint_params[2];
        params.softcap = uint_params[3];
        params.hardcap = uint_params[4];
        params.liquidityPercent = uint_params[5];
        params.listingRate = uint_params[6];
        params.startBlock = uint_params[7];
        params.endBlock = uint_params[8];
        params.lockPeriod = uint_params[9];

        require(msg.value == creationFee, "Wrong balance!");
        require(params.hardcap * params.presaleRate >= 10000, "Min divis");
        require(
            params.endBlock - params.startBlock <= 2 weeks,
            "Invalid start-end"
        );
        require(params.presaleRate * params.hardcap > 0, "Invalid params");
        require(params.listingRate > 0, "Invalid params");
        require(
            params.liquidityPercent >= 500 && params.liquidityPercent <= 1000,
            "liq > 50%"
        );
        require(params.softcap < params.hardcap, "SC < HC");
        require(params.lockPeriod >= 4 weeks, "Invalid lock");

        if (creationFee != 0) payable(devAddr).transfer(creationFee);
        if (!firstPresale) {
            require(params.hardcap <= params.softcap * 2, "Invalid params");
        }

        uint256 tokensForPresale = calculateAmountRequired(
            params.hardcap,
            params.presaleRate,
            params.listingRate,
            params.liquidityPercent,
            _baseToken.decimals()
        );

        Presale newPresale = new Presale(
            address(this),
            smartLockForwarder,
            address(_baseToken),
            payable(devAddr)
        );
        _presaleToken.safeTransferFrom(
            address(msg.sender),
            address(newPresale),
            tokensForPresale
        );

        require(
            _presaleToken.balanceOf(address(newPresale)) == tokensForPresale,
            "Transfer from failed!"
        );

        newPresale.initPresale1(
            params.presaleRate,
            params.minSpendPerBuyer,
            params.maxSpendPerBuyer,
            params.softcap,
            params.hardcap,
            params.liquidityPercent,
            params.listingRate,
            params.startBlock,
            params.endBlock,
            params.lockPeriod
        );

        uint256 presaleID = presaleFactory.presalesLength();
        newPresale.initPresale2(
            _presaleOwner,
            _presaleToken,
            address(_baseToken),
            presaleID
        );
        presaleFactory.registerPresale(address(newPresale));
        firstPresale = false;
    }
}
