// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/IStaking.sol";
import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IUniswapV2Router02.sol";
import "./interfaces/IarKLIMA.sol"; //may be removable
import "./interfaces/IBondDepo.sol";


contract KNS_Treasurer is Initializable, OwnableUpgradeable{

    //EVENTS


    //CONSTANTS

    //STATE VARIABLES
    address public KLIMAMCO2Router;
    address public USDCMCO2Router;
    address public KLIMAMCO2;


    
    function set_KLIMAMCO2Router (address _router) public onlyOwner {
        KLIMAMCO2Router = _router;
    }
    
    function set_USDCMCO2Router (address _router) public onlyOwner {
        USDCMCO2Router = _router;
    }
    
    function set_KLIMAMCO2 (address _pair) public onlyOwner {
        KLIMAMCO2 = _pair;
    }
    address public MCO2USDC;
    function set_MCO2USDC (address _pair) public onlyOwner {
        MCO2USDC = _pair;
    }
    address public MCO2;
    function set_MCO2 (address _token) public onlyOwner {
        MCO2 = _token;
    }
    address public USDC;
    function set_USDC (address _token) public onlyOwner {
        USDC = _token;
    }

    address public KLIMA;
    function set_KLIMA (address _token) public onlyOwner {
        KLIMA = _token;
    }
    address public sKLIMA;
    function set_sKLIMA (address _token) public onlyOwner {
        sKLIMA = _token;
    }
    address public staking;
    function set_staking (address _contract) public onlyOwner {
        staking = _contract;
    }
    address public MCO2BondContract;
    function set_MCO2BondContract (address _bond) public onlyOwner {
        MCO2BondContract = _bond;
    } 

    uint public MCO2USDCSlippage;
    function set_MCO2USDCSlippage (uint _slippage) public onlyOwner {
        MCO2USDCSlippage = _slippage;
    }
    uint public bondSlippage;
    function set_bondSlippage (uint _slippage) public onlyOwner {
        bondSlippage = _slippage;
    }
    uint public nextKlimaPayout;
    uint public USDCBondReserve;
    uint public FreeUSDCReserve;
    uint public CumulativeFreeUSDCReserves;
    uint public StdWdlPcg;
    function set_StdWdlPcg (uint _percentage) public onlyOwner {
        StdWdlPcg = _percentage;
    }
    uint public PercentToBond;
    function set_PercentToBond (uint _percentage) public onlyOwner {
        PercentToBond = _percentage;
    }
    uint public minPercentToRedeem;
    function set_minPercentToRedeem (uint _percentage) public onlyOwner {
        minPercentToRedeem = _percentage;
    }
    uint public sKLIMAReserve;
    uint public MCO2Reserve;
    uint public minBondDiscount;
    function set_minBondDiscount (uint _percentage) public onlyOwner {
        minBondDiscount = _percentage;
    }
    uint public bondPrice;
    uint public swapPrice;
    uint public bondDiscount;
    
    function initialize()public initializer{
        __Context_init_unchained();
        __Ownable_init_unchained();
        KLIMAMCO2Router = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff;
        USDCMCO2Router = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff;
        KLIMAMCO2 = 0x64a3b8cA5A7e406A78e660AE10c7563D9153a739;
        MCO2USDC = 0x68aB4656736d48bb1DE8661b9A323713104e24cF;
        MCO2 = 0xAa7DbD1598251f856C12f63557A4C4397c253Cea;
        USDC = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        KLIMA = 0x4e78011Ce80ee02d2c3e649Fb657E45898257815;
        sKLIMA = 0xb0C22d8D350C67420f06F48936654f567C73E8C8;
        staking = 0x25d28a24Ceb6F81015bB0b2007D795ACAc411b4d;
        MCO2BondContract = 0x00Da51bC22edF9c5A643da7E232e5a811D10B8A3;
        MCO2USDCSlippage = 50; //5%;
        bondSlippage = 50; //5%;
        StdWdlPcg = 200; //20%;
        PercentToBond = 300; //30%;
        minPercentToRedeem = 5000; //50%;
        minBondDiscount= 80; //0.8%;

    }


    event maticReceived(address _sender, uint value );
    receive() external payable {
        emit maticReceived(msg.sender, msg.value);
    }

    function depositUSDC( uint _USDCAmt ) external {
        IERC20(USDC).transferFrom(msg.sender, address(this), _USDCAmt);
        //revert("We got up to line 535!");
        rebalanceFunds();

    }


    function rebalanceFunds() public {
        uint USDCExcess = IERC20(USDC).balanceOf(address(this))
                            - FreeUSDCReserve
                            - USDCBondReserve;
        if (USDCExcess > 1e7) {
            FreeUSDCReserve += ( USDCExcess * (1000-PercentToBond) ) / 1000;
            CumulativeFreeUSDCReserves += ( USDCExcess * (1000-PercentToBond) ) / 1000;
            USDCBondReserve += (USDCExcess * PercentToBond) / 1000; // 100% = 1000
        }
        //revert("We got up to line 550!");
        MCO2Reserve = IERC20(MCO2).balanceOf(address(this));
        sKLIMAReserve = IERC20(sKLIMA).balanceOf(address(this));
        uint KlimaAmt = IERC20(KLIMA).balanceOf(address(this));
        //revert("We got up to line 554!");
        if (KlimaAmt > 1e10 ){
            stakeKlima();
            sKLIMAReserve += KlimaAmt;
            
        }
        bondingRun();
    }

    function bondingRun() private {

        swapPrice = getSwapPrice();
        bondPrice = getBondPrice();
        
        if ( bondPrice > swapPrice ) {
            bondDiscount = 0;
        } else {
            bondDiscount = ((swapPrice - bondPrice) * 100) / swapPrice;
        }
        if (bondDiscount >= minBondDiscount) {
            sKLIMAReserve += redeemBond();
            if(USDCBondReserve > 1e7){
                MCO2Reserve += swapToBondable(USDCBondReserve);
                nextKlimaPayout = depositBond(MCO2Reserve);
            }
        }


    }
    /// @dev gets swap price in MCO2 per KLIMA, ,9 dec pts
    function getSwapPrice() private view returns ( uint ) {
        IUniswapV2Router02 KMRouter = IUniswapV2Router02(KLIMAMCO2Router);
        address token0 = IUniswapV2Pair(KLIMAMCO2).token0();
        address token1 = IUniswapV2Pair(KLIMAMCO2).token1();

        address[] memory path = new address[](2);
        if (token0 == KLIMA) {
                    path[0] = token0;
                    path[1] = token1;
        } else {
                    path[1] = token0;
                    path[0] = token1;
        }

        uint256[] memory minOut 
                    = KMRouter.getAmountsOut(1e9, path);
        return minOut[minOut.length - 1];
        
    }

    /// @dev gets bond price in MCO2 per KLIMA,9 dec pts
    function getBondPrice() private returns ( uint ){
        return (IBondDepo( MCO2BondContract )
                                .bondPrice() * 1e7);
    }

    /// @dev bond redemption run; auto-stakes payout
    function redeemBond() private returns ( uint redeemed ){
        uint pendingPayout = IBondDepo ( MCO2BondContract )
                            .pendingPayoutFor( address(this));
        uint percentVested =  IBondDepo ( MCO2BondContract )
                            .percentVestedFor( address(this));
        //revert("We got up to line 615!");
        if ((pendingPayout >= 1e9) && 
            (percentVested >= minPercentToRedeem)
            ){
            redeemed = IBondDepo( MCO2BondContract ).redeem(
                address(this),
                false
            );
            stakeKlima();
        }   
    }

    function stakeKlima() private {
        uint KlimaAmt = IERC20(KLIMA).balanceOf(address(this));
        IERC20(KLIMA).approve(staking, KlimaAmt);
        IStaking(staking).stake(KlimaAmt, address(this));
        IStaking(staking).claim(address(this));
    }

    /// @dev swaps USDC to MCO2
    function swapToBondable( uint _USDCAmt ) private 
                                        returns( uint MCO2Amt ) {
        //comment out this transferFrom when not testing the swap.
        //IERC20(USDC).transferFrom(msg.sender, address(this), USDAmt);
        IUniswapV2Router02 UMRouter = IUniswapV2Router02(USDCMCO2Router);
        IERC20(USDC).approve(USDCMCO2Router,
                                        _USDCAmt
                                        );
        address token0 = IUniswapV2Pair(MCO2USDC).token0();
        address token1 = IUniswapV2Pair(MCO2USDC).token1();

        address[] memory path = new address[](2);
        if (token0 == USDC) {
                    path[0] = token0;
                    path[1] = token1;
        } else {
                    path[1] = token0;
                    path[0] = token1;
        }

        uint256[] memory minOut 
                    = UMRouter.getAmountsOut(_USDCAmt,
                                        path);
        uint expectedAmt = minOut[minOut.length - 1];
        
        uint256[] memory amounts = UMRouter.swapExactTokensForTokens(
                                    _USDCAmt,
                                    //0,
                                    (expectedAmt 
                                        * (1000-MCO2USDCSlippage)) 
                                            / 1000,
                                    path,
                                    address(this),
                                    block.timestamp +10*5 
                                        );
        USDCBondReserve -= _USDCAmt;
        MCO2Amt = amounts[amounts.length-1];   
    }

    /// @dev deposits given MCO2 amount
    function depositBond( uint _bondAmt) private returns ( uint bondPayout ){
        uint MCO2Balance = IERC20(MCO2).balanceOf(address(this));
        if (MCO2Balance < _bondAmt){
            _bondAmt = MCO2Balance;
        }
        IERC20(MCO2).approve(MCO2BondContract,
                                        _bondAmt //reserveToBond
                                        );
        bondPayout = IBondDepo( MCO2BondContract ).deposit(
            _bondAmt,
            (bondPrice * (1000+bondSlippage) )/ 1000,
            address( this )
        );
        MCO2Reserve -= _bondAmt;
    }

    ///@dev Owner is able to withdraw sKLIMA if necessary.
    ///@dev This is not planned to be used, however if operational
    ///@dev needs dictate, GWAMI can be funded from its sKLIMA
    ///@dev stock. 
    function energency_withdraw_sKLIMA(uint _amount) external onlyOwner {
        uint sKLIMABalance = IERC20(sKLIMA).balanceOf(address(this));
       if ( sKLIMABalance <_amount){
            _amount = sKLIMABalance;
        }
        if ( _amount > 0 ){
            sKLIMAReserve -= _amount;
            IERC20(sKLIMA).approve(msg.sender, _amount);
            IERC20(sKLIMA).transfer(msg.sender, _amount);
        }
    }

    ///@dev For management of any other accidental transfers into
    ///@dev contract - performed manually from owner wallet.
    function withdraw_other(address _token, uint _amount) external onlyOwner {
        uint tokenBalance = IERC20(_token).balanceOf(address(this));
        if ( tokenBalance < _amount){
            _amount = tokenBalance;
        }
        if (_token == USDC){
            FreeUSDCReserve -= _amount;
        }
        if ( _amount > 0 ){
            IERC20(_token).approve(msg.sender, _amount);
            IERC20(_token).transfer(msg.sender, _amount);
        }
    }

    function withdrawRegularUSDC() external onlyOwner {
        uint AllTimeWithdrawable = (CumulativeFreeUSDCReserves * StdWdlPcg) /1000;
        //subtract amount already withdrawn.
        uint toWithdraw = AllTimeWithdrawable -
                                    (CumulativeFreeUSDCReserves
                                    - FreeUSDCReserve);
        if( toWithdraw > FreeUSDCReserve ){
              toWithdraw = FreeUSDCReserve;
        }
        FreeUSDCReserve -= toWithdraw;
        IERC20(USDC).approve(msg.sender, toWithdraw);
        IERC20(USDC).transfer(msg.sender, toWithdraw);
    }



 
}