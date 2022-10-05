// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import {ERC20} from "./ERC20.sol";

contract DepositorCoin is ERC20 {
    address public owner;

    constructor() ERC("DepositorCoin", "DPC") {
        owner = msg.sender;
    }
}
