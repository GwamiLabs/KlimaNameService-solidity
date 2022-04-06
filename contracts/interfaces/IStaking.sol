// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

interface IStaking {
        function stake( uint _amount, address _recipient ) external returns ( bool );
        function claim ( address _recipient ) external;
        function rebase() external;
        function unstake( uint _amount, bool _trigger ) external;
}
