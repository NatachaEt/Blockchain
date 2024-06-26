// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier minimumAmount {
        require(msg.value > 1e18, "The minimin amnout to send is 1 ETH");
        _;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You are not the owner !");
        _;
    }

    uint256 minimumUsd = 5e18;

    mapping (address funders => uint256 amounFunded) public fundedAmountBy;
    address[] public funders;

    receive() external payable {
        fund();
    }

    fallback() external payable { 
        fund();
    }

    function fund() public payable minimumAmount {
        require(msg.value.getConversionRate()> minimumUsd, "The minimum amnout to send is 5 USD");
        fundedAmountBy[msg.sender] = fundedAmountBy[msg.sender] + msg.value;
        funders.push(msg.sender);
    }

    function withdrawal() public onlyOwner {
        //Empty the mapping 'fundedAmountBy'
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            fundedAmountBy[funder] = 0;
        }
        funders = new address[](0);
 
        //As it returns nothing, we can write
        (bool successCall, ) = payable(msg.sender).call{value: address(this).balance}("");    
        require(successCall, "Call to send ETH failed");
    }


}