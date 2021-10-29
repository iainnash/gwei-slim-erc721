// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import {DelegatedLogic} from "./DelegatedLogic.sol";
import {IBaseInterface} from "./IBaseInterface.sol";
import {ERC721Base} from "./ERC721Base.sol";

import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

/// This custom NFT contract is straight-forward
///   except for disabling the burn function by override
contract ChildNFTNoBurn is DelegatedLogic {
    constructor(
        ERC721Base baseFactory,
        string memory name,
        string memory symbol,
        uint16 royaltyBps
    ) DelegatedLogic(baseFactory, name, symbol, royaltyBps) {}

    function setup() public onlyOwner {
        base().setBaseURI("http://non-burnable.api/");
        base().mint(msg.sender, 0);
        base().mint(msg.sender, 1);
        base().mint(msg.sender, 2);
    }

    function burn(uint256) external pure {
        revert("Burn not allowed");
    }
}
