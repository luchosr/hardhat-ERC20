// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

contract ERC20 {
    uint256 public totalSupply;
    string public name;
    string public symbol;
    uint8 public decimals;

    constructor(string memory _name, string memory _symbiol) {
        name = _name;
        symbol = _symbiol;
    }

    function decimals() external pure return(uint){
        return 18;
    }
}
