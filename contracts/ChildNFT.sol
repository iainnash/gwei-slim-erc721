// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

import {DelegatedLogic} from "./DelegatedLogic.sol";
import {ILogicContract} from "./ILogicContract.sol";
import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import {ERC721BaseFactory} from './ERC721BaseFactory.sol';


// this is the custom implementation logic and all the user has to deploy
contract ChildNFT is ILogicContract, DelegatedLogic {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter public atId;

    constructor(
        ERC721BaseFactory baseFactory,
        string memory name,
        string memory symbol,
        uint16 royaltyBps
    ) DelegatedLogic(baseFactory, name, symbol, royaltyBps) {
        // // Set owner to contract creator
        // nftImplementation.transferOwnership(msg.sender);
        // // Set base URI
        // nftImplementation.setBaseURI("asdf");
        // // Set royalties
        // nftImplementation.setRoyaltyBPS(1000);
    }

    // Custom token uri if base uri is not set
    function implementationTokenURI(uint256 tokenId) public override view returns (string memory) {
        return string(abi.encodePacked("https://arweave-bucket?tokenId=", tokenId));
    }

    // How minting works
    function mint() external onlyBaseOwner {
        nftImplementation.mintFromLogic(msg.sender, atId.current());
        atId.increment();
    }
}
