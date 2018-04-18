# Learn Ethereum - Truffle框架介绍（1）

本文档包含内容来自于[Truffle Framework](http://truffleframework.com/docs/)   
- 安装
- 创建项目
- 客户端的选择
- 编译合约
- 部署合约
- 更多内容请参考下一期

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
选择什么客户端取决于当前是开发阶段，还是要部署合约。  

### 开发阶段
#### ganache UI
本文强烈推荐 [ganache](http://truffleframework.com/ganache)，简单易用。可以在个人PC上完美模拟一个以太坊的节点环境

#### truffle develop

### ganache CLI

### 部署阶段（生产环境）

## 参考文档  
[Truffle Framework](http://truffleframework.com/docs/)   