# Solidity contracts for KNS Domains - Green Identity

The key contracts located in this repository are the contracts to KNS_Retirer.sol, which manages stacking of carbon tonne retirement on mint of a Klima Name Service domain, and InitTreasury.sol.

## Preamble - premise of project

Product owner: GWAMI Labs

Premise: Decentralized carbon neutral social identification for individuals, groups and companies.


Name of Product: Klima Name Service - Green Identity

Name of product domain (tentative): kns.earth/

Product description: Regenerative Name Service that continuously offsets carbon credits on behalf of the domain owners.

The domain uses KLIMA as the tool to continuously offset carbon footprint while acting as a carbon custodian.

Rationale: We want to be able to easily tie our climate pledges to our social profile. KNS enables an easy way to socially declare your carbon neutral pledge while giving you the perks of an ENS. 

KNS can also be connected to your previous retirements and your love letter to the planet through record specifically designed to input links to other retirements that specific wallet has carried out.

This is also useful for companies and business who want to tie their Klima Infinity pledge/Dashbaord to their social profile. A .klima address makes this achievable seamlessly by providing a url record that ties into their carbon pledge dashboard. So a user can go on web browser and type for example microsoft.klima and it will pull up details of their Klima infinity pledge dashboard showing their current offsets and their retirements up to date.

Implementation aspects:
- Dashboard.
- Royalties.
- Referrals.
- Avatar (URL or NFT)
- Other records like Twitter handle, GitHub etc.
- Browser extension.
- Sold in USDC. Fixed price of 100 USDC (Price can be changed by contract owner).
- Explanation docs.

Important/core features (that are not yet implemented):
- Converting to BCT
- Retiring carbon offsets
- Allocated minting - whitelist specific addresses to mint one free .klima domain.

Converting to BCT and retiring carbon offsets is the base value proposition for users (besides having a .klima domain name). 


Tokenomics:

With referal:

Executed by normal contract

10% -> Referee - Contract owner can edit this percentage ONLY through gorvernance.

20% -> punkdomains (Fixed can not be edited, receiver wallet address can be changed but requires multisig from punkdomain and contract owner).

2% -> Sent to gas Wallet to cover fees. (Tentative - may be best handled directly by Paymaster contract if GSNV2 implementation)

Both will be the executed with the Klima Infinity contract.

(Remainder - roughly 70-68%)

5% -> converted to BCT and retired using klimadomain retirement address.(There will be a dedicated contract address for klima domain retiring. So we can track the avearage retired carbon tonne each klima domain has).

5% -> converted to sKLIMA and wrapped into auto retirement KLIMA (arKLIMA) for enrolling into Klima Infnity. Commits 1/3 rebases of the to converting and retiring for BCT. (This contract was written by Chaz.) 

To be executed by treasury contract.

58% -> Sent to Treasury (Bond 30% to the treasury and redeem for sKLIMA, 70% retained as USDC for GWAMI Labs. (Fixed can not be editied and Contract owner can change receiver address). There is functionality included for simple limiting of withdrawals to preserve runway.


## Public Variable and Function Description for KNS_Retirer:

address public Aggregator: the KI Retirement Aggregator address

function set_Aggregator (address _aggregator) external onlyOwner : updates the KI Retirement Aggregator address

address public wMaticUSDCRouter: the router address for Matic-USDC swaps if necessary

function set_wMaticUSDCRouter (address _router) external onlyOwner : owner can change this address if it changes.

address public USDCKLIMARouter : Klima-USDC swaps router

function set_USDCKLIMARouter (address _router) external onlyOwner : owner can change the Uniswap V2 fork router address for Klima-USDC swaps (currently Polygon Sushi)

address public KLIMAUSDC : the LP pair contact address

function set_KLIMAUSDC (address _pair) external onlyOwner : for any changes necessary

address public USDC : the token address

function set_USDC (address _token) external onlyOwner : for changes

address public BCT : the ERC20 token address for Toucan Base Carbon Tonne

function set_BCT (address _token) external onlyOwner : for changes

address public KLIMA : the ERC20 token address for the Klima Dao token $KLIMA

function set_KLIMA (address _token) external onlyOwner : for changes

address public sKLIMA :  the ERC20 token address for the Klima Dao token $KLIMA

function set_sKLIMA (address _token) external onlyOwner

address public arKLIMA : the ERC20 token address for auto-retirement $KLIMA; set to retire 33% of AKR.

function set_arKLIMA (address _token) external onlyOwner

address public treasurer : address of GWAMI Labs treasury contract

function set_treasurer (address _treasurer) external onlyOwner

address public staking : address of the staking contract for $KLIMA

function set_staking (address _contract) external onlyOwner : for changes

uint public slippageFactor : allowed slippage in swaps. 10 is 1%.

function set_slippageFactor (uint _slippage) external onlyOwner

uint public retireBCTPercent : Percent of total mint price to retire upfront. 10 is 1%.

function set_retireBCTPercent (uint _percent) external onlyOwner

uint public stakeInKIPercent : Percent to retire over time as locked arKLIMA. 10 is 1%.

function set_stakeInKIPercent (uint _percent) external onlyOwner

uint public percentFundsReceived : Represents amount of mint price received net of referral and royalties. 700 is 70%.

function set_percentFundsReceived (uint _percent) external onlyOwner

uint public USDCFromSwap;

uint public KLIMAFromSwap;

uint public amtLastStaked;

uint public amtLastWrapped; - last transaction logging public variables.

uint public arKLIMABalance; - The current incremented balance of arKLIMA

function retireAndKI( uint _USDCAmt ) public: This is the key function in the contract. This receives USDC and processes it.

function emergency_withdraw_other(address _token, uint _amount) external onlyOwner: the owner can withdraw any token other than arKLIMA to manage unforeseen circumstances for the contract.

There are also simple receive and fallback functions.


## Public Variable and Function Description for InitTreasury:

 address public KLIMAMCO2Router

function set_KLIMAMCO2Router (address _router) public onlyOwner

address public USDCMCO2Router

function set_USDCMCO2Router (address _router) public onlyOwner

address public KLIMAMCO2

function set_KLIMAMCO2 (address _pair) public onlyOwner

address public MCO2USDC

function set_MCO2USDC (address _pair) public onlyOwner

address public MCO2

function set_MCO2 (address _token) public onlyOwner

address public USDC

function set_USDC (address _token) public onlyOwner

address public KLIMA

function set_KLIMA (address _token) public onlyOwner

address public sKLIMA

function set_sKLIMA (address _token) public onlyOwner

address public staking

function set_staking (address _contract) public onlyOwner

address public MCO2BondContract

function set_MCO2BondContract (address _bond) public onlyOwner

uint public MCO2USDCSlippage :  50 is 5%

function set_MCO2USDCSlippage (uint _slippage) public onlyOwner

uint public bondSlippage : 50 is 5%

function set_bondSlippage (uint _slippage) public onlyOwner

uint public nextKlimaPayout;

uint public USDCBondReserve;

uint public FreeUSDCReserve;

uint public CumulativeFreeUSDCReserves;

uint public StdWdlPcg;// = 200; //20%

function set_StdWdlPcg (uint _percentage) public onlyOwner

uint public PercentToBond;// = 300; //30%

function set_PercentToBond (uint _percentage) public onlyOwner

uint public minPercentToRedeem;// = 5000; //50%

function set_minPercentToRedeem (uint _percentage) public onlyOwner

uint public sKLIMAReserve;

uint public MCO2Reserve;

uint public minBondDiscount;// = 80; //0.8%

function set_minBondDiscount (uint _percentage) public onlyOwner

uint public bondPrice;

uint public swapPrice;

uint public bondDiscount;

function depositUSDC( uint _USDCAmt ) external : for direct function calls

function rebalanceFunds() public : this rebalances funds and pushes allocation for bonding into an MCO2 bond if conditions are favourable, as determined by minBondDiscount.

There is a receive function to handle unexpected transfers of Matic.

Owner withdrawal functions:

function energency_withdraw_sKLIMA(uint _amount) external onlyOwner

function withdraw_other(address _token, uint _amount) external onlyOwner

function withdrawRegularUSDC() external onlyOwner