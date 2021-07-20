// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

contract SimpleStorage {
    uint256 num;

    function get() public view returns (uint256) {
        return num;
    }

    function set(uint256 _num) public {
        num = _num;
    }
}
