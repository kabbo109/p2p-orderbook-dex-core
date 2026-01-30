# P2P Orderbook DEX Core

This repository provides a professional-grade settlement engine for decentralized limit orders. Unlike AMMs, this system allows users to specify an exact price and wait for a counterparty, mirroring traditional financial exchanges but with non-custodial security.

## Features
- **Off-Chain Order Intent**: Users sign EIP-712 structured data for their orders.
- **On-Chain Settlement**: The `OrderBook` contract verifies signatures and atomicity of the swap.
- **Partial Fills**: Support for partially filling an order while maintaining the original price ratio.
- **Nonce Management**: Secure cancellation logic via incremental nonces or specific order invalidation.

## Technical Flow
1. **Maker**: Signs an order (Sell X for Y) and shares it via a relayer/API.
2. **Taker**: Finds the order, provides the signed data to the contract, and fulfills the trade.
3. **Contract**: Validates the signature using `ecrecover` and executes two `transferFrom` calls.



## Prerequisites
- Node.js v18+
- Hardhat for testing
- Ethers.js for EIP-712 signing
