# Learn Ethereum - Truffle框架介绍（1）

本文档包含内容来自于[Truffle Framework](http://truffleframework.com/docs/)   
本文包含内容如下：  
- 安装
- 创建项目
- 客户端的选择
- 编译合约
- 部署合约
- 更多内容请参考[下一期](./truffle-introduction-2.md)

## 安装

### 前提

- 建议NodeJS5.0+
- Mac OS X 或者Linux或Windows都可以

```
npm install -g truffle
```

提示：
> Truffle需要一个支持标准的JSON RPC API的以太坊客户端，有很多种选择，下文将详细描述。

## 创建项目

在 Truffle 中创建项目非常简单，有两种方式：

1. 全新的项目
2. 从已有的 truffle 项目开始，如 [truffle box](http://truffleframework.com/boxes)

### 创建全新的项目

```
mkdir myproject
cd myproject
truffle init
```

### 从以后的项目开始

已有的项目，可以浏览[truffle box](http://truffleframework.com/boxes) 
```
mkdir MetaCoin
cd MetaCoin
truffle unbox metacoin
```

目录结构如下：

- contracts/ solidity合约存放目录
- migrations/ 部署脚本目录
- test/ 测试脚本目录
- truffle.js 配置文件

## 客户端选择
选择什么客户端取决于当前是开发阶段，还是要部署合约（生产系统）。  

### 开发阶段的选择
#### ganache UI
本文强烈推荐 [ganache](http://truffleframework.com/ganache)，简单易用。可以在个人PC上完美模拟一个以太坊的节点环境。默认RPC端口 7545，比如 http://127.0.0.1:7545

#### truffle develop
truffle内置了一个以太坊客户端，RPC端口为9545，比如http://127.0.0.1:9545

### ganache CLI
ganache cli的功能和ganache UI类似不过是命令行模式。默认端口 8545 比如 http://127.0.0.1:8545

### 部署阶段（生产环境）
如果要部署智能合约，以下客户端可以考虑：  
- Geth (go-ethereum): https://github.com/ethereum/go-ethereum
- WebThree (cpp-ethereum): https://github.com/ethereum/cpp-ethereum
- Parity: https://github.com/paritytech/parity
- More: https://www.ethereum.org/cli

## 编译智能合约
### 合约存放位置
默认合约存放位置 **contracts/** 目录。如果是solidity语言，默认后缀为 .sol 。 

如果是全新的项目，可以用 **truffle init** 命令创建，contracts/ 目录下可以找到 Migrations.sol 用来帮助进行部署的。如果使用 truffle box，会有多个合约文件。

### 编译命令
编译命令如下，在项目的根目录执行  
```
truffle compile
```
第一次运行，会把所有的合约文件进行编译。之后仅仅编译修改的文件，如果想要全部重新编译，可以使用参数 --all  

### 编译后的文件
编译后的文件存放在 build/contracts/ 目录下。不应该手动修改本目录下的内容，truffle compile会自动生成。

### 依赖
#### 通过文件名导入
合约可以导入其他源文件，语法如下  
```
import "./AnotherContract.sol";
```

#### 从外部包导入
truffle还支持 EthPM 和 NPM的包管理。为了导入合约，可以采用如下语法：  
```
import "packagename/SomeContract.sol";
```
packagename是通过EthPM或NPM安装的包，SomeContract.sol是包里面的合约文件。

## 部署智能合约
部署是通过JavaScript脚本，把合约部署到以太坊网络上。这些脚本文件用来执行部署任务。随着项目演化，需要创建自己的部署脚本。之前的部署历史通过一个特殊的 Migrations合约记录在链上。  

### 部署命令
部署的命令如下：  
```
truffle migrate
```
这个命令会运行 migrations/目录下的所有脚本。如果之前成功运行过这个命令，truffle migrate将只执行新的部署脚本，如果没有新的部署脚本，truffle migrate不会执行任何操作。 可以用参数 --reset强制从头运行所有的部署脚本。

### 部署脚本
一个简单的部署脚本如下：（文件名：4_example_migration.js）  
```
var MyContract = artifacts.require("MyContract");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(MyContract);
};
```

上述的部署脚本，前缀是一个数字，这个是用来标识部署脚本是否运行成功。后半部分是描述，可以用易懂的语言进行描述。

#### artifacts.require()
部署脚本的开头，会通过artifacts.require()方法与合约进行交互。这个方法和Node的 require类似，但在这里需要填写的是合约的名字，而不是合约文件的名字。  
举个例子：假设我们在一个文件内包含了2个合约：  
文件名： ./contracts/SampleContracts.sol  
```
contract ContractOne {
  // ...
}

contract ContractTwo {
  // ...
}
```

如果我们只用到 ContractTwo，那么部署脚本会如下：  
```
var ContractTwo = artifacts.require("ContractTwo");
```
如果我们用到了2个合约，部署脚本会如下：  
```
var ContractOne = artifacts.require("ContractOne");
var ContractTwo = artifacts.require("ContractTwo");
```

#### module.exports
所有的部署必须通过 module.exports 导出方法。每个部署导出的方法应该把 deployer 作为第一个参数接受。deployer对象是部署任务的主要接口，下面将详细介绍。

### 发起部署
truffle需要有一个 Migrations 合约来使用部署的功能。这个合约包含特定的接口，但你也可以根据需要进行修改。默认的Migrations合约可以通过 truffle init命令进行创建。

文件名：contracts/Migrations.sol  
```
pragma solidity ^0.4.8;

contract Migrations {
  address public owner;

  // A function with the signature `last_completed_migration()`, returning a uint, is required.
  uint public last_completed_migration;

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  function Migrations() {
    owner = msg.sender;
  }

  // A function with the signature `setCompleted(uint)` is required.
  function setCompleted(uint completed) restricted {
    last_completed_migration = completed;
  }

  function upgrade(address new_address) restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}
```
部署的第一个操作必须是 Migrations合约。为了这么做，需要创建如下的部署脚本：  
文件名：migrations/1_initial_migration.js  

```
var Migrations = artifacts.require("Migrations");

module.exports = function(deployer) {
  // Deploy the Migrations contract as our only task
  deployer.deploy(Migrations);
};
```

## Deployer （部署接口）
部署脚本将采用 deployer 来执行部署任务。可以采用同步的方式编写部署任务，这样任务将按照指定的顺序执行：  

```
// 先部署A合约，再部署B合约
deployer.deploy(A);
deployer.deploy(B);
```

另外，deployer的每个方法，可以依赖于其他deployer的返回来进行部署。例如：  

```
// 先部署A，再部署B，部署B的时候A的部署地址传入。
deployer.deploy(A).then(function() {
  return deployer.deploy(B, A.address);
});
```

### 网络的考虑
在部署的时候，需要考虑到网络情况，以及有条件的执行部署。这里可以针对部署脚本传入另一个参数 network。例如：  

```
module.exports = function(deployer, network) {
  if (network == "live") {
    // Do something specific to the network named "live".
  } else {
    // Perform a different step otherwise.
  }
}
```

### 可用的账号
部署可以传入账号列表，用来在部署阶段对账号进行操作。accounts 是从web3接口返回的账号列表。  

```
module.exports = function(deployer, network, accounts) {
  // Use the accounts within your migrations.
}
```

### deployer API
deployer 包含很多可用的方法来简化部署过程。

#### deployer.deploy(contract,args...,options)
部署合约可以传入参数，还可以通过数组进行一次部署多个合约，还可以指定 gas 的最大值以及 `from` 从哪儿消耗gas。
示例代码如下：  

```
// Deploy a single contract without constructor arguments
deployer.deploy(A);

// Deploy a single contract with constructor arguments
deployer.deploy(A, arg1, arg2, ...);

// Don't deploy this contract if it has already been deployed
deployer.deploy(A, {overwrite: false});

// Set a maximum amount of gas and `from` address for the deployment
deployer.deploy(A, {gas: 4612388, from: "0x...."});

// Deploy multiple contracts, some with arguments and some without.
// This is quicker than writing three `deployer.deploy()` statements as the deployer
// can perform the deployment as a single batched request.
deployer.deploy([
  [A, arg1, arg2, ...],
  B,
  [C, arg1]
]);

// External dependency example:
//
// For this example, our dependency provides an address when we're deploying to the
// live network, but not for any other networks like testing and development.
// When we're deploying to the live network we want it to use that address, but in
// testing and development we need to deploy a version of our own. Instead of writing
// a bunch of conditionals, we can simply use the `overwrite` key.
deployer.deploy(SomeDependency, {overwrite: false});
```

#### DEPLOYER.LINK(LIBRARY, DESTINATIONS)

Link一个已经部署的库（lib）到一个合约或多个合约。  

```
// Deploy library LibA, then link LibA to contract B, then deploy B.
deployer.deploy(LibA);
deployer.link(LibA, B);
deployer.deploy(B);

// Link LibA to many contracts
deployer.link(LibA, [B, C, D]);
```

#### DEPLOYER.THEN(FUNCTION() {…})

```
var a, b;
deployer.then(function() {
  // Create a new version of A
  return A.new();
}).then(function(instance) {
  a = instance;
  // Get the deployed instance of B
  return B.deployed();
}).then(function(instance) {
  b = instance;
  // Set the new instance of A's address on B via B's setA() function.
  return b.setA(a.address);
});
```


## 参考文档  
[Truffle Framework](http://truffleframework.com/docs/)   