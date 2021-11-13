// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import {DelegatedNFTLogic} from "../base/DelegatedNFTLogic.sol";
import {IBaseInterface} from "../base/IBaseInterface.sol";
import {ERC721Base, ConfigSettings} from "../base/ERC721Base.sol";

import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

/// This custom NFT contract stores additional metadata to use for tokenURI
contract ChildNFTOnChainData is DelegatedNFTLogic {
    uint256 public currentTokenId;
    mapping(uint256 => string) metadataJson;
    string testing = "super long string testing memory testing memory";

    constructor(
        ERC721Base baseFactory,
        string memory name,
        string memory symbol,
        uint16 royaltyBps
    )
        DelegatedNFTLogic(
            baseFactory,
            name,
            symbol,
            ConfigSettings({
                royaltyBps: royaltyBps,
                uriBase: "",
                uriExtension: "",
                hasTransferHook: false
            })
        )
    {}

    function mint(string memory nftMetadata) public {
        metadataJson[currentTokenId] = nftMetadata;
        _mint(msg.sender, currentTokenId++);
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
        metadataJson[tokenId] = "";
    }

    function getTesting() public view returns (string memory) {
        return testing;
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        return metadataJson[tokenId];
    }
}
