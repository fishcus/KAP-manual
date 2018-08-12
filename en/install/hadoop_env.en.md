## Kyligence Enterprise Required Environment

Kyligence Enterprise needs a good Hadoop cluster as its running environment to provide you with a more stable user experience. We recommend that you run Kyligence Enterprise on a single Hadoop cluster. Each server in the cluster should be configured with Hadoop, Hive, HBase, Kafka and so on. Among them, Hadoop and Hive are essential components.

Next we will introduce the required enviroment for Kyligence Enterprise installation.

### Java Environment

Kyligence Enterprise, and the Hadoop nodes that it runs on top of, requires:

- JDK 8 64 bit or above

If your Hadoop cluster is based on JDK 7, please refer to "[How to Run Kyligence Enterprise on Lower Version JDK](about_low_version_jdk.en.md)".

### Account Authority

The Linux account running Kyligence Enterprise must have required access permissions to Hadoop cluster. These permissions include:
* Read/Write permission of HDFS
* Create/Read/Write permission of Hive table
* Create/Read/Write permission of HBase table
* Execution permission of MapReduce job

### Enterprise Level Platform Supported

The following enterprise level data management platform have been authenticated and tested by us.

* Cloudera CDH 5.7 / 5.8 / 5.11 / 5.12
* Hortonworks HDP 2.2 / 2.4
* MapR 5.2.1
* Huawei FusionInsight C60 / C70
* Azure HDInsight 3.4~3.6
* AWS EMR 5.1~5.7

### Resource Allocation

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
We recommend that you use the following hardware configuration:

- Two way Intel to strong processor, 6 core (or 8 core) CPU, main frequency 2.3GHz or above.

- 64GB ECC DDR3 or above

- At least one 1TB SAS hard drives (3.5 inches), 7200RPM, RAID1

- At least two 1GbE Ethernet ports

### Recommended Linux Distribution

We recommend that you use the following version of the Linux operating system:

- Red Hat Enterprise Linux 6.4+ or  7.x
- CentOS 6.4+ or 7.x

