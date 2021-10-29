module.exports = async ({ getNamedAccounts, deployments }: any) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  const baseAddress = (await deployments.get("ERC721Base")).address;

  await deploy("ChildNFTNoBurn", {
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
module.exports.tags = ["ChildNFTNoBurn"];
module.exports.dependencies = ["ERC721Base"]