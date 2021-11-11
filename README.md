# Save on ⛽️ writing custom NFT contracts

| Contract | Deploy GWEI | % of block size |
| :---: | :---: | :---: |
| `OptimizedChildNFT` | **501,064** | 1.6% |
| `ERC721Base` | 1,614,646 | 5.4%

Deploy [your own](/contracts/examples/ChildNFTOnChainData.sol) on-chain metadata NFT contract for only ~500k gwei.

For most NFT projects, the base 80% of NFT code is unchanged from OpenZeppelin. A transparent factory pattern works well when the implementation used is identical between NFT contracts, but what about custom logic and overriding certain portions of standard behavior? 

This proxy pattern uses a solidity fallback to call into OpenZeppelin contract code for any undefined functions. When your NFT contract code calls these functions, permission is granted since the contract itself is the caller.

`[YourNft] => fallback [BaseNFT]`

Any functions on ChildNFT override the default behavior of the standard Openzeppelin ERC721 code. To add logic before or after these functions, the standard `_mint`, `_burn` and main NFT functions can be accessed by using the `base()` getter. This logic is all in `DelegatedLogic` contract.

The standard base contract code is loaded in using the `delegatecall()` pattern.

A few common additional features for NFT series are included:
1. ERC2981 royalties
2. BaseURI and tokenID string generation for fixed-sized collections. 
3. Syntax sugar has been added for calling openzeppelin standard `_` private functions from the contract implementing DelegatedLogic itself.

The deployed base contract OpenZeppelin code can be used to be the underlying implementation for many, many NFT contracts.

## Getting started

1. Clone this repository (will publish on NPM after further review)
2. Choose a contract to start off in the [`/contracts/examples/`](/contracts/examples) folder
3. Update the deploy folder with your contract information
4. Set base NFT contract address in [`hardhat.config.ts`](/hardhat.config.ts)
5. `hardhat deploy --network NETWORK --tags MY_CONTRACT` replacing YOUR_CONTRACT with your contract and NETWORK with the desired network.

## What still needs to be done?

1. Better testing and security review
2. Deploy `ERC721Base` to mainnet and update address of deployment in this repo.

## Current Deployments:

- Mainnet: Not yet

- Rinkeby: [0x3Be479A0e8D5732BE5051Bfe6833CC98722f2C1b](https://rinkeby.etherscan.io/address/0x3Be479A0e8D5732BE5051Bfe6833CC98722f2C1b)

## Example Contract Deployed

- child implementation: https://rinkeby.etherscan.io/address/0x83FA6bfdF5920816a4cF9230D32049372F6E06eA

- base: https://rinkeby.etherscan.io/address/0x3Be479A0e8D5732BE5051Bfe6833CC98722f2C1b

## How do I get started?

1. Clone this repo
2. Update your desired ChildNFT class
3. Delete all unused ChildNFT examples and deployments
4. Add address to deployed base ERC721Base to `hardhat.config.ts`
4. `hardhat deploy --network rinkeby --tags ChildNFT`

## Features

Things you now can get for no additional gas when writing your own NFT contracts:

0. 3.5x (!) lower deployment cost in gas
1. ERC2981 built-in option to enable, more complex usages can override the reading function
2. URI + ID functionality built-in, able to override and reset base URIs
3. Ability to gate transfer, burn, mint, or disable certain functionality when needed
4. `totalSupply` without full enumerable interface implementation
5. More legible "special" functionality on top of base NFT contract for readers
6. Ability to verify contracts and add custom comments functionality without being beholden to a factory contract's rules.

## Gotchyas

1. ABIs need to be combined manually or use both contract interfaces for typechain (working on a fix soon)
2. Native ERC721 functions will be shown as a "Contract Proxy" on etherscan
