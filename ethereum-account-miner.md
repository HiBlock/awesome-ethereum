# Learn Ethereum

## 以太坊账户、挖矿、转账

我们先来看看geth命令有哪些功能

```
bobjiang$ geth help
NAME:
   geth - the go-ethereum command line interface

   Copyright 2013-2017 The go-ethereum Authors

USAGE:
   geth [options] command [command options] [arguments...]

VERSION:
   1.8.3-stable

COMMANDS:
   account           Manage accounts
   attach            Start an interactive JavaScript environment (connect to node)
   bug               opens a window to report a bug on the geth repo
   console           Start an interactive JavaScript environment
   copydb            Create a local chain from a target chaindata folder
   dump              Dump a specific block from storage
   dumpconfig        Show configuration values
   export            Export blockchain into file
   export-preimages  Export the preimage database into an RLP stream
   import            Import a blockchain file
   import-preimages  Import the preimage database from an RLP stream
   init              Bootstrap and initialize a new genesis block
   js                Execute the specified JavaScript files
   license           Display license information
   makecache         Generate ethash verification cache (for testing)
   makedag           Generate ethash mining DAG (for testing)
   monitor           Monitor and visualize node metrics
   removedb          Remove blockchain and state databases
   version           Print version numbers
   wallet            Manage Ethereum presale wallets
   help, h           Shows a list of commands or help for one command
```

### 以太坊账户  

1. 再次启动私链的以太坊节点  

```
$ geth --datadir /hiblock.net/private_net/datadir --networkid 1000 console
```

[如何搭建以太坊私链](./setup-a-private-ethereum-blockchain.md)

2. 新建两个以太坊账号  

账号密码设置为123456
```
> personal.newAccount("123456")
"0xe75636e8aefa4d87d162381713b4ec6852744f57"
> personal.listAccounts
["0xe75636e8aefa4d87d162381713b4ec6852744f57"]
> personal.newAccount("123456")
"0xade3aa350a4f63d2195eaa72e0c8701e47f6d979"
> personal.listAccounts
["0xe75636e8aefa4d87d162381713b4ec6852744f57", "0xade3aa350a4f63d2195eaa72e0c8701e47f6d979"]
```

现在我们有两个以太坊账号（下面是账号的地址）：
- 0xe75636e8aefa4d87d162381713b4ec6852744f57
- 0xade3aa350a4f63d2195eaa72e0c8701e47f6d979

3. 解锁账号

```
> personal.unlockAccount("0xe75636e8aefa4d87d162381713b4ec6852744f57")
Unlock account 0xe75636e8aefa4d87d162381713b4ec6852744f57
Passphrase:
true
```

### 挖矿  

4. 开始挖矿  

```
> miner.start()
INFO [03-30|15:33:27] Transaction pool price threshold updated price=18000000000
INFO [03-30|15:33:27] Starting mining operation
null
INFO [03-30|15:33:27] Commit new mining work                   number=4 txs=0 uncles=0 elapsed=158.034µs
> INFO [03-30|15:33:27] Successfully sealed new block            number=4 hash=f99304…808d64
INFO [03-30|15:33:27] 🔨 mined potential block                  number=4 hash=f99304…808d64
INFO [03-30|15:33:27] Commit new mining work                   number=5 txs=0 uncles=0 elapsed=147.1µs
INFO [03-30|15:33:27] Successfully sealed new block            number=5 hash=774240…364495
INFO [03-30|15:33:27] 🔨 mined potential block                  number=5 hash=774240…364495
INFO [03-30|15:33:27] Mining too far in the future             wait=2s
INFO [03-30|15:33:29] Commit new mining work                   number=6 txs=0 uncles=0 elapsed=2.008s
INFO [03-30|15:33:31] Generating DAG in progress               epoch=1 percentage=0 elapsed=2.537s
INFO [03-30|15:33:31] Successfully sealed new block            number=6 hash=286f74…cd2a07
```

5. 停止挖矿  

```
> miner.stop()
```

6. 当前区块信息  

```
> eth.blockNumber
10
> eth.getBlock( eth.blockNumber )
{
  difficulty: 131456,
  extraData: "0xd783010803846765746886676f312e31308664617277696e",
  gasLimit: 132912767,
  gasUsed: 0,
  hash: "0x63e67962081932b4bfbf22520891a3b34f0e1454cfead960d99d6c2612bfdd93",
  logsBloom: "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  miner: "0xe75636e8aefa4d87d162381713b4ec6852744f57",
  mixHash: "0x0935b87ca9f5c7b5ecccea7b72b8e4899425aecd0eef73f6522c040e849035bb",
  nonce: "0x08a4b142a67d1b50",
  number: 10,
  parentHash: "0xd999531e6da9a4f2c119ca613ca2004f3cfe2d2efd04ee9232b31910d4e77f92",
  receiptsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  sha3Uncles: "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347",
  size: 536,
  stateRoot: "0x75141e874ff80f0cbbb5d27383350602fb24a167d2882df237aa0cfa6d2559de",
  timestamp: 1522395219,
  totalDifficulty: 1312384,
  transactions: [],
  transactionsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  uncles: []
}
```

### 转账  

7. 账户余额

```
> web3.fromWei(eth.getBalance(eth.accounts[0]))
50
```

8. 两个账户之间转账  

```
> eth.accounts
["0xe75636e8aefa4d87d162381713b4ec6852744f57", "0xade3aa350a4f63d2195eaa72e0c8701e47f6d979"]
> personal.unlockAccount("0xe75636e8aefa4d87d162381713b4ec6852744f57")
Unlock account 0xe75636e8aefa4d87d162381713b4ec6852744f57
Passphrase:
true
> eth.sendTransaction({from: "0xe75636e8aefa4d87d162381713b4ec6852744f57", to: "0xade3aa350a4f63d2195eaa72e0c8701e47f6d979", value: web3.toWei(2,"ether")})
INFO [03-30|15:45:56] Submitted transaction                    fullhash=0x50dd5491f0f474dda8c9ad09b16e98686638b3269e56f24b05b2219685009001 recipient=0xAde3AA350A4F63D2195EaA72E0c8701e47f6d979
"0x50dd5491f0f474dda8c9ad09b16e98686638b3269e56f24b05b2219685009001"
>
> web3.fromWei(eth.getBalance(eth.accounts[0]))
50
> web3.fromWei(eth.getBalance(eth.accounts[1]))
0
```

已经转账，然而此时交易没有被打包，所以账户1的余额仍然是50个以太。  
下面启动挖矿，进行交易打包  

```
> miner.start()
INFO [03-30|15:48:07] Updated mining threads                   threads=0
INFO [03-30|15:48:07] Transaction pool price threshold updated price=18000000000
INFO [03-30|15:48:07] Starting mining operation
null
> INFO [03-30|15:48:07] Commit new mining work                   number=11 txs=1 uncles=0 elapsed=1.402ms
INFO [03-30|15:48:11] Successfully sealed new block            number=11 hash=c4f2b9…e5b282
> miner.stop()
```

交易被打包，再检查余额  
```
> web3.fromWei(eth.getBalance(eth.accounts[1]))
2
```

转载请注明以下信息：  
HiBlock秉承开放、协作、透明、链接、分享的价值观，致力打造一个专注于区块链的开发者社区，我们不仅在开发者中宣传推广区块链，还会帮助开发者真正掌握区块链技术和应用。  

有问题、疑问，欢迎到社区提问 -   
[访问HiBlock社区](hiblock.net)  
[访问HiBlock仓库1](https://github.com/HiBlock/)  
[访问HiBlock仓库2](https://github.com/etherchina/)  

参考资料：https://github.com/ConsenSys/local_ethereum_network
