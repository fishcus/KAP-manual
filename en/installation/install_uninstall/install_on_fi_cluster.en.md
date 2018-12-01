# Kyligence Enterprise Quick Start on FusionInsight

Before the installation, please read the [Prerequisite of Kyligence Enterprise](hadoop_env.en.md) chapter at first.

Kyligence Enterprise can run in FusionInsight environment. In this section, we will guide you to install Kyligence Enterprise quickly in the FusionInsight environment.

### Preparation for Operating Environment 

If you need to run Kyligence Enterprise in FusionInsight environment, please select the corresponding version of **Huawei FI** package.

Execute the following command to initialize some environment variables:

```shell
source /opt/hadoopclient/bigdata_env
kinit <user_name>
```

### Download and Install Kyligence Enterprise

1. Get Kyligence Enterprise software package. You can visit [Kyligence Enterprise release notes](../release/README.md) and choose the version that is suitable for you.
2. Copy the Kyligence Enterprise software package to the server or virtual machine that you need to install Kyligence Enterprise, and decompress it to the installation path. We assume that your installation path is `/usr/local/`. Run the following command:

```shell
cd /usr/local
tar -zxvf Kyligence-Enterprise-{version}.tar.gz
```

3. Set the value of environment variable `KYLIN_HOME` to the path of Kyligence Enterprise.

```shell
export KYLIN_HOME=/usr/local/Kyligence-Enterprise-{version}
```

4. Create a working directory of Kyligence Enterprise on HDFS and grant permission to read and write. The default working directory is `/kylin`. Kyligence Enterprise needs to write temporary data to `/user/{current_user} `directory, and create corresponding directory. Run the following command:

```shell
hdfs dfs -mkdir /kylin
hdfs dfs -chown root /kylin
hdfs dfs -chmod 755 /tmp/hive-scratch
hdfs dfs -mkdir /user/root
hdfs dfs -chown root /user/root
```

> Tip: You can modify the location of the Kyligence Enterprise working directory in `$KYLIN_HOME/conf/kylin.properties`.
>

Notice: If the account you use does not have read and write permissions on HDFS, please transfer to HDFS account first, then create work directory and grant permissions. Please execute the following command:

```shell
su hdfs
hdfs dfs -mkdir /kylin
hdfs dfs -chown root /kylin
hdfs dfs -chmod 755 /tmp/hive-scratch
hdfs dfs -mkdir /user/root
hdfs dfs -chown root /user/root
```

5. Please copy **all the configuration items** from `hivemetastore-site.xml`  to `hive-site.xml` in FusionInsight Hive directory. Then copy the `hive-site.xml` file to `$KYLIN_HOME/conf/` by the following commands:

   ```shell
   cp $HIVE_HOME/../config/hive-site.xml $KYLIN_HOME/conf/
   ```

6. In the FI Manager page, click **Hive - configuration (all configuration) - Security-whitelist.**

   The white list's configuration item is named `hive.security.authorization.sqlstd.confwhitelist`, and then add all Hive configuration keys (such as `dfs.replication`) from `$KYLIN_HOME/conf/kylin_hive_conf.xml ` and some other parameters (such as `fs.defaultFS` and`mapreduce.job.reduces`) to the whitelist of the FI Hive configuration.

   Here is an example and please replace some values based on your **Hadoop** environment.

   ```properties
   hive.security.authorization.sqlstd.confwhitelist = mapreduce.job.reduces,dfs.replication,hive.exec.compress.output,hive.auto.convert.join,hive.auto.convert.join.noconditionaltask,hive.auto.convert.join.noconditionaltask.size,mapreduce.map.output.compress.codec,mapreduce.output.fileoutputformat.compress.codec,mapreduce.output.fileoutputformat.compress.type,mapreduce.job.split.metainfo.maxsize,hive.stats.autogather,hive.merge.mapfiles,hive.merge.mapredfiles,mapreduce.job.reduces,fs.defaultFS
   ```

7. Please input **beeline** into the FI client and copy the contents after `Connect to`,  and do the following configuration in `$KYLIN_HOME/conf/kylin.properties`:

   ```properties
   kylin.source.hive.client=beeline
   kylin.source.hive.beeline-params=-n root -u 'jdbc:hive2://…HADOOP.COM'
   ```

   > The user.keytab item that needs to be configured in the `kylin.source.hive.beeline-params` should be the concrete path name, such as `user.keytab = ${KYLIN_HOME}/conf/user.keytab`;

### Check the Running Environment

Before starting Kyligence Enterprise for the first time, Kyligence Enterprise will check the environment. If the system finds problems in the process, you will see warnings or error messages in the console.

Some of the problems encountered may be due to the inability to obtain environmental dependencies effectively. If you encounter such problems, please run the following command to gets the environment dependency information:

```properties
export HIVE_CONF=HIVE_CLIENT_CONF //The configuration path of the hive client is not hive path.
export HCAT_HOME=HCATALOG_DIR
export SPARK_HOME=$KYLIN_HOME/spark //For Kyligence Enterprise Plus 2.2 and plus.
```

> Notice: You can check the running environment manually at any time. Run the following command:
>
> ```shell
> $KYLIN_HOME/bin/check-env.sh
> ```

For HUAWEI FI C70, if Kerberos security authentication is enabled in the runtime environment, and the configuration `hive.server2.enable.doAs `of the cluster's` hive-site.xml `is false, the associated configuration items need to be added:

```properties
kylin.source.hive.table-dir-create-first=true
```

If you need to deploy Kerberos, please refer to [Kerberos](..\security\kerberos.en.md)

### Start Kyligence Enterprise

Run the following command to star Kyligence Enterprise:

```shell
${KYLIN_HOME}/bin/kylin.sh start
```

> If you want to observe the detailed progress of the startup, run the following command:
>
> ```shell
> tail -f $KYLIN_HOME/logs/kylin.log
> ```

After the boot is successful, you will see the information in the console. At this point, you can run the following commands to check the process:

```shell
ps -ef | grep kylin
```

### Access to Kyligence Enterprise GUI

When Kyligence Enterprise starts successfully, you can open the web browser and access `http://<host_name>: 7070/kylin/`. Please replace the `<host_name>` with the specific host name, IP address, or domain name. The default port value is `7070`. The default username and password are `ADMIN` and` KYLIN`, respectively.

After you have successfully logged in to Kyligence Enterprise GUI, you can verify the function of Kyligence Enterprise by building Sample Cube. Please refer to [install validate](.\install_validate.en.md).

### Stop Kyligence Enterprise

Execute the following command to stop Kyligence Enterprise:

```shell
$KYLIN_HOME/bin/kylin.sh stop
```

You can run the following command to see if the Kyligence Enterprise process has stopped.

```shell
ps -ef | grep kylin
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