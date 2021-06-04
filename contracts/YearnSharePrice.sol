// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "./IYVault.sol";
import "./ITrigger.sol";

/**
 * @notice Defines a trigger that is toggled if the price per share for the yVault decreases block over block. In normal scenarious, this should be static or monotonically increasing.
 */
contract YearnPricePerShare is ITrigger {
  uint256 internal constant WAD = 10**18;

  /// @notice Market this trigger is for
  IYVault public immutable market;

  /// @notice Last read exchangeRateStored
  uint256 public lastPricePerShare;

  /// @dev Due to rounding errors in the Yearn Protocol, the stored pricePerSare may occassionally decrease by small
  /// amount even when nothing is wrong. A tolerance is applied to ensure we do not accidentally trigger in these cases
  uint256 public constant tolerance = 100; // 100 wei tolerance

  constructor(
    string memory _name,
    string memory _symbol,
    string memory _description,
    uint256[] memory _platformIds,
    address _recipient,
    address _market
  ) ITrigger(_name, _symbol, _description, _platformIds, _recipient) {
    // Set market
    market = IYVault(_market);

    // Save current exchange rate (immutables can't be read at construction, so we don't use `market` directly)
    lastPricePerShare = IYVault(_market).pricePerShareStored();
  }

  /**
   * @dev Checks the yVault pricePerShare
   */
  function isMarketTriggered() internal override returns (bool) {
    // Read this blocks exchange rate
    uint256 _currentPricePerShare = market.pricePerShareStored();

    // Check if current exchange rate is below current exchange rate, accounting for tolerance
    bool _status = _currentPricePerShare < (lastPricePerShare - tolerance);

    // Save the new exchange rate
    lastPricePerShare= _currentPricePerShare;

    // Return status
    return _status;
  }
}
