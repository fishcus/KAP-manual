## Kyligence Enterprise Quick Start on MapR Sandbox

To enable you to experience Kyligence Enterprise as soon as possible, we recommend you use Kyligence Enterprise with sandbox software such as All-in-one Sandbox VM. In this section, we will guide you to quickly install Kyligence Enterprise in the HDP sandbox.

### Prepare Environment

First of all, *make sure that you allocate sufficient resources for sandbox*. For resource requirements of Kyligence Enterprise for sandbox, please refer to [Requirement](.\hadoop_env.en.md).

When configuring sandbox, we recommend that you use the Bridged Adapter model instead of the NAT model. The Bridged Adapter model will assign an independent IP address to your sandbox, allowing you to choose either local or remote access to Kyligence Enterprise GUI.

To avoid permission issue in the sandbox, you can use MapR's  *root* account through SSH . The password for *MapR 5.2.1* is *`mapr`*. This guide uses *`root`* account as example. 

### Install Kyligence Enterprise

After setting up the environment, installing Kyligence Enterprise is very simple.

For detailed steps, please refer to [Quick install](.\quick_install.en.md). Pay attention to the following MapR particularity.

### Particularity of the MapR Environment

The MapR environment has its particularity. Please pay attention to the following steps when implementing the installation steps:

- The file system of MapR is `maprfs://`, so the working directory of Kyligence Enterprise should be set as:

  ```properties
  kylin.env.hdfs-working-dir=maprfs:///kylin
  ```

- The file operation command in MapR is `hadoop fs`instead of `hdfs dfs`. Please replace it by yourself when the file is operated, such as:

  ```shell
  hadoop fs -mkdir /kylin
  hadoop fs -chown root /kylin
  ```

- When checking the environment, there will be error because the `hdfs` command cannot be found. Please modify the` $KYLIN_HOME/bin/check-2100-os-commands.sh` and annotate the command line of `hdfs`. For an example:

  ```shell
  #command -v hdfs    || quit "ERROR: Command 'hdfs' is not accessible..."
  ```

- If you need to specify the environment dependencies of Hive and Spark, their default locations are as follows:

  ```shell
  export HIVE_CONF=/opt/mapr/hive/hive-2.1/conf
  export SPARK_HOME=/opt/mapr/spark/spark-2.1.0
  ```

### Common Problems in the MapR Environment

- If you use HBase as Metastore and errors can't be solved easily, you can consider using MySQL as Metastore storage. Details refer to [Use JDBC to connect MySQL as metastore](..\config\metastore_jdbc_mysql.en.md).

- If the spark-context task is failed on YARN at startup and shows `requestedVirtualCores > maxVirtualCores` error,  `yarn.scheduler.maximum-allocation-vcores` configuration parameters in `yarn-site.xml`can be adjusted:

  ```xml
  <property>
      <name>yarn.scheduler.maximum-allocation-vcores</name>
      <value>24</value>
  </property>
  ```

   Or set `conf/profile` to `min_profile` to reduce the need for YARN Vcore:

- ```shell
  rm -f $KYLIN_HOME/conf/profile
  ln -sfn $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
  ```

- If you use Kafka and can't connect to Zookeeper, please note that the default of Zookeeper's service port in the MapR environment is 5181, not 2181. The ports can be confirmed as follows:

- ```shell
  netstat -ntl | grep 5181
  netstat -ntl | grep 2181
  ```

