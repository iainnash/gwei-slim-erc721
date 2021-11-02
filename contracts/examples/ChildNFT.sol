// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import {DelegatedLogic} from "../base/DelegatedLogic.sol";
import {ERC721Base, ConfigSettings} from "../base/ERC721Base.sol";

import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

// this is the custom implementation logic and all the user has to deploy
contract ChildNFT is DelegatedLogic {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter public atId;

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
    {}

    function setup(string memory) public onlyOwner {
        base().setBaseURI("http://asdf.cmo/");
    }

    // How minting works
    function mint() external onlyOwner {
        base().mint(msg.sender, atId.current());
        atId.increment();
    }
}
