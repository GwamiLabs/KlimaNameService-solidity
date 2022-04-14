// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/IarKLIMA.sol";
import "./interfaces/IRetire.sol";
import "./interfaces/IStaking.sol";
import "./interfaces/ITreasury.sol";
import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IUniswapV2Router02.sol";

// KNS Retirer retires 5% of mint price as BCT, wraps 5% into
// auto-retirement KLIMA that retires 33% of any staking rewards
// and is permanently locked in the contract, and transfers the
// remainder to GWAMI Labs treasury. 
contract KNS_Retirer is Initializable, OwnableUpgradeable {

    // EVENTS
    event maticReceived(address indexed _sender, uint _value);
    event BCT_retired(address indexed _beneficiary, string _domain, uint _BCTFromSwap);

    // CONSTANTS
    uint public constant MAX_BPS = 10_000; // 10000 bps = 100%
    
    // STATE VARIABLES
    address public Aggregator;
    address public USDCKLIMARouter;
    address public USDCBCTRouter;
    address public KLIMAUSDC;
    address public BCTUSDC;
    address public USDC;
    address public BCT;
    address public KLIMA;
    address public sKLIMA;
    address public arKLIMA;
    address public treasurer;
    address public staking;

    string public retirementMessage;

    uint public slippageFactor; // 500 bps = 5%
    uint public retireBctBps; // 500 bps = 5%
    uint public stakeInKIbps; // 500 bps = 5%
    uint public bpsFundsReceived; // 7000 bps = 70%

    uint public totalBCTRetiredByKNS; // total BCT retired by KNS
    mapping (string => uint) public BCTRetiredByDomain; // domainName => BCT amount 

    // INITIALIZER

    function initialize(
        address _arKLIMA,
        address _treasurer
    ) public initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
        Aggregator = 0xEde3bd57a04960E6469B70B4863cE1c9d9363Cb8;
        USDCKLIMARouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506;
        USDCBCTRouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506;
        KLIMAUSDC = 0x5786b267d35F9D011c4750e0B0bA584E1fDbeAD1;
        BCTUSDC = 0x1E67124681b402064CD0ABE8ed1B5c79D2e02f64;
        USDC = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        BCT = 0x2F800Db0fdb5223b3C3f354886d907A671414A7F;
        KLIMA = 0x4e78011Ce80ee02d2c3e649Fb657E45898257815;
        sKLIMA = 0xb0C22d8D350C67420f06F48936654f567C73E8C8;
        arKLIMA = _arKLIMA;
        treasurer = _treasurer;
        staking = 0x25d28a24Ceb6F81015bB0b2007D795ACAc411b4d;
        retirementMessage = "Climate Action can become the ONLY option and it starts with YOU. KNS Domains helps you go green, stay green and socially represent green. Visit www.kns.earth for more info.";
        slippageFactor = 500; // 500 bps = 5%
        retireBctBps = 500; // 500 bps = 5%
        stakeInKIbps = 500; // 500 bps = 5%
        bpsFundsReceived = 7_000; // 7000 bps = 70%
    }

    // OWNER

    function set_Aggregator (address _aggregator) external onlyOwner {
        Aggregator = _aggregator;
    }
    
    function set_USDCKLIMARouter (address _router) external onlyOwner {
        USDCKLIMARouter = _router;
    }

    function set_USDCBCTRouter (address _router) external onlyOwner {
        USDCBCTRouter = _router;
    }
    
    function set_KLIMAUSDC (address _pair) external onlyOwner {
        KLIMAUSDC = _pair;
    }

    function set_BCTUSDC (address _pair) external onlyOwner {
        BCTUSDC = _pair;
    }
    
    function set_sKLIMA (address _token) external onlyOwner {
        sKLIMA = _token;
    }
    
    function set_arKLIMA (address _token) external onlyOwner {
        arKLIMA = _token;
    }
    
    function set_treasurer (address _treasurer) external onlyOwner {
        treasurer = _treasurer;
    }
    
    function set_staking (address _contract) external onlyOwner {
        staking = _contract;
    }
    
    function setRetirementMessage(string memory _message) external onlyOwner {
        retirementMessage = _message;
    }
    
    function set_slippageFactor (uint _slippage) external onlyOwner {
        slippageFactor = _slippage;
    }
    
    ///@notice bps means basis points (1% = 100 bps)
    function set_retireBctBps (uint _bps) external onlyOwner {
        retireBctBps = _bps;
    }
    
    ///@notice bps means basis points (1% = 100 bps)
    function set_stakeInKIbps (uint _bps) external onlyOwner {
        stakeInKIbps = _bps;
    }
    
    ///@notice bps means basis points (1% = 100 bps)
    function set_bpsFundsReceived (uint _bps) external onlyOwner {
        bpsFundsReceived = _bps;
    }

    // Owner has the ability to transfer out tokens except for arKLIMA.
    // This is a function to enable recovery from errors or
    // unexpected circumstances only.
    function emergency_withdraw_other(address _token, uint _amount) external onlyOwner {
        require(_token != arKLIMA, "arKLIMA cannot be withdrawn.");

        uint tokenBalance = IERC20(_token).balanceOf(address(this));

        if (tokenBalance < _amount){
            _amount = tokenBalance;
        }

        IERC20(_token).transfer(msg.sender, _amount);
    }
    
    // PUBLIC

    function retireAndKI(
        uint _USDCAmt,
        address _beneficiary, 
        string memory _domainName,
        string memory _retMessage
    ) external {
        require(
            _USDCAmt >= 1*(10**6), 
            "Payment net of royalties and referrals is less than 1 USDC."
        );

        IERC20(USDC).transferFrom(msg.sender, address(this), _USDCAmt);

        // if user did not add retirement message, use the default one
        if (bytes(_retMessage).length == 0) {
            _retMessage = retirementMessage;
        }

        retireBCT(
            (_USDCAmt * retireBctBps) / bpsFundsReceived,
            _beneficiary,
            _domainName,
            _retMessage
        );
        
        stakeinKI((_USDCAmt * stakeInKIbps) / bpsFundsReceived);
        
        // transfer the remaining USDC to the treasury address
        IERC20(USDC).transfer(treasurer, IERC20(USDC).balanceOf(address(this)));
    }

    // PRIVATE

    //Retires BCT via Klima DAO's Klima Infinity retirement aggregator.
    function retireBCT(
        uint _USDCAmt, 
        address _beneficiary, 
        string memory _domainName,
        string memory _retMessage
    ) private {
        uint BCTFromSwap = _swapUSDCToBCT(_USDCAmt);
        IRetire KI_Retirer = IRetire(Aggregator);
        IERC20(BCT).approve(Aggregator, BCTFromSwap);
        KI_Retirer.retireCarbon(
            BCT, // _sourceToken
            BCT, // _poolToken
            BCTFromSwap, // _amount
            true, // _amountInCarbon
            _beneficiary,
            _domainName,
            _retMessage
        );
        emit BCT_retired(_beneficiary, _domainName, BCTFromSwap);
        _BCTRetirementAnalysis(_domainName, BCTFromSwap);
    }

    function _swapUSDCToBCT(uint _USDCAmt) private returns (uint BCTAmt) {
        IERC20(USDC).approve(USDCBCTRouter, _USDCAmt);
        IUniswapV2Router02 UBRouter = IUniswapV2Router02(USDCBCTRouter);
        address token0 = IUniswapV2Pair(BCTUSDC).token0();
        address token1 = IUniswapV2Pair(BCTUSDC).token1();

        address[] memory path = new address[](2);
        if (token0 == USDC) {
                    path[0] = token0;
                    path[1] = token1;
        } else {
                    path[1] = token0;
                    path[0] = token1;
        }

        uint256[] memory minOut = UBRouter.getAmountsOut(_USDCAmt, path);
        
        uint[] memory amounts = UBRouter.swapExactTokensForTokens(
                                    _USDCAmt,
                                    (minOut[1]*(MAX_BPS-slippageFactor))/MAX_BPS,
                                    path,
                                    address(this),
                                    block.timestamp 
                                );
        
        BCTAmt = amounts[amounts.length-1];
        require(BCTAmt > 0, "Didn't process swap to BCT properly");
    }

    //Provides granular BCT retirement analytics
    function _BCTRetirementAnalysis(string memory _domainName, uint _BCTRetired) private {      
        totalBCTRetiredByKNS += _BCTRetired; // total BCT retired by KNS
        BCTRetiredByDomain[_domainName] += _BCTRetired; // BCT retired per domain   
    }

    // Swaps USDC to Klima, stakes this, wraps this in auto-retirement KLIMA
    // (This version of auto-retirement KLIMA retires 33% of KLIMA emmissions)
    // and maintains a current balance of arKLIMA.
    function stakeinKI(uint _USDCAmt) private {
        _swapUSDCToKlima(_USDCAmt);
        _stakeKLIMA();
        _wrapArKLIMA();
    } 

    function _swapUSDCToKlima(uint _USDCAmt) private returns (uint KlimaAmt) {
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

        uint256[] memory minOut = UKRouter.getAmountsOut(_USDCAmt, path);
        
        uint[] memory amounts = UKRouter.swapExactTokensForTokens(
                                    _USDCAmt,
                                    (minOut[1]*(MAX_BPS-slippageFactor))/MAX_BPS,
                                    path,
                                    address(this),
                                    block.timestamp 
                                );
        
        KlimaAmt = amounts[amounts.length-1];
        require(KlimaAmt > 0, "Didn't process swap to klima properly");
    }

    function _stakeKLIMA() private returns (uint) {
        uint amountToStake = IERC20(KLIMA).balanceOf(address(this));
        IERC20(KLIMA).approve(staking, amountToStake);
        IStaking(staking).stake(amountToStake, address(this));
        IStaking(staking).claim(address(this));
        return amountToStake;
    }

    function _wrapArKLIMA() private returns (uint) {
        uint amountToWrap = IERC20(sKLIMA).balanceOf(address(this));
        IERC20(sKLIMA).approve(arKLIMA, amountToWrap);
        return IarKLIMA(arKLIMA).wrap(amountToWrap);
    }

    // RECEIVE & FALLBACK

    receive() external payable {
        emit maticReceived(msg.sender, msg.value);   
    }

    fallback() external payable {
        if (msg.value > 0){
            emit maticReceived(msg.sender, msg.value);
        }
    }
}