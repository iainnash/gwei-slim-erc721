import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import "@nomiclabs/hardhat-ethers";
import { ethers, deployments } from "hardhat";
import { ERC721Base, ExampleNFT } from "../typechain";

describe("ExampleNFT", () => {
  let signer: SignerWithAddress;
  let signerAddress: string;
  let childNft: ExampleNFT;
  let baseNft: ERC721Base;

  beforeEach(async () => {
    const { ExampleNFT } = await deployments.fixture([
      "ERC721Base",
      "ExampleNFT",
    ]);

    childNft = (await ethers.getContractAt(
      "ExampleNFT",
      ExampleNFT.address
    )) as ExampleNFT;
    baseNft = (await ethers.getContractAt(
      "ERC721Base",
      ExampleNFT.address
    )) as ERC721Base;

    signer = (await ethers.getSigners())[0];
    signerAddress = await signer.getAddress();
  });

  it("mints", async () => {
    await childNft.mint();
    expect(await baseNft.ownerOf(0)).to.be.equal(signerAddress)
  });
});
