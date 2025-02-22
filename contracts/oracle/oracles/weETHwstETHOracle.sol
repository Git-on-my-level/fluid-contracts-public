// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.21;

import { FluidOracle } from "../fluidOracle.sol";
import { WstETHOracleImpl } from "../implementations/wstETHOracleImpl.sol";
import { WeETHOracleImpl } from "../implementations/weETHOracleImpl.sol";
import { IWstETH } from "../interfaces/external/IWstETH.sol";
import { IWeETH } from "../interfaces/external/IWeETH.sol";
import { OracleUtils } from "../libraries/oracleUtils.sol";

/// @title   Oracle for weETH (Etherfi's wrapped eETH) to wstETH. wstETH is the debt token here (get amount of wstETH for 1 weETH)
contract WeETHWstETHOracle is FluidOracle, WstETHOracleImpl, WeETHOracleImpl {
    /// @param  wstETH   address of the wstETH contract
    /// @param  weETH    address of the weETH contract
    constructor(IWstETH wstETH, IWeETH weETH) WstETHOracleImpl(wstETH) WeETHOracleImpl(weETH) {}

    /// @inheritdoc FluidOracle
    function getExchangeRate() public view override returns (uint256 exchangeRate_) {
        // weEth -> wstETH
        exchangeRate_ =
            (_WEETH.getEETHByWeETH(1e18) * (10 ** OracleUtils.RATE_OUTPUT_DECIMALS)) /
            _WSTETH.stEthPerToken();
    }
}
