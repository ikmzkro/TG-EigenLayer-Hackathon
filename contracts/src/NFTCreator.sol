// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import { ERC721, Context } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Counters } from "@openzeppelin/contracts/utils/Counters.sol";
import { ERC2771Context } from "@openzeppelin/contracts/metatx/ERC2771Context.sol";
import { ERC721Enumerable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./INFTCreator.sol";
import "./INFTMetadataCreator.sol";

// NOTE: roleなしで実装
contract NFTCreator is
    ERC721,
    ERC721Enumerable,
    ERC2771Context
{
    constructor() ERC721("name", "symbol") {}

    using Counters for Counters.Counter;
    Counters.Counter private tokenIdTracker;

    function mint(address _to) public {
        uint256 tokenId = tokenIdTracker.current();
        _mint(_to, tokenId);
        tokenIdTracker.increment();
        emit Minted(tokenId, _to); // to or msg.sender
    }

    function createEvent(uint256 tokenId) external {
        address owner = ownerOf(tokenId);
        emit MetadataCreationRequested(tokenId, owner);
        metadataCreator.createMetadata(tokenId, owner);
    }

    /**
     * @dev
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}