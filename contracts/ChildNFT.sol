// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

import {ProxyUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/ProxyUpgradeable.sol";

// this is the custom implementation logic and it's all the user has to deploy

contract LogicContract is ILogicContract, ProxyUpgradeable {
  constant feeBps = 1000;
  IBaseInterface immutable public nftImplementation;
  using CountersUpgradeable for CountersUpgradeable.Counter;
  CountersUpgradeable.Counter public atId;

  // This sets the implementation logic to be the base NFT contract created prior
  function _implementation() override returns (address) {
    return nftImplementation;
  }

  constructor() {
    nftImplementation = IBaseInterface(BASE_ADDRESS);
    // Set owner to contract creator
    nftImplementation.transferOwnership(msg.sender);
    // Set base URI
    nftImplementation.setBaseURI("asdf");
    // Set royalties
    nftImplementation.setRoyaltyBPS(1000);
  }
  
  // Custom token uri if base uri is not set
  function tokenURI(uint256 tokenId) public returns (string memory) {
    return abi.encodePacked("https://arweave-bucket?tokenId=", tokenId);
  }

  // How minting works
  function mint() external onlyOwner returns {
    nftImplementation.mintFromLogic(msg.sender, atId.current());
    atId.increment();
  }

}