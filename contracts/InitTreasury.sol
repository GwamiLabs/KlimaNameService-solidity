// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

interface IStaking {
        function stake( uint _amount, address _recipient ) external returns ( bool );
        function claim ( address _recipient ) external;
        function rebase() external;
        function unstake( uint _amount, bool _trigger ) external;
}


interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}



interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}


/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IStakingHelper{
    function stake(uint amount) external;
}


interface IRetire {
     function retireCarbon(
        address _sourceToken,
        address _poolToken,
        uint256 _amount,
        bool _amountInCarbon,
        address _beneficiaryAddress,
        string memory _beneficiaryString,
        string memory _retirementMessage
    ) external;
    function KLIMA() external view returns (address);
    function sKLIMA() external view returns (address);
    function wsKLIMA() external view returns (address);
    function USDC() external view returns (address);
    function staking() external view returns (address);
    function stakingHelper() external view returns (address);
    function treasury() external view returns (address);
    function klimaRetirementStorage() external view returns (address);

}

interface IsKLIMA {
    function index() external view returns ( uint );
}

interface IarKLIMA {
    function canRetire() external returns ( uint );
}

interface IBondDepo {

    function deposit(
        uint256 _amount,
        uint256 _maxPrice,
        address _depositor
    ) external returns (uint);

    //the one below for contracts.
    function redeem(
        address _recipient,
        bool _stake
    ) external returns ( uint );

    function bondPrice() external returns ( uint );

    function payoutFor(uint _amount) external returns ( uint );

    function pendingPayoutFor( address _depositor ) 
                        external view returns ( uint pendingPayout_ );
    
    function percentVestedFor( address _depositor )
                        external view returns ( uint percentVested_ );
    
    function bondInfo(uint index) external returns (
                    uint payout,
                    uint vesting,
                    uint lastBlock,
                    uint pricePaid
    );

    //TODO: consider other logic allowed for
    //in function list.
    
    function terms() external returns (
                uint controlVariable,
                uint vestingTerm,
                uint minimumPrice,
                uint maxPayout,
                uint fee,
                uint maxDebt
    );
    

}

contract InitTreasury is Initializable, OwnableUpgradeable{

    //Later when we make an initializer, move this code into the initializer
    //and just declare them outside. Remember to include the initialized bool
    //or use openzeppelin Initializable.sol
    address public KLIMAMCO2Router;// = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff;
    function set_KLIMAMCO2Router (address _router) public onlyOwner {
        KLIMAMCO2Router = _router;
    }
    address public USDCMCO2Router;// = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff;
    function set_USDCMCO2Router (address _router) public onlyOwner {
        USDCMCO2Router = _router;
    }
    address public KLIMAMCO2;// = 0x64a3b8cA5A7e406A78e660AE10c7563D9153a739;
    function set_KLIMAMCO2 (address _pair) public onlyOwner {
        KLIMAMCO2 = _pair;
    }
    address public MCO2USDC;// = 0x68aB4656736d48bb1DE8661b9A323713104e24cF;
    function set_MCO2USDC (address _pair) public onlyOwner {
        MCO2USDC = _pair;
    }
    address public MCO2;// = 0xAa7DbD1598251f856C12f63557A4C4397c253Cea;
    function set_MCO2 (address _token) public onlyOwner {
        MCO2 = _token;
    }
    address public USDC;// = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
    function set_USDC (address _token) public onlyOwner {
        USDC = _token;
    }

    address public KLIMA;// = 0x4e78011Ce80ee02d2c3e649Fb657E45898257815;
    function set_KLIMA (address _token) public onlyOwner {
        KLIMA = _token;
    }
    address public sKLIMA;// = 0xb0C22d8D350C67420f06F48936654f567C73E8C8;
    function set_sKLIMA (address _token) public onlyOwner {
        sKLIMA = _token;
    }
    address public staking;// = 0x25d28a24Ceb6F81015bB0b2007D795ACAc411b4d;
    function set_staking (address _contract) public onlyOwner {
        staking = _contract;
    }
    address public MCO2BondContract;// = 0x00Da51bC22edF9c5A643da7E232e5a811D10B8A3;
    function set_MCO2BondContract (address _bond) public onlyOwner {
        MCO2BondContract = _bond;
    } 

    uint public MCO2USDCSlippage;// = 50; //5%
    function set_MCO2USDCSlippage (uint _slippage) public onlyOwner {
        MCO2USDCSlippage = _slippage;
    }
    uint public bondSlippage;// = 50; //5%
    function set_bondSlippage (uint _slippage) public onlyOwner {
        bondSlippage = _slippage;
    }
    uint public nextKlimaPayout;
    uint public USDCBondReserve;
    uint public FreeUSDCReserve;
    uint public CumulativeFreeUSDCReserves;
    uint public StdWdlPcg;// = 200; //20%
    function set_StdWdlPcg (uint _percentage) public onlyOwner {
        StdWdlPcg = _percentage;
    }
    uint public PercentToBond;// = 300; //30%
    function set_PercentToBond (uint _percentage) public onlyOwner {
        PercentToBond = _percentage;
    }
    uint public minPercentToRedeem;// = 5000; //50%
    function set_minPercentToRedeem (uint _percentage) public onlyOwner {
        minPercentToRedeem = _percentage;
    }
    uint public sKLIMAReserve;
    uint public MCO2Reserve;
    uint public minBondDiscount;// = 80; //0.8%
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