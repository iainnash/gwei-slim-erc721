import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import "@nomiclabs/hardhat-ethers";
import { ethers, deployments } from "hardhat";
import { ERC721Base, ChildNFT } from "../typechain";

describe("ChildNFT", () => {
  let signer: SignerWithAddress;
  let signerAddress: string;
  let childNft: ChildNFT;
  let baseNft: ERC721Base;

  beforeEach(async () => {
    const { ChildNFT } = await deployments.fixture([
      "ERC721Base",
      "ChildNFT",
    ]);

    childNft = (await ethers.getContractAt(
      "ChildNFT",
      ChildNFT.address
    )) as ChildNFT;
    baseNft = (await ethers.getContractAt(
      "ERC721Base",
      ChildNFT.address
    )) as ERC721Base;

    signer = (await ethers.getSigners())[0];
    signerAddress = await signer.getAddress();
  });

  it("mints", async () => {
    await childNft.mint();
    expect(await baseNft.ownerOf(0)).to.be.equal(signerAddress)
  });
});
