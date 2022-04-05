# Solidity contracts for KNS Domains - Green Identity

The key contracts located in this repository are the contracts to KNS_Retirer.sol, which manages stacking of carbon tonne retirement on mint of a Klima Name Service domain, and InitTreasury.sol.

# Public Variable and Function Description for KNS_Retirer:

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

# Public Variable and Function Description for InitTreasury:

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