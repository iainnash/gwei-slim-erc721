import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import "@nomiclabs/hardhat-ethers";
import { ethers, deployments } from "hardhat";
import { ChildNFT, ChildNFTWithBase } from "../typechain";

describe("SingleEditionMintable", () => {
  let signer: SignerWithAddress;
  let signerAddress: string;
  let childNft: ChildNFTWithBase;

  beforeEach(async () => {
    const { ChildNFT } = await deployments.fixture([
      "ERC721Base",
      "ERC721BaseFactory",
      "ChildNFT",
    ]);
    const childNFT = await deployments.get("ChildNFT");
    childNft = (await ethers.getContractAt(
      "ChildNFTWithBase",
      ChildNFT.address
    )) as ChildNFTWithBase;

    signer = (await ethers.getSigners())[0];
    signerAddress = await signer.getAddress();
  });

  it("mints", async () => {
    await childNft.mint();
    expect(await childNft.ownerOf(0)).to.be.equal(signerAddress)
  });
});
