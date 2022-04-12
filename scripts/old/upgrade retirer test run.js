const { ethers, run, upgrades } = require("hardhat");

async function main() {

  require('dotenv').config({path:__dirname+'../.env'});
  const ARKLIMA = "0x21A52488f9F339B5605Ec7196BdbcC5bf2D45a78";
  const RET_PROXY = "0x59b2E78f0716d2d7FBF3d3EAD2B6ff11cDFc97f5";

  await run('compile');

  const [deployer] = await ethers.getSigners();  
  
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  Treasurer = await ethers.getContractFactory("InitTreasury", deployer);
  treasurer = await upgrades.deployProxy(Treasurer, [], {
    initializer: "initialize",
  });
  await treasurer.deployed();
  console.log("treasurer proxy deployed to:", treasurer.address);

  const retirer_init = [
    ARKLIMA,
    treasurer.address
  ];

  Retirer = await ethers.getContractFactory("InitRetirements", deployer);
  retirer = await upgrades.deployProxy(Retirer, retirer_init, {
    initializer: "initialize",
  });

  await retirer.deployed();

  console.log("Retirer proxy deployed to:", retirer.address);
  
  console.log("deployer address is: ", deployer.address);

  KNS_Retirer = await ethers.getContractFactory("KNS_Retirer");
  await upgrades.upgradeProxy(retirer.address, KNS_Retirer);
  console.log( "Upgraded InitRetirements to KNS_Retirer." );

  console.log("Testing state variables...arKLIMA:", await retirer.arKLIMA());
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
