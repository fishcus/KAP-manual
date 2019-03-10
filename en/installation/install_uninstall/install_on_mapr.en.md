## Install on MapR

For quick start, we recommend that you use Kyligence Enterprise with sandbox software such as All-in-one Sandbox VM. In this section. We will guide you to quickly install Kyligence Enterprise in the MapR sandbox.

### Prepare Environment

**MapR Sandbox Environment**

First of all, **make sure that you allocate sufficient resources for sandbox**. For resource requirements of Kyligence Enterprise for sandbox, please refer to [Prerequisites](../prerequisite.en.md).

When configuring sandbox, we recommend that you use the Bridged Adapter model instead of the NAT model. The Bridged Adapter model will assign an independent IP address to your sandbox, allowing you to choose either local or remote access to Kyligence Enterprise GUI.

**MapR Cluster Environment**

Following MapR versions are supported by Kyligence Enterprise:
- MapR 5.2.1
- MapR 6.0.1

To avoid permission issue in the sandbox, you can use MapR's `mapr` account through SSH. The default password is `mapr`. This guide uses `mapr` account as example.

For the MapR Cluster environment, we use the MapR Converged Community Edition 6.0a1 in AWS Marketplace. For more details, please refer to [AWS Marketplace](https://aws.amazon.com/marketplace/pp/B010GJS5WO?qid=1522845995210&sr=0-4&ref_=srh_res_product_title) 

When installing MapR Cluster, it is recommended to assign public network IP to each node. After installation, you need to open some ports in the security group, such as 7070 (Kylin), 8090 (RM), etc.

MapR Cluster Node cannot be accessed directly through SSH. It requires MapR Installer as a springboard, and then access through SSH. SSH secret keys stored in ` /opt/mapr/installer/data ` of  MapR Installer node.

To access MapR Cluster resources in MapR Cluster Node, you need to generate mapr_ticket. The generation instruction is `maprlogin password`. If you do not know the current account password, please set the password with `passwd {user}`.

### Install Kyligence Enterprise

After setting up the environment, installing Kyligence Enterprise is very simple. For detailed steps, please refer to [Quick Startl](../../quickstart/README.md). 

Please **DO PAY ATTENTION** to the following instructions.

>**Caution:** For Kyligence metastore, only MySQL is **supported** in current version. For how to set up MySQL as metastore, please refer to [Use MySQL as Metastore](../../installation/rdbms_metastore/mysql_metastore.en.md).

### Special Instructions for MapR Environment
 
Please pay sepcial attention to the following steps when install Kyligence Enterprise on MapR:

> **Note:** Please set environment variable `KYLIN_HOME` to be the folder path where Kyligence Enterprise is unpacked, which will be used in further illustration.

- The file operation command in MapR is `hadoop fs` instead of `hdfs dfs`. Please replace it by yourself and here we use  `/kylin` as an example:

  ```sh
  hadoop fs -mkdir /kylin
  hadoop fs -chown mapr /kylin
  ```

- The file system of MapR is `maprfs://`, so some properties in `$KYLIN_HOME/conf/kylin.properties` should be changed as:

  ```properties
  kylin.env.hdfs-working-dir=maprfs:///kylin
  kylin.engine.spark-conf.spark.eventLog.dir=maprfs:///kylin/spark-history
  kylin.engine.spark-conf.spark.history.fs.logDirectory=maprfs:///kylin/spark-history
  ```

  In addition to this, please add the following properties in `$KYLIN_HOME/conf/kylin_hive_conf.xml` and `$KYLIN_HOME/conf/kylin_job_conf.xml`. 

  ```xml
    <property>
           <name>fs.default.name</name>
           <value>maprfs:///</value>
           <description> Disable Hive's auto merge</description>
    </property>
  ```

- If you need to specify the environment dependencies of Hive, the default locations are as follows:

  ```sh
  export HIVE_CONF=/opt/mapr/hive/hive-2.1/conf
  ```

* Please specify the environment dependencies of Spark before you start Kyligence Enterprise. Please replace the example path with your actual Spark path.

> Note:
> 
>  Kyligence Enterprise currently only support MapR Spark-2.2.1, please refer to the MapR's official document to install MapR Spark-2.2.1
>  Spark-2.2.1 will be installed in the path `/opt/mapr/spark/spark-2.2.1` by default

  ```sh
  export SPARK_HOME=/opt/mapr/spark/spark-2.2.1
  ```


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

```sh
rm -f $KYLIN_HOME/conf/profile
ln -sfn $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
```

**Q: If you use Kafka and can't connect to Zookeeper.**

Please note that the default of Zookeeper's service port in the MapR environment is 5181, not 2181. The ports can be confirmed as follows:

```sh
netstat -ntl | grep 5181
netstat -ntl | grep 2181
```

