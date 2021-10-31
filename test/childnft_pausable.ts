import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import "@nomiclabs/hardhat-ethers";
import { ethers, deployments } from "hardhat";
import { ERC721Base, ChildNFTPausable } from "../typechain";

describe("ChildNFTPausable", () => {
  let signer: SignerWithAddress;
  let signerAddress: string;
  let childNft: ChildNFTPausable;
  let baseNft: ERC721Base;

  beforeEach(async () => {
    const { ChildNFTPausable } = await deployments.fixture([
      "ERC721Base",
      "ChildNFTPausable",
    ]);

    childNft = (await ethers.getContractAt(
      "ChildNFTPausable",
      ChildNFTPausable.address
    )) as ChildNFTPausable;
    baseNft = (await ethers.getContractAt(
      "ERC721Base",
      ChildNFTPausable.address
    )) as ERC721Base;

    signer = (await ethers.getSigners())[0];
    signerAddress = await signer.getAddress();
  });

  it("mints unless paused", async () => {
    await childNft.mintAccess(0);
    expect(await baseNft.ownerOf(0)).to.be.equal(signerAddress);
    await childNft.setPaused(true);
    await expect(childNft.mintAccess(1)).to.be.revertedWith("Paused");
  });
  it("burns unless paused", async () => {
    await childNft.mintAccess(0);
    expect(await baseNft.ownerOf(0)).to.be.equal(signerAddress);
    await childNft.setPaused(true);
    await expect(baseNft.burn(0)).to.be.revertedWith("Paused");
    await childNft.setPaused(false);
    await baseNft.burn(0);
    await expect(baseNft.ownerOf(0)).to.be.revertedWith(
      "ERC721: owner query for nonexistent token"
    );
  });
});
