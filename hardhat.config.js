require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('@openzeppelin/hardhat-upgrades');
require('dotenv').config({path:__dirname+'/.env'});

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more
PolygonAPI = process.env.POLYGON_API;
PolygonKey = process.env.POLYGON_KEY;
PolygonCID = process.env.POLYGON_CHAINID;
PolygonPKey = process.env.POLYGON_PKEY;
PolygonScan = process.env.POLYGONSCAN_KEY;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  networks:{
    hardhat:{
      forking: {
        url: PolygonAPI+PolygonKey,
        chainID:PolygonCID
      }
    },
    
    polygon:{
      url: PolygonAPI+PolygonKey,
      chainID: PolygonCID,
      accounts: [`${PolygonPKey}`]
    }
  

  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: PolygonScan
  },
  solidity: {
    compilers: [
      {version: "0.8.4"},
    ],
  },
};
