const { ethers } = require("ethers");

async function createOrderSignature(wallet, orderBookAddress, order) {
    const domain = {
        name: "P2P-OrderBook",
        version: "1",
        chainId: 1, // Mainnet
        verifyingContract: orderBookAddress
    };

    const types = {
        Order: [
            { name: "maker", type: "address" },
            { name: "tokenIn", type: "address" },
            { name: "tokenOut", type: "address" },
            { name: "amountIn", type: "uint256" },
            { name: "amountOut", type: "uint256" },
            { name: "nonce", type: "uint256" },
            { name: "deadline", type: "uint256" }
        ]
    };

    const signature = await wallet.signTypedData(domain, types, order);
    return signature;
}

module.exports = { createOrderSignature };
