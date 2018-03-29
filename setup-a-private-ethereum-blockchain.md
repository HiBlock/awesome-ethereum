# Learn Ethereum

## 教你6步搭建一个以太坊私链  

### 为什么需要以太坊私链  
学习智能合约，可以部署在自己的以太坊私链上，这样省去了真金白银的花费。  
私链，可以理解为本地部署以及运行以太坊智能合约以及DApp的环境。  
环境准备好了，后续才好玩。  

### 操作步骤

1. 安装geth （Mac）

```
$ brew update  
$ brew upgrade  
$ brew tap ethereum/ethereum  
$ brew install ethereum  
```

2. 创建项目  

```
$ mkdir hiblock.net  
$ sudo ln -s /Users/bobjiang/Documents/hiblock.net /hiblock.net
$ cd hiblock.net  
```

3. 创建私链目录

```
$ mkdir private_net  
$ cd private_net  
```

4. 创世块的配置
创建配置文件genesis.json  
文件内容如下：

```
{  
     "config": {
       "chainId": 1000,
       "homesteadBlock": 0,
       "eip155Block": 0,
       "eip158Block": 0
                },
     "nonce": "0x0000000000000061",
     "timestamp": "0x0",
     "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000", 
     "gasLimit": "0x8000000",   
     "difficulty": "0x100",    
     "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
     "coinbase": "0x3333333333333333333333333333333333333333",
     "extraData": "hiblock.net first block",
     "alloc": {}
}
```

解释一下各个参数的作用：

chainId:    以太坊主网chainId为0，私链自己修改为一个任意Id。  
mixhash:    与nonce配合用于挖矿，由上一个区块的一部分生成的hash。注意和nonce的设置需要满足以太坊的黄皮书, 4.3.4. Block Header Validity, (44)章节所描述的条件。  
nonce:    nonce就是一个64位随机数，用于挖矿，注意他和mixhash的设置需要满足以太坊的黄皮书,4.3.4. Block Header Validity, (44)章节所描述的条件。  
difficulty:    设置当前区块的难度，如果难度过大，cpu挖矿就很难，这里设置较小难度  
alloc:    用来预置账号以及账号的以太币数量，因为私有链挖矿比较容易，所以我们不需要预置有币的账号，需要的时候自己创建即可以。  
coinbase:    矿工的账号，随便填  
timestamp:    设置创世块的时间戳  
parentHash:    上一个区块的hash值，因为是创世块，所以这个值是0  
extraData:    附加信息，随便填，可以填你的个性信息  
gasLimit:    值设置对GAS的消耗总量限制，用来限制区块能包含的交易信息总和，因为我们是私有链，所以填最大。

5. 初始化以太坊节点  

```
$ geth --datadir /hiblock.net/private_net/datadir init /hiblock.net/private_net/genesis.json
```

6. 启动私链的以太坊节点  

```
$ geth --datadir /hiblock.net/private_net/datadir --networkid 1000 console
```

7. 以太坊节点的操作说明  
主要操作：  

- admin
- eth
- personal
- miner

每个操作的具体指令，参见如下的提示。

```
> admin
{
  datadir: "/hiblock.net/private_net/datadir",
  nodeInfo: {
    enode: "enode://a2be9153a2f29e6ad2cf381d3b8b89f89d4710e0477ceb44e41a15e68f5f7860f82e68bde9ef65083363f4a9f9a5ae9b46d3e47bb07f94eb8736b9fb7ef237d7@114.22.11.153:30303",
    id: "a2be9153a2f29e6ad2cf381d3b8b89f89d4710e0477ceb44e41a15e68f5f7860f82e68bde9ef65083363f4a9f9a5ae9b46d3e47bb07f94eb8736b9fb7ef237d7",
    ip: "114.22.11.153",
    listenAddr: "[::]:30303",
    name: "Geth/v1.8.3-stable/darwin-amd64/go1.10",
    ports: {
      discovery: 30303,
      listener: 30303
    },
    protocols: {
      eth: {
        config: {...},
        difficulty: 256,
        genesis: "0xacdfa62d82249dfeaad52d08be1098eeb9d630060e842bfc42b916ff887365e9",
        head: "0xacdfa62d82249dfeaad52d08be1098eeb9d630060e842bfc42b916ff887365e9",
        network: 1000
      }
    }
  },
  peers: [],
  addPeer: function(),
  clearHistory: function(),
  exportChain: function(),
  getDatadir: function(callback),
  getNodeInfo: function(callback),
  getPeers: function(callback),
  importChain: function(),
  removePeer: function(),
  sleep: function github.com/ethereum/go-ethereum/console.(*bridge).Sleep-fm(),
  sleepBlocks: function github.com/ethereum/go-ethereum/console.(*bridge).SleepBlocks-fm(),
  startRPC: function(),
  startWS: function(),
  stopRPC: function(),
  stopWS: function()
}
>
> eth
{
  accounts: [],
  blockNumber: 0,
  coinbase: undefined,
  compile: {
    lll: function(),
    serpent: function(),
    solidity: function()
  },
  defaultAccount: undefined,
  defaultBlock: "latest",
  gasPrice: 18000000000,
  hashrate: 0,
  mining: false,
  pendingTransactions: [],
  protocolVersion: "0x3f",
  syncing: false,
  call: function(),
  contract: function(abi),
  estimateGas: function(),
  filter: function(options, callback, filterCreationErrorCallback),
  getAccounts: function(callback),
  getBalance: function(),
  getBlock: function(),
  getBlockNumber: function(callback),
  getBlockTransactionCount: function(),
  getBlockUncleCount: function(),
  getCode: function(),
  getCoinbase: function(callback),
  getCompilers: function(),
  getGasPrice: function(callback),
  getHashrate: function(callback),
  getMining: function(callback),
  getPendingTransactions: function(callback),
  getProtocolVersion: function(callback),
  getRawTransaction: function(),
  getRawTransactionFromBlock: function(),
  getStorageAt: function(),
  getSyncing: function(callback),
  getTransaction: function(),
  getTransactionCount: function(),
  getTransactionFromBlock: function(),
  getTransactionReceipt: function(),
  getUncle: function(),
  getWork: function(),
  iban: function(iban),
  icapNamereg: function(),
  isSyncing: function(callback),
  namereg: function(),
  resend: function(),
  sendIBANTransaction: function(),
  sendRawTransaction: function(),
  sendTransaction: function(),
  sign: function(),
  signTransaction: function(),
  submitTransaction: function(),
  submitWork: function()
}
> personal
{
  listAccounts: [],
  listWallets: [],
  deriveAccount: function(),
  ecRecover: function(),
  getListAccounts: function(callback),
  getListWallets: function(callback),
  importRawKey: function(),
  lockAccount: function(),
  newAccount: function github.com/ethereum/go-ethereum/console.(*bridge).NewAccount-fm(),
  openWallet: function github.com/ethereum/go-ethereum/console.(*bridge).OpenWallet-fm(),
  sendTransaction: function(),
  sign: function github.com/ethereum/go-ethereum/console.(*bridge).Sign-fm(),
  signTransaction: function(),
  unlockAccount: function github.com/ethereum/go-ethereum/console.(*bridge).UnlockAccount-fm()
}
>
> miner
{
  getHashrate: function(),
  setEtherbase: function(),
  setExtra: function(),
  setGasPrice: function(),
  start: function(),
  stop: function()
}
>
```