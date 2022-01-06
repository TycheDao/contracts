// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface IBenSwapRouter {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline) external returns (uint[] memory amounts);
}

contract catsluck is ERC20 {
    address constant private erc20Address = 0x265bD28d79400D55a1665707Fa14A72978FA6043; // Cats Token
    address constant private routerAddress = 0xa194133ED572D86fe27796F2feADBAFc062cB9E0; // 路由
    uint constant private CatsDecimal = 2; // Cats 代币精度

    uint constant private MUL = 10**(18-CatsDecimal);
    uint constant private DIV = 10**18;
    uint constant public EndMintingTime = 1646092800; // 挖矿结束时间

    uint private totalShare; // 总份额
    uint public buybackPoolTokenCount; // 回购池中的数量
    mapping(address => uint) private sharesAndLockUntil; // 参股股份
    mapping(address => uint) public buyerTickets; // 下注

    event Buy(address indexed addr, uint data); // 下注
    event Win(address indexed addr, uint data); // 获胜
    event Deposit(address indexed addr, uint data); // 存款
    event Withdraw(address indexed addr, uint data); // 退款

    constructor() ERC20("CATSLUCK", "CLK") {
        IERC20(erc20Address).approve(routerAddress, ~uint(0)); // 给路由授权
    }

    // 给合约地址转账Cats，返回转账数量，转之前的数量
    function safeTransferFrom(address addr, uint amount) private returns (uint, uint) {
        uint oldBalance = IERC20(erc20Address).balanceOf(address(this));
        IERC20(erc20Address).transferFrom(addr, address(this), amount);
        uint newBalance = IERC20(erc20Address).balanceOf(address(this));
        return (newBalance - oldBalance, oldBalance);
    }

    // 存款Cats（数量、锁定时间）
    function depositCATS(uint amount, uint lockUntil) public {
        uint oldBalance;
        (amount, oldBalance) = safeTransferFrom(msg.sender, amount);
        oldBalance = oldBalance - buybackPoolTokenCount;
        uint mySharesAndLockUntil = sharesAndLockUntil[msg.sender];
        uint oldShare = mySharesAndLockUntil>>64;
        uint oldLockUntil = uint(uint64(mySharesAndLockUntil));
        if(oldShare > 0) {
            require(lockUntil >= oldLockUntil, "invalid lockUntil");
        }

        // 如果总股份为空
        if(totalShare == 0) {
            emit Deposit(msg.sender, amount<<(96+64) | (amount<<64) | block.timestamp);
            amount = amount*(10**(8-CatsDecimal)); //shares have at least 8-digit precision
            sharesAndLockUntil[msg.sender] = (amount<<64) | lockUntil;
            totalShare = amount;
            return;
        }
        // deltaShare / totalShare = amount / oldBalance
        // 新增股份
        uint deltaShare = amount * totalShare / oldBalance;
        // 记录股份
        sharesAndLockUntil[msg.sender] = ((deltaShare+oldShare)<<64) | lockUntil;
        totalShare += deltaShare;
        emit Deposit(msg.sender, amount<<(96+64) | (deltaShare<<64) | block.timestamp);
    }

    // 返回基础信息
    function info(address addr) external view returns (uint, uint, uint) {
        uint totalBalance = IERC20(erc20Address).balanceOf(address(this));
        return (totalBalance-buybackPoolTokenCount, totalShare, sharesAndLockUntil[addr]);
    }

    // 提现Cats
    function withdrawCATS(uint deltaShare) external {
        uint mySharesAndLockUntil = sharesAndLockUntil[msg.sender];
        uint oldShare = mySharesAndLockUntil>>64;
        uint lockUntil = uint(uint64(mySharesAndLockUntil));
        // 合法性判断
        require(oldShare >= deltaShare, "not enough share");
        require(block.timestamp > lockUntil, "still locked");
        // 计算旧余额
        uint oldBalance = IERC20(erc20Address).balanceOf(address(this));
        oldBalance = oldBalance - buybackPoolTokenCount;
        // deltaBalance / oldBalance = deltaShare / totalShare
        // 更新股份
        uint deltaBalance = oldBalance * deltaShare / totalShare;
        sharesAndLockUntil[msg.sender] = ((oldShare - deltaShare)<<64) | lockUntil;
        totalShare -= deltaShare;
        // 转账
        IERC20(erc20Address).transfer(msg.sender, deltaBalance);
        emit Withdraw(msg.sender, deltaBalance<<(96+64) | (deltaShare<<64) | block.timestamp);
    }

    // 买彩票（下注数量、下注赔率*100）
    function buyLottery(uint amount, uint multiplierX100) external {
        uint amountAndHeightAndMul = buyerTickets[msg.sender];
        // 如果还有奖励未领取，先领取，领取完删除下注信息
        if(amountAndHeightAndMul != 0) {
            uint height = uint(uint64(amountAndHeightAndMul>>32));
            // There may be some pending reward
            // 不超过256个区块的奖励才有效
            if(height + 256 > block.number && blockhash(height) != 0) {
                getMyReward();
            }
        }
        // 下注数量必须大于10，包含精度
        require(amount >= 10, "amount too small");
        // 将下注资金转到本合约
        uint oldBalance;
        (amount, oldBalance) = safeTransferFrom(msg.sender, amount);
        // 计算手续费，至少2%
        uint fee = 2 * amount / 100; // 2% fee
        if(fee<2) fee = 2; //at least 2
        // 扣完手续费剩下的资金
        uint remainedAmount = amount - fee;
        buybackPoolTokenCount += fee/2;
        require(105 <= multiplierX100 && multiplierX100 <= 100000, "invalid multiplier");
        // remainedAmount*(multiplierX100/100) < oldBalance*0.01
        // 不可超过最大赔率
        require(remainedAmount*multiplierX100 < oldBalance, "amount too large");

        // 记录下注
        buyerTickets[msg.sender] = (remainedAmount<<96) | (block.number<<32) | multiplierX100;
        // 触发事件
        emit Buy(msg.sender, (amount<<(64+32)) | (multiplierX100<<64) | block.timestamp);
        // 奖励代币
        if(block.timestamp < EndMintingTime) {
            _mint(msg.sender, amount*MUL);
        }
    }

    // 领取奖励
    function getMyReward() public returns (uint) {
        uint amountAndHeightAndMul = buyerTickets[msg.sender];
        if(amountAndHeightAndMul == 0) return 0;
        uint multiplierX100 = uint(uint32(amountAndHeightAndMul));
        uint height = uint(uint64(amountAndHeightAndMul>>32));
        uint amount = amountAndHeightAndMul>>96;
        bytes32 hash = blockhash(height);
        if(uint(hash) == 0) return ~uint(0); // a value with all ones
        delete buyerTickets[msg.sender]; //to prevent replay

        // 获得随机数
        uint rand = uint(keccak256(abi.encodePacked(hash, amountAndHeightAndMul, msg.sender)));
        uint reward = 0;
        rand = rand % DIV;
        // rand / DIV <= 100 / multiplierX100
        // 开奖
        bool isLucky = rand*multiplierX100 < DIV*100;
        if(isLucky) {
            reward = amount*multiplierX100/100;
            IERC20(erc20Address).transfer(msg.sender, reward);
            emit Win(msg.sender, (reward<<(64+32)) | (multiplierX100<<64) | block.timestamp);
        }
        return reward;
    }

    // 回购销毁
    function buyback() external returns (uint) {
        address[] memory path = new address[](2);
        path[0] = erc20Address;
        path[1] = address(this);
        uint oldBuybackPoolFunds = buybackPoolTokenCount;
        uint[] memory amounts = IBenSwapRouter(routerAddress).swapExactTokensForTokens(
            oldBuybackPoolFunds, 0, path, address(1)/*burning address*/, 9000000000/*very large*/);
        buybackPoolTokenCount = oldBuybackPoolFunds - amounts[0];
        return amounts[1];
    }
}
