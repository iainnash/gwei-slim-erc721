import { NetworksUserConfig } from "hardhat/types";
import dotenv from 'dotenv';

// Setup env from .env file if present
dotenv.config();

const networks: NetworksUserConfig = {};

if (process.env.DEV_MNEMONIC) {
  if (process.env.RINKEBY_RPC) {
    networks.rinkeby = {
      chainId: 4,
      url: process.env.RINKEBY_RPC,
      accounts: {
        mnemonic: process.env.DEV_MNEMONIC,
      },
    };
  }
  if (process.env.MAINNET_RPC) {
    networks.mainnet = {
      chainId: 1,
      url: process.env.MAINNET_RPC,
      accounts: [process.env.PROD_PRIVATE_KEY as string],
    };
  }
}

export default networks;
