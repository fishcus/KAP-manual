## Prerequisite

For better system performance and stability, we recommend that you run Kyligence Enterprise on a dedicated Hadoop cluster. Each server in the cluster should be configured with HDFS, YARN, MapReduce, Hive, Kafka and so on. Among them, HDFS, Yarn, MapReduce, Hive, and Zookeeper are mandatory components.

Next we will introduce the prerequisite of Kyligence Enterprise installation.

### Java Environment

Kyligence Enterprise, and the Hadoop nodes that it runs on top of, require:

- JDK 8 (64 bit) or above

If your Hadoop cluster is based on JDK 7, please refer to [Run Kyligence Enterprise on JDK 7](../appendix/run_on_jdk7.en.md).

### Account Authority

The Linux account running Kyligence Enterprise must have required access permissions to Hadoop cluster. These permissions include:
* Read/Write permission of HDFS
* Create/Read/Write permission of Hive table
* Create/Read/Write permission of HBase table
* Execution permission of MapReduce job

Verify if user have access to the Hadoop cluster assuming the account is `KyAdmin`. Here are the specific test steps:

1. Verify whether user have HDFS read and write permissions

   Assuming the HDFS storage path for cube data is `/kylin`, setting in `conf/kylin.properties` is:

   ```properties
   kylin.env.hdfs-working-dir=/kylin
   ```

   The storage folder must be created and granted with permissions. You may have to switch to HDFS administrator, usually the `hdfs` user, to do this:

   ```shell
   su hdfs
   hdfs dfs -mkdir /kylin
   hdfs dfs -chown KyAdmin /kylin
   hdfs dfs -mkdir /user/KyAdmin
   hdfs dfs -chown KyAdmin /user/KyAdmin
   ```
   Verify the `KyAdmin` user have read and write permissions
   ```shell
   hdfs dfs -put <any_file> /kylin
   hdfs dfs -put <any_file> /user/KyAdmin   
   ```

2. Verify whether the `KyAdmin` user have Hive read and write permissions

   Assuming that the Hive database storing the intermediate table is `kylinDB`. You need to manually create a Hive database named `kylinDB`, and define it in `conf/kylin.properties`:

   ```properties
   kylin.source.hive.database-for-flat-table=kylinDB
   ```

   Then verify the Hive permissions:

   ```shell
   #hive
   hive> show databases;
   hive> create database kylinDB location "/kylin";
   hive> use kylinDB;
   hive> create table t1(id string);
   hive> drop table t1;
   ```
   In Hive, the current user needs to be authorized to access the Kyligence Enterprise HDFS working directory, which is `/kylin` in this case:
   ```shell
   hive> grant all on URI "/kylin" to role KyAdmin;
   ```

3. If you use HBase as metastore, please verify whether the `KyAdmin` user have HBase read and write permissions

   Assume that the HBase table for storing metadata is `XXX_instance` (Kyligence cluster unique identifier), the HBase namespace is `XXX_NS`. Setting in `conf/kylin.properties` is:
   
   ```properties
   kylin.metadata.url=XXX_NS:XXX_instance@hbase
   ```
   
   Verify:

   ```shell
   #hbase shell
   hbase(main)> list
   hbase(main)> create 't1',{NAME => 'f1', VERSIONS => 2}
   hbase(main)> disable 't1'
   hbase(main)> drop 't1'
   ```
   If user do not have permission, ask administrator for authorization, authorization command `hbase(main)> grant 'KyAdmin', 'RWXCA'`.

### Supported Hadoop Distributions

The following Hadoop distributions are verified to run Kyligence Enterprise.

* Cloudera CDH 5.7 / 5.8 / 5.11 / 5.12	
* Hortonworks HDP 2.2 / 2.4 / 2.6
* MapR 5.2.1
* Huawei FusionInsight C60 / C70
* Azure HDInsight 3.6
* AWS EMR 5.14 ~ 5.16

### Hadoop Cluster Resource Allocation

To enable Kyligence Enterprise to efficiently complete the tasks, please ensure that the configuration of the Hadoop cluster satisfies the following conditions:

* `yarn.nodemanager.resource.memory-mb` configuration item bigger than 8192 MB
* `yarn.scheduler.maximum-allocation-mb` configuration item bigger than 4096 MB
* `mapreduce.reduce.memory.mb` configuration item bigger than 700 MB
* `mapreduce.reduce.java.opts` configuration item bigger than 512 MB

If you need to run Kyligence Enterprise in sandbox and other virtual machine environments, please make sure that the virtual machine environment can get the following resources:

- No less than 4 processors

- Memory is no less than 10 GB

- The value of the configuration item `yarn.nodemanager.resource.cpu-vcores` is no less than 8

### Recommended Hardware Configuration
We recommend that you use the following hardware configuration to install Kyligence Enterprise:
- 32 vCore, 128 GB memory
- At least one 1TB SAS HDD (3.5 inches), 7200RPM, RAID1
- At least two 1GbE Ethernet ports

### Recommended Linux Distribution

We recommend that you use the following version of the Linux operating system:

- Red Hat Enterprise Linux 6.4+ or  7.x
- CentOS 6.4+ or 7.x

### Recommended Client Configuration
- CPU: 2.5 GHz Intel Core i7
- Operating System: macOS / windows 7 / windows 10
- RAM: 8G or above
- Browser version:
   + Firefox 60.0.2 or above
   + Chrome 67.0.3396 or above
