const { ethers, run, upgrades } = require("hardhat");

async function main() {

  require('dotenv').config({path:__dirname+'../.env'});
  const ARKLIMA = "0x21A52488f9F339B5605Ec7196BdbcC5bf2D45a78";

  await run('compile');

  const [deployer] = await ethers.getSigners();  

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const retirer_init = [
    ARKLIMA,
    "0x97fAFd95bc0A332aA6123A8f8f369dfc492ff1D0"//treasurer.address
  ];

  Retirer = await ethers.getContractFactory("KNS_Retirer", deployer);
  retirer = await upgrades.deployProxy(Retirer, retirer_init, {
    initializer: "initialize",
  });

  await retirer.deployed();

  console.log("Retirer proxy deployed to:", retirer.address);
  
  console.log("deployer address is: ", deployer.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
