// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

interface IERC20 {
    function decimals() external view returns (uint8);
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }

    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function sqrrt(uint256 a) internal pure returns (uint c) {
        if (a > 3) {
            c = a;
            uint b = add( div( a, 2), 1 );
            while (b < c) {
                c = b;
                b = div( add( div( a, b ), b), 2 );
            }
        } else if (a != 0) {
            c = 1;
        }
    }

    /*
     * Expects percentage to be trailed by 00,
    */
    function percentageAmount( uint256 total_, uint8 percentage_ ) internal pure returns ( uint256 percentAmount_ ) {
        return div( mul( total_, percentage_ ), 1000 );
    }

    /*
     * Expects percentage to be trailed by 00,
    */
    function substractPercentage( uint256 total_, uint8 percentageToSub_ ) internal pure returns ( uint256 result_ ) {
        return sub( total_, div( mul( total_, percentageToSub_ ), 1000 ) );
    }

    function percentageOfTotal( uint256 part_, uint256 total_ ) internal pure returns ( uint256 percent_ ) {
        return div( mul(part_, 100) , total_ );
    }

    /**
     * Taken from Hypersonic https://github.com/M2629/HyperSonic/blob/main/Math.sol
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }

    function quadraticPricing( uint256 payment_, uint256 multiplier_ ) internal pure returns (uint256) {
        return sqrrt( mul( multiplier_, payment_ ) );
    }

    function bondingCurve( uint256 supply_, uint256 multiplier_ ) internal pure returns (uint256) {
        return mul( multiplier_, supply_ );
    }
}

interface IBenSwapRouter {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline) external returns (uint[] memory amounts);
}

interface ITycheERC20Token{
    function mint(address account_, uint256 amount_) external;     
}

interface ITyche {
    function getReferrerAddr(address addr) view external returns (address);
}

contract catsluck {

    using SafeMath for uint256;
    
    address public erc20Address; // Cats Token
    address private teamAddress;
    address constant private routerAddress = 0xa194133ED572D86fe27796F2feADBAFc062cB9E0; // 路由
    address private owner;
    uint constant private TokenDecimal = 2; // Cats

    uint constant private MUL = 10 ** (18 - TokenDecimal);
    uint constant private DIV = 10 ** 18;
    uint constant public EndMintingTime = 1646092800; // 挖矿结束时间

    uint private totalShare; // 总份额
    uint public buybackPoolTokenCount; // 回购池中的数量
    uint private teamTokenCount; // 回购池中的数量
    mapping(address => uint) private sharesAndLockUntil; // 参股股份
    mapping(address => uint) public buyerTickets; // 下注
    mapping(address => uint) public buyerAmount; // 下注数量

    // 用户下单记录
    struct buyInfo {
        uint buyTime;
        uint amount;
        uint multiplierX100;
        uint height;
    }
    mapping(address => uint) public buyID; // 下注ID
    mapping(address => mapping(uint => buyInfo)) public allBuyInfo; // 下注信息

    event Buy(address indexed addr, uint data); // 下注
    event Win(address indexed addr, uint data); // 获胜
    event Deposit(address indexed addr, uint data); // 存款
    event Withdraw(address indexed addr, uint data); // 退款

    constructor(address _erc20Address){
        // 给路由授权
        require(_erc20Address != address(0), "address can not be address 0x0");
        IERC20(_erc20Address).approve(routerAddress, ~uint(0));
        erc20Address = _erc20Address;
        owner = tx.origin;
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
        uint oldShare = mySharesAndLockUntil >> 64;
        uint oldLockUntil = uint(uint64(mySharesAndLockUntil));
        if (oldShare > 0) {
            require(lockUntil >= oldLockUntil, "invalid lockUntil");
        }

        // 如果总股份为空
        if (totalShare == 0) {
            emit Deposit(msg.sender, amount << (96 + 64) | (amount << 64) | block.timestamp);
            amount = amount * (10 ** (8 - TokenDecimal));
            //shares have at least 8-digit precision
            sharesAndLockUntil[msg.sender] = (amount << 64) | lockUntil;
            totalShare = amount;
            return;
        }
        // deltaShare / totalShare = amount / oldBalance
        // 新增股份
        uint deltaShare = amount * totalShare / oldBalance;
        // 记录股份
        sharesAndLockUntil[msg.sender] = ((deltaShare + oldShare) << 64) | lockUntil;
        totalShare += deltaShare;
        emit Deposit(msg.sender, amount << (96 + 64) | (deltaShare << 64) | block.timestamp);
    }

    // 返回基础信息
    function info(address addr) external view returns (uint, uint, uint) {
        uint totalBalance = IERC20(erc20Address).balanceOf(address(this));
        return (totalBalance - buybackPoolTokenCount, totalShare, sharesAndLockUntil[addr]);
    }

    // 提现Cats
    function withdrawCATS(uint deltaShare) external {
        uint mySharesAndLockUntil = sharesAndLockUntil[msg.sender];
        uint oldShare = mySharesAndLockUntil >> 64;
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
        sharesAndLockUntil[msg.sender] = ((oldShare - deltaShare) << 64) | lockUntil;
        totalShare -= deltaShare;
        // 转账
        IERC20(erc20Address).transfer(msg.sender, deltaBalance);
        emit Withdraw(msg.sender, deltaBalance << (96 + 64) | (deltaShare << 64) | block.timestamp);
    }

    // 买彩票（下注数量、下注赔率*100）
    function buyLottery(uint amount, uint multiplierX100) external {
        uint amountAndHeightAndMul = buyerTickets[msg.sender];
        // 如果还有奖励未领取，先领取，领取完删除下注信息
        if (amountAndHeightAndMul != 0) {
            uint height = uint(uint64(amountAndHeightAndMul >> 32));
            // There may be some pending reward
            // 不超过256个区块的奖励才有效
            if (height + 256 > block.number && blockhash(height) != 0) {
                getMyReward();
            }
        }
        // 下注数量必须大于10，包含精度
        require(amount >= 10, "amount too small");
        // 将下注资金转到本合约
        uint oldBalance;
        (amount, oldBalance) = safeTransferFrom(msg.sender, amount);
        // 计算手续费，至少2%
        uint fee = 15 * amount / 1000;
        // 2.5% fee
        if (fee < 2) fee = 2;
        //at least 2
        // 扣完手续费剩下的资金
        uint remainedAmount = amount - fee;
        buybackPoolTokenCount += fee / 5;
        teamTokenCount += fee / 5;
        require(105 <= multiplierX100 && multiplierX100 <= 100000, "invalid multiplier");
        // remainedAmount*(multiplierX100/100) < oldBalance*0.01
        // 不可超过最大赔率
        require(remainedAmount * multiplierX100 < oldBalance, "amount too large");

        // 记录下注
        buyerTickets[msg.sender] = (remainedAmount << 96) | (block.number << 32) | multiplierX100;
        buyerAmount[msg.sender] += amount;

        buyID[msg.sender] += 1;
        allBuyInfo[msg.sender][buyID[msg.sender]] = buyInfo({
        buyTime : block.timestamp,
        amount : amount,
        multiplierX100 : multiplierX100,
        height : block.number
        });
        // 触发事件
        emit Buy(msg.sender, (amount << (64 + 32)) | (multiplierX100 << 64) | block.timestamp);
    }

    // 领取奖励
    function getMyReward() public returns (uint) {
        uint amountAndHeightAndMul = buyerTickets[msg.sender];
        if (amountAndHeightAndMul == 0) return 0;
        uint multiplierX100 = uint(uint32(amountAndHeightAndMul));
        uint height = uint(uint64(amountAndHeightAndMul >> 32));
        uint amount = amountAndHeightAndMul >> 96;
        bytes32 hash = blockhash(height);
        if (uint(hash) == 0) return ~uint(0);
        // a value with all ones
        delete buyerTickets[msg.sender];
        //to prevent replay

        // 获得随机数
        uint rand = uint(keccak256(abi.encodePacked(hash, amountAndHeightAndMul, msg.sender)));
        uint reward = 0;
        rand = rand % DIV;
        // rand / DIV <= 100 / multiplierX100
        // 开奖
        bool isLucky = rand * multiplierX100 < DIV * 100;
        if (isLucky) {
            reward = amount * multiplierX100 / 100;
            uint referReward = amount.div(100);
            address refer = ITyche(erc20Address).getReferrerAddr(msg.sender);
            if (refer != address(0)){
                IERC20(erc20Address).transfer(refer, referReward);
            }
            IERC20(erc20Address).transfer(msg.sender, reward.sub(referReward));
            emit Win(msg.sender, (reward << (64 + 32)) | (multiplierX100 << 64) | block.timestamp);
        }

        uint mintReward = buyerAmount[msg.sender];
        if (mintReward.sub(amount) > 0) {
            getMintReward(mintReward.sub(amount));
        }
        return reward;
    }

    // 获取平台币奖励
    function getMintReward(uint _amount) internal {
        if (block.timestamp < EndMintingTime) {
            ITycheERC20Token(erc20Address).mint(msg.sender, _amount * MUL);
        }
        delete buyerAmount[msg.sender];
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

    function claimTeamToken(uint _amount) external {
        if (_amount == 0) _amount = teamTokenCount;
        teamTokenCount -= _amount;
        IERC20(erc20Address).transfer(teamAddress, _amount);
    }

    // 修改团队地址
    function changeTeamAddr(address _addr) external {
        require(_addr != address(0), "can not be address 0x0");
        require(msg.sender == owner, "not owner");
        teamAddress = _addr;
    }

    function changeOwner(address _addr) external {
        require(_addr != address(0), "can not be address 0x0");
        require(msg.sender == owner, "not owner");
        owner = _addr;
    }

    function getLastBuyInfos(address _addr) public view returns (buyInfo[] memory buyInfos){
        uint lastID = buyID[_addr];
        uint len = 10;
        if (lastID < 10) len = lastID;
        buyInfos = new buyInfo[](len);

        for (uint i = 0; i < len; i++){
            buyInfos[i] = allBuyInfo[_addr][lastID];
            lastID--;
        }
    }
}
