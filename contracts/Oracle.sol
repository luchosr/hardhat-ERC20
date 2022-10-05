// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Oracle {
    address public owner;
    uint256 private price;

    constructor() {
        owner = msg.sender;
    }

    function getprice() external view returns (uint256) {
        return price;
    }

    function setPrice(uitn256 newPrice) external {
        require(msg.sender == owner, "Oracle: only owner allowed");
        price = newPrice;
    }
}
