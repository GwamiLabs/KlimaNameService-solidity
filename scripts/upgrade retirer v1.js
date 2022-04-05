const { ethers, run, upgrades } = require("hardhat");

async function main() {

  require('dotenv').config({path:__dirname+'../.env'});
  const RET_PROXY = "0x59b2E78f0716d2d7FBF3d3EAD2B6ff11cDFc97f5";

  await run('compile');

  const [deployer] = await ethers.getSigners();  
  
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  KNS_Retirer = await ethers.getContractFactory("KNS_Retirer");
  await upgrades.upgradeProxy(RET_PROXY, KNS_Retirer);
  console.log( "Upgraded InitRetirements to KNS_Retirer." );

  console.log("Testing state variables...arKLIMA:", await retirer.arKLIMA());


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
