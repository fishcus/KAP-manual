## Install on Hortonworks HDP Platform

To enable you to experience Kyligence Enterprise as soon as possible, we recommend you use Kyligence Enterprise with sandbox software such as All-in-one Sandbox VM. In this section, we will guide you to quickly install Kyligence Enterprise in the HDP sandbox.

### Prepare Environment

First of all, **make sure that you allocate sufficient resources for sandbox**. For resource requirements of Kyligence Enterprise for sandbox, please refer to [Prerequisites](../prerequisite.en.md).

When configuring sandbox, we recommend that you use the Bridged Adapter model instead of the NAT model. The Bridged Adapter model will assign an independent IP address to your sandbox, allowing you to choose either local or remote access to Kyligence Enterprise GUI.

To avoid permission problems, we recommend that you use HDP's `root` account to access HDP sandbox. Please refer to the [Hortonworks documents](http://zh.hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/) for detailed information about account and passwords for HDP 2.3+. In this section, the `root` account is taken as an example.

Please run the following command to start Ambari:

```shell
ambari-agent start
ambari-server start
```

After start, please ensure that `HDFS`, `Yarn`, `Hive`, `HBase`,` Zookeeper` and other components are in normal state and do not have any warning information.

### Install Kyligence Enterprise

After setting up the environment, please refer to [Quick Start](../../quickstart/README.md).

### FAQ

**Q: If I encounter the following information `org.apache.hadoop.hbase.security.AccessDeniedException: Insufficient permissions for user'root (auth:SIMPLE)'`when installing Kyligence Enterprise, how to resolve it?**

This indicates that you lack HBase write permissions. If you need to close the permission check for HBase, set the value of the `hbase.coprocessor.region.classes` and` hbase.coprocessor.master.classes`  to `empty`, and set the value of  `hbase.security.authentication`  to` simple`.