module.exports = async ({ getNamedAccounts, deployments }: any) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  const sharedNFTLogicAddress = (await deployments.get("ERC721Base")).address;

  await deploy("ERC721BaseFactory", {
    from: deployer,
    args: [
      sharedNFTLogicAddress
    ],
    log: true,
  });
};
module.exports.tags = ["ERC721BaseFactory"];
module.exports.dependencies = ["ERC721Base"]