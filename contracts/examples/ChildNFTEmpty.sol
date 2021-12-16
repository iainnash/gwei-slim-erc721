// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import {ERC721Delegated} from "../base/ERC721Delegated.sol";
import {ConfigSettings} from "../base/ERC721Base.sol";

import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

/// This custom NFT contract is straight-forward
///   except for disabling the burn function by override
/// This uses the openzeppelin style solidity contract abi
contract ChildNFTEmpty is ERC721Delegated {
    constructor(
        address baseFactory,
        string memory name,
        string memory symbol,
        uint16 royaltyBps
    )
        ERC721Delegated(
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

    function adminMint() public onlyOwner {
        _mint(msg.sender, 1);
    }
}
