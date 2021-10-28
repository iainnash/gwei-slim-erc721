import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import "@nomiclabs/hardhat-ethers";
import { ethers, deployments } from "hardhat";
import { ChildNFT } from "../typechain";

describe("SingleEditionMintable", () => {
  let signer: SignerWithAddress;
  let signerAddress: string;
  let childNft: ChildNFT;

  beforeEach(async () => {
    const { ChildNFT } = await deployments.fixture([
      "ERC721Base",
      "ERC721BaseFactory",
      "ChildNFT",
    ]);
    const childNFT = await deployments.get("ChildNFT");
    childNft = (await ethers.getContractAt(
      "ChildNFT",
      ChildNFT.address
    )) as ChildNFT;

    signer = (await ethers.getSigners())[0];
    signerAddress = await signer.getAddress();
  });

  it("mints", async () => {
    await childNft.mint();
  });
});
