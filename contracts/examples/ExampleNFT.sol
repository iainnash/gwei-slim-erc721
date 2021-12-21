// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import {ERC721Delegated} from "../base/ERC721Delegated.sol";
import {ConfigSettings} from "../base/ERC721Base.sol";

import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

// this is the custom implementation logic and all the user has to deploy
contract ExampleNFT is ERC721Delegated {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter public atId;

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
