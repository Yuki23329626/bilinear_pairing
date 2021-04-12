pragma solidity 0.6.8;

import "contracts/BN256G1.sol";
import "contracts/BN256G2.sol";

contract bn256test{
    
    uint ax = 1;
    uint ay = 2;
    
    function test()public view returns(uint[2] memory result)
    {
        result[0] = ax;
        result[1] = ay;
        return result;
    }
    
}