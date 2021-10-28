module.exports = async ({ getNamedAccounts, deployments }: any) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  const baseFactoryAddress = (await deployments.get("ERC721BaseFactory")).address;

  await deploy("ChildNFT", {
    from: deployer,
    args: [
      baseFactoryAddress,
      "TEST",
      "testing",
      1000
    ],
    log: true,
  });
};
module.exports.tags = ["ChildNFT"];
module.exports.dependencies = ["ERC721BaseFactory"]