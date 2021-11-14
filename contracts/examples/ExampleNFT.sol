// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import {DelegatedNFTLogic} from "../base/DelegatedNFTLogic.sol";
import {ERC721Base, ConfigSettings} from "../base/ERC721Base.sol";

import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

// this is the custom implementation logic and all the user has to deploy
contract ExampleNFT is DelegatedNFTLogic {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter public atId;

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
                uriBase: 'http://uri-test.com/',
                uriExtension: '',
                hasTransferHook: false
            })
        )
    {}

    // How minting works
    function mint() external onlyOwner {
        _mint(msg.sender, atId.current());
        atId.increment();
    }
}
