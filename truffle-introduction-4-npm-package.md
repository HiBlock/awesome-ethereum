# Learn Ethereum - Truffle框架介绍（4）

本文档包含内容来自于[Truffle Framework](http://truffleframework.com/docs/)   
本文包含内容如下：  
- NPM包管理

# NPM包管理
truffle集成了 npm 包管理功能，在项目的 node_modules 文件夹下存储着NPM包。也就是说我们可以通过 npm 使用和发布合约、dapp、以及库文件，这样我们可以使用别人的代码，其他人也很容易的使用我们的代码。

## 包结构
truffle创建的项目有默认的结构，也可以用于包的结构。这不是必须的，只是通用习惯。这么做的话会让你的包变得更容易使用。

truffle包中最重要的2个文件夹：  
- /contracts
- /builds (还包含 /builds/contracts，truffle自动创建的)

第一个是合约的文件夹，里面包含合约的源文件。第二个是构建文件夹，里面包含 .json 格式的构建产物。包含合约的源文件，会允许其他人在他们的代码中导入你的合约。简单来说，包含构建后的 .json 格式的构建产物，其他人可以在 javascript 中无缝的使用你的合约，如在 dapp、脚本及部署中使用。

## 使用包
有两种方式可以使用包，一种是在合约代码中导入（import），另一种是在 javascript 代码（部署和测试）中使用。下面分别给出例子。

### 安装


转载请注明以下信息：  

有问题、疑问，欢迎到社区提问 -   

## HiBlock介绍
HiBlock 秉承开放、协作、透明、链接、分享的价值观，致力打造一个专注于区块链的开发者社区，我们不仅在开发者中宣传推广区块链，还会帮助开发者真正掌握区块链技术和应用。我们有线上活动（如一起译文档、一起学以太坊、一起学EOS等），有培训课程（提供专业的区块链技术培训 http://hiblock.net/topics/node16 ）、也有线下沙龙聚会（全国各城进行线下交流），还有blockathon（链接全球区块链开发者）。详情参考：https://github.com/HiBlock/hiblock/tree/master/meetup 

[HiBlock社区](hiblock.net)  
[HiBlock github仓库](https://github.com/HiBlock/)  
[EtherChina github仓库](https://github.com/etherchina/)  

## 参考文档  
[Truffle Framework](http://truffleframework.com/docs/)   
