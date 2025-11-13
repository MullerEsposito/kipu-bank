# KipuBank

A smart contract for depositing and withdrawing ETH with configurable limits.

## 🚀 Features

- ETH deposits
- ETH withdrawals with configurable limits
- Balance tracking per address
- Per-withdrawal limit
- Maximum total deposits cap

## 📋 Prerequisites

- [Node.js](https://nodejs.org/) (v18+)
- [Hardhat](https://hardhat.org/)
- [ethers.js](https://docs.ethers.org/v5/)

## 🌐 Deployed Contracts

### Sepolia Testnet
- **KipuBank**: [0xBCAB20ABB74c1055C3A28fA8292317fA2A200423](https://sepolia.etherscan.io/address/0xBCAB20ABB74c1055C3A28fA8292317fA2A200423)

## 🔧 Installation

```bash
# Install dependencies
npm install

# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test
```

## 🧪 Testing

```bash
# Run all tests
npx hardhat test

# Run tests with coverage
npx hardhat coverage
```

## 📝 Contract

### State Variables

 - LIMIT_PER_WITHDRAW: Maximum withdrawal limit
 - BANK_CAP: Total deposits cap
 - balances: Mapping of address to balance
 - depositCount: Deposit count per address
 - withdrawCount: Withdrawal count per address
 - totalDeposits: Total deposits in the contract

### Main Functions

 - deposit()
   - Allows depositing ETH into the contract
   - Emits Deposited event
 - withdraw(uint256 amount)
   - Allows withdrawing ETH from the contract
   - Verifies balance and limits
   - Emits Withdrawn event
 - getBalance()
   - Returns the sender's balance
 - getBalanceOf(address user)
   - Returns the balance of a specific address

## 🛡️Security

This contract includes:

 - Overflow/underflow protection
 - Zero-value verification
 - Withdrawal limits
 - Sufficient balance verification
 - Transfer failure handling

## 📄 License

MIT