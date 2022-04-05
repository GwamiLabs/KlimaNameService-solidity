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
}

interface IarKLIMA {
    function wrap( uint _amount ) external returns ( uint );
}

interface ITreasury {
    function depositUSDC( uint _USDCAmt ) external;
}


// KNS Retirer retires 5% of mint price as BCT, wraps 5% into
// auto-retirement KLIMA that retires 33% of any staking rewards
// and is permanently locked in the contract, and transfers the
// remainder to GWAMI Labs treasury. 
contract KNS_Retirer is Initializable, OwnableUpgradeable {
    

    address public Aggregator;
    function set_Aggregator (address _aggregator) external onlyOwner {
        Aggregator = _aggregator;
    }
    address public wMaticUSDCRouter;
    function set_wMaticUSDCRouter (address _router) external onlyOwner {
        wMaticUSDCRouter = _router;
    }
    address public USDCKLIMARouter;
    function set_USDCKLIMARouter (address _router) external onlyOwner {
        USDCKLIMARouter = _router;
    }
    address public KLIMAUSDC;
    function set_KLIMAUSDC (address _pair) external onlyOwner {
        KLIMAUSDC = _pair;
    }
    address public USDC;
    function set_USDC (address _token) external onlyOwner {
        USDC = _token;
    }
    address public BCT;
    function set_BCT (address _token) external onlyOwner {
        BCT = _token;
    }
    address public KLIMA;
    function set_KLIMA (address _token) external onlyOwner {
        KLIMA = _token;
    }
    address public sKLIMA;
    function set_sKLIMA (address _token) external onlyOwner {
        sKLIMA = _token;
    }
    address public arKLIMA;
    function set_arKLIMA (address _token) external onlyOwner {
        arKLIMA = _token;
    }
    address public treasurer;
    function set_treasurer (address _treasurer) external onlyOwner {
        treasurer = _treasurer;
    }
    address public staking;
    function set_staking (address _contract) external onlyOwner {
        staking = _contract;
    }
    uint public slippageFactor; // 50 = 5%
    function set_slippageFactor (uint _slippage) external onlyOwner {
        slippageFactor = _slippage;
    }
    uint public retireBCTPercent; // 50 = 5%
    function set_retireBCTPercent (uint _percent) external onlyOwner {
        retireBCTPercent = _percent;
    }
    uint public stakeInKIPercent; // 50 = 5%
    function set_stakeInKIPercent (uint _percent) external onlyOwner {
        stakeInKIPercent = _percent;
    }
    uint public percentFundsReceived; // 700 = 70%
    function set_percentFundsReceived (uint _percent) external onlyOwner {
        percentFundsReceived = _percent;
    }
    uint public USDCFromSwap;
    uint public KLIMAFromSwap;
    uint public amtLastStaked;
    uint public amtLastWrapped;
    uint public arKLIMABalance;


    /* function initialize(
            address _arKLIMA,
            address _treasurer
        ) public initializer {
            __Context_init_unchained();
            __Ownable_init_unchained();
            Aggregator = 0xEde3bd57a04960E6469B70B4863cE1c9d9363Cb8;
            wMaticUSDCRouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506;
            USDCKLIMARouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506;
            KLIMAUSDC = 0x5786b267d35F9D011c4750e0B0bA584E1fDbeAD1;
            USDC = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
            BCT = 0x2F800Db0fdb5223b3C3f354886d907A671414A7F;
            KLIMA = 0x4e78011Ce80ee02d2c3e649Fb657E45898257815;
            sKLIMA = 0xb0C22d8D350C67420f06F48936654f567C73E8C8;
            arKLIMA = _arKLIMA;
            treasurer = _treasurer;
            staking = 0x25d28a24Ceb6F81015bB0b2007D795ACAc411b4d;
            slippageFactor = 50;//5%
            retireBCTPercent = 50;//5%
            stakeInKIPercent = 50;//5%
            percentFundsReceived = 700;//70%
        } */

    event maticReceived(address indexed _sender, uint value );
    receive() external payable {
        emit maticReceived(msg.sender, msg.value);   
    }

    fallback() external payable{
        if (msg.value > 0){
            emit maticReceived(msg.sender, msg.value);
        }
    }
    

    function retireAndKI( uint _USDCAmt ) public {
        require(( _USDCAmt >= 1*(10**6) ), 
                        "Payment net of royalties and referrals is less than 1 USDC.");
        IERC20(USDC).transferFrom(msg.sender, address(this), _USDCAmt);
        retireBCT((_USDCAmt * retireBCTPercent) / percentFundsReceived );
        stakeinKI ((_USDCAmt * stakeInKIPercent) / percentFundsReceived );
        
        //Check balance after retirement and allocation to auto-retirement KLIMA.
        uint256 leftoverFunds = IERC20(USDC).balanceOf(address(this));
        
        IERC20(USDC).approve(treasurer, leftoverFunds);
        IERC20(USDC).transferFrom(address(this), treasurer, leftoverFunds);

    }

    //Retires BCT via Klima DAO's Klima Infinity retirement aggregator.
    function retireBCT(uint _retireAmt) private {
        IRetire KI_Retirer = IRetire(Aggregator);
        IERC20(USDC).approve(Aggregator, _retireAmt);
        KI_Retirer.retireCarbon(
            USDC,
            BCT,
            _retireAmt,
            false,
            msg.sender,
            "KNS Domains",
            "Go green and stay green."
        );

    }

    // Swaps USDC to Klima, stakes this, wraps this in auto-retirement KLIMA
    // (This version of auto-retirement KLIMA retires 33% of KLIMA emmissions)
    // and maintains a current balance of arKLIMA.
    function stakeinKI( uint _USDCAmt) private {
         
        KLIMAFromSwap = _swapUSDCToKlima(_USDCAmt);
        amtLastStaked = _stakeKLIMA();
        amtLastWrapped = _wrapArKLIMA();
        arKLIMABalance += amtLastWrapped;
    }
        

    function _swapUSDCToKlima(uint _USDCAmt) private 
                                        returns (uint KlimaAmt) {
        
        IERC20(USDC).approve(USDCKLIMARouter, _USDCAmt);
        IUniswapV2Router02 UKRouter = IUniswapV2Router02(USDCKLIMARouter);
        address token0 = IUniswapV2Pair(KLIMAUSDC).token0();
        address token1 = IUniswapV2Pair(KLIMAUSDC).token1();

        address[] memory path = new address[](2);
        if (token0 == USDC) {
                    path[0] = token0;
                    path[1] = token1;
        } else {
                    path[1] = token0;
                    path[0] = token1;
        }

        uint256[] memory minOut 
                    = UKRouter.getAmountsOut(_USDCAmt, path);
        
        uint[] memory  amounts = UKRouter.swapExactTokensForTokens(
                                    _USDCAmt,
                                    (minOut[1]
                                        *(1000-slippageFactor))/1000,
                                    path,
                                    address(this),
                                    block.timestamp 
                                        );
        
        KlimaAmt = amounts[amounts.length-1];
        require(KlimaAmt > 0, "Didn't process swap to klima properly");
    }

    function _stakeKLIMA() private returns ( uint _stakedAmt) {
        uint AmounttoStake = IERC20(KLIMA).balanceOf(address(this));
        IERC20(KLIMA).approve(staking, AmounttoStake);
        IStaking(staking).stake(AmounttoStake, address(this));
        IStaking(staking).claim(address(this));
        _stakedAmt =AmounttoStake;
    }
    

    function _wrapArKLIMA() private returns (uint _wrapAmt) {
        uint AmountToWrap = IERC20(sKLIMA).balanceOf(address(this));
        IERC20(sKLIMA).approve(arKLIMA, AmountToWrap);
        _wrapAmt = IarKLIMA(arKLIMA).wrap(AmountToWrap);
    }

    // Owner has the ability to transfer out tokens except for arKLIMA.
    // This is a function to enable recovery from errors or
    // unexpected circumstances only.
    function emergency_withdraw_other(address _token, uint _amount) external onlyOwner {
        require(( _token != arKLIMA ), "arKLIMA cannot be withdrawn.");
        uint tokenBalance = IERC20(_token).balanceOf(address(this));
        if ( tokenBalance < _amount){
            _amount = tokenBalance;
        }
        IERC20(_token).approve(msg.sender, _amount);
        IERC20(_token).transfer(msg.sender, _amount);
    }
}