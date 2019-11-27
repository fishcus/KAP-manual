## 在 MapR 环境安装

为使您可以尽快体验到 Kyligence Enterprise 的强大功能，我们推荐您将 Kyligence Enterprise 与 All-in-one Sandbox VM 等沙箱软件一起配合使用。在本节中，我们将引导您在 MapR 环境中快速安装 Kyligence Enterprise。

### 准备运行环境

**MapR 沙箱环境**

首先**请确保您为沙箱分配了充足的资源**，Kyligence Enterprise 对沙箱的资源要求请参阅[**安装前置条件**](../prerequisite.cn.md)。

在配置沙箱时，我们推荐您使用 Bridged Adapter 模型替代 NAT 模型。Bridged Adapter 模型将为您的沙箱分配一个独立的 IP 地址，使您可以任意选择通过本地或远程访问 Kyligence Enterprise GUI。

**MapR 版本支持**

Kyligence Enterprise 支持的 MapR 版本列表
- MapR 5.2.1
- MapR 6.0.1
- MapR 6.1.0

为了避免权限问题， 我们推荐您使用 MapR 的 `mapr` 账户访问 MapR 沙箱， 默认密码为 `mapr`。本节中均以 `mapr` 账户为例。

MapR Cluster 相比于 MapR Sandbox 环境提供了更多的计算存储资源，但是同时环境上也存在一些差异。

**MapR 集群环境**

准备 MapR Cluster 环境，本文使用的是 AWS Marketplace 中的 MapR Converged Community Edition 6.0a1，更多详情请访问 [AWS Marketplace](https://aws.amazon.com/marketplace/pp/B010GJS5WO?qid=1522845995210&sr=0-4&ref_=srh_res_product_title)。

在安装 MapR Cluster 时，推荐给每个节点分配公网 IP。安装完成后，需要在安全组开放一些常用的端口，如 7070 (Kylin)、8090 (RM) 等。

MapR Cluster Node不能直接通过 ssh 访问，需要以 MapR Installer 为跳板机，再通过 ssh 连接访问，ssh 秘钥保存在 MapR Installer 节点的 `/opt/mapr/installer/data` 目录中。

在 Mapr Cluster Node 中访问 MapR Cluster 资源，需要生成 mapr_ticket。生成指令为 `maprlogin password`。如果不清楚当前账户密码，请用 `passwd {user} ` 设置密码。

### 快速安装 Kyligence Enterprise

准备好了环境之后，请参照[快速开始](../../quickstart/README.md)章节安装 Kyligence Enterprise。同时请**务必留意**下述 MapR 环境下的特别注意事项。

> **注意：** 目前在 MapR 上安装 Kyligence Enterprise **仅支持**使用 MySQL 作为元数据存储。详情请参考：[基于 MySQL 的 Metastore 配置](../../installation/rdbms_metastore/mysql_metastore.cn.md)。

### MapR 环境下的特别注意事项

在执行安装步骤时，请务必留意以下事项：

> **提示：** 我们将环境变量 `KYLIN_HOME` 的值设为 Kyligence Enterprise 解压后的路径，便于后面进行说明。

- MapR 中的文件操作命令为 `hadoop fs`，而不是 `hdfs dfs`。请在文件操作时自行替换，这里工作目录以`/kylin` 为例：
   ```sh
   hadoop fs -mkdir /kylin
   hadoop fs -chown mapr /kylin
   ```

- MapR 的文件系统为 `maprfs://`，所以需要您在`$KYLIN_HOME/conf/kylin.properties`中进行以下修改：

   ```properties
   kylin.env.hdfs-working-dir=maprfs:///kylin
   kylin.engine.spark-conf.spark.eventLog.dir=maprfs:///kylin/spark-history
   kylin.engine.spark-conf.spark.history.fs.logDirectory=maprfs:///kylin/spark-history
   ```

   对于 **Kyligence Enterprise 3.4.5** 之前的版本， 同时还需要对 `$KYLIN_HOME/conf/kylin_hive_conf.xml` 及 `$KYLIN_HOME/conf/kylin_job_conf.xml` 中均添加以下参数：

   ```xml
    <property>
        <name>fs.default.name</name>
        <value>maprfs:///</value>
    </property>
   ```

- 如果需要指定 Hive 的环境依赖，请进行以下操作，默认位置如下：

   ```sh
   export HIVE_CONF=/opt/mapr/hive/hive-2.1/conf
   ```

- 请在启动 Kyligence Enterprise 前，指定 `SPARK_HOME` 环境变量，请您根据环境中的 Spark 地址进行替换。

> 注意:
>
>  Kyligence Enterprise 目前只支持 MapR Spark-2.2.1 版本，请通过 MapR 官方文档进行 Spark-2.2.1 的安装。
>  默认情况下， Spark 会被安装至 `/opt/mapr/spark/spark-2.2.1`

  ```sh
  export SPARK_HOME=/opt/mapr/spark/spark-2.2.1
  ```

### FAQ

**Q：如果启动时在 YARN 上提交 spark-context 任务失败，并提示 requestedVirtualCores > maxVirtualCores 的错误？**

您可以调高 `yarn-site.xml ` 中的 `yarn.scheduler.maximum-allocation-vcores` 配置参数：

```xml
<property>
    <name>yarn.scheduler.maximum-allocation-vcores</name>
    <value>24</value>
</property>
```

或者将 `conf/profile` 设置成 `min_profile` 来降低对 YARN Vcore 的需求：

```sh
rm -f $KYLIN_HOME/conf/profile
ln -sfn $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
```

**Q：如果使用 Kafka 报错称连接不上 ZooKeeper**

请留意 MapR 环境里 Zookeeper 的服务端口默认为 `5181`，而不是更常见的 `2181`。可以如下确认当前开放的端口：

```sh
netstat -ntl | grep 5181
netstat -ntl | grep 2181
```

**Q: 如何在 MapR 6.1.0 上安装 Spark 2.2.1**

MapR 6.1.0 版本中， 官方支持的 Spark 版本为 2.3.1， 所以需要手动进行 Spark 2.2.1 的安装.
安装 Spark 2.2.1 需要系统管理员权限， 步骤如下

首先确保系统中的 Spark 2.3.1 已正确安装并可用，如果未安装，可以通过以下命令先安装 Spark 2.3.1

```sh
yum install mapr-spark mapr-spark-historyserver mapr-spark-thriftserver
```

1. 从 MapR 软件库中下载 Spark 2.2.1

```sh
wget http://package.mapr.com/releases/MEP/MEP-5.0.0/redhat/mapr-spark-2.2.1.201804031348-1.noarch.rpm
```

2. 安装 Spark 2.2.1

```sh
mkdir -p /opt/mapr/spark
rpm2cpio mapr-spark-2.2.1.201804031348-1.noarch.rpm | cpio -idmv
cp -r ./opt/mapr/spark/spark-2.2.1 /opt/mapr/spark
rm -rf ./opt
```

MapR spark 2.2.1 被安装至目录： `/opt/mapr/spark/spark-2.2.1`

3. 在 `/opt/mapr/spark/spark-2.2.1/conf` 目录中添加文件 `spark-env.sh` 配置文件， 内容如下

```sh
#########################################################################################################
# Set MapR attributes and compute classpath
#########################################################################################################

# Set the spark attributes
if [ -d "/opt/mapr/spark/spark-2.2.1" ]; then
        export SPARK_HOME=/opt/mapr/spark/spark-2.2.1
fi

# Load the hadoop version attributes
source /opt/mapr/spark/spark-2.2.1/mapr-util/hadoop-version-picker.sh
export HADOOP_HOME=$hadoop_home_dir
export HADOOP_CONF_DIR=$hadoop_conf_dir

# Enable mapr impersonation
export MAPR_IMPERSONATION_ENABLED=1

MAPR_HADOOP_CLASSPATH=`/opt/mapr/spark/spark-2.2.1/bin/mapr-classpath.sh`
MAPR_HADOOP_JNI_PATH=`hadoop jnipath`
MAPR_SPARK_CLASSPATH="$MAPR_HADOOP_CLASSPATH"

SPARK_MAPR_HOME=/opt/mapr

export SPARK_LIBRARY_PATH=$MAPR_HADOOP_JNI_PATH
export LD_LIBRARY_PATH="$MAPR_HADOOP_JNI_PATH:$LD_LIBRARY_PATH"

# Load the classpath generator script
source /opt/mapr/spark/spark-2.2.1/mapr-util/generate-classpath.sh

# Calculate hive jars to include in classpath
generate_compatible_classpath "spark" "2.2.1" "hive"
MAPR_HIVE_CLASSPATH=${generated_classpath}
if [ ! -z "$MAPR_HIVE_CLASSPATH" ]; then
  MAPR_SPARK_CLASSPATH="$MAPR_SPARK_CLASSPATH:$MAPR_HIVE_CLASSPATH"
fi

# Calculate hbase jars to include in classpath
generate_compatible_classpath "spark" "2.2.1" "hbase"
MAPR_HBASE_CLASSPATH=${generated_classpath}
if [ ! -z "$MAPR_HBASE_CLASSPATH" ]; then
  MAPR_SPARK_CLASSPATH="$MAPR_SPARK_CLASSPATH:$MAPR_HBASE_CLASSPATH"
  SPARK_SUBMIT_OPTS="$SPARK_SUBMIT_OPTS -Dspark.driver.extraClassPath=$MAPR_HBASE_CLASSPATH"
fi

# Set executor classpath for MESOS. Uncomment following string if you want deploy spark jobs on Mesos
#MAPR_MESOS_CLASSPATH=$MAPR_SPARK_CLASSPATH
SPARK_SUBMIT_OPTS="$SPARK_SUBMIT_OPTS -Dspark.executor.extraClassPath=$MAPR_HBASE_CLASSPATH:$MAPR_MESOS_CLASSPATH"

# Set SPARK_DIST_CLASSPATH
export SPARK_DIST_CLASSPATH=$MAPR_SPARK_CLASSPATH

# Security status
source /opt/mapr/conf/env.sh
if [ "$MAPR_SECURITY_STATUS" = "true" ]; then
  SPARK_SUBMIT_OPTS="$SPARK_SUBMIT_OPTS -Dhadoop.login=hybrid -Dmapr_sec_enabled=true"
fi

# scala
export SCALA_VERSION=2.11
export SPARK_SCALA_VERSION=$SCALA_VERSION
export SCALA_HOME=/opt/mapr/spark/spark-2.2.1/scala
export SCALA_LIBRARY_PATH=$SCALA_HOME/lib

# Use a fixed identifier for pid files
export SPARK_IDENT_STRING="mapr"

#########################################################################################################
#    :::CAUTION::: DO NOT EDIT ANYTHING ON OR ABOVE THIS LINE
#########################################################################################################


#
# MASTER HA SETTINGS
#
#export SPARK_DAEMON_JAVA_OPTS="-Dspark.deploy.recoveryMode=ZOOKEEPER  -Dspark.deploy.zookeeper.url=<zookeerper1:5181,zookeeper2:5181,..> -Djava.security.auth.login.config=/opt/mapr/conf/mapr.login.conf -Dzookeeper.sasl.client=false"


# MEMORY SETTINGS
export SPARK_DAEMON_MEMORY=1g
export SPARK_WORKER_MEMORY=16g

# Worker Directory
export SPARK_WORKER_DIR=$SPARK_HOME/tmp
```

4. 拷贝配置文件

```sh
mv /opt/mapr/spark/spark-2.2.1/conf/spark-defaults.conf /opt/mapr/spark/spark-2.2.1/conf/spark-defaults.conf.old
cp /opt/mapr/spark/spark-2.3.1/conf/spark-defaults.conf /opt/mapr/spark/spark-2.2.1/conf/spark-defaults.conf
cp /opt/mapr/hive/hive-2.3/conf/hive-site.xml /opt/mapr/spark/spark-2.2.1/conf/
```

5. 创建 Spark 工作目录

```sh
hadoop fs -mkdir /apps/spark
hadoop fs -chown root /apps/spark
hadoop fs -chmod 777 /apps/spark
```

至此， Spark 2.2.1 在 MapR 6.1.0 环境中安装完毕

