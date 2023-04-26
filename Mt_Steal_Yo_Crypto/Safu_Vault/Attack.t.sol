// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Token.sol";
import "../src/SafuVault.sol";
import "../src/SafuStrategy.sol";


interface CheatCodes {
   // Gets address for a given private key, (privateKey) => (address)
   function addr(uint256) external returns (address);
}
contract AttackTest is Test {
    
    // Gets us accounts to interact with in foundry
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
    address attacker = cheats.addr(1);
    address admin = cheats.addr(2);
    address o1 = cheats.addr(3);
    address o2 = cheats.addr(4);
    address usdcAdmin = cheats.addr(5);
    Token usdcToken;
    SafuStrategy safuStrategy;
    SafuVault safuVault;
    
    function setUp() public {
        usdcToken = new Token("USDC","USDC");
        address[] memory  addr = new address[](2);
        uint256[] memory vals = new uint256[](2);
        addr[0] = attacker;
        addr[1] = admin;
        vals[0] = 10_000;
        vals[1] = 10_000;
        usdcToken.mintPerUser(addr,vals);

        vm.startPrank(admin);
        safuStrategy = new SafuStrategy(address(usdcToken));
        safuVault = new SafuVault(IStrategy(address(safuStrategy)),'LP Token','LP');
        safuStrategy.setVault(address(safuVault));
        usdcToken.approve(address(safuVault),type(uint256).max);
        safuVault.depositAll();
        vm.stopPrank();
    }

    function testSafuVault() public {
        

        uint256 totalfunds = usdcToken.balanceOf(address(safuVault)) + usdcToken.balanceOf(address(safuStrategy));
        assertLt(totalfunds,1000);
        assertGt(usdcToken.balanceOf(address(attacker)), 19000);
    }

}
