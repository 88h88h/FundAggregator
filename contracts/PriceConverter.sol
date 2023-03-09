// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
    function getPrice() internal view returns(uint256){
        // ABI - we get it using interface which is same as the import function written on top
        // Address of the contract we want to interact with which we get from chainlink data feed addresses of goerli test net 
        // eth/usd - 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        AggregatorV3Interface PriceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (, int256 price,,,) = PriceFeed.latestRoundData();
        // ETH in USD
        // 8 decimals
        return uint256(price*1e10); // 1 ** 10 = 10000000000
    }

    function getVersion() internal view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice*ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}