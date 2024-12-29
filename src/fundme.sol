//SPDX-License-Identifier:MIT

pragma solidity ^0.8.24;

// importing required libraries
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {priceConvertor} from "./priceConvertor.sol";

// for modifier error on reverting
error notOwner();
error callFailed();

// Contract: A deployable unit of code that can hold state, interact with other contracts, and manage Ether.
contract FundMe{

    // uint256 variable can directly call the functions defined in the priceConvertor library as if they were methods of the uint256 type .
    //  ex - uint256 value = 100;  value.convert();
    using priceConvertor for uint256;
    
    // mimimum amount of eth required to fund
    uint256 public constant MIN_USD = 2e18 ;
    // creating an array of funders
    address[] public s_funder;   // we need the address variable to start with s_....
    // mapping is linking each funder with its amount sent
    mapping(address s_funder => uint256 amountFunded ) private s_addressToAmountFunded;
    // mapping(address => uint256) public addressToAmountFunded;   // another way of writing above line
    // initializing a private variable to store the price feed address
    AggregatorV3Interface private s_priceFeed;

    // using immutable makes variable more gas efficient
    // as owner is immutable so we will name it as i_owner
    address private immutable i_owner;  //setting this to immutable means can be set only once 
    
    // constructor to set the owner and price feed address on creation
    constructor(address priceFeed) {
        // owner is the one who deploys the contract
        i_owner = msg.sender;
        // priceFeed is the address of the price feed contract
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    // fundme contract is deployed by the owner and accept amount greater than 2USD
    function fund() public payable {
        // Converts the sent ETH (msg.value) to USD using the getConversionRate method from priceConvertor.
        require( msg.value.getConversionRate(s_priceFeed) >= MIN_USD , "you must send eth more than 0.0001 ETH atleast");  // 1e18 = 1 ETH
        // Adds the funder to the funder array 
        s_funder.push(msg.sender);
        // updates their funding amount in addressToAmountFunded.
        s_addressToAmountFunded[msg.sender] = s_addressToAmountFunded[msg.sender] + msg.value ;
    }

    // used modifier onlyOwner to restrict the access to the owner only (instead of require statement)
    function withdraw() public onlyOwner {
        // require( msg.sender == owner , "Only owner can access");
        // runs a loop for the array of funders and resets their amount funded to 0.
        uint256 funderLength =  s_funder.length;  // for gas optimisation
        for(uint256 funderIndex = 0 ; funderIndex < funderLength ; funderIndex++){
            address WithdrawFunder = s_funder[funderIndex] ;
            s_addressToAmountFunded[WithdrawFunder] = 0 ;
        }
        // resetting the funder array
        s_funder = new address[](0);


    // 3 ways to transfer the money to the owner

        // (i). transfer
                    //  1. transfers the entire balance of the contract to the msg.sender.
                    // 2.  automatically reverts if the transfer fails.
                    // 3.  gas limit of 2300
            // payable(msg.sender).transfer(address(this).balance);


        // (ii). send
                    // 1. sends the entire balance of the contract to the msg.sender.
                    // 2. returns a boolean indicating whether the transfer was successful.
                    // 3. does not automatically revert if the transfer fails. so need to handle failure using require
                    // 4. same 2300 gas limit as transfer
            // bool sendSuccess = payable(msg.sender).send(address(this).balance);
            // require(sendSuccess , "Send Failed");

        // (iii). call
                // 1. sends the entire balance of the contract to the msg.sender.
                // 2. returns a boolean indicating whether the transfer was successful.
                // 3. does not automatically revert if the transfer fails. so need to handle failure using require
                // 4. no gas limit

    // Conclusion - 
        // call is the most flexible and recommended method for transferring Ether, while transfer and send are simpler but have limitations due to the fixed gas stipend


        // call
        (bool callSuccess , ) = payable (msg.sender).call{value : address(this).balance }("");  // to withdraw the money
        // require(callSuccess , "Call Failed ");
        if(!callSuccess){  // more gas efficient then above lines of code
            revert callFailed();
        }
    }

    // returns the version i.e 4
    function getVersion() external view returns (uint256) {
        // AggregatorV3Interface getversion = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);   //etherium
        // AggregatorV3Interface getversion = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);  //zksync
        return  s_priceFeed.version();
    }
    
    // more gas optimised than require
    // modiifier for checking owner
    modifier onlyOwner() { 
        // can do by require
        // require(msg.sender == owner , "Only owner can access");
        if(msg.sender != i_owner ){
            // checking by if condition
            // if the msg.sender is not owner then revert the transaction
            revert notOwner(); 
        }
        // checks this onlyOwner first then runs the function in which it is included _;
        _;
        // we can also do ;_ to run the function first then checks the onlyOwner
    }

    // receive() is a special function that is executed when the contract receives ETH without a function call.(without data)
    receive() external payable {
        // so we are basically calling the fund function for this purpose to get the eth
        fund();
    }

    // fallback() is a special function that is executed when the contract receives ETH without a function call.(with data)
    fallback() external payable { 
        fund();
    }

    //                         msg.data
    //                         /      \
    //                    no data    with data
    //                    /              \
    //             receive()           fallback()   
    //            /        \
    //         yes          no
    // (receive present)    (if receive not present)
    //         /              \
    //    receive()            fallback()   



    //  getters

    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }
    function getFunder(uint256 index) external view returns (address) {
        return s_funder[index];
    } 
    function getOwner() external view returns (address) {
        return i_owner;
    }
}
