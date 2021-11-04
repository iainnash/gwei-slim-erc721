# Save on ⛽️ writing custom NFT contracts

For most NFT projects, the base 80% of NFT code is unchanged from Opensea. A transparent factory pattern works well when the solidity used is identical between NFT contracts, but what about custom logic and overriding certain portions of the OZ standard?

This proxy pattern uses a solidity fallback to call into openzeppelin contract code for any undefined functions, and when your NFT contract code calls the standard functions, it can do this because the contract call is now possible since the permissions are granted to the NFT contract itself.

[YourNft] => fallback [BaseNFT]

Any functions on ChildNFT override the default behavior of the standard Openzeppelin ERC721 code.

The standard base contract code is loaded in using the delegatecall() pattern.

A few common additional features for NFT series are included: 1. ERC2981 royalties, 2. BaseURI and tokenID string generation for fixed-sized collections. Syntax sugar has been added for calling openzeppelin standard `_` private functions from the contract implementing DelegatedLogic itself.

Each base contract can be the logic behind many other NFT contracts saving considerable deployment gas to lower the barrier of entry to create customc reator contracts.

## What still needs to be done?
1. Better testing and security review
2. Deploy `ERC721Base` to mainnet and update address of deployment in this repo.

## Current Deployments:

- Mainnet: Not yet

- Rinkeby: [0x3Be479A0e8D5732BE5051Bfe6833CC98722f2C1b](https://rinkeby.etherscan.io/address/0x3Be479A0e8D5732BE5051Bfe6833CC98722f2C1b)

## Example Contract Deployed

base: https://rinkeby.etherscan.io/address/0x3Be479A0e8D5732BE5051Bfe6833CC98722f2C1b
child: https://rinkeby.etherscan.io/address/0x83FA6bfdF5920816a4cF9230D32049372F6E06eA

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
