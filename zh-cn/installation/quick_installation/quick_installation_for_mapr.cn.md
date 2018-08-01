## 在 MapR 沙箱中快速安装 Kyligence Enterprise

在安装前，请确认您已阅读[**安装前置条件**](../installation_conditions.cn.md)。

为使您可以尽快体验到 Kyligence Enterprise 的强大功能，我们推荐您将 Kyligence Enterprise 与 All-in-one Sandbox VM 等沙箱软件一起配合使用。在本节中，我们将引导您在 MapR 沙箱中快速安装 Kyligence Enterprise。

### 准备运行环境

首先**请确保您为沙箱分配了充足的资源**，Kyligence Enterprise 对沙箱的资源要求请参阅[安装前置条件](../installation_conditions.cn.md)。

在配置沙箱时，我们推荐您使用 Bridged Adapter 模型替代 NAT 模型。Bridged Adapter 模型将为您的沙箱分配一个独立的 IP 地址，使您可以任意选择通过本地或远程访问 Kyligence Enterprise GUI。

为了避免权限问题，我们推荐您使用 MapR 的 `mapr` 账户访问 MapR 沙箱。MapR 5.2.1 的默认密码是`mapr`。本节中均以`mapr`账户为例。

### 快速安装 Kyligence Enterprise

准备好了环境之后，安装 Kyligence Enterprise 十分简单。

详细步骤请看[在单节点上快速安装 Kyligence Enterprise](quick_installation_for_single_node.cn.md)，并留意下述的 MapR 特殊性。

### MapR 环境的特殊性

MapR 环境有它的特殊性，在执行安装步骤时，请留意以下不同：

- MapR 的文件系统为 `maprfs://`，所以 Kyligence Enterprise 的工作目录应该设为：
   ```properties
   kylin.env.hdfs-working-dir=maprfs:///kylin
   ```

- MapR 中的文件操作命令为 `hadoop fs`，而不是 `hdfs dfs`。请在文件操作时自行替换，比如：
   ```shell
   hadoop fs -mkdir /kylin
   hadoop fs -chown mapr /kylin
   ```

- 检查运行环境时，会因为 `hdfs` 命令找不到而报错。请修改 `$KYLIN_HOME/bin/check-2100-os-commands.sh`，将其中检查 `hdfs` 命令的一行注释掉即可。示例如下：
   ```shell
   #command -v hdfs    || quit "ERROR: Command 'hdfs' is not accessible..."
   ```

- 如果需要显示地指定 Hive 和 Spark 的环境依赖，它们的默认位置如下：
   ```shell
   export HIVE_CONF=/opt/mapr/hive/hive-2.1/conf
   export SPARK_HOME=/opt/mapr/spark/spark-2.1.0
   ```

### MapR 环境中的常见问题

- 如果使用 HBase 做为 Metastore 出现各种错误不好排查，可以考虑改用 MySQL 作为 Metastore 存储。详情参考：[基于关系型数据库（MySQL）的 Metastore 配置](../../config/metastore_jdbc_mysql.cn.md)。

- 如果启动时在 YARN 上提交 spark-context 任务失败，并提示 `requestedVirtualCores > maxVirtualCores` 的错误，可以调高 `yarn-site.xml ` 中的 `yarn.scheduler.maximum-allocation-vcores` 配置参数：

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

- 如果您使用 Kafka，并且 Kafka 报错称连接不上 Zookeeper，请留意 MapR 环境里 Zookeeper 的服务端口默认为 5181，而不是更常见的 2181。可以如下确认当前开放的端口：
   ```shell
   netstat -ntl | grep 5181
   netstat -ntl | grep 2181
   ```

