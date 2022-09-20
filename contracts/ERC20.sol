// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

contract ERC20 {
    uint256 public totalSupply;
    string public name;
    string public symbol;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbiol) {
        name = _name;
        symbol = _symbiol;
    }

    function decimals() external pure returns (uint256) {
        return 18;
    }

    function _transfer(address recipient, uint256 amount)
        private
        returns (bool)
    {
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = balanceOf[msg.sender];
        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        balanceOf[msg.sender] = senderBalance - amount;
        balanceOf[recipient] += amount;

        return true;
    }
}
