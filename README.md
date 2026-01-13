# VaultFi - Decentralized Collateralized Lending Protocol

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Stacks](https://img.shields.io/badge/Built%20on-Stacks-purple.svg)](https://stacks.co)
[![Clarity](https://img.shields.io/badge/Language-Clarity-orange.svg)](https://clarity-lang.org)

## Overview

VaultFi is an advanced DeFi lending platform that revolutionizes decentralized finance by providing a robust infrastructure for collateral-backed lending. Users can leverage their Bitcoin holdings to access instant liquidity while maintaining exposure to their digital assets. The protocol features intelligent risk assessment, real-time collateral monitoring, and automated liquidation protection to ensure market stability and user security.

## Features

- **🔒 Secure Bitcoin Collateralization**: Lock Bitcoin as collateral to access instant liquidity
- **⚡ Dynamic Risk Management**: Real-time collateral ratio monitoring and automated risk assessment
- **🛡️ Automated Liquidation Protection**: Intelligent liquidation mechanisms to protect the protocol
- **📊 Real-time Price Feeds**: Oracle-based price updates for accurate collateral valuation
- **👥 Multi-Asset Support**: Support for Bitcoin (BTC) and Stacks (STX) as collateral
- **📈 Portfolio Management**: Comprehensive loan tracking and user portfolio management
- **🔧 Governance Controls**: Administrative functions for risk parameter adjustments

## System Architecture

### Contract Architecture

```text
VaultFi Protocol
├── Core Functions
│   ├── Platform Initialization
│   ├── Collateral Deposit
│   ├── Loan Request & Approval
│   └── Loan Repayment
├── Risk Management
│   ├── Collateral Ratio Calculation
│   ├── Interest Calculation
│   ├── Liquidation Checks
│   └── Position Liquidation
├── Governance
│   ├── Parameter Updates
│   ├── Price Feed Management
│   └── Risk Threshold Adjustments
└── Data Access
    ├── Loan Information
    ├── User Portfolios
    └── Platform Statistics
```

### Data Structures

#### Loans Registry

```clarity
{
  borrower: principal,
  collateral-amount: uint,
  loan-amount: uint,
  interest-rate: uint,
  start-height: uint,
  last-interest-calc: uint,
  status: (string-ascii 20)
}
```

#### User Loan Tracking

```clarity
{
  active-loans: (list 10 uint)
}
```

#### Price Feeds

```clarity
{
  price: uint
}
```

## Data Flow

### Loan Creation Process

1. **Collateral Deposit**: User deposits Bitcoin collateral
2. **Risk Assessment**: System calculates collateral-to-loan ratio
3. **Loan Approval**: If ratio meets minimum requirements, loan is created
4. **Portfolio Update**: Loan added to user's active loan portfolio
5. **Interest Tracking**: Interest calculation begins from loan creation block

### Liquidation Process

1. **Continuous Monitoring**: System monitors collateral ratios
2. **Threshold Check**: Compare current ratio against liquidation threshold
3. **Automated Liquidation**: Execute liquidation if threshold breached
4. **Collateral Seizure**: Transfer collateral to protocol
5. **Position Closure**: Mark loan as liquidated and update records

## Smart Contract Functions

### Core Public Functions

#### `initialize-platform()`

Initialize the VaultFi lending platform (owner only)

#### `deposit-collateral(amount)`

- **Parameters**: `amount` (uint) - Amount of collateral to deposit
- **Description**: Deposit Bitcoin collateral into the vault

#### `request-loan(collateral, loan-amount)`

- **Parameters**:
  - `collateral` (uint) - Amount of collateral to lock
  - `loan-amount` (uint) - Desired loan amount
- **Description**: Request a collateralized loan with automatic risk assessment
- **Returns**: Loan ID if successful

#### `repay-loan(loan-id, amount)`

- **Parameters**:
  - `loan-id` (uint) - ID of the loan to repay
  - `amount` (uint) - Repayment amount
- **Description**: Repay loan with interest and reclaim collateral

### Governance Functions

#### `update-collateral-ratio(new-ratio)`

Update minimum collateral ratio for risk management (owner only)

#### `update-liquidation-threshold(new-threshold)`

Adjust liquidation threshold for market conditions (owner only)

#### `update-price-feed(asset, new-price)`

Update oracle price feeds with validation (owner only)

### Read-Only Functions

#### `get-loan-details(loan-id)`

Retrieve detailed information about a specific loan

#### `get-user-loans(user)`

Get user's active loan portfolio

#### `get-platform-stats()`

Platform statistics and health metrics

#### `get-valid-assets()`

List of supported collateral assets

## Risk Parameters

| Parameter | Value | Description |
|-----------|--------|-------------|
| Minimum Collateral Ratio | 150% | Minimum required collateral-to-loan ratio |
| Liquidation Threshold | 120% | Ratio at which liquidation is triggered |
| Platform Fee Rate | 1% | Platform fee on loan operations |
| Interest Rate | 5% | Annual interest rate on loans |

## Error Codes

| Code | Error | Description |
|------|-------|-------------|
| u100 | ERR-NOT-AUTHORIZED | Caller not authorized for this operation |
| u101 | ERR-INSUFFICIENT-COLLATERAL | Insufficient collateral for requested loan |
| u102 | ERR-BELOW-MINIMUM | Amount below minimum threshold |
| u103 | ERR-INVALID-AMOUNT | Invalid amount specified |
| u104 | ERR-ALREADY-INITIALIZED | Platform already initialized |
| u105 | ERR-NOT-INITIALIZED | Platform not yet initialized |
| u106 | ERR-INVALID-LIQUIDATION | Invalid liquidation attempt |
| u107 | ERR-LOAN-NOT-FOUND | Specified loan not found |
| u108 | ERR-LOAN-NOT-ACTIVE | Loan is not in active status |
| u109 | ERR-INVALID-LOAN-ID | Invalid loan ID provided |
| u110 | ERR-INVALID-PRICE | Invalid price data |
| u111 | ERR-INVALID-ASSET | Unsupported asset type |

## Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Stacks development environment
- [Node.js](https://nodejs.org/) - For running tests and scripts
- [Stacks CLI](https://docs.stacks.co/stacks-cli) - For blockchain interactions

### Installation

1. Clone the repository:

```bash
git clone https://github.com/agnes-pro/VaultFi.git
cd VaultFi
```

2. Install dependencies:

```bash
npm install
```

3. Check contract syntax:

```bash
clarinet check
```

4. Run tests:

```bash
npm test
```

### Deployment

1. Configure network settings in `settings/` directory
2. Deploy using Clarinet:

```bash
clarinet deploy --network testnet
```

## Testing

The project includes comprehensive test suites:

```bash
# Run all tests
npm test

# Check contract syntax
clarinet check

# Run specific test file
npm run test -- VaultFi.test.ts
```

## Security Considerations

- **Collateral Management**: Secure handling of Bitcoin collateral with automated monitoring
- **Price Oracle Security**: Validation of price feed data to prevent manipulation
- **Access Control**: Owner-only functions for critical protocol parameters
- **Liquidation Protection**: Automated liquidation to prevent bad debt accumulation
- **Input Validation**: Comprehensive validation of all user inputs and parameters

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Roadmap

- [ ] Multi-collateral asset support expansion
- [ ] Advanced liquidation mechanisms
- [ ] Interest rate optimization algorithms
- [ ] Cross-chain collateral integration
- [ ] Governance token implementation
- [ ] Flash loan functionality

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
