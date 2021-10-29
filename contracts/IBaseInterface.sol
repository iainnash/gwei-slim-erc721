// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

interface IBaseInterface {
    function mint(address to, uint256 tokenId) external;
    
    function setBaseURI(string memory) external;

    function burn(uint256 tokenId) external;

    function owner() external returns (address);

    function createNewChild(
        address owner,
        string memory name,
        string memory symbol,
        uint16 _royaltyBps
    ) external returns (address);

    function exists(uint256 tokenId) external view returns (bool);
    function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);
}
