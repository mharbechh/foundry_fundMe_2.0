// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockAggregator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address p_feed;
    }

    NetworkConfig public activeNetwork;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetwork = getSepoliaEthConfig();
        } else {
            activeNetwork = getAnvilorCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({p_feed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
    }

    function getAnvilorCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetwork.p_feed != address(0)) {
            return activeNetwork;
        }
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(8, 2500e8);
        vm.stopBroadcast();
        return NetworkConfig({p_feed: address(mockV3Aggregator)});
    }
}
