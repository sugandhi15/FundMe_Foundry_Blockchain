//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script , console} from "forge-std/Script.sol";
import {MockV3Aggregator} from "chainlink-brownie-contracts/contracts/src/v0.8/tests/MockV3Aggregator.sol";

// to manage price feed for different blockchain networks
contract HelperConfig is Script {

    NetworkConfig public ActiveNetworkConfig;

    uint8 public constant decimals =8;
    int256 public constant initialPrice = 2000e8;
    
    struct NetworkConfig {
        address priceFeed;
    }
    constructor() {
        if(block.chainid == 11155111) {
            ActiveNetworkConfig = getSepolia();
        }else if (block.chainid == 1) {
            ActiveNetworkConfig = getMainnetEth();
        } 
        else {
            ActiveNetworkConfig = getOrCreateAnvil();
        }
    }
    function getSepolia() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed : 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }
    function getMainnetEth() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetEthConfig = NetworkConfig({priceFeed : 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        console.log(mainnetEthConfig.priceFeed);
        return mainnetEthConfig;
    }
    function getOrCreateAnvil() public returns (NetworkConfig memory) {
        if(ActiveNetworkConfig.priceFeed != address(0)) {
            return ActiveNetworkConfig;
        }
        
        vm.startBroadcast();
        MockV3Aggregator mockv3 = new MockV3Aggregator(decimals,initialPrice);
        vm.stopBroadcast(); 
        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed : address(mockv3)});
        return anvilConfig;
    }
}