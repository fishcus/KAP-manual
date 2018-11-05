## 在 MapR Cluster 中快速安装 Kyligence Enterprise

在安装前，请确认您已阅读[**安装前置条件**](../installation_conditions.cn.md)。

MapR Cluster 相比于 MapR Sandbox 环境提供了更多的计算存储资源，但是同时环境上也存在一些差异。

### 准备运行环境

1. 准备 MapR Cluster 环境，本文使用的是 AWS Marketplace 中的 MapR Converged Community Edition 6.0a1，可以点击如下[链接](https://aws.amazon.com/marketplace/pp/B010GJS5WO?qid=1522845995210&sr=0-4&ref_=srh_res_product_title)获取相关信息。

2. 在安装 MapR Cluster 时，推荐给每个节点分配公网 IP。安装完成后，需要在安全组开放一些常用的端口，如 7070 (Kylin)、8090 (RM) 等。

3. MapR Cluster Node不能直接通过 ssh 访问，需要以 MapR Installer 为跳板机，再通过 ssh 连接访问，ssh 秘钥保存在 MapR Installer 节点的 `/opt/mapr/installer/data` 目录中。

4. 在 Mapr Cluster Node 中访问 MapR Cluster 资源，需要生成 mapr_ticket。生成指令为 `maprlogin password`。如果不清楚当前账户密码，请用 `passwd {user} ` 设置密码。

### 快速安装 Kyligence Enterprise

准备好了环境之后，安装 Kyligence Enterprise 十分简单。

详细步骤请看[在单节点上快速安装 Kyligence Enterprise](quick_installation_for_single_node.cn.md)，并留意下述的 MapR 特殊性。

### MapR 环境的特殊性

MapR 环境有它的特殊性，在执行安装步骤时，请留意以下不同：

- MapR 中的文件操作命令为 `hadoop fs`，而不是 `hdfs dfs`。请在文件操作时自行替换，这里工作目录以`/kylin` 为例：

  ```shell
  hadoop fs -mkdir /kylin
  hadoop fs -chown mapr /kylin
  ```

- MapR 的文件系统为 `maprfs://`，所以需要您在 Kyligence Enterprise 安装目录下的 `/conf/kylin.properties`中进行以下修改：

  ```properties
  kylin.env.hdfs-working-dir=maprfs:///kylin
  kylin.engine.spark-conf.spark.eventLog.dir=maprfs:///kylin/spark-history
  kylin.engine.spark-conf.spark.history.fs.logDirectory=maprfs:///kylin/spark-history
  ```

- 如果需要指定 Hive 的环境依赖，请进行以下操作，默认位置如下：

  ```shell
  export HIVE_CONF=/opt/mapr/hive/hive-2.1/conf
  ```

- 请在启动 Kyligence Enterprise 前，指定 Spark 的环境依赖，这里以默认位置作为示范：

  ```shell
  export SPARK_HOME=/opt/mapr/spark/spark-2.1.0
  ```

- 考虑到使用 HBase 做为 Metastore 出现各种错误不好排查，我们建议您使用 MySQL 作为 Metastore 存储。详情参考：[基于 MySQL 的 Metastore 配置](../../config/metastore_jdbc_mysql.cn.md)。

### FAQ

**Q：如果启动时在 YARN 上提交 spark-context 任务失败，并提示 `requestedVirtualCores > maxVirtualCores` 的错误？**

您可以调高 `yarn-site.xml ` 中的 `yarn.scheduler.maximum-allocation-vcores` 配置参数：

```xml
<property>
    <name>yarn.scheduler.maximum-allocation-vcores</name>
    <value>24</value>
</property>
```

或者将 `conf/profile` 设置成 `min_profile` 来降低对 YARN vcore 的需求：

```shell
rm -f $KYLIN_HOME/conf/profile
ln -sfn $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
```

**Q：如果使用 Kafka 报错称连接不上 ZooKeeper**

请留意 MapR 环境里 Zookeeper 的服务端口默认为 5181，而不是更常见的 2181。可以使用如下命令确认当前开放的端口：

```shell
netstat -ntl | grep 5181
netstat -ntl | grep 2181
```

**Q：检查运行环境时，如果因为 `hdfs` 命令找不到而报错**

请修改 `$KYLIN_HOME/bin/check-2100-os-commands.sh`，将其中检查 `hdfs` 命令的一行注释掉即可。示例如下：

```shell
#command -v hdfs    || quit "ERROR: Command 'hdfs' is not accessible..."
```

