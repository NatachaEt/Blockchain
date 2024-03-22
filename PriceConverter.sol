// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
import "https://raw.githubusercontent.com/smartcontractkit/chainlink/develop/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
        function getPrice() view public returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer * 1e10);
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}