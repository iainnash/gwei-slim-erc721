// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {IERC2981Upgradeable, IERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {StringsUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import {IBaseInterface} from "./IBaseInterface.sol";
import {ClonesUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/ClonesUpgradeable.sol";

/**
    This smart contract adds features and allows for a ownership only by another smart contract as fallback behavior
    while also implementing all normal ERC721 functions as expected
*/
contract ERC721Base is
    ERC721Upgradeable,
    IBaseInterface,
    IERC2981Upgradeable,
    OwnableUpgradeable
{
    event NewContractCreated(address indexed, address indexed, string, string);

    uint256 private minted;
    uint16 public royaltyBps;
    string private baseURI;

    /**
      @dev Function to create a new edition. Can only be called by the allowed creator
           Sets the only allowed minter to the address that creates/owns the edition.
           This can be re-assigned or updated later
     */
    function initialize(
        address newOwner,
        string memory _name,
        string memory _symbol,
        uint16 _royaltyBps
    ) public initializer {
        __ERC721_init(_name, _symbol);
        __Ownable_init();

        transferOwnership(newOwner);

        royaltyBps = _royaltyBps;
    }

    function isApprovedForAll(address _owner, address operator)
        public
        view
        override
        returns (bool)
    {
        return
            ERC721Upgradeable.isApprovedForAll(_owner, operator) ||
            operator == address(this);
    }

    function setBaseURI(string memory _baseURI) public override {
        require(msg.sender == address(this), "Only internal contract call");
        baseURI = _baseURI;
    }

    /// @dev returns the number of minted tokens
    /// uses some extra gas but makes etherscan and users happy so :shrug:
    /// partial erc721enumerable implemntation
    function totalSupply() public view returns (uint256) {
        return minted;
    }

    /**
      @param to address to send the newly minted edition to
      @dev This mints one edition to the given address by an allowed minter on the edition instance.
     */
    function mint(address to, uint256 tokenId) external override {
        _mint(to, tokenId);
        minted += 1;
    }

    /**
        @param tokenId Token ID to burn
        User burn function for token id 
     */
    function burn(uint256 tokenId) public override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId) ||
                msg.sender == address(this),
            "Not allowed"
        );
        _burn(tokenId);
        minted -= 1;
    }

    /**
        Simple override for owner interface.
     */
    function owner()
        public
        view
        override(OwnableUpgradeable, IBaseInterface)
        returns (address)
    {
        return super.owner();
    }

    /**
        @dev Get royalty information for token
        @param _salePrice Sale price for the token
     */
    function royaltyInfo(uint256, uint256 _salePrice)
        external
        view
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        if (owner() == address(0x0)) {
            return (owner(), 0);
        }
        return (owner(), (_salePrice * royaltyBps) / 10_000);
    }

    /**
        @dev Get URI for given token id
        @param tokenId token id to get uri for
        @return base64-encoded json metadata object
    */
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(tokenId), "No token");

        return
            string(
                abi.encodePacked(baseURI, StringsUpgradeable.toString(tokenId))
            );
    }

    function exists(uint256 tokenId) external view override returns (bool) {
        return _exists(tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId)
        external
        view
        override
        returns (bool)
    {
        return _isApprovedOrOwner(spender, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, IERC165Upgradeable)
        returns (bool)
    {
        return
            type(IERC2981Upgradeable).interfaceId == interfaceId ||
            ERC721Upgradeable.supportsInterface(interfaceId);
    }
}
