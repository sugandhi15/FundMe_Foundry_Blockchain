//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe , WithdrawFundMe} from "../../script/Interactions.s.sol";


contract TestInteractions is Test{

    FundMe fundmeInstance;

    uint256 SEND_VALUE = 10e18;
    address USER = makeAddr("user");
    uint256 STARTING_BALANCE = 10 ether;

    function setUp() external {
        vm.deal(USER, STARTING_BALANCE);
        DeployFundMe deployFund = new DeployFundMe();
        fundmeInstance = deployFund.run();
    }

    function testUserCanFund() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundmeInstance));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundmeInstance)); 

        assert(address(fundmeInstance).balance == 0);
    }
}