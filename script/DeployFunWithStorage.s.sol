// SPDX-Licnese-Identifier: MIT
pragma solidity ^0.8.19;

import {FunWithStorage} from "../src/FunWithStorage.sol";
import {Script} from "forge-std/Script.sol";

contract DeployFunWithStorage is Script {
    function run() external returns (FunWithStorage) {
        vm.startBroadcast();
        FunWithStorage funWithStorage = new FunWithStorage();
        vm.stopBroadcast();
        return funWithStorage;
    }
}
