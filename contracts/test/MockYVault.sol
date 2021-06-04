// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "../IYVault.sol";

/**
 * @notice Mock CToken, implemented the same way as a Compound CToken, but with configurable parameters for testing
 */

contract MockYVault is IYVault {
  uint256 public override pricePerShare;
  uint256 public underlyingDecimals = 6; // decimals of USDC underlying

  constructor() {
    // Initializing the values based on the yUSDC values on 2021-06-03 
    pricePerShare = 1058448;
  }

  /**
   * @notice Set the value of a parameter

   * @param _value Value to set the parameter to
   */
  function set(uint256 _value) external {
    pricePerShare = _value;
  }

  /**
   * @notice Get cash balance of this cToken in the underlying asset
   * @return The quantity of underlying asset owned by this contract
   */
  function getPricePerShare() external view override returns (uint256) {
    return pricePerShare;
  }
}
