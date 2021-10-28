module.exports = async ({ getNamedAccounts, deployments }: any) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  await deploy("ERC721Base", {
    from: deployer,
    args: [],
    log: true,
  });
};
module.exports.tags = ["ERC721Base"];