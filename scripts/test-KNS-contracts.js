const { ethers, run, upgrades } = require("hardhat");
require('dotenv').config({path:__dirname+'../.env'});
const ERC20ABI = require('./erc20.json');
const SUSHIABI = require('./sushirouter.json');
const KNS_RETABI = require('./KNS_Retirer.json');
const KNS_TREASABI = require('./KNS_Treasurer.json');
const ARKLIMA = "0x21A52488f9F339B5605Ec7196BdbcC5bf2D45a78";
const USDC = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174";
const sKLIMA = "0xb0C22d8D350C67420f06F48936654f567C73E8C8";
 const SushiAddress = "0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506";
  KlimaDecs = 9;
  USDCDecs = 6;
  wMaticDecs = 18;


async function main() {

  await run('compile');

  const [deployer, Address1] = await ethers.getSigners();  

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  treasurer = await ethers.getContractFactory("KNS_Treasurer", deployer);
  treasurer = await upgrades.deployProxy(treasurer, [], {
    initializer: "initialize",
  });
  await treasurer.deployed();
  console.log("treasurer proxy deployed to:", treasurer.address);

  const retirer_init = [
    ARKLIMA,
    treasurer.address
  ];

  Retirer = await ethers.getContractFactory("KNS_Retirer", deployer);
  retirer = await upgrades.deployProxy(Retirer, retirer_init, {
    initializer: "initialize",
  });

  await retirer.deployed();

  console.log("Retirer proxy deployed to:", retirer.address);
  
  console.log("deployer address is: ", deployer.address);

    retirer = await retirer.connect(Address1);
    //await retirer.initialize(ARKLIMA, knstreas_add);
    console.log("Aggregator is:",  await retirer.Aggregator());


    treasurer = await treasurer.connect(Address1);

    USDCContract = await ethers.getContractAt(ERC20ABI,
        USDC,
        Address1);
    USDCBalance = await USDCContract.balanceOf(Address1.address);
    console.log("Current USDC balance is ", 
                  ethers.utils.formatUnits(USDCBalance, USDCDecs));

    //start sushi section

    sushiswap = await ethers.getContractAt(SUSHIABI,
      SushiAddress,
      Address1);
      console.log("started...");
    sushiswap = await sushiswap.connect(Address1);
    sushiWeth = String(await sushiswap.WETH());
    console.log("swap: WETH address obtained: ", sushiWeth);
    var numbers = await sushiswap.getAmountsIn(
                                ethers.utils.parseUnits("1", 6),
                                [sushiWeth, USDC]);
    console.log("rate:Matic value: ", ethers.utils.formatEther(numbers[0]));
    console.log("rate:USDC value: ", ethers.utils.formatUnits(numbers[1], 6));
  
    await sushiswap.swapExactETHForTokens(
              0,
              [sushiWeth, USDC],
              Address1.address,
              Date.now()+300,
              {value:ethers.utils.parseEther("1000")}
          );
   
    USDCBalance = await USDCContract.balanceOf(Address1.address);
    console.log("USDC balance after swap is ", 
                  ethers.utils.formatUnits(USDCBalance, USDCDecs));

    //end sushi section
                  
    await USDCContract.connect(Address1);
    await USDCContract.approve(retirer.address, 1e9);

    await retirer.retireAndKI(
        1e9,
        Address1.address, 
        "pplTestr",
        "trees as trustees"
    );

    arKlimaContract = await ethers.getContractAt(ERC20ABI,
        ARKLIMA,
        Address1);

    console.log (await arKlimaContract.name());
    var tokenBalance = await arKlimaContract.balanceOf(retirer.address);
    console.log("Address is ", retirer.address);
    console.log ("Current $arKLIMA balance wrapped in contract: ", 
    ethers.utils.formatUnits(tokenBalance,9));


    USDCAmt = await USDCContract.balanceOf(treasurer.address);

    console.log("Treasury contract is deployed to ", treasurer.address);
    console.log ("Current $USDC balance from token contract: ", 
        ethers.utils.formatUnits(USDCAmt,6));
    
    await treasurer.rebalanceFunds();
    
    pendingPayout = await treasurer.nextKlimaPayout();
    console.log ("Incoming KLIMA payout: ", 
        ethers.utils.formatUnits(pendingPayout,9));
    
    await hre.network.provider.send("hardhat_mine", ["0x21C000"]);   
    
    await treasurer.rebalanceFunds();

    sKLIMAContract = await ethers.getContractAt(ERC20ABI,
        sKLIMA,
        Address1);
    sKLIMAAmt = await sKLIMAContract.balanceOf(treasurer.address);

    console.log (await sKLIMAContract.name());
    console.log("Address is ", treasurer.address);
    console.log ("Current $sKLIMA balance after partial redemption: ", 
    ethers.utils.formatUnits(sKLIMAAmt,9));

    //final tests of KNS_Retirer analytics
    console.log("Testing retirement analytics...");

    domainRetirement = await retirer.getBCTRetiredByDomain("pplTestr");
    addressRetirement = await retirer.BCTRetiredByBeneficiaryAddress(
                                                        Address1.address);
    totalRetirements = await retirer.totalBCTRetiredByKlimaNameService();
    
    console.log("domain Retirements of pplTestr: ", domainRetirement);
    console.log("address Retirements of ",
                Address1.address,
                ": ", addressRetirement);
    console.log("total Retirements by Klima Name Service: ",
                  totalRetirements);

    console.log("Pushing 10 more USDC into retireAndKI...");
    console.log("New domain: uintTestr")
    await USDCContract.approve(retirer.address, 1e7);
    await retirer.retireAndKI(
      1e7,
      Address1.address, 
      "uintTestr",
      "trees as integers"
    );

    oldDomainRetirement = await retirer.getBCTRetiredByDomain("pplTestr");
    newDomainRetirement = await retirer.getBCTRetiredByDomain("uintTestr");
    addressRetirement = await retirer.BCTRetiredByBeneficiaryAddress(
                                                        Address1.address);
    totalRetirements = await retirer.totalBCTRetiredByKlimaNameService();
    

    console.log("domain Retirements of pplTestr: ", oldDomainRetirement);
    console.log("domain Retirements of uintTestr: ", newDomainRetirement);
    console.log("address Retirements of ",
                Address1.address,
                ": ", addressRetirement);
    console.log("total Retirements by Klima Name Service: ",
                  totalRetirements);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
