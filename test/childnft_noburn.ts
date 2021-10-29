import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import "@nomiclabs/hardhat-ethers";
import { ethers, deployments } from "hardhat";
import { ERC721Base, ChildNFT } from "../typechain";

describe("ChildNFTNoBurn", () => {
  let signer: SignerWithAddress;
  let signerAddress: string;
  let childNft: ChildNFT;
  let baseNft: ERC721Base;

  beforeEach(async () => {
    const { ChildNFTNoBurn } = await deployments.fixture([
      "ERC721Base",
      "ChildNFTNoBurn",
    ]);
    // why you ask is this like so?
    childNft = (await ethers.getContractAt(
      "ChildNFT",
      ChildNFTNoBurn.address
    )) as ChildNFT;
    baseNft = (await ethers.getContractAt(
      "ERC721Base",
      ChildNFTNoBurn.address
    )) as ERC721Base;

    signer = (await ethers.getSigners())[0];
    signerAddress = await signer.getAddress();
  });

  it("mints", async () => {
    expect(await baseNft.ownerOf(0)).to.be.equal(signerAddress)
    expect(await baseNft.ownerOf(1)).to.be.equal(signerAddress)
    await expect(baseNft.burn(0)).to.be.revertedWith('Burn not allowed');
    await expect(baseNft.burn(1)).to.be.revertedWith('Burn not allowed');
  });
});