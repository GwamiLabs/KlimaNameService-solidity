// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

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
    
    function terms() external returns (
                uint controlVariable,
                uint vestingTerm,
                uint minimumPrice,
                uint maxPayout,
                uint fee,
                uint maxDebt
    );
    

}