## KyStorage参数配置
Kyligence Enterprise Plus将所有的cube数据都保存在KyStorage，一种基于HDFS的列式存储之上。在查询时，Kyligence Enterprise Plus使用Spark (http://spark.apache.org ，具体而言是Spark on Yarn模式)来读取cube，并做可能的存储层预聚合。一个或者多个Spark executor作为长进程启动，用来接收可能的cube访问。对于生产环境部署，请仔细阅读本文档并保证您的executors已经正确配置。

### 配置Spark参数

Kyligence Enterprise Plus将Spark的二进制包和配置文件打包至`KAP_HOME/spark/`目录。理论上可以直接在`KAP_HOME/spark/conf/`路径下按照http://spark.apache.org/docs/latest/configuration.html 来修改Spark自带的所有配置。但是我们不推荐这种方式，因为从运维的便捷性考虑所有Kyligence Enterprise相关的配置都应限制在`KAP_HOME/conf/`路径下。

我们建议用户通过修改kylin.properties配置文件中对应的参数值来配置Spark参数。这些参数大致分为两个类别：环境变量和Spark属性。

### 环境变量

这一类配置与`SPARK_HOME/conf/spark-env.sh`中的配置项相关，在 http://spark.apache.org/docs/latest/configuration.html#environment-variables 中有详细的介绍。一个典型的例子是HADOOP_CONF_DIR参数，它为Spark指定读取Hadoop相关配置的路径。在kylin.properties中有如下配置：

```
kap.storage.columnar.env.HADOOP_CONF_DIR=/etc/hadoop/conf
```

如例子所示，我们只要在任何Spark环境变量前加上前缀*kap.storage.columnar.env*，就能在kylin.properties中指定并覆盖相应的Spark环境变量。

### Spark属性

这一类配置与`SPARK_HOME/conf/spark-defaults.conf`中的配置项相关，在 http://spark.apache.org/docs/latest/configuration.html#spark-properties 中有详细的介绍。一个典型的例子是spark.executor.instances参数，它指定运行的executor数量。在默认的`kylin.properties`中有如下配置（虽然被注释掉了）：

  ```
kap.storage.columnar.conf.spark.executor.instances=4
  ```

这个配置项告诉Spark应当为Kyligence Enterprise启动4个executor。如例子所示，只要在Spark属性前加上前缀*kap.storage.columnar.conf*，就能在kylin.properties中指定并覆盖相应的Spark属性。

| 参数名                       | 默认值 | 含义                                  |
| ---------------------------------------- | ------- | ---------------------------------------- |
| kap.storage.columnar.conf.spark.driver.memory | 4G      | Driver进程可以使用的内存总量。注意，在 client 模式下，这个配置不能在 `SparkConf` 中直接设置，应为在那个时候 driver 进程的 JVM 已经启动了。因此需要在命令行里用` --driver-memory` 选项 或者在默认属性配置文件里设置。 |
| kap.storage.columnar.conf.spark.executor.memory | 4G      | 每个executor进程使用的内存数(如 `2g`, `8g`). |
| kap.storage.columnar.conf.spark.yarn.executor.memoryOverhead |  1G  | 每个`executor`分配的堆外内存. This is memory that accounts for things like VM overheads, interned strings, other native overheads, etc. 该值会随着excutor大小而增长 (通常为 6-10%)。因为Kyligence Enterprise的默认SNAPPY压缩算法消耗大量的堆外内存，默认memoryOverhead 会更大一点 (在Kyligence Enterprise 2.4.0 设置为 4G) |
| kap.storage.columnar.conf.spark.executor.cores | 5       | 在每个excuter上使用的core数量。在 standalone 和 Mesos 粗粒度 模式下，设置该参数允许应用在相同的worker中运行多个excuter，只要该worker有足够多的core。否则在每个应用在单个worker上只会启动一个excuter |
| kap.storage.columnar.conf.spark.executor.instances | 4       | 静态分配时excuter实例的数量。如果配置 `spark.dynamicAllocation.enabled`，excuter的初始数量将会最少为该默认值。 |

### 配置建议

在Spark的默认配置下，启动的executor数量(*spark.executor.instances*)为2，每个executor的CPU核数量(*spark.executor.cores*)为1，为每个executor分配的内存(*spark.executor.memory*)为1GB，为driver分配的内存(*spark.driver.memory*)为1GB。显然这样的配置对于Kyligence Enterprise部署来说太小了。

最佳的配置取决于具体的集群硬件配置。大多数情况下我们建议为每个HDFS或者Yarn节点上分配一个executor。每个executor的CPU核数量应该在2~5个之间。用户可以根据数据量的大小灵活地调节为executor和driver分配的内存大小。以下是一个示例集群上的配置，该集群有4个节点，每个节点有24个CPU核以及64GB的内存。

  ```
kap.storage.columnar.conf.spark.driver.memory=8192m
kap.storage.columnar.conf.spark.executor.memory=8192m
kap.storage.columnar.conf.spark.executor.cores=5
kap.storage.columnar.conf.spark.executor.instances=4
  ```


