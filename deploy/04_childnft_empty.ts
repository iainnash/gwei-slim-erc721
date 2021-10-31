module.exports = async ({ getNamedAccounts, deployments }: any) => {
  const { deploy } = deployments;
  const { deployer, erc721base } = await getNamedAccounts();

  let baseAddress = erc721base;
  // Deploy in testnet or when no base is deployed
  if (!baseAddress) {
    baseAddress = (await deployments.get("ERC721Base")).address;
  }

  await deploy("ChildNFTEmpty", {
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
module.exports.tags = ["ChildNFTEmpty"];
module.exports.dependencies = ["ERC721Base"]