// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface INFTCreator {
    // EVENTS
    event Minted(uint256 tokenId, address owner);
    event MetadataTaskCreated(uint256 taskNum, Task metadata);

    // STRUCTS
    struct Task {
        uint256 tokenId;
        address owner;
        string uri;
        uint32 createdBlock;
    }

    // FUNCTIONS
    function mint(address to) external;
    function createNewTask(uint256 tokenId, address owner, string memory uri) external;
    function respondToTask(Task calldata task, uint32 referenceTaskIndex, bytes calldata signature) external view returns (bytes32);
}
