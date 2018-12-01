## Quick Installation on a Single Node

In this guide, we will explain how to quickly install Kyligence Enterprise on a single node.

Before proceeding, please make sure the [Prerequisite of Kyligence Enterprise](hadoop_env.en.md) is met.

### Download and Install Kyligence Enterprise

1. Get Kyligence Enterprise software package. You can visit [Kyligence Enterprise Release Notes](../release/README.md) and choose the right version according to your environment.

2. Decide the installation location and the Linux account to run Kyligence Enterprise. All the examples below are based on the following assumptions:
   * The install location is `/usr/local/`.
   * Linux account to run Kyligence Enterprise is `root`. It is called the **Linux account** hereafter.
    > **Note**: Replace the above with your real installation location and Linux account in all the steps in this guide. For example, the default user for the CDH sandbox should be `cloudera` rather than `root`.
3. Copy Kyligence Enterprise software package to your server or VM, and unpack.

   ```shell
   cd /usr/local
   tar -zxvf Kyligence-Enterprise-{version}.tar.gz
   ```
4. Set environment variable `KYLIN_HOME` to be the folder path where Kyligence Enterprise is unpacked:

   ```shell
   export KYLIN_HOME=/usr/local/Kyligence-Enterprise-{version}
   ```

5. Create a working directory for Kyligence Enterprise on HDFS and grant the Linux account with the permission with r/w access. The default working directory is `/kylin`. Also ensure the Linux account has access to its home directory on HDFS.

   ```shell
   hdfs dfs -mkdir /kylin
   hdfs dfs -chown root /kylin
   hdfs dfs -mkdir /user/root
   hdfs dfs -chown root /user/root
   ```
   
   If necessary, you can modify the path of the Kyligence Enterprise working directory in `$KYLIN_HOME/conf/kylin.properties`.

   > **Note**: If you do not have permission to execute the above commands, you can `su` to HDFS account and try again.
   >
   > ```shell
   > su hdfs
   > # then retry the above hdfs dfs commands
   > ```

### Quick Configuration for Kyligence Enterprise

Under `$KYLIN_HOME/conf/`, there are two sets of configuration ready for use: `profile_prod` and `profile_min`. The former is the default configuration, which is recommended for production environment. The latter uses minimal resource, and is suitable for sandbox and other limited single node. Run the following command to switch to `profile_min` if your environment has only limited resource:

```shell
rm -f $KYLIN_HOME/conf/profile
ln -sfn $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
```

### If You Use Beeline to Connect Hive

If you use Beeline to connect Hive, you need to modify `$KYLIN_HOME/conf/kylin.properties ` as below to ensure it uses the correct account to execute Hive commands:

> **Note**:
> - Replace `-n root` with your Linux account.
> - Replace `jdbc:hive2://localhost:10000` with the Beeline service address in your enviroment.

```properties
kylin.source.hive.client=beeline
kylin.source.hive.beeline-params=beeline -n root -u 'jdbc:hive2://host:port' --hiveconf hive.exec.compress.output=true --hiveconf dfs.replication=2  --hiveconf hive.security.authorization.sqlstd.confwhitelist.append='mapreduce.job.*|dfs.*'
```

> **Note**: If your Hadoop platform is **HDP**, please ensure the security authorization is `SQLStdAuth` with `true` status. Then add the following to your `hive-site.xml` to give Kyligence Enterprise some permission to adjust the Hive execution parameters at runtime:

```properties
hive.security.authorization.sqlstd.confwhitelist=dfs.replication|hive.exec.compress.output|hive.auto.convert.join|hive.auto.convert.join.noconditionaltask.*|mapreduce.map.output.compress.codec|mapreduce.output.fileoutputformat.compress.*|mapreduce.job.split.metainfo.maxsize|hive.stats.autogather|hive.merge.*|hive.security.authorization.sqlstd.confwhitelist.*
```

For more information, please refer to [Beeline command options](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-BeelineCommandOptions) .

### If You Use Kerberos

If your cluster enables Kerberos security, the Spark embeds in Kyligence Enterprise needs proper configuration to access your cluster resource securely. For more information, please refer to [Kerberos integration](../security/kerberos.en.md).

### If Your Cluster is Based on JDK 7

Please follow the steps in [How to Run Kyligence Enterprise on Lower Version JDK](about_low_version_jdk.en.md).

### Start Kyligence Enterprise

Run the following command to start Kyligence Enterprise:

```shell
${KYLIN_HOME}/bin/kylin.sh start
```

If you want to observe the detailed startup progress, run:
> ```shell
>
> tail -f $KYLIN_HOME/logs/kylin.log
>
> ```

Once the startup is completed, you will see information prompt in the console. Run the below command to check the Kyligence Enterprise process at any time.

```shell
ps -ef | grep kylin
```

### Use Kyligence Enterprise

After Kyligence Enterprise is started, open web GUI at `http://{host}:7070/kylin`. Please replace `host` with your host name, IP address, or domain name. The default port is `7070`. The default username and password are `ADMIN` and `KYLIN` . After the first login, please reset the administrator password according to the password rule.
- At least 8 characters.
- Contains at least one number, one letter, and one special character (~!@#$%^&*(){}|:"<>?[];',./`).

Now, you can verify the installation by building a sample cube. Please continue to [Install Validation](install_validate.en.md).

### Stop Kyligence Enterprise
Run the following command to stop Kyligence Enterprise:

```shell
$KYLIN_HOME/bin/kylin.sh stop
```

You can run the following command to check if the Kyligence Enterprise process has stopped.

```shell
ps -ef | grep kylin
```

### FAQ

**Q: When I use Beeline to connect Hive, it was failed with the following error message:  Cannot modify xxx at runtime. It is not in list of params that are allowed to be modified at runtime.**

Please find `hive.security.authorization.sqlstd.confwhitelist` property in `hive-site.xml` file and add the values according to the error messages. 

