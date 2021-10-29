// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

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
    ) DelegatedLogic(baseFactory, name, symbol, royaltyBps) {
        nftImplementation.setBaseURI("ipfs://CID/");
    }

    // Custom token uri if base uri is not set
    // function tokenURI(uint256 tokenId) public override view returns (string memory) {
    //     return string(abi.encodePacked("https://arweave-bucket?tokenId=", tokenId));
    // }

    // How minting works
    function mint() external onlyOwner {
        nftImplementation.mint(msg.sender, atId.current());
        atId.increment();
    }
}
