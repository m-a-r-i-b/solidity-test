
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    uint256 public transferFeePercentage = 1; // 1% fee

    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        _mint(msg.sender, initialSupply);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function setTransferFeePercentage(uint256 _transferFeePercentage) public onlyOwner {
        transferFeePercentage = _transferFeePercentage;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
        uint256 fee = (amount * transferFeePercentage) / 100;
        uint256 amountAfterFee = amount - fee;

        super._transfer(sender, recipient, amountAfterFee);
        if (fee > 0) {
            super._transfer(sender, owner(), fee);
        }
    }
}
