# Learn Ethereum - Truffle框架介绍（2）

本文档包含内容来自于[Truffle Framework](http://truffleframework.com/docs/)   
本文包含内容如下：  
- 操作智能合约


## 操作智能合约
### 读取及写入数据
以太坊网络中读取数据和写入数据是完全不同的。一般来说，读取数据称为**调用**，而写入数据称为**交易**。  

#### 交易
交易从根本上改变了网络的状态。交易可以像转账那么简单，也可以像执行合约方法或新建一个合约那么复杂。交易的基本特征是会写入数据（或改变数据）。交易需要消耗以太（Ether），交易也需要花时间来处理。通过交易执行一个合约方法时，不可能获取方法的返回值，因为交易不是立即执行的。总之，通过交易执行的方法不会返回值；而是返回一个交易编号（transaction id）。总之，交易有如下特点：  
- 消耗以太（也成为gas, 即 Ether）
- 改变网络状态
- 不会立即执行
- 不会返回值（只有交易编号）

#### 调用（call）
另一方面，调用是完全不同的。调用可以用来执行网络上的代码，尽管不会有数据被永久改变。调用是免费运行的，他们的典型特点是读取数据。通过调用执行一个合约方法时，会立即受到返回值。总之，调用有如下特点：  
- 免费的（不消耗 gas ）
- 不改变网络状态
- 立即执行
- 有返回值

选择交易还是调用，非常简单，取决于是从以太坊网络读取数据还是写入数据。

### 介绍抽象
合约抽象和以太坊合约进行交互是相辅相成的。简言之，合约抽象就是为了让与合约交互更简单的封装代码，这样你就不用关心汽车机器盖下面还有发动机和刹车装置（这里是隐喻）。Truffle采用自己的 [truffle-contract](https://github.com/trufflesuite/truffle-contract) 模块进行合约抽象。

为了更好的说明合约抽象问题，下面是一个例子，来自于 Truffle Box的 metacoin例子：  

```
pragma solidity ^0.4.2;

import "./ConvertLib.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract MetaCoin {
    mapping (address => uint) balances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    function MetaCoin() {
        balances[tx.origin] = 10000;
    }

    function sendCoin(address receiver, uint amount) returns(bool sufficient) {
        if (balances[msg.sender] < amount) return false;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        Transfer(msg.sender, receiver, amount);
        return true;
    }

    function getBalanceInEth(address addr) returns(uint){
        return ConvertLib.convert(getBalance(addr),2);
    }

    function getBalance(address addr) returns(uint) {
        return balances[addr];
    }
}
```

上面这个合约除了构造方法外，还有三个方法（`sendCoin`、`getBalanceInEth`、`getBalance`）。

下面我们来看看Truffle提供的 `MetaCoin` Javascript对象。

```
// Print the deployed version of MetaCoin.
// Note that getting the deployed version requires a promise, hence the .then.
MetaCoin.deployed().then(function(instance) {
  console.log(instance);
});

// outputs:
//
// Contract
// - address: "0xa9f441a487754e6b27ba044a5a8eb2eec77f6b92"
// - allEvents: ()
// - getBalance: ()
// - getBalanceInEth: ()
// - sendCoin: ()
// ...
```

### 执行合约方法
#### 创建交易
在 MetaCoin 当中有3个方法可以执行，如果仔细分析可以发现， `sendCoin` 方法是可以改变网络状态的，即从一个账号转账到另一个账号。

当调用 `sendCoin`的时候，我们就创建了一笔交易。如下例子中，我们从一个账号转账10个Meta Coin到另一个账号中：

```
var account_one = "0x1234..."; // an address
var account_two = "0xabcd..."; // another address

var meta;
MetaCoin.deployed().then(function(instance) {
  meta = instance;
  return meta.sendCoin(account_two, 10, {from: account_one});
}).then(function(result) {
  // If this callback is called, the transaction was successfully processed.
  alert("Transaction successful!")
}).catch(function(e) {
  // There was an error! Handle it.
})
```

上述代码中，有几个有趣的事情：  
- 我们直接调用 `sendCoin` 方法，默认会产生一笔交易（写入数据）而不是调用
- 交易成功，回调函数不会马上触发，直到交易处理完成（即打包）才会触发。也就是说我们不用自己去检查交易状态。
- `sendCoin` 当中传递了第三个参数。而我们发现上面的 `sendCoin` 方法只有2个参数。我们看到的上面这个例子，像第三个参数这样，每一个交易都有一个最后的参数，可以用来指定交易的细节。比如这里指定了 `from` 确保交易是从 `account_one` 发起的。

#### 创建调用
继续 MetaCoin 这个例子，我们注意到 `getBalance` 方法只是从网络上读取数据。它不会去改变任何数据，只是返回传入地址的 MetaCoin 余额。我们看一下代码：  

```
var account_one = "0x1234..."; // an address

var meta;
MetaCoin.deployed().then(function(instance) {
  meta = instance;
  return meta.getBalance.call(account_one, {from: account_one});
}).then(function(balance) {
  // If this callback is called, the call was successfully executed.
  // Note that this returns immediately without any waiting.
  // Let's print the return value.
  console.log(balance.toNumber());
}).catch(function(e) {
  // There was an error! Handle it.
})
```

这里很有趣的是：  
- 我们必须显示的执行 `.call()` 方法，让以太坊网络清楚我们不会做出任何改变。
- 成功后我们会收到一个返回值而不是交易编号（transaction id）。

> 当心：这里的数字只是简单返回，如果数字大于了类型的最大值，会导致溢出。

#### 捕获事件
我们可以通过捕获事件来获取合约具体操作的细节。捕获事件最简单的方法是处理触发事件的交易结果。如下是一个例子：  

```
var account_one = "0x1234..."; // an address
var account_two = "0xabcd..."; // another address

var meta;
MetaCoin.deployed().then(function(instance) {
  meta = instance;  
  return meta.sendCoin(account_two, 10, {from: account_one});
}).then(function(result) {
  // result is an object with the following values:
  //
  // result.tx      => transaction hash, string
  // result.logs    => array of decoded events that were triggered within this transaction
  // result.receipt => transaction receipt object, which includes gas used

  // We can loop through result.logs to see if we triggered the Transfer event.
  for (var i = 0; i < result.logs.length; i++) {
    var log = result.logs[i];

    if (log.event == "Transfer") {
      // We found the event!
      break;
    }
  }
}).catch(function(err) {
  // There was an error! Handle it.
});
```

#### 处理交易结果
创建一笔交易后，可以通过 `result` 对象来获取交易的详细信息。如下：  
- `result.tx`  (string) - 交易哈希值
- `result.logs` (array) - 解码的事件(日志)
- `result.receipt` (object) - 交易明细

更多信息，请参考 `truffle-contract` [项目说明](https://github.com/trufflesuite/truffle-contract)

#### 网络中新建一个合约
上面的例子中，我们都是直接使用一个已经部署好的合约。我们也可以通过 `.new()` 方法来部署我们自己的合约：  

```
MetaCoin.new().then(function(instance) {
  // Print the new address
  console.log(instance.address);
}).catch(function(err) {
  // There was an error! Handle it.
});
```

#### 发送以太（ether）到一个合约
你可以只是想要往一个合约直接发送以太，或者触发一个合约的[回调方法](http://solidity.readthedocs.io/en/develop/contracts.html#fallback-function)。可以采用如下2个方法之一：

方法1：通过 `instance.sendTransaction()`直接发送一笔交易。这个方法像其他可用的合约实例方法一样，和 `web3.eth.sendTransaction` 的API一样，不过没有回调。 `to` 的值如果不指定会自动填写。（注：由于这个是合约调用，to的值是0地址）

```
instance.sendTransaction({...}).then(function(result) {
  // Same transaction result object as above.
});
```

方法2：简化方法，直接发送以太（ether）：  

```
instance.send(web3.toWei(1, "ether")).then(function(result) {
  // Same result object as above.
});
```

转载请注明以下信息：  

有问题、疑问，欢迎到社区提问 -   

## HiBlock介绍
HiBlock 秉承开放、协作、透明、链接、分享的价值观，致力打造一个专注于区块链的开发者社区，我们不仅在开发者中宣传推广区块链，还会帮助开发者真正掌握区块链技术和应用。我们有线上活动（如一起译文档、一起学以太坊、一起学EOS等），有培训课程（提供专业的区块链技术培训 http://hiblock.net/topics/node16 ）、也有线下沙龙聚会（全国各城进行线下交流），还有blockathon（链接全球区块链开发者）。详情参考：https://github.com/HiBlock/hiblock/tree/master/meetup 

[HiBlock社区](hiblock.net)  
[HiBlock github仓库](https://github.com/HiBlock/)  
[EtherChina github仓库](https://github.com/etherchina/)  

## 参考文档  
[Truffle Framework](http://truffleframework.com/docs/)   

## 更多信息
truffle提供的合约抽象包含大量的使合约简化的工具。可以查看 [truffle-contract](https://github.com/trufflesuite/truffle-contract) 文档获取更多信息。
