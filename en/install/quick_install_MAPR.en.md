## Kyligence Enterprise Quick Start on MapR Sandbox

In this guide, we will explain how to quickly install Kyligence Enterprise on MapR sandbox.

Before proceeding, please make sure the [Prerequisite of Kyligence Enterprise](hadoop_env.en.md) is met.

### Prerequisite

First of all, **please make sure that you allocate sufficient resources for sandbox**. For resource requirements of Kyligence Enterprise for sandbox, please refer to [Requirement](.\hadoop_env.en.md).

When configuring sandbox, we recommend that you use the Bridged Adapter model instead of the NAT model. The Bridged Adapter model will assign an independent IP address to your sandbox, allowing you to choose either local or remote access to Kyligence Enterprise GUI.

To avoid permission issue in the sandbox, you can use MapR's  *mapr* account through SSH. The password for **MapR 5.2.1** is `mapr`. This guide uses `mapr` account as example. 

### Install Kyligence Enterprise

After setting up the environment, installing Kyligence Enterprise is very simple.

For detailed steps, please refer to [Quick install](.\quick_install.en.md).  Please pay attention to the following particularity in MapR environment.

### Particularity of the MapR Environment

The MapR environment is different with others. Please pay attention to the following steps when implementing the installation steps:

- The file operation command in MapR is `hadoop fs` instead of `hdfs dfs`. Please replace it by yourself and here we use  `/kylin` as an example:

  ```shell
  hadoop fs -mkdir /kylin
  hadoop fs -chown mapr /kylin
  ```
- The file system of MapR is `maprfs://`, so some properties in `$KYLIN_HOME/conf/kylin.properties` should be changed as:

  ```properties
  kylin.env.hdfs-working-dir=maprfs:///kylin
  kylin.engine.spark-conf.spark.eventLog.dir=maprfs:///kylin/spark-history
  kylin.engine.spark-conf.spark.history.fs.logDirectory=maprfs:///kylin/spark-history
  ```


- If you need to specify the environment dependencies of Hive, the default locations are as follows:

  ```shell
  export HIVE_CONF=/opt/mapr/hive/hive-2.1/conf
  ```

* Please specify the environment dependencies of Spark before you start Kyligence Enterprise, such as:

  ```shell
  export SPARK_HOME=/opt/mapr/spark/spark-2.1.0
  ```

* To consider that using HBase as Metastore and errors can't be solved easily, using MySQL as Metastore is recommended. More details refer to [Use MySQL as Metastore](../config/metastore_jdbc_mysql.en.md).

### FAQ

**Q: If the spark-context task is failed on YARN at startup and shows error with requestedVirtualCores > maxVirtualCores.**

Please adjust `yarn.scheduler.maximum-allocation-vcores` configuration parameters in `yarn-site.xml`:

```xml
<property>
    <name>yarn.scheduler.maximum-allocation-vcores</name>
    <value>24</value>
</property>
```

Or set `conf/profile` to `min_profile` to reduce the need for YARN Vcore:

```shell
rm -f $KYLIN_HOME/conf/profile
ln -sfn $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
```

**Q: If you use Kafka and can't connect to Zookeeper.**

Please note that the default of Zookeeper's service port in the MapR environment is 5181, not 2181. The ports can be confirmed as follows:

```shell
netstat -ntl | grep 5181
netstat -ntl | grep 2181
```

**Q: When checking the environment, there is an error with `hdfs` command cannot be found.**

Please modify the` $KYLIN_HOME/bin/check-2100-os-commands.sh` and annotate the command line of `hdfs`, such as:

```shell
#command -v hdfs    || quit "ERROR: Command 'hdfs' is not accessible..."
```