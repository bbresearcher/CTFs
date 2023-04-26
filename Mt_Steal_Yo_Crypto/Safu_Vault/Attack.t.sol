// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";



interface CheatCodes {
   // Gets address for a given private key, (privateKey) => (address)
   function addr(uint256) external returns (address);
}
contract AttackTest is Test {
    
    // Gets us accounts to interact with in foundry
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
    address attacker = cheats.addr(1);
    
    
    function setUp() public {
        
    }

    function testSafuVault() public {
        
    }

}
