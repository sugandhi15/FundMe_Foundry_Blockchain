//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script ,console} from "forge-std/Script.sol";
import {FundMe} from "../src/fundme.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    
    function run() external returns (FundMe) {

        HelperConfig helperConfig = new HelperConfig();
        address PriceFeed = helperConfig.ActiveNetworkConfig();

        vm.startBroadcast();

        FundMe myFundMe = new FundMe(PriceFeed);

        vm.stopBroadcast();
        
        return myFundMe;
    }
    
}