## Install on Huawei FusionInsight Platform

To enable you to experience Kyligence Enterprise as soon as possible, we recommend that you use Kyligence Enterprise with sandbox software such as All-in-one Sandbox VM. In this section. We will guide you to quickly install Kyligence Enterprise in the Huawei FusionInsight sandbox.

### Prepare Environment

First of all, **make sure that you allocate sufficient resources for sandbox**. For resource requirements of Kyligence Enterprise for sandbox, please refer to [Prerequisites](../prerequisite.en.md).

Execute the following command to initialize some environment variables:

```shell
source /opt/hadoopclient/bigdata_env
kinit <user_name>
```

### Install Kyligence Enterprise

After setting up the environment, please refer to [Quick Start](../../quickstart/README.md).

### Special Instructions for FusionInsight Environment

1. Create a working directory of Kyligence Enterprise on HDFS and grant permission to read and write. The default working directory is `/kylin`. Kyligence Enterprise needs to write temporary data to `/user/{current_user} `directory, and create corresponding directory. Run the following command:

   ```shell
   hdfs dfs -mkdir /kylin
   hdfs dfs -chown root /kylin
   hdfs dfs -chmod 755 /tmp/hive-scratch
   hdfs dfs -mkdir /user/root
   hdfs dfs -chown root /user/root
   ```

   > Tip: You can modify the location of the Kyligence Enterprise working directory in    `$KYLIN_HOME/conf/kylin.properties`.
   >

   If the account you use does not have read and write permissions on HDFS, please transfer to HDFS account first, then create work directory and grant permissions. Please execute the following command:

   ```sh
   su hdfs
   hdfs dfs -mkdir /kylin
   hdfs dfs -chown root /kylin
   hdfs dfs -chmod 755 /tmp/hive-scratch
   hdfs dfs -mkdir /user/root
   hdfs dfs -chown root /user/root
   ```

2. Please copy **all the configuration items** from `hivemetastore-site.xml`  to the `hive-site.xml` file used by Kyligence Enterprise. Then copy the `hive-site.xml` file to `$KYLIN_HOME/spark/conf/`.


3. In the FI Manager page, click **Hive - configuration (all configuration) - Security-whitelist.**

   The white list's configuration item is named `hive.security.authorization.sqlstd.confwhitelist`, and then add all Hive configuration keys (such as `dfs.replication`) from `$KYLIN_HOME/conf/kylin_hive_conf.xml ` and some other parameters (such as `fs.defaultFS` and`mapreduce.job.reduces`) to the whitelist of the FI Hive configuration.

   Here is an example and please replace some values based on your **Hadoop** environment.

   ```properties
   hive.security.authorization.sqlstd.confwhitelist = mapreduce.job.reduces,dfs.replication,hive.exec.compress.output,hive.auto.convert.join,hive.auto.convert.join.noconditionaltask,hive.auto.convert.join.noconditionaltask.size,mapreduce.map.output.compress.codec,mapreduce.output.fileoutputformat.compress.codec,mapreduce.output.fileoutputformat.compress.type,mapreduce.job.split.metainfo.maxsize,hive.stats.autogather,hive.merge.mapfiles,hive.merge.mapredfiles,mapreduce.job.reduces,fs.defaultFS
   ```

4. Please input **beeline** into the FI client and copy the contents after `Connect to`,  and do the following configuration in `$KYLIN_HOME/conf/kylin.properties`:

	```properties
kylin.source.hive.client=beeline
kylin.source.hive.beeline-params=-n root -u 'jdbc:hive2://…HADOOP.COM'
  ```

### FAQ:

**Q: If there occurs permission denied on /tmp/hive-scratch after restart FusionInsight Hive, how to resolve it?**

Please run the command below and try again.

```shell
hdfs dfs -chmod 755 /tmp/hive-scratch
```

**Q: If the environment check failed on Snappy not installed, how to resolve it?**

Please install Snappy on your own, or modify the following configuration items related to the Snappy in the `$KYLIN_HOME/conf/kylin.properties`:

```properties
kylin.storage.hbase.compression-codec=none
```

**Q: If there is an error message about HBase permission, how to resolve it？**

Please create a new user in FI Manager and allocate the user in a user group named `supergroup`  as `System_administrator`. After that, please run the below commands to change the directory owner.

```sh
hdfs dfs -chown -R <user_name> <working_directory>
```

**Q: When building a Cube or query pushdown to SparkSQL, appear the following error: `Caused by: org.apache.thrift.transport.TTransportException` **

Please confirm whether to implement the second point of special instructions above. Ensure that the `hive-site.xml` used by Kyligence Enterprise contains all configuration items from the `hivemetastore-site.xml` file of the hive directory in the FusionInsight client.