## Use SparkSQL during Cube Build

Kyligence Enterprise leverages Hive by default to do part of the pre-calculations during cube build process. Since SparkSQL has better performance over Hive in general, using SparkSQL instead of Hive during cube build may improve the build speed at certain steps.

![sparksql_build_step](images/sparksql_flat_table.en.png)

### Configure SparkSQL

**HDP / CDH / FusionInsight Platform:**

Please follow the steps below to enable SparkSQL during cube build:

1. To run Spark on YARN, you need to specify environment variable `HADOOP_CONF_DIR`, which is the directory that contains the client side configuration files for Hadoop. In many Hadoop distributions, the directory normally is `/etc/hadoop/conf`. Therefore, it is recommended to create a directory to link those files. 

   ```shell
   mkdir $KYLIN_HOME/hadoop-conf
   ln -s $HADOOP_CONF_DIR/core-site.xml $KYLIN_HOME/hadoop-conf/core-site.xml
   ln -s $HADOOP_CONF_DIR/hdfs-site.xml $KYLIN_HOME/hadoop-conf/hdfs-site.xml
   ln -s $HADOOP_CONF_DIR/yarn-site.xml $KYLIN_HOME/hadoop-conf/yarn-site.xml
   ln -s $HBASE_HOME/hbase-site.xml $KYLIN_HOME/hadoop-conf/hbase-site.xml
   cp /$HIVE_HOME/conf/hive-site.xml $KYLIN_HOME/hadoop-conf/hive-site.xml
   ```

   > **Note**: In HDP 2.4, there is a conflict between hive-tez and Spark, so please change the default engine from “tez” to “mr” when copying.
   >
   > ```xml
   > <property>
   > 	<name>hive.execution.engine</name>
   > 	<value>mr</value>
   > </property>
   > ```

2. Set below configuration in `$KYLIN_HOME/conf/kylin.properties`.

   ```properties
   kylin.source.hive.enable-sparksql-for-table-ops=true
   kylin.env.hadoop-conf-dir=$KYLIN_HOME/hadoop-conf
   ```
  > Note: Please replace the ` $KYLIN_HOME/hadoop-conf ` here with an absolute path. Property ` kylin.source.hive.enable-sparksql-for-table-ops=true ` supports setup at the project or cube level, see [Configuration Override](../config/config_override.en.md).

**MapR Platform:**

For MapR platform, you can simply just add the property below to enable SparkSQL during cube build, and this property also supports setup at the system or project or cube level:


   ```properties
   kylin.source.hive.enable-sparksql-for-table-ops=true
   ```
   
> Note: It's need to export `SPARK_HOME` as MapR Spark installation before Kyligence Enterprise start 


### Verify SparkSQL

You can run the prepared check script to verify those properties.

```shell
$KYLIN_HOME/bin/spark-test.sh test
```

> Note: ` kylin.source.hive.enable-sparksql-for-table-ops=true ` need to be set to `$KYLIN_HOME/conf/kylin.properties` before this script is run.

If you can see the following output, it means those properties have been configured successfully.

```shell
...
Starting test spark with conf
...
====================================
Testing spark-sql...
19/01/16 07:55:50 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 1.2.0
19/01/16 07:55:51 WARN ObjectStore: Failed to get database default, returning NoSuchObjectException
19/01/16 07:56:02 WARN Utils: Your hostname, maprdemo resolves to a loopback address: 127.0.0.1; using 10.1.2.223 instead (on interface eth0)
19/01/16 07:56:02 WARN Utils: Set SPARK_LOCAL_IP if you need to bind to another address
Time taken: 1.597 seconds
...
```
