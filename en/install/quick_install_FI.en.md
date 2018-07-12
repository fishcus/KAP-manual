# Kyligence Enterprise Quick Start on FusionInsight

Kyligence Enterprise can run in FusionInsight environment. In this section, we will guide you to install Kyligence Enterprise quickly in the FusionInsight environment.

### Preparation for Operating Environment

Kyligence Enterprise supports FusionInsight environment of version V100R002C60U20. The versions of the components in this version are as follows:

- Hadoop: 2.7.2

- HBase: 1.0.2

- Hive: 1.3.0

- Zookeeper: 3.5.1

- Spark: 1.5.1

If you need to run Kyligence Enterprise in FusionInsight environment, please select the corresponding version of HBase 1.x.

Execute the following command to create Kerberos users and initialize the environment:

```shell
kinit <user_name>
source /opt/hadoopclient/bigdata_env
```

If the version of the thrift package under  `lib/ ` of HBase client and Hive client is inconsistent, please keep the higher version and remove the lower version of the thrift package out of `lib/ ` and backup it.

### Download and Install Kyligence Enterprise

1. Get Kyligence Enterprise software package. You can visit [Kyligence Enterprise release notes](../release/README.md) and choose the version that is suitable for you.
2. Copy the Kyligence Enterprise software package to the server or virtual machine that you need to install Kyligence Enterprise, and decompress it to the installation path. We assume that your installation path is `/usr/local/`. Run the following command:

```shell
cd /usr/local
tar -zxvf Kyligence Enterprise-{version}.tar.gz
```

3. Set the value of environment variable `KYLIN_HOME` to the path of Kyligence Enterprise.

```shell
export KYLIN_HOME=/usr/local/Kyligence Enterprise-{version}
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

*Notice: If the account you use does not have read and write permissions on HDFS, please transfer to HDFS account first, then create work directory and grant permissions.* Execute the following command:

```shell
su hdfs
hdfs dfs -mkdir /kylin
hdfs dfs -chown root /kylin
hdfs dfs -chmod 755 /tmp/hive-scratch
hdfs dfs -mkdir /user/root
hdfs dfs -chown root /user/root
```

5. Please copy all the configuration items file of the Hive client  in`hivemetastore-site.xml`  to `hive-site.xml`.

> *Notice: For Kyligence Enterprise Plus 2.4 and above, you also need to copy `hive-site.xml` file to `$KYLIN_HOME/spark/conf/ path`.*
>
> If you are running Kyligence Enterprise Enterprise instead of Kyligence Enterprise Plus, please copy all the configuration items in `hbase-site.xml  `of the HBase client to` $KYLIN_HOME/conf/kylin_job_conf.xml`.
>

6. In the FI Manager page, click *Hive - configuration (all configuration) - Security-whitelist*.

   The white list's configuration item is named `hive.security.authorization.sqlstd.confwhitelis`t, and then add all the keys to Hive configurarion files(such as `dfs.replication`)  in `$KYLIN_HOME/conf/kylin_hive_conf.xml `  to the whitelist of the FI Hive configuration. In addition, for Kyligence Enterprise Plus 2.2 and above, add `mapreduce.job.reduces` to the whitelist.

7. Please input *beeline* into the FI client and copy the contents after *Connect to*: *jdbc:hive2://... HADOOP.COM*, and do the following configuration in `$KYLIN_HOME/conf/kylin.properties`:

```properties
kylin.source.hive.client=beeline
kylin.source.hive.beeline-params=-n root -u 'jdbc:hive2://…HADOOP.COM'
```

> The usr.keytab item that needs to be configured in the `kylin.source.hive.beeline-params` should be the concrete path name, such as `user.keytab\= ${KYLIN_HOME}/conf/user.keytab`;

### Replace the Spark Jar File

Due to the upgrade of Hadoop version in *Fusioninght C70*, some Jar packages in Kyligence Enterprise HBase 1.x version are not compatible. You need to get the Jar package in the Hadoop environment to replace the jar package in Spark.

The specific replacement steps are as follows:

1. Copy the distcp jar from FI environment to `${KYLIN_HOME}/lib`.

   `Find /opt/hadoop_client/ grep distcp`

2. Copy the Hadoop related jar package in the FI environment to replace the same jar package under `${KYLIN_HOME}/spark/jars`.

- Find the jar related to Hadoop in the FI environment

`find /opt/hadoop_client/HBase/hbase | grep hadoop`

- Find related jars of `${KYLIN_HOME}/spark/jars`

`ls {KYLIN_HOME}/spark | grep hadoop`

- Backup the `{KYLIN_HOME}/spark/jars` package and replace the package under `${KYLIN_HOME}/spark/jars`.

  The jar packages that need to be copied or replaced are:

- - hadoop-auth-2.6.4.jar

  - hadoop-client-2.6.4.jar

  - hadoop-common-2.6.4.jar

  - hadoop-hdfs-2.6.4.jar

  - hadoop-mapreduce-client-app-2.6.4.jar

  - hadoop-mapreduce-client-common-2.6.4.jar

  - hadoop-mapreduce-client-core-2.6.4.jar

  - hadoop-mapreduce-client-jobclient-2.6.4.jar

  - hadoop-mapreduce-client-shuffle-2.6.4.jar

  - hadoop-yarn-api-2.6.4.jar

  - hadoop-yarn-client-2.6.4.jar

  - hadoop-yarn-common-2.6.4.jar

  - hadoop-yarn-server-common-2.6.4.jar

  - hadoop-yarn-server-web-proxy-2.6.4.jar

    > This package needs to be copied to spark/jars

  - hadoop-hdfs-client-2.7.2.jar

    > This package needs to be copied to spark/jars

  - htrace-core-3.1.0-incubating.jar

    > This package needs to be copied to spark/jars

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

If there is a lack of HBase permission to check the run environment, you can create a new user on the FI Manager page and add the user to the`supergroup`  to assign permissions `System_administrator`. Then, please run the following command to change the owner of Kyligence Enterprise working directory to this user:

```shell
hdfs dfs -chown -R <user_name> <working_directory>
```

If you have not installed Snappy, you can install Snappy on your own, or modify the following configuration items related to the Snappy in the `$KYLIN_HOME/conf/kylin.properties` :

```properties
kylin.storage.hbase.compression-codec=none
#kyligence Enterprise.storage.columnar.page-compression=SNAPPY //Annotate the item
```

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

