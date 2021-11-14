import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import "@nomiclabs/hardhat-ethers";
import { ethers, deployments } from "hardhat";
import { ERC721Base, ChildNFTEmpty } from "../typechain";

describe("ChildNFTEmpty", () => {
  let signer: SignerWithAddress;
  let signerAddress: string;
  let childNft: ChildNFTEmpty;
  let baseNft: ERC721Base;

  beforeEach(async () => {
    const { ChildNFTEmpty } = await deployments.fixture([
      "ERC721Base",
      "ChildNFTEmpty",
    ]);

    childNft = (await ethers.getContractAt(
      "ChildNFTEmpty",
      ChildNFTEmpty.address
    )) as ChildNFTEmpty;
    baseNft = (await ethers.getContractAt(
      "ERC721Base",
      ChildNFTEmpty.address
    )) as ERC721Base;

    signer = (await ethers.getSigners())[0];
    signerAddress = await signer.getAddress();
  });

  it("mints", async () => {
    await expect(baseNft.__mint(signerAddress, 1)).to.be.revertedWith(
      "Only internal"
    );
  });
  it("burns", async () => {
    await childNft.adminMint();
    await baseNft.burn(1);
  });
  it("does not burn for non-owner", async () => {
    const [_, s2] = await ethers.getSigners();
    await childNft.adminMint();
    await expect(baseNft.connect(s2).burn(1)).to.be.revertedWith("Not allowed");
  });
});
