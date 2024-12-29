//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// Library: A reusable piece of code that is meant to be shared across contracts. Libraries cannot hold state and are generally stateless.
library priceConvertor{

    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
                // AggregatorV3Interface price = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);   // for sepolia
        //  to get the latest price of 1ETH in USD 
      ( ,int256 currPrice ,,,) = priceFeed.latestRoundData();   // latest round is a method of AggregatorV3Interface and returns lots of values but we only need the price.
        // The Chainlink price feeds typically return prices with 8 decimal places.
      return uint256(currPrice * 1e10) ; // so we multiply the price by 10^10 to get the price in eth
    }

    function getConversionRate(uint256 ethAmount ,AggregatorV3Interface priceFeed) internal view returns (uint256) {
      uint256 ethPrice = getPrice(priceFeed);    // getting the price of 1ETH in dollar from getPrice
          // multiplying the price of 1ETH in dollar with the amount of eth sent to get the amount in USD
          //  then dividing by 1e18 to get the amount in USD
      uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18 ;    
      return ethAmountInUSD ; 
    }
    
    // function getVersion() internal view returns (uint256) {
    //     AggregatorV3Interface getversion = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);   //etherium
    //     // AggregatorV3Interface getversion = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);  //zksync
    //     return  getversion.version();
    // }
    

}