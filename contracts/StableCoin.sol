// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import {ERC20} from "./ERC20.sol";
import {DepositorCoin} from "./DerpositorCoin.sol";

contract StableCoin is ERC20 {
    constructor() ERC("StablerCoin", "STC") {}
}
