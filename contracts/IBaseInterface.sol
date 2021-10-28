// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.6;

interface IBaseInterface {
    function mintFromLogic(address to, uint256 tokenId) external;

    function burn(uint256 tokenId) external;

    function owner() external returns (address);
}
