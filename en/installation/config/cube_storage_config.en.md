## Cube Storage Configuration

Kyligence Enterprise stores all cube data in KyStorage, a columnar storage system on HDFS. When processing queries, Kyligence Enterprise uses [Spark](http://spark.apache.org), specifically we use Spark on Yarn mode, for cube accessing and possibly storage pre-aggregations.  One or more Spark executors are started as long-running processes to receive cube access requests. For deployments in production environment, please go through this page to make sure your Spark executors are well configured. 

Kyligence Enterprise ships with all necessary Spark assemblies and configurations, which reside in `$KYLIN_HOME/spark/`. Kyligence Enterprise uses the spark-submit script to launch all the executors. Theoretically you can directly go to `$KYLIN_HOME/spark/conf/` to make changes according to the [Spark configuration]( http://spark.apache.org/docs/latest/configuration.html). However it's NOT the recommended way, we suggest you keep all Kyligence Enterprise related configurations in `$KYLIN_HOME/conf/`. 

It's highly recommended to change Spark configurations in `$KYLIN_HOME/bin/kylin.properties`. Typically there're two major categories of configurations for Spark: environment variables and Spark properties.

### Environment Variables

This category relates to properties in `$SPARK_HOME/conf/spark-env.sh`, for which there are detailed explanations in [Spark Environment Variables](http://spark.apache.org/docs/latest/configuration.html#environment-variables). A typical example is `HADOOP_CONF_DIR`, which tells Spark where the hadoop configurations reside in. By default we have a configuration entry in  `$KYLIN_HOME/bin/kylin.properties`:

```
kap.storage.columnar.env.HADOOP_CONF_DIR=/etc/hadoop/conf
```

As the example illustrates, by prefixing the Spark environment variable with *kap.storage.columnar.env*, we can specify any Spark environment variable in `$KYLIN_HOME/bin/kylin.properties`.

### Spark Properties

This category relates to `$SPARK_HOME/conf/spark-defaults.conf`, for which there are detailed explanations in [Spark Properties](http://spark.apache.org/docs/latest/configuration.html#spark-properties). A typical example is `spark.executor.instances`, which specifies how many executors should be launched. By default we have a configuration entry in `$KYLIN_HOME/bin/kylin.properties`:

```
kap.storage.columnar.spark-conf.spark.executor.instances=4
```

The configuration entry tells Spark to launch 4 executors for KE. As the example illustrates, by prefixing the Spark property with *kap.storage.columnar.conf* , we can specify any Spark property in `$KYLIN_HOME/bin/kylin.properties`.

| Property Name                                                | Default | Meaning                                                      |
| ------------------------------------------------------------ | ------- | ------------------------------------------------------------ |
| kap.storage.columnar.spark-conf.spark.driver.memory          | 4G      | Amount of memory to use for the driver process, i.e. where SparkContext is initialized. (e.g. `1g`, `2g`). *Note:* In client mode, this config must not be set through the `SparkConf` directly in your application, because the driver JVM has already started at that point. Instead, please set this through the `--driver-memory` command line option or in your default properties file. |
| kap.storage.columnar.spark-conf.spark.executor.memory        | 4G      | Amount of memory to use per executor process (e.g. `2g`, `8g`). |
| kap.storage.columnar.spark-conf.spark.yarn.executor.memoryOverhead | 1G      | The amount of off-heap memory (in megabytes) to be allocated per executor. This is memory that accounts for things like VM overheads, interned strings, other native overheads, etc. This tends to grow with the executor size (typically 6-10%). Since Kyligence Enterprise's default SNAPPY compression consumes lots of off-heap, by default memoryOverhead is larger (in KAP 2.4.0 it's 4G) |
| kap.storage.columnar.spark-conf.spark.executor.cores         | 5       | The number of cores to use on each executor. In standalone and Mesos coarse-grained modes, setting this parameter allows an application to run multiple executors on the same worker, provided that there are enough cores on that worker. Otherwise, only one executor per application will run on each worker. |
| kap.storage.columnar.spark-conf.spark.executor.instances     | 4       | The number of executors for static allocation. With `spark.dynamicAllocation.enabled`, the initial set of executors will be at least this large. |

### Recommended Configuration

By Spark's default configuration, the number of executors to be launched (*spark.executor.instances*) is 2, the number of cores for each executor (*spark.executor.cores*) is 1, the memory per executor (*spark.executor.memory*) is 1GB, the memory for driver (*spark.driver.memory*) is 1GB. Obviously it's not enough for KE deployments in production environment. 

The optimal configuration depends on your cluster hardware specifications. In most cases we suggest one executors assigned per HDFS/Yarn server. The number of cores for each executor could be somewhere between 2~5. You can flexibly adjust memory for executors and memory for the driver depending on data scale. Here's a sample configuration for a 4-node cluster, where each server has 24 cores and 64GB RAM:

```
kap.storage.columnar.spark-conf.spark.driver.memory=8192m
kap.storage.columnar.spark-conf.spark.executor.memory=8192m
kap.storage.columnar.spark-conf.spark.executor.cores=5
kap.storage.columnar.spark-conf.spark.executor.instances=4
```

