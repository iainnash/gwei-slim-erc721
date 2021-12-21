# Save on ⛽️ writing custom NFT contracts

| Contract | Deploy GWEI | % of block size |
| :---: | :---: | :---: |
| `OptimizedChildNFT` | **447,059** | 1.5% |
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

1. Clone the example repository: https://github.com/iainnash/example-gwei-optimized-minting-contract
2. Update the contract code with your custom NFT contract information
4. Ensure base NFT contract address is set in [`hardhat.config.ts`](/hardhat.config.ts) for your network
5. `hardhat deploy --network NETWORK --tags MY_CONTRACT` replacing YOUR_CONTRACT with your contract and NETWORK with the desired network.

## Current Deployments:

- Mainnet: [0x43955024b1985E2b933A59021500aE5f55b04091](https://etherscan.io/address/0x43955024b1985e2b933a59021500ae5f55b04091)

- Rinkeby: [0x86c67a16C16BF784BdFE7D4b7575dB664D191F88](https://rinkeby.etherscan.io/address/0x86c67a16C16BF784BdFE7D4b7575dB664D191F88)

## Example Contract Deployed

- child implementation: https://rinkeby.etherscan.io/address/0x83FA6bfdF5920816a4cF9230D32049372F6E06eA

- base: https://rinkeby.etherscan.io/address/0x86c67a16C16BF784BdFE7D4b7575dB664D191F88

## How do I get started?

1. Clone this repo
2. Update your desired ChildNFT class
3. Delete all unused ChildNFT examples and deployments
4. Add address to deployed base ERC721Base to `hardhat.config.ts`
4. `hardhat deploy --network rinkeby --tags ChildNFT`

## Features

Things you now can get for no additional gas when writing your own NFT contracts:

0. 4x (!) lower deployment cost in gas
1. ERC2981 built-in option to enable, more complex usages can override the reading function
2. URI + ID functionality built-in, able to override and reset base URIs
3. Ability to gate transfer, burn, mint, or disable certain functionality when needed
4. `totalSupply` without full enumerable interface implementation
5. More legible "special" functionality on top of base NFT contract for readers
6. Ability to verify contracts and add custom comments functionality without being beholden to a factory contract's rules.

## Gotchyas

1. ABIs need to be combined manually or use both contract interfaces for typechain (working on a fix soon)
2. Native ERC721 functions will be shown as a "Contract Proxy" on etherscan
