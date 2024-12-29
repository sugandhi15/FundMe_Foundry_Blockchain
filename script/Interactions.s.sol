//fund
//withdraw

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script , console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/fundme.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;
    function run() external {
        address mostRecent = DevOpsTools.get_most_recent_deployment("FundMe" , block.chainid);
        fundFundMe(mostRecent);
    }
    function fundFundMe(address mostRecent) public {
        vm.startBroadcast();
        FundMe(payable(mostRecent)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        // console.log("Funded FundMe contract at address: ", mostRecent);
    }
}

contract WithdrawFundMe is Script {
    function run() external {
        address mostRecent = DevOpsTools.get_most_recent_deployment("FundMe" , block.chainid);
        withdrawFundMe(mostRecent);
    }
    function withdrawFundMe(address mostRecent) public {
        
        vm.startBroadcast();
        FundMe(payable(mostRecent)).withdraw();
        vm.stopBroadcast();
        // console.log("Funded FundMe contract at address: ", mostRecent);
    }
}