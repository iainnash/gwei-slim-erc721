import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import "@nomiclabs/hardhat-ethers";
import { ethers, deployments } from "hardhat";
import { ERC721Base, ChildNFTOnChainData } from "../typechain";

describe("ChildNFTOnChainData", () => {
  let signer: SignerWithAddress;
  let signerAddress: string;
  let childNft: ChildNFTOnChainData;
  let baseNft: ERC721Base;

  beforeEach(async () => {
    const { ChildNFTOnChainData } = await deployments.fixture([
      "ERC721Base",
      "ChildNFTOnChainData",
    ]);

    childNft = (await ethers.getContractAt(
      "ChildNFTOnChainData",
      ChildNFTOnChainData.address
    )) as ChildNFTOnChainData;
    baseNft = (await ethers.getContractAt(
      "ERC721Base",
      ChildNFTOnChainData.address
    )) as ERC721Base;

    signer = (await ethers.getSigners())[0];
    signerAddress = await signer.getAddress();
  });

  it("mints", async () => {
    await childNft.mint(JSON.stringify({name: "amazing", description: "on-chain content"}));
    expect(await baseNft.ownerOf(0)).to.be.equal(signerAddress)
    expect(await baseNft.name()).to.be.equal('TEST');
    await childNft.mint(JSON.stringify({name: "amazing", description: "on-chain content"}));
    await childNft.mint(JSON.stringify({name: "amazing", description: "on-chain content"}));
    await baseNft.setApprovalForAll(ethers.constants.AddressZero, true);
    expect(await childNft.getTesting()).to.be.equal('super long string testing memory testing memory');
  });
});
