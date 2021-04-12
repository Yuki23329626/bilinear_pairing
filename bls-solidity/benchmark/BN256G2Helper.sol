pragma solidity ^0.6.0;

import "../contracts/BN256G2.sol";

/**
 * @title Test Helper for the BN256G2 contract
 * @dev The aim of this contract is twofold:
 * 1. Raise the visibility modifier of contract functions for testing purposes
 * 2. Removal of the `pure` modifier to allow gas consumption analysis
 * @author Witnet Foundation
 */
 
contract BN256G2Helper {

  function _ecTwistMul(uint256[5] memory input) public returns (uint256[4] memory result) {
    (result[0], result[1], result[2], result[3]) = BN256G2.ecTwistMul(
      input[0], input[1], input[2], input[3], input[4]);
  }

  function _ecTwistAdd(uint256[8] memory input) public returns (uint256[4] memory result) {
    (result[0], result[1], result[2], result[3]) = BN256G2.ecTwistAdd(
      input[0],
      input[1],
      input[2],
      input[3],
      input[4],
      input[5],
      input[6],
      input[7]);
  }
}
