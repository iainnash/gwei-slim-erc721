// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import {ERC721Delegated} from "../base/ERC721Delegated.sol";
import {ConfigSettings} from "../base/ERC721Base.sol";

import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

/// This custom NFT contract is straight-forward
///   except for disabling the burn function by override
/// This uses the openzeppelin style solidity contract abi
contract ChildNFTPausable is ERC721Delegated {
    bool paused;

    constructor(
        address baseFactory,
        string memory name,
        string memory symbol
    )
        ERC721Delegated(
            baseFactory,
            name,
            symbol,
            ConfigSettings({
                royaltyBps: 1000,
                uriBase: "",
                uriExtension: "",
                hasTransferHook: true
            })
        )
    {}

    modifier onlyUnpaused() {
        require(!paused, "Paused");
        _;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) public onlyUnpaused {
        // Stop transfers when paused
    }

    function setPaused(bool _paused) public onlyOwner {
        paused = _paused;
    }

    function mintAccess(uint256 tokenId) public onlyUnpaused {
        _mint(msg.sender, tokenId);
    }
}
