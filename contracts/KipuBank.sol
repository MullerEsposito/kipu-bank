// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./modifiers/KipuBankModifiers.sol";

/**
 * @title KipuBank
 * @dev A simple contract that allows users to deposit and store native tokens (ETH).
 */
contract KipuBank is KipuBankModifiers {
  uint256 public immutable LIMIT_PER_WITHDRAW;
  uint256 public immutable BANK_CAP;

  mapping(address => uint256) public depositCount;
  mapping(address => uint256) public withdrawCount;
  mapping(address => uint256) private balances;

  uint256 public totalDeposits;

  /*
  * @dev Events
  *
  * - Deposited: Emitted when a user deposits ETH into their personal vault.
  * - Withdrawn: Emitted when a user withdraws ETH from their personal vault.
  */
  event Deposited(address indexed user, uint256 amount);
  event Withdrawn(address indexed user, uint256 amount);

  error TransferFailed();

  constructor(uint256 _LIMIT_PER_WITHDRAW, uint256 _BANK_CAP) {
    LIMIT_PER_WITHDRAW = _LIMIT_PER_WITHDRAW;
    BANK_CAP = _BANK_CAP;
  }

  /**
   * @dev Allows a user to deposit ETH into their personal vault.
   * The amount of ETH sent with the transaction will be credited to the sender's balance.
   */
  function deposit() external payable 
    nonZeroAmount(msg.value)
    withinBankCap(msg.value, BANK_CAP, totalDeposits)
  {
    makeDeposit();

    emit Deposited(msg.sender, msg.value);
  }

  /**
   * @dev Allows a user to withdraw ETH from their personal vault.
   * The amount of ETH sent with the transaction will be debited from the sender's balance.
   */
  function withdraw(uint256 amount) external 
    nonZeroAmount(amount)
    hasSufficientBalance(balances[msg.sender], amount)
    withinWithdrawLimit(amount, LIMIT_PER_WITHDRAW)
  {
    makeWithdrawal(amount);

    emit Withdrawn(msg.sender, amount);
  }

  /**
   * @dev Returns the stored ETH balance of the caller.
   * @return The balance in wei.
   */
  function getBalance() external view returns (uint256) {
    return balances[msg.sender];
  }

  /**
   * @dev Returns the stored ETH balance of a specific address.
   * @param user The address to query the balance of.
   * @return The balance in wei.
   */
  function getBalanceOf(address user) external view returns (uint256) {
    return balances[user];
  }

  /**
   * @dev Internal function to make a deposit.
   */
  function makeDeposit() private {
    balances[msg.sender] += msg.value;
    totalDeposits += msg.value;
    depositCount[msg.sender]++; 
  }

  /**
   * @dev Internal function to make a withdrawal.
   * @param amount The amount of ETH to withdraw.
   */
  function makeWithdrawal(uint256 amount) private {
    balances[msg.sender] -= amount;
    totalDeposits -= amount;
    withdrawCount[msg.sender]++;

    (bool success, ) = payable(msg.sender).call{value: amount}("");
    if (!success)
      revert TransferFailed();
  }
}
