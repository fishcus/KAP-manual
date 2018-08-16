## Kyligence Enterprise 安装前置条件

Kyligence Enterprise 需要一个状态良好的 Hadoop 集群作为其运行环境，以便为您提供更加稳定的使用体验。我们建议您将 Kyligence Enterprise 单独运行在一个 Hadoop 集群上。该集群中的每一台服务器应当配置的组件包括：HDFS、Yarn、MapReduce、Hive、Kafka 等。其中，HDFS、Yarn、MapReduce、Hive 是必需组件。

下面我们将为您介绍 Kyligence Enterprise 安装的前置条件。

### Java 环境

本产品，及其运行的 Hadoop 环境中的所有节点，需要的 Java 环境是：

- JDK 8 64 bit 或以上

如果您的 Hadoop 集群环境为 JDK 7，请参考 [如何在低版本 JDK 上运行 Kyligence Enterprise](./about_low_version_jdk.cn.md)。

### 账户权限

您在运行 Kyligence Enterprise 时所使用的的 Linux 账户，应当具备访问 Hadoop 集群的权限，包括：

+ 读写 HDFS 上的文件
+ 创建和读取 Hive 表
+ 创建和操作 HBase 表（如果您使用 JDBC 连接元数据存储，该项可忽略）
+ 提交 MapReduce 任务

### 支持的 Hadoop 平台

下述企业级数据管理平台及其相应版本已经过我们的认证和测试：

+ Cloudera CDH 5.7 / 5.8 / 5.11 / 5.12
+ Hortonworks HDP 2.2 / 2.4
+ MapR 5.2.1
+ 华为 FusionInsight C60 / C70
+ Azure HDInsight 3.4~3.6
+ AWS EMR 5.1~5.7


### 资源分配

为了使 Kyligence Enterprise 能够高效地完成提交的任务，请您确保使用的 Hadoop 集群的配置满足如下条件：

+ `yarn.nodemanager.resource.memory-mb` 配置项的值不小于 8192 MB
+ `yarn.scheduler.maximum-allocation-mb` 配置项的值不小于 4096 MB
+ `mapreduce.reduce.memory.mb` 配置项的值不小于 700 MB
+ `mapreduce.reduce.java.opts` 配置项的值不小于 512 MB

如果您需要在沙箱等虚拟机环境中运行 Kyligence Enterprise，请您确保该虚拟机环境能够获取如下资源：

+ 处理器个数不小于 4
+ 内存不小于 10 GB
+ `yarn.nodemanager.resource.cpu-vcores` 配置项的值不小于8

### 推荐的硬件配置

我们推荐您使用下述硬件配置：

+ 两路 Intel 至强处理器，6核（或8核）CPU，主频 2.3GHz 或以上
+ 64GB ECC DDR3 以上
+ 至少1个 1TB 的 SAS 硬盘（3.5寸），7200RPM，RAID1
+ 至少两个 1GbE 的以太网电口

### 推荐的Linux版本

我们推荐您使用下述版本的 Linux 操作系统：

+ Red Hat Enterprise Linux 6.4+ 或 7.x
+ CentOS 6.4+ 或 7.x

### 推荐的客户端配置

- CPU：2.5 GHz Intel Core i7
- 操作系统：macOS / windows 7 或 10
- 内存：8G 或以上
- 浏览器及版本：
- 火狐 60.0.2 及以上
- 谷歌 67.0.3396 及以上
