import "@nomiclabs/hardhat-waffle";
import "hardhat-gas-reporter";
import "hardhat-deploy";
import '@typechain/hardhat'
import '@nomiclabs/hardhat-ethers'
import '@nomiclabs/hardhat-waffle'
import "@nomiclabs/hardhat-etherscan";
import { HardhatUserConfig } from "hardhat/config";
import dotenv from 'dotenv';

import networks from './networks';

// Setup env from .env file if present
dotenv.config();

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  etherscan: {
    apiKey: process.env.ETHERSCAN_API,
  },
  gasReporter: {
    currency: "USD",
    gasPrice: 40,
  },
  namedAccounts: {
    deployer: 0,
    sharedMetadataContract: {
      // this is from the nft-editions contract
      1: '0x7eB947242dbF042e6388C329A614165d73548670',
      // this is from the nft-editions contract
      4: '0x2a3245d54E5407E276c47f0C181a22bf90c797Ce',
    }
  },
  networks,
  solidity: {
    compilers: [
      {
        version: "0.8.6",
        settings: {
          optimizer: {
            enabled: true,
            runs: 100,
          },
        },
      },
    ],
  },
};

export default config;
