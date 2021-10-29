// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

import {DelegatedLogic} from "./DelegatedLogic.sol";
import {IBaseInterface} from "./IBaseInterface.sol";

import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

/// This custom NFT contract is straight-forward
///   except for disabling the burn function by override
contract ChildNFTNoBurn is DelegatedLogic {
    constructor(
        IBaseInterface baseFactory,
        string memory name,
        string memory symbol,
        uint16 royaltyBps
    ) DelegatedLogic(baseFactory, name, symbol, royaltyBps) {
        nftImplementation.setBaseURI("http://non-burnable.api/");
        nftImplementation.mint(msg.sender, 0);
        nftImplementation.mint(msg.sender, 1);
        nftImplementation.mint(msg.sender, 2);
    }

    function burn(uint256 tokenId) external {
        revert("Burn not allowed");
    }
}