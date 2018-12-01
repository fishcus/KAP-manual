# Kyligence Enterprise Quick Start on CDH Sandbox

To enable you to experience Kyligence Enterprise as soon as possible, we recommend that you use Kyligence Enterprise with sandbox software such as All-in-one Sandbox VM. In this section. We will guide you to quickly install Kyligence Enterprise in the CDH sandbox.

### Prepare Environment

First of all, *make sure that you allocate sufficient resources for sandbox*. For resource requirements of Kyligence Enterprise for sandbox, please refer to [Requirement](.\hadoop_env.en.md).

When configuring sandbox, we recommend that you use the Bridged Adapter model instead of the NAT model. The Bridged Adapter model will assign an independent IP address to your sandbox, allowing you to choose either local or remote access to Kyligence Enterprise GUI.

To avoid permission problems, we recommend that you use CDH default account and password `cloudera` to access CDH sandbox. In this section, the `cloudera` account is taken as an example.

If you need to run Kyligence Enterprise in the environment of CDH 5.7+, please select the corresponding version of the CDH.

Please visit Cloudera Manager (the default address: `http://<host_name>: 7180/`, default account and password: `cloudera`) and ensure that `HDFS`, `Yarn`, `Hive`, `HBase`, `Zookeeper` and other components are in normal state without any warning information, as shown in the diagram:

![](images/cdh_57_status.jpg)

> If you encounter the following information when installing Kyligence Enterprise:
>
> ```java
> org.apache.hadoop.hbase.security.AccessDeniedException: Insufficient permissions for user'root (auth:SIMPLE) '
> ```
>
> This indicates that you lack HBase write permissions. If you need to close the permission check for HBase, set the value of the `hbase.coprocessor.region.classes` and` hbase.coprocessor.master.classes`  to `empty`, and set the value of  `hbase.security.authentication`  to` simple`.

### Install Kyligence Enterprise

After setting up the environment, installing Kyligence Enterprise is very simple.

For detailed steps, please refer to [Quick install](.\quick_install.en.md).