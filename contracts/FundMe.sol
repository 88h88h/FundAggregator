// Get funds from user
// Withdraw funds 
// Set a minimum funding value in USD 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe{

    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 50 * 1e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable{
        // Payable keyword is used to make a function hold or transfer funds
        // Smart Contracts can hold funds just like a normal wallet
        // Want to be able to set a minimum fund amount in USD 
        // 1. How do we send ETH to this contract

        

        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough"); // require keyword checks if the condition is fulfilled or not
        // 18 decimals
        // msg.value checks the value container
        // require reverts if the condition is not met
        // Reverting is unoding any action and sending the remaining gas back

        funders.push(msg.sender); // msg.sender gives us the address of the wallet calling the function
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function Withdraw() public onlyOwner{
        

        for(uint256 funderIndex = 0;funderIndex < funders.length; ++funderIndex){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the array
        funders = new address[](0); // the number inside the () means the number of elements the array will contain

        // actually withdraw funds

        // transfer
        // msg.sender = address
        // payable(msg.sender) = payable address
       // payable(msg.sender).transfer(address(this).balance); // msg.sender gets the address of the person calling the function
        // address(this) gets address of this contract .balance gets it balance
        // transfer transfers that balance to msg.sender

        // transfer function is capped at 2300 gas and will revert the whole transaction if it fails

        // send
       // bool = sendSuccess = payable(msg.sender).send(address(this).balance); // send returns a bool if it is sent or not but will not revert
       // require(sendSuccess, "Send Failed"); // we'll have to add require to revert if send fails

        // call
        (bool callSuccess, ) = payable(msg.sender).call{value : address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    modifier onlyOwner{
        // require(msg.sender == i_owner, "Sender is not owner!"); 
        if(msg.sender != i_owner){
            revert NotOwner();  // more gas efficient way for errors is by using custom errors which uses if statement instead of require
        }
        _; // _ represents do all the statements in the function, if it is at the end then first all the statement in m
           // in the modifier will be executed and then rest of the statement of the function
           // but if its at the start then all the function statement will be executed and then all the modifier statements
    }

    // What would happen if someone tries to send ETH without calling the fund function

    receive() external payable{
        fund();
    }

    fallback() external payable{
        fund();
    }
}