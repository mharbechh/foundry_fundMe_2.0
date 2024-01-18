// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;
    address USER = makeAddr("sahbi");

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, 10 ether);
    }

    function testOwner() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testVersion() public {
        assertEq(fundMe.getVersion(), 4);
    }

    function testMinimumUsd() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testFundWithoutFund() public {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.fund();
    }

    function testFundWorked() public {
        vm.prank(USER);
        fundMe.fund{value: 1 ether}();
    }

    function testArrayUpdated() public funded {
        //use modifier of paul here and hoax when funded multiple
        assertEq(fundMe.getFunder(0), USER);
    }

    function testMappingUpdated() public funded {
        assertEq(fundMe.getAddressToValue(USER), 2e18);
    }

    function testWithdrawByOneFunder() public funded {
        //arrange
        uint256 fundMeStartBalance = address(fundMe).balance;
        uint256 ownerStartBalance = fundMe.i_owner().balance;
        //Act
        vm.prank(fundMe.i_owner());
        fundMe.withdraw();
        //assertion
        uint256 fundMeEndBalance = address(fundMe).balance;
        uint256 ownerEndBalance = fundMe.i_owner().balance;
        assertEq(fundMeEndBalance, 0);
        assertEq(ownerEndBalance, ownerStartBalance + fundMeStartBalance);
    }

    function testWithdrawFromMultipleFunders() public {
        uint160 starIndex = 1;
        uint256 totalFunders = 11;
        uint256 startOwnerBalance = fundMe.i_owner().balance;
        for (uint160 i = starIndex; i < totalFunders; i++) {
            hoax(address(i), 5 ether);
            fundMe.fund{value: 2 ether}();
        }
        vm.prank(fundMe.i_owner());
        fundMe.withdraw();
        assertEq(fundMe.i_owner().balance, startOwnerBalance + 20e18);
        assertEq(address(fundMe).balance, 0);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: 2 ether}();
        _;
    }
}

// testWithdrawFromMultipleFunders() (gas: 488464)
// testWithdrawFromMultipleFunders() (gas: 487668) more cheaper by loading storage var into memory and then used
