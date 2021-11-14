// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import {DelegatedNFTLogic} from "../base/DelegatedNFTLogic.sol";
import {IBaseInterface, ConfigSettings} from "../base/ERC721Base.sol";

import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

/// This custom NFT contract is straight-forward
///   except for disabling the burn function by override
/// This uses the openzeppelin style solidity contract abi
contract ChildNFTNoBurn is DelegatedNFTLogic {
    constructor(
        IBaseInterface baseFactory,
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
                uriBase: "http://non-burnable.api/nft/",
                uriExtension: ".json",
                hasTransferHook: false
            })
        )
    {}

    function initialMint() public onlyOwner {
        // This can only be called once since re-mints will conflict.
        _mint(msg.sender, 0);
        _mint(msg.sender, 1);
        _mint(msg.sender, 2);
    }

    function burn(uint256) external pure {
        revert("Burn not allowed");
    }
}
