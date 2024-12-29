//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract fundmeTest is Test {
    // creating a fundme instance
    FundMe fundmeInstance;

    uint256 SEND_VALUE = 10e18;
    address USER = makeAddr("user");
    uint256 STARTING_BALANCE = 10 ether;
    // uint256 constant GAS_PRICE=1;

    //  writting test for fundMe
    
    // setting up the test
    function setUp() external {
        vm.deal(USER, STARTING_BALANCE);
        DeployFundMe deployFund = new DeployFundMe();
        fundmeInstance = deployFund.run();
    }
    
    function testMinDollar() public view {
        assertEq(fundmeInstance.MIN_USD(), 2e18);
    }
    // testing the owner of the contract
    function testIsOwner() public view {
        assertEq(fundmeInstance.getOwner(), msg.sender);
    }
    // testing the price feed address and version check
    function testVersionIsCorrect() public view {
        uint256 version = fundmeInstance.getVersion();
        if(block.chainid == 1) {
            assertEq(version, 6);
        } 
        else {
            assertEq(version, 4);
        }
    }
    // testing the fund function for money less than minimum amount
    function testFailDueToInsufficientFunds() public {
        vm.expectRevert("you must send eth more than 0.0001 ETH at least");
        fundmeInstance.fund();
    }
    // testing the funder is added to funders and returns the amount
    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        fundmeInstance.fund{value: SEND_VALUE}();
        uint256 amount = fundmeInstance.getAddressToAmountFunded(USER);
        assertEq(amount, SEND_VALUE);
    }
    function testAddFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundmeInstance.fund{value: SEND_VALUE}();
        address funder = fundmeInstance.getFunder(0);
        assertEq(funder, USER);
    }
    function testIfOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundmeInstance.withdraw();
    }
    modifier funded{
        vm.prank(USER);
        fundmeInstance.fund{value: SEND_VALUE}();
        _;
    }
    function testWithdrawByASingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundmeInstance.getOwner().balance;
        uint256 startingFunderBalance = address(fundmeInstance).balance;
        // Act
        // uint256 gasStart = gasleft();
        // vm.txGasPrice(GAS_PRICE);
        vm.prank(fundmeInstance.getOwner());
        fundmeInstance.withdraw();
        
        // uint256 gasEnd = gasleft();
        // uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        // console.log("Gas used: ", gasUsed);

        // Assert
        uint256 endingOwnerBalance = fundmeInstance.getOwner().balance;
        uint256 endingFunderBalance = address(fundmeInstance).balance;
        assertEq(endingFunderBalance , 0);
        assertEq(startingOwnerBalance + startingFunderBalance , endingOwnerBalance);
    }
    function testWithdrawByMultipleFunders() public funded {
        uint256 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;
        for(uint160 i=startingFunderIndex;i<numberOfFunders;i++){
            // vm.prank
            // vm.deal 
            hoax( address(i) , SEND_VALUE);
            // fund the fundmeInstance
            fundmeInstance.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundmeInstance.getOwner().balance;
        uint256 startingFunderBalance = address(fundmeInstance).balance;

        vm.startPrank(fundmeInstance.getOwner());
        fundmeInstance.withdraw();
        vm.stopPrank();

        uint256 endingOwnerBalance = fundmeInstance.getOwner().balance;
        uint256 endingFunderBalance = address(fundmeInstance).balance;

        assertEq(endingFunderBalance , 0);
        assertEq(startingOwnerBalance + startingFunderBalance , endingOwnerBalance);
    }
}

