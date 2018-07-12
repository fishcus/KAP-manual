## Kyligence Enterprise Quick Start on MapR Cluster

MapR cluster provides more calculation and storage resources than MapR sandbox. In the meantime, there are some differences in configuration. 

### Prepare Environment

1. For the MapR Cluster environment, we use the MapR Converged Community Edition 6.0a1 in AWS Marketplace. [Click](https://aws.amazon.com/marketplace/pp/B010GJS5WO?qid=1522845995210&sr=0-4&ref_=srh_res_product_title) to find more information.

2. When installing MapR Cluster, it is recommended to assign public network IP to each node. After installation, you need to open some ports in the security group, such as 7070 (Kylin), 8090 (RM), etc.

3. MapR Cluster Node cannot be accessed directly through SSH. It requires MapR Installer as a springboard, and then access through SSH. SSH secret keys stored in ` /opt/mapr/installer/data ` of  MapR Installer node.

4. To access MapR Cluster resources in Mapr Cluster Node, you need to generate mapr_ticket. The generation instruction is `maprlogin password`. If you do not know the current account password, please set the password with `passwd {user}`.

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

