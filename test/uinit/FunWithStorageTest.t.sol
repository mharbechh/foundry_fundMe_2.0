// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {FunWithStorage} from "../../src/FunWithStorage.sol";
import {Test} from "forge-std/Test.sol";
import {DeployFunWithStorage} from "../../script/DeployFunWithStorage.s.sol";

contract FunWithStorageTest is Test {
    FunWithStorage public funWithStorage;

    function setUp() external {
        DeployFunWithStorage deployFunWithStorage = new DeployFunWithStorage();
        funWithStorage = deployFunWithStorage.run();
    }

    function testSlots() public {
        uint256 slotIndexOfArrayItem = uint256(keccak256(abi.encode(2)));
        uint256 hashingSlotMapping = uint256(keccak256(abi.encode(0, 3)));
        bytes32 value_slot0 = vm.load(address(funWithStorage), 0);
        bytes32 value_slot1 = vm.load(address(funWithStorage), bytes32(uint256(1)));
        bytes32 value_slot2 = vm.load(address(funWithStorage), bytes32(uint256(2)));
        bytes32 valueFirstArray = vm.load(address(funWithStorage), bytes32(slotIndexOfArrayItem));
        bytes32 valueRelatedToMapping = vm.load(address(funWithStorage), bytes32(hashingSlotMapping));
        assertEq(value_slot0, 0x0000000000000000000000000000000000000000000000000000000000000019);
        assertEq(value_slot1, 0x0000000000000000000000000000000000000000000000000000000000000001);
        assertEq(value_slot2, 0x0000000000000000000000000000000000000000000000000000000000000001);
        assertEq(valueFirstArray, 0x00000000000000000000000000000000000000000000000000000000000000de);
        assertEq(valueRelatedToMapping, 0x0000000000000000000000000000000000000000000000000000000000000001);
    }
}
