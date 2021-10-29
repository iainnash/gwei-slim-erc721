module.exports = async ({ getNamedAccounts, deployments }: any) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  const baseAddress = (await deployments.get("ERC721Base")).address;

  await deploy("ChildNFTOnChainData", {
    from: deployer,
    args: [
      baseAddress,
      "TEST",
      "testing",
      1000
    ],
    log: true,
  });
};
module.exports.tags = ["ChildNFTOnChainData"];
module.exports.dependencies = ["ERC721Base"]