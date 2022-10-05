// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import {ERC20} from "./ERC20.sol";
import {DepositorCoin} from "./DerpositorCoin.sol";
import {Oracle} from "./Oracle.sol";

contract StableCoin is ERC20 {
    DepositorCoin public depositorCoin;

    uint256 public feeRatePercentage;
    Oracle public oracle;
    uint256 public constant INITIAL_COLLATERAL_RATIO_PERCENTAGE = 10;


    constructor(uint256 _feeRatePercentage, Oracle _oracle) ERC("StablerCoin", "STC") {
      feeRatePercentage = _feeRatePercentage;
      oracle = _oracle;
    }

    function mint() external payable {
        uint256 fee = _getFee(msg.value);
        uint256 remainingEth = msg.value - fee;

        uint256 mintStableCounAmount = remainingEth * oracle.getprice();
        _mint(msg.sender, mintStableCounAmount);
    }

    function burn(uint256 burnStableCoinAmount) external{
      _burn(msg.sender, burnStableCoinAmount);
      
      uint256 refundingEth = burnStableCoinAmount / oracle.getprice();
      uint256 fee = _getFee(refundingEth);
      uint256 remainingRefundingEth = refundingEth - fee;

      (bool success,) = msg.sender.call{value:remainingRefundingEth}("");
      require(success, "STC: Burn refund transaction failed");
    }

    function _getFee (uint256 ethAmount)private view returns (uint256){
      bool hasDepositors = address(depositorCoin) 1= address(0) && depositorCoin.totalSupply() > 0;
      if(!hasDepositors){
        return 0;
      }
      return (feeRatePercentage * ethAmount) / 100;
    }

    function depositCollateralBuffer() external payable{
      int256 deficitOrSurplusInUsd = _getDeficitOrSurplusInContractInUsd();
      
      if(deficitOrSurplus <= 0) {
      uint256 deficitInUsd = uint256(deficitOrSurplusInUsd * -1);
      uint256 usdInEthPrice = oracle.getprice();
      uint256 deficitInEth = deficitInUsd / usdInEthPrice;

      uint256 requiredInitialSurplusInUsd = (INITIAL_COLLATERAL_RATIO_PERCENTAGE *
      totalSupply) / 100;
      uint256 requiredInitialSurplusInEth = requiredInitialSurplusInUsd / usdInEthPrice;

      require(msg.value >= deficitInEth + requiredInitialSurplusInEth,"STC: Initial collateral ratio not met");

      uint256 newInitialSurplusInEth = msg.value - deficitInEth;
      uint256 newInitialSurplusInUsd = newInitialSurplusInEth * usdInEthPrice;

      depositorCoin = new DepositorCoin();
      uint256 mintDepostorCoinAmount = newInitialSurplusInUsd;
      depositorCoin.mint(msg.sender, mintDepostorCoinAmount);

        return;
      }

      uint256 surplusInUsd = uint256(deficitOrSurplusInUsd);
      uint256 dpcInUsdPrice = _getDPCinUsdPrice(surplusInUsd); 
      uint256 mintDepositorCoinAmount = (msg.value * dpcInUsdPrice ) / oracle.getPrice();

      depositorCoin.mint(msg.sender, mintDepositorCoinAmount);
    }

    function _getDeficitOrSurplusInContractInUsd() private view returns (int256)  {
      uint256 ethContractBalanceInUsd = (address(this).balance - msg.value) * oracle.getprice();

      uint256 totalStableCoinBalanceinUsd = totalSupply;

      int256 deficitOrSurplus = int256(ethContractBalanceInUsd) - int256(totalStableCoinBalanceinUsd);

      return deficitOrSurplus;
    }

    function _getDPCinUsdPrice(uint256 surplusInUsd) private view returns (uint256){
      return depositorCoin.totalSupply() / surplusInUsd;
    }
}
