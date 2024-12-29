# FundMe - A Blockchain Crowdfunding DApp

FundMe is a decentralized application (DApp) built with Foundry for smart contract development and deployment on Ethereum. This project provides a crowdfunding platform where users can fund campaigns or withdraw funds securely using smart contracts.

## Features

- **Decentralized Crowdfunding**: Allows users to contribute funds to campaigns using Ethereum.
- **Price Conversion**: Integrated with Chainlink Price Feeds for accurate ETH to USD conversion.
- **Secure Transactions**: Smart contracts ensure the security and transparency of all transactions.
- **Test Suite**: Comprehensive unit and interaction tests for contract functionality.
- **Deployment Automation**: Scripts for deploying and configuring the DApp on Ethereum testnets.

## Project Structure

FundMe/ ├── Makefile # Build automation file ├── .env # Environment variables ├── .gitignore # Ignored files for git ├── foundry.toml # Foundry configuration ├── script/ # Scripts for deployment and testing │ ├── DeployFundMe.s.sol # Deployment script │ ├── HelperConfig.s.sol # Configuration helper script │ └── Interactions.s.sol # Interaction script for testing ├── src/ # Smart contracts │ ├── FundMe.sol # Main FundMe contract │ └── PriceConvertor.sol # Price conversion library ├── test/ # Test files │ ├── interaction/ # Integration tests │ │ └── TestInteractions.t.sol │ └── unit/ # Unit tests │ ├── FundMeTest.t.sol │ └── zkSyncDevOps.t.sol ├── lib/ # External libraries │ ├── chainlink-brownie-contracts # Chainlink contracts for price feeds │ ├── foundry-devops # Foundry development tools │ └── forge-std # Standard testing library

## Smart Contracts

### 1. **FundMe.sol**
   - Handles funding logic.
   - Allows only the owner to withdraw funds.
   - Integrates Chainlink for ETH to USD price conversion.

### 2. **PriceConvertor.sol**
   - Library for price conversion using Chainlink Price Feeds.

## Installation

### Prerequisites
- [Node.js](https://nodejs.org/)
- [Foundry](https://book.getfoundry.sh/)
- [Git](https://git-scm.com/)
- An Ethereum wallet like [MetaMask](https://metamask.io/)
- A Sepolia testnet faucet for ETH (if deploying on testnets).

#Acknowledgments :
 -Foundry for testing and deployment tools.
 -Chainlink for price feed integration.
 -The Ethereum community for their continued support and innovation.

