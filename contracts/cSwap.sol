pragma solidity >=0.6.0 <0.8.0;

import "../client/node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Swap {
    uint256 public count = 0;

    uint256 public mantissa = 10**18;

    mapping(uint256 => exitSwap) public exitswaps;

    mapping(uint256 => initSwap) public initswaps;

    struct initSwap {
        address addr1;
        uint256 rate1;
        address addr2;
        uint256 rate2;
        uint256 quantity;
    }

    struct exitSwap {
        uint256 newrate1;
        uint256 newrate2;
    }

    function initSwapFunc(
        address _addr1,
        uint256 _rate1,
        address _addr2,
        uint256 _rate2,
        uint256 _quantity
    ) public {
        initswaps[count] = initSwap(_addr1, _rate1, _addr2, _rate2, _quantity);
        count += 1;
    }

    function exitSwapFunc(
        uint256 _key,
        uint256 _newrate1,
        uint256 _newrate2
    ) public {
        exitswaps[_key] = exitSwap(_newrate1, _newrate2);

        ExecuteSwap(_key);
    }

    function ExecuteSwap(uint256 _key) public returns (uint256) {
        uint256[2] memory rates = [
            initswaps[_key].rate1,
            initswaps[_key].rate2
        ];
        uint256[2] memory newrates = [
            exitswaps[_key].newrate1,
            exitswaps[_key].newrate2
        ];
        uint256[2] memory newvals = [
            (uint256(newrates[0]) * mantissa) / uint256(rates[0]),
            (uint256(newrates[1]) * mantissa) / uint256(rates[1])
        ];
        address[2] memory addresses = [
            initswaps[_key].addr1,
            initswaps[_key].addr2
        ];

        uint256 min;
        uint256 max;

        if (newvals[0] > newvals[1]) {
            min = 1;
            max = 0;
        } else {
            min = 0;
            max = 1;
        }

        uint256 dif = newvals[max] - newvals[min];

        //gets to 8 decimals

        uint256 exchange = ((uint256(dif) * mantissa) /
            uint256(newrates[max])) / uint256(10**10);

        IERC20 cUSDC = IERC20(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
        IERC20 cUSDT = IERC20(0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9);

        if (min == 0) {
            cUSDC.transfer(
                addresses[0],
                (uint256(mantissa) / uint256(rates[0]) / uint256(10**10))
            );
            cUSDT.transfer(addresses[0], exchange);

            cUSDT.transfer(
                addresses[1],
                (uint256(mantissa) / uint256(rates[1]) / uint256(10**10)) -
                    exchange
            );
        } else {
            cUSDC.transfer(
                addresses[0],
                (uint256(mantissa) / uint256(rates[0]) / uint256(10**10)) -
                    exchange
            );

            cUSDC.transfer(addresses[1], exchange);
            cUSDT.transfer(
                addresses[1],
                (uint256(mantissa) / uint256(rates[1]) / uint256(10**10))
            );
        }
    }
}
