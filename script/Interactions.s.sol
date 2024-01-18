// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function fundFundMe(address _mostRec) public {
        vm.startBroadcast();
        FundMe(payable(_mostRec)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("fund FundMe with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentDeploy = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRecentDeploy);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address _mostRec) public {
        vm.startBroadcast();
        FundMe(payable(_mostRec)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address mostDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostDeployed);
    }
}
