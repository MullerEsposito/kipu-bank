// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract KipuBankModifiers {
  /*
  * @dev Error messages
  *
  * - InvalidAmount: The specified amount is invalid.
  * - InsufficientBalance: The user does not have sufficient balance.
  * - WithdrawLimitExceeded: The specified amount exceeds the withdrawal limit.
  * - BankCapExceeded: The total deposits exceed the bank cap.
  */
  error InvalidAmount(string message);
  error InsufficientBalance();
  error WithdrawLimitExceeded();
  error BankCapExceeded();

  /**
   * @dev Modifies the function to ensure that the amount is not zero.
   * @param amount The amount to be checked.
   */
  modifier nonZeroAmount(uint256 amount) {
    if (amount == 0)
      revert InvalidAmount("Amount must be greater than 0");
    _;
  }

  /**
   * @dev Modifies the function to ensure that the user has sufficient balance.
   * @param currentBalance The current balance of the user.
   * @param amount The amount to be checked.
   */
  modifier hasSufficientBalance(uint256 currentBalance, uint256 amount) {
    if (currentBalance < amount)
      revert InsufficientBalance();
    _;
  }

  /**
   * @dev Modifies the function to ensure that the withdrawal amount does not exceed the limit.
   * @param amount The amount to be withdrawn.
   * @param limitPerWithdraw The maximum amount that can be withdrawn in a single transaction.
   */
  modifier withinWithdrawLimit(uint256 amount, uint256 limitPerWithdraw) {
    if (amount > limitPerWithdraw)
      revert WithdrawLimitExceeded();
    _;
  }

  /**
   * @dev Modifies the function to ensure that the total deposits do not exceed the bank cap.
   * @param amount The amount to be deposited.
   * @param bankCap The maximum amount of deposits allowed.
   * @param totalDeposits The total amount of deposits made so far.
   */
  modifier withinBankCap(uint256 amount, uint256 bankCap, uint256 totalDeposits) {
    if (totalDeposits + amount > bankCap)
      revert BankCapExceeded();
    _;
  }
}