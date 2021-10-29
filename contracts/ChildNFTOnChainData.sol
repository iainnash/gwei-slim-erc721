// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

import {DelegatedLogic} from "./DelegatedLogic.sol";
import {IBaseInterface} from "./IBaseInterface.sol";

import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

/// This custom NFT contract stores additional metadata to use for tokenURI
contract ChildNFTOnChainData is DelegatedLogic {
    uint256 public tokenId;
    mapping(uint256 => string) metadataJson;

    constructor(
        IBaseInterface baseFactory,
        string memory name,
        string memory symbol,
        uint16 royaltyBps
    ) DelegatedLogic(baseFactory, name, symbol, royaltyBps) {}

    function mint(string memory nftMetadata) public {
        metadataJson[tokenId] = nftMetadata;
        nftImplementation.mint(msg.sender, tokenId++);
    }

    function burn(uint256 tokenId) public {
        // Since this contract can do whatever, we need to ensure we _can_ first burn.
        require(nftImplementation.isApprovedOrOwner(msg.sender, tokenId));
        nftImplementation.burn(tokenId);
        metadataJson[tokenId] = "";
    }

    function tokenURI(uint256 tokenId) external returns (string memory) {
        return metadataJson[tokenId];
    }
}
