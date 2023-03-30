// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./IToken.sol";



contract LaunchPad {
    address public owner;
    address public tokenA;
    address public tokenB;
    uint256 public startTime;
    uint256 public endTime;
    uint256 public totalTokenA;
    uint256 public totalTokenB;
    mapping(address => uint256) public balances;
    
    constructor(
        address _owner,
        address _tokenA,
        address _tokenB,
        uint256 _startTime,
        uint256 _endTime
    ) {
        owner = _owner;
        tokenA = _tokenA;
        tokenB = _tokenB;
        startTime = _startTime;
        endTime = _endTime;
    }
    
    function deposit(uint256 amount) external {
        require(block.timestamp >= startTime, "LaunchPad: not started yet");
        require(block.timestamp < endTime, "LaunchPad: already ended");
        require(amount > 0, "LaunchPad: amount must be greater than zero");
        
        IERC20(tokenA).transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
        totalTokenA += amount;
    }
    
    function withdraw() external {
        require(block.timestamp >= endTime, "LaunchPad: not ended yet");
        
        uint256 amount = balances[msg.sender];
        require(amount > 0, "LaunchPad: no balance to withdraw");
        
        balances[msg.sender] = 0;
        totalTokenB -= amount;
        
        IERC20(tokenB).transfer(msg.sender, amount);
    }
    
    function ownerWithdraw() external {
        require(msg.sender == owner, "LaunchPad: only owner can withdraw");
        
        uint256 balance = IERC20(tokenA).balanceOf(address(this));
        IERC20(tokenA).transfer(owner, balance);
    }

    function getBalance() public view returns (uint256 result) {
        result = balances[msg.sender];
    }
    
}
