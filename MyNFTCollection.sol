// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract MyNFTCollection is ERC721URIStorage, Ownable, Pausable {
    uint256 private _tokenIdCounter;

    event Minted(address indexed to, uint256 indexed tokenId, string tokenURI);

    constructor(address initialOwner) ERC721("MyNFTCollection", "MNFT") Ownable(initialOwner) {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mintNFT(address to, string memory tokenURI) public onlyOwner whenNotPaused {
        require(bytes(tokenURI).length > 0, "please, tokenURI cannot be empty");

        _tokenIdCounter++;
        uint256 newTokenId = _tokenIdCounter;

        _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, tokenURI);

        emit Minted(to, newTokenId, tokenURI);
    }

    function isOwnerOf(address owner, uint256 tokenId) public view returns (bool) {
        return ownerOf(tokenId) == owner;
    }

    function transferNFT(address from, address to, uint256 tokenId) public whenNotPaused {
        require(msg.sender == ownerOf(tokenId), "You're not the owner of this NFT");
        safeTransferFrom(from, to, tokenId);
    }
}
