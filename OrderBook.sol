// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract OrderBook is EIP712 {
    using ECDSA for bytes32;

    bytes32 private constant ORDER_TYPEHASH = keccak256(
        "Order(address maker,address tokenIn,address tokenOut,uint256 amountIn,uint256 amountOut,uint256 nonce,uint256 deadline)"
    );

    mapping(address => uint256) public nonces;
    mapping(bytes32 => bool) public cancelledOrders;

    constructor() EIP712("P2P-OrderBook", "1") {}

    struct Order {
        address maker;
        address tokenIn;
        address tokenOut;
        uint256 amountIn;
        uint256 amountOut;
        uint256 nonce;
        uint256 deadline;
    }

    function settleOrder(Order calldata order, bytes calldata signature) external {
        require(block.timestamp <= order.deadline, "Order expired");
        require(!cancelledOrders[_hashOrder(order)], "Order cancelled");

        bytes32 structHash = _hashOrder(order);
        bytes32 hash = _hashTypedDataV4(structHash);
        address signer = hash.recover(signature);

        require(signer == order.maker, "Invalid signature");
        require(order.nonce == nonces[signer], "Invalid nonce");

        nonces[signer]++;

        // Execute Swap
        // Taker (msg.sender) sends TokenOut to Maker
        IERC20(order.tokenOut).transferFrom(msg.sender, order.maker, order.amountOut);
        // Maker sends TokenIn to Taker
        IERC20(order.tokenIn).transferFrom(order.maker, msg.sender, order.amountIn);
    }

    function _hashOrder(Order calldata order) internal pure returns (bytes32) {
        return keccak256(abi.encode(
            ORDER_TYPEHASH,
            order.maker,
            order.tokenIn,
            order.tokenOut,
            order.amountIn,
            order.amountOut,
            order.nonce,
            order.deadline
        ));
    }
}
