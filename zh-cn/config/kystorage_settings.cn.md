## 介绍
KAP Plus将所有的cube都保存在KyStorage上，一种基于HDFS的列式存储。在查询时，KAP使用Spark (http://spark.apache.org, 具体来说我们使用Spark on yarn模式)来读取cube，并做可能的存储层预聚合。一个或者多个Spark executor作为长进程启动，用来接收可能的cube访问。对于生产环境部署，您应当仔细阅读本文档并保证您的executors被正确配置。另外，我们使用grpc（http://www.grpc.io/ ）来连接KAP的查询服务器和spark，必要时，需要增加grpc的配置、

## 调整spark参数

KAP Plus打包了所有spark的二进制包和配置文件，这些都位于KAP_HOME/spark目录。KAP使用spark-submit脚本来启动所有的executor，因此在理论上您可以直接到KAP_HOME/spark/conf并按照 http://spark.apache.org/docs/latest/configuration.html 来修改spark自带的所有配置。但是这并不是我们推荐的方式，因为从运维的便捷性考虑我们推荐所有的KAP相关的设置都应该在KAP_HOME/conf目录中。



### 环境变量

这一类设置与SPARK_HOME/conf/spark-env.sh中的设置项相关，在 http://spark.apache.org/docs/latest/configuration.html#environment-variables 中有详细的介绍。一个典型的例子是`HADOOP_CONF_DIR`，它可以用来告诉Spark该从哪里读到hadoop相关的设置。在默认的`kylin.properties`中有如下配置：

> kap.storage.columnar.env.HADOOP_CONF_DIR=/etc/hadoop/conf

如这个例子所示，我们只要在任何的环境变量前面加上`kap.storage.columnar.env`,就能在`kylin.properties`中指定一个Spark的环境变量。

### Spark属性

这一类设置与SPARK_HOME/conf/spark-defaults.conf中的设置项相关，在 http://spark.apache.org/docs/latest/configuration.html#spark-properties 中有详细的介绍。一个典型的例子是`spark.executor.instances`，它可以用来指定应该运行多少个executor。在默认的`kylin.properties`中有如下配置（虽然被注释掉了）：

> ```
> kap.storage.columnar.conf.spark.executor.instances=4
> ```

这个配置项告诉Spark应当为KAP启动4个executor。如这个例子所示，只要在Spark属性前面加上`kap.storage.columnar.conf`，我们就能够在`kylin.properties`中指定一个Spark属性。

| Property Name                            | Default | Meaning                                  |
| ---------------------------------------- | ------- | ---------------------------------------- |
| kap.storage.columnar.conf.spark.driver.memory | 1G      | Amount of memory to use for the driver process, i.e. where SparkContext is initialized. (e.g. `1g`, `2g`). *Note:* In client mode, this config must not be set through the `SparkConf` directly in your application, because the driver JVM has already started at that point. Instead, please set this through the `--driver-memory` command line option or in your default properties file. |
| kap.storage.columnar.conf.spark.executor.memory | 1G      | Amount of memory to use per executor process (e.g. `2g`, `8g`). |
| kap.storage.columnar.conf.spark.executor.cores | 1       | The number of cores to use on each executor. In standalone and Mesos coarse-grained modes, setting this parameter allows an application to run multiple executors on the same worker, provided that there are enough cores on that worker. Otherwise, only one executor per application will run on each worker. |
| kap.storage.columnar.conf.spark.executor.instances | 2       | The number of executors for static allocation. With `spark.dynamicAllocation.enabled`, the initial set of executors will be at least this large. |

### 配置建议

在Spark的默认配置下，启动的executor数量(`spark.executor.instances`)为2，每个executor的CPU核数量(`spark.executor.cores`)是1，每个executor的内存(`spark.executor.memory`)是1G，driver的内存(`spark.driver.memory`)是1G。显然这样的配置对于严肃的KAP部署来说太小了。

最佳的配置取决于具体的集群硬件配置。在大多数情况下我们建议在每台hdfs或者yarn节点上安排一个executor。每个executor的CPU核数量应该在2~5个之间。用户可以根据数据量的大小灵活地调节executor和driver的内存大小。以下是一个示例集群上的配置，该集群有4个节点，每台有24个CPU核，64G的内存。

> ```
> kap.storage.columnar.conf.spark.driver.memory=8192m
> kap.storage.columnar.conf.spark.executor.memory=8192m
> kap.storage.columnar.conf.spark.executor.cores=5
> kap.storage.columnar.conf.spark.executor.instances=4
> ```

## 调整grpc参数

### 修改最大返回大小 （从KAP 2.2开始）

由于https://github.com/grpc/grpc-java/issues/1676， grpc默认的最大的返回结果的大小被减小到了4。为了避免类似“Caused by: io.grpc.StatusRuntimeException: INTERNAL: Frame size 108427384 exceeds maximum: 104857600”这样的异常，在KAP的默认配置中，我们把这个值增加到了128M。如果这个配置还是不够大，可以考虑在`kylin.properties`中设置


> ```
> kap.storage.columnar.grpc-max-response-size=SIZE_IN_BYTES
> ```
