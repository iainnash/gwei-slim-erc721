# Save on ⛽️ writing custom NFT contracts

This pattern embeds a factory for a slight variation on the OpenZeppelin ERC271 code.

Any functions on ChildNFT override the default behavior of the standard Openzeppelin ERC721 code.

The standard base contract code is loaded in using the delegatecall() pattern.

A few common additional features for NFT series are included: 1. ERC2981 royalties, 2. BaseURI and tokenID string generation for collections.

However, there is no need to re-deploy the base contract since it is aware of this new ownership pattern.

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
2. (potentially) Etherscan will not be show all operations available to the contract, just overridden ones.