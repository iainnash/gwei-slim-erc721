// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import {DelegatedLogic} from "./DelegatedLogic.sol";
import {IBaseInterface} from "./IBaseInterface.sol";

import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

// this is the custom implementation logic and all the user has to deploy
contract ChildNFT is DelegatedLogic {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter public atId;

    constructor(
        IBaseInterface baseFactory,
        string memory name,
        string memory symbol,
        uint16 royaltyBps
    ) DelegatedLogic(baseFactory, name, symbol, royaltyBps) {}

    function setup(string memory) public onlyOwner {
        _setBaseURI("http://asdf.cmo/");
    }

    // How minting works
    function mint() external onlyOwner {
        _mint(msg.sender, atId.current());
        atId.increment();
    }
}
