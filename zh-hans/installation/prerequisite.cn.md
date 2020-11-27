## 安装前置条件

为了保障系统的性能与稳定性，我们建议您将 Kyligence Enterprise 单独运行在一个独立的 Hadoop 集群上。该集群中的每一台服务器应当配置的组件包括：HDFS、Yarn、MapReduce、Hive、Kafka 等。其中，HDFS、YARN、MapReduce、Hive、Zookeeper 是必需组件。

下面我们将为您介绍 Kyligence Enterprise 安装的前置条件。

### Java 环境

本产品，及其运行的 Hadoop 环境中的所有节点，需要的 Java 环境是：

- JDK 8 (64 bit) 或以上

如果您的 Hadoop 集群环境为 JDK 7，请参考 [如何在低版本 JDK 上运行 Kyligence Enterprise](../appendix/run_on_jdk7.cn.md)。

### 账户权限

您在运行 Kyligence Enterprise 时所使用的的 Linux 账户，应当具备访问 Hadoop 集群的权限，包括：

+ 读写 HDFS 上的文件
+ 创建和读取 Hive 表
+ 创建和操作 HBase 表（如果您使用 JDBC 连接元数据存储，该项可忽略）
+ 提交 MapReduce 任务

下面假设使用账户为 `KyAdmin`，并验证是否具备访问 Hadoop 集群的权限。具体步骤如下：

1. 测试是否具有 HDFS 读写权限

   假设 Cube 数据的 HDFS 存储路径为`/kylin`，在 `conf/kylin.properties` 中定义：

   ```properties
   kylin.env.hdfs-working-dir=/kylin
   ```

   请手工创建该工作目录并授予权限。一般需要由文件系统管理员 HDFS 用户，为 `KyAdmin` 创建工作目录`/kylin`，并且赋予权限。

   ```shell
   su hdfs
   hdfs dfs -mkdir /kylin
   hdfs dfs -chown KyAdmin /kylin
   hdfs dfs -mkdir /user/KyAdmin
   hdfs dfs -chown KyAdmin /user/KyAdmin
   ```
   验证 `KyAdmin` 具有读写权限：
   ```shell
   hdfs dfs -put <any_file> /kylin
   hdfs dfs -put <any_file> /user/KyAdmin   
   ```

2. 测试 `KyAdmin` 是否具备 Hive 读写权限

   假设您存储中间表的 Hive 数据库为 kylinDB，您需要手动创建名为 kylinDB 的 Hive 数据库，并在 `conf/kylin.properties` 中设置：

   ```properties
   kylin.source.hive.database-for-flat-table=kylinDB
   ```
   然后验证权限：

   ```shell
   #hive
   hive> show databases;
   hive> create database kylinDB location "/kylin";
   hive> use kylinDB;
   hive> create table t1(id string);
   hive> drop table t1;
   ```
3. 如果启用 Sentry 管理 Hive 的数据权限，则需要在 Hive 中授权当前用户访问 Kyligence Enterprise HDFS 工作目录和临时目录的权限。请参考 [与 Kerberos + Sentry 集成](../security/cdh_kerberos_sentry.cn.md) 进行赋权。

4. 假如您使用 HBase 作为 Metastore，请测试 `KyAdmin` 用户是否具备 HBase 读写权限
   假设存储元数据的 HBase 表为 *XXX_instance*（ Kyligence 集群唯一标识），HBase 命名空间为 *XXX_NS*，需要在`conf/kylin.properties` 中设置：

   ```properties
   kylin.metadata.url=XXX_NS:XXX_instance@hbase
   ```

   验证如下命令：

   ```shell
   #hbase shell
   hbase(main)> list
   hbase(main)> create 't1',{NAME => 'f1', VERSIONS => 2}
   hbase(main)> disable 't1'
   hbase(main)> drop 't1'
   ```
   如果没有权限，找管理员授权，授权方法 `hbase(main)> grant 'KyAdmin','RWXCA'`

### 支持的 Hadoop 平台

下述企业级数据管理平台及其相应 Hadoop 版本已经过我们的认证和测试，其中粗体的为主要测试版本：

- Cloudera CDH  5.4/5.8/5.14/6.0/6.1/6.2.1/6.3.1
- Hortonworks HDP **2.4** / 2.6
- MapR **6.0.1** / **6.1.0**
- 华为 FusionInsight C60 / **C70** / **6.5.1**
- Azure HDInsight **3.6**
- AWS EMR 5.14 ~ 5.16 / **5.23**

> 以下 Hadoop 版本曾经测试可用，但已不再维护测试：
> - Hortonworks HDP 2.2
> - MapR 5.2.1
>
> 对于 Hortonworks HDP 3.1 版本已支持下压至原生 Spark SQL。


### 集群资源分配

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

我们推荐您使用下述硬件配置安装 Kyligence Enterprise：
+ 32 vCore，128 GB 内存
+ 至少1个 1TB 的 SAS 硬盘（3.5寸），7200RPM，RAID1
+ 至少两个 1GbE 的以太网电口

### 推荐的 Linux 版本

我们推荐您使用下述版本的 Linux 操作系统：

+ Red Hat Enterprise Linux 6.4+ 或 7.x
+ CentOS 6.4+ 或 7.x

### 推荐的客户端配置

- CPU：2.5 GHz Intel Core i7
- 操作系统：macOS / windows 7 或 10
- 内存：8G 或以上
- 浏览器及版本：
	+ 火狐 60.0.2 及以上
	+ 谷歌Chrome 67.0.3396 及以上
