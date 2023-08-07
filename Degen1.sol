// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DegenToken {
    string public name;
    string public symbol;
    uint8 public decimals = 18; // 18 is the most common number of decimal places
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Redeem(address indexed from, uint256 value, uint256 prizeId);

    constructor(string memory _name, string memory _symbol, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        totalSupply = _initialSupply * 10**uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) external returns (bool) {
        require(_to != address(0), "Invalid address");
        require(_value <= balanceOf[msg.sender], "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
        require(_from != address(0), "Invalid address");
        require(_to != address(0), "Invalid address");
        require(_value <= balanceOf[_from], "Insufficient balance");
        require(_value <= allowance[_from][msg.sender], "Allowance exceeded");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    // Function to redeem a prize, assuming the prizeId is known.
    // This function should be called by users to redeem a prize by specifying the prizeId and cost.
    function redeem(uint256 _prizeId, uint256 _cost) external returns (bool) {
        // Implement prize selection logic based on the _prizeId, and deduct the _cost from the user's balance.
        require(_cost > 0, "Invalid cost");
        require(balanceOf[msg.sender] >= _cost, "Insufficient balance");

        // Implement your prize selection logic here based on _prizeId.
        // ...

        // Deduct the cost from the user's balance.
        balanceOf[msg.sender] -= _cost;

        // Emit the Redeem event to indicate the successful redemption.
        emit Redeem(msg.sender, _cost, _prizeId);

        return true;
    }

    // Function to burn tokens from the sender's account.
    function burn(uint256 _amount) external returns (bool) {
        require(_amount > 0, "Invalid amount");
        require(balanceOf[msg.sender] >= _amount, "Insufficient balance");

        // Burn the specified amount of tokens from the sender's balance.
        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;

        // Emit the Transfer event to indicate the token burn.
        emit Transfer(msg.sender, address(0), _amount);

        return true;
    }
}
