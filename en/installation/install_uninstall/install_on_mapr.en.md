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
- MapR 6.1.0

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

  **Before the Kyligence Enterprise version 3.4.5**, please add the following properties in `$KYLIN_HOME/conf/kylin_hive_conf.xml` and `$KYLIN_HOME/conf/kylin_job_conf.xml`. 

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

**Q: How to Install Spark 2.2.1 on MapR 6.1.0**

MapR 6.1.0 supports Spark 2.3.1 officially, which is not supported by Kyligence Enterprise. So we need to install Spark 2.2.1 manually.
Installing Spark 2.2.1 requires root privileges, please follow the steps below:

Before install Spark 2.2.1, please make sure Spark 2.3.1 has been installed and runs correctly.
If Spark 2.3.1 is not installed, please install it as bellow:

```sh
yum install mapr-spark mapr-spark-historyserver mapr-spark-thriftserver
```

1. Download Spark 2.2.1 from MapR repository

```sh
wget http://package.mapr.com/releases/MEP/MEP-5.0.0/redhat/mapr-spark-2.2.1.201804031348-1.noarch.rpm
```

2. Install Spark 2.2.1

```sh
mkdir -p /opt/mapr/spark
rpm2cpio mapr-spark-2.2.1.201804031348-1.noarch.rpm | cpio -idmv
cp -r ./opt/mapr/spark/spark-2.2.1 /opt/mapr/spark
rm -rf ./opt
```

MapR spark 2.2.1 will be installed to the directory `/opt/mapr/spark/spark-2.2.1`

3. Add the configuration file `spark-env.sh` into the directory `/opt/mapr/spark/spark-2.2.1/conf`, the content as below

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

4. Copy configuration files

```sh
mv /opt/mapr/spark/spark-2.2.1/conf/spark-defaults.conf /opt/mapr/spark/spark-2.2.1/conf/spark-defaults.conf.old
cp /opt/mapr/spark/spark-2.3.1/conf/spark-defaults.conf /opt/mapr/spark/spark-2.2.1/conf/spark-defaults.conf
cp /opt/mapr/hive/hive-2.3/conf/hive-site.xml /opt/mapr/spark/spark-2.2.1/conf/
```

5. Create the working directory for Spark

```sh
hadoop fs -mkdir /apps/spark
hadoop fs -chown root /apps/spark
hadoop fs -chmod 777 /apps/spark
```

Until now, the Spark 2.2.1 has been installed on MapR 6.1.0 successfully.