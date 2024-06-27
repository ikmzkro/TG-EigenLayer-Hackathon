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
    uint32 public latestTaskNum;

    function mint(
        address to
    ) public {
        uint256 tokenId = tokenIdTracker.current();
        _mint(to, tokenId);
        tokenIdTracker.increment();
        emit Minted(tokenId, to); // to or msg.sender
    }

    function createNewTask(
        uint256 tokenId,
        address owner,
        string memory uri
    ) external {
        // create a new task struct
        Task memory newMetadata;
        newMetadata.tokenId = tokenId;
        newMetadata.owner = owner;
        newMetadata.uri = uri;
        newMetadata.createdBlock = uint32(block.number);

        allMetadataTaskHashes[latestTaskNum] = keccak256(abi.encode(newMetadata));
        emit MetadataTaskCreated(latestTaskNum, newMetadata);
        latestTaskNum = latestTaskNum + 1;
    }

    function respondToTask(
        Task calldata task,
        uint32 referenceTaskIndex,
        bytes calldata signature
    ) external view returns (bytes32) {
        // Check that the task matches the recorded one
        require(
            keccak256(abi.encode(task)) == allTaskHashes[referenceTaskIndex],
            "Supplied task does not match the one recorded in the contract"
        );

        // Create metadata based on the task and signature
        bytes32 metadata = keccak256(abi.encodePacked(
            task.name,
            task.description,
            task.deadline,
            signature
        ));

        return metadata;
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