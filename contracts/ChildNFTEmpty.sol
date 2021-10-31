// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import {DelegatedLogic} from "./DelegatedLogic.sol";
import {IBaseInterface} from "./IBaseInterface.sol";
import {ERC721Base, ConfigSettings} from "./ERC721Base.sol";

import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

/// This custom NFT contract is straight-forward
///   except for disabling the burn function by override
/// This uses the openzeppelin style solidity contract abi
contract ChildNFTEmpty is DelegatedLogic {
    constructor(
        ERC721Base baseFactory,
        string memory name,
        string memory symbol,
        uint16 royaltyBps
    )
        DelegatedLogic(
            baseFactory,
            name,
            symbol,
            ConfigSettings(royaltyBps, false)
        )
    { }

    function adminMint() public onlyOwner {
        _mint(msg.sender, 1);
    }
}
