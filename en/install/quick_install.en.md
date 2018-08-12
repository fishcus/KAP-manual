## Installation for Single Node

In this section, we will guide you to quickly install Kyligence Enterprise on single node.

### Download and Install Kyligence Enterprise

1.Get Kyligence Enterprise software package. You can visit [Kyligence Enterprise Release Notes](../release/README.md) and choose the version that is suitable for you.

2.Decides the path and the Linux account to run Kyligence Enterprise. All the examples below are based on the following assumptions:

- Suppose the installation path is `/usr/local/`.
- Suppose the Linux account running Kyligence Enterprise is `root`, below referred to as "Linux account".
- When installing, lease note that the above assumptions are replaced by the true installation path and Linux account. For example, the default user for the CDH sandbox is `cloudera`.


3.Copy the Kyligence Enterprise software package to the server or virtual machine you need to install, and uninstall to the installation path.

```shell
cd /usr/local
tar -zxvf Kyligence-Enterprise-{version}.tar.gz
```
4.Set the value of environment variable `KYLIN_HOME` to the path Kyligence Enterprise uninstalled:

```shell
export KYLIN_HOME=/usr/local/Kyligence-Enterprise-{version}
```

Create a working directory of Kyligence Enterprise on HDFS and grant Linux account permission to read and write. The default working directory is `/kylin`. At the same time, ensure that the user directory of Linux account on HDFS has normal read and write permissions. Run the following command:

```shell
hdfs dfs -mkdir /kylin
hdfs dfs -chown root /kylin
hdfs dfs -mkdir /user/root
hdfs dfs -chown root /user/root
```
If necessary, you can modify the location of the Kyligence Enterprise working directory in `$KYLIN_HOME/conf/kylin.properties`.

> Notice: If you do not have permission to execute the above command, you can first transfer to HDFS account and try again.
>

```shell
su hdfs
hdfs dfs -mkdir /kylin
hdfs dfs -chown root /kylin
hdfs dfs -mkdir /user/root
hdfs dfs -chown root /user/root
```
### Fast Configuration of Kyligence Enterprise


Because the single node environment can provide limited resources, we recommend you configure the Kyligence Enterprise to limit the resources it uses. Under the `$KYLIN_HOME/conf/` path, we have prepared two configurations for you: `profile_prod `and `profile_min`. The former is the default solution, which is suitable for the actual production environment. The latter uses less resources and is suitable for sandbox and other environments. Run the following command and switch to `profile_min` configuration:

```shell
rm -f $KYLIN_HOME/conf/profile
ln -sfn $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
```

### If You Use Beeline to Connect Hive

If you use Beeline to connect to Hive, you need to modify the `kylin.properties ` configuration as follows to ensure it uses the correct account to execute commands:

- Please replace  `-n root's` with your Linux account
- Please replace `jdbc:hive2://localhost:10000` with your Beeline service address in your enviroment

```properties
kylin.source.hive.beeline-params=-n root --hiveconf
hive.security.authorization.sqlstd.confwhitelist.append='mapreduce.job.*|dfs.*' -u jdbc:hive2://localhost:10000
```

Writ3 the following parameters to `hive-site.xml, and give Kyligence Enterprise a certain permissions to adjust the Hive execution parameters:

```properties
hive.security.authorization.sqlstd.confwhitelist=dfs.replication|hive.exec.compress.output|hive.auto.convert.join.noconditionaltask.*|mapred.output.compression.type|mapreduce.job.split.metainfo.maxsize
```

For more information, refer to [Beeline command opetions](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-BeelineCommandOptions).

### If You Use Kerberos to Connect Hive

If your cluster uses Kerberos security mechanism, Kyligence Enterprise's own Spark needs proper configuration to access your cluster resources securely.

First of all, if you have SPARK_HOME environment variables on your machine, make sure that it points to Kyligence Enterprise's own Spark.

```shell
   export SPARK_HOME=$KYLIN_HOME/spark
```

Then, do the following configuration in `kylin.properties` to enable Kyligence Enterprise to read the Kerberos configuration file correctly.

- Please replace `/opt/spark/cfg/jaas-zk.conf `with your `jaas` configuration file path

- Please replace`/opt/spark/cfg/kdc.conf `with your `kdc`configuration file path

```properties
kap.storage.columnar.spark-conf.spark.yarn.am.extraJavaOptions=\
-Djava.security.auth.login.config=/opt/spark/cfg/jaas-zk.conf \
-Djava.security.krb5.conf=/opt/spark/cfg/kdc.conf
kap.storage.columnar.spark-conf.spark.driver.extraJavaOptions=\
-Djava.security.auth.login.config=/opt/spark/cfg/jaas-zk.conf \
-Djava.security.krb5.conf=/opt/spark/cfg/kdc.conf
kap.storage.columnar.spark-conf.spark.executor.extraJavaOptions=\
-Djava.security.auth.login.config=/opt/spark/cfg/jaas-zk.conf \
-Djava.security.krb5.conf=/opt/spark/cfg/kdc.conf
```

Finally, Kyligence Enterprise needs to use the correct Kerberos configuration to access Hive Metastore. There are two configuration methods.

- Method 1: further modify `kap.storage.columnar.spark-conf.spark.driver.extraJavaOptions`parameters in `kylin.properties` as follows:

  ```properties
  ap.storage.columnar.spark-conf.spark.driver.extraJavaOptions=\
  -Djava.security.auth.login.config=/opt/spark/cfg/jaas-zk.conf \
  -Djava.security.krb5.conf=/opt/spark/cfg/kdc.conf \
  -Dhive.metastore.sasl.enabled=true \
  -Dhive.metastore.kerberos.principal=hive/XXX@XXX.com
  ```

- Method 2: copy `hive-site.xml` file (or soft link) to`$KYLIN_HOME/spark/conf directory`.

  > Notice: When Kyligence Enterprise is started, if it is found that the `/tmp/hive-scratch `directory (or similar temporary HDFS directory) has no write permissions in the log, you just need to grant permissions (such as `Hadoop FS -chmod -R 777 /tmp/hive-scratch`), and then restart Kyligence Enterprise.

For more information, refer to [Kerberos](C:\Users\yicen.du\Documents\GitHub\KAP-Manual\en\security\kerberos.en.md).

### If Your Cluster is Based on JDK 7

Please follow the steps in "[How to Run Kyligence Enterprise on Lower Version JDK](about_low_version_jdk.en.md)".

### Environment Check

When start Kyligence Enterprise for the first time, system will automatically check the environment you depend on. If Kyligence Enterprise find problems in the process, you will see warnings or error messages in the console.

Some of the problems may be due to the inability to obtain environmental dependencies effectively. If you encounter such problems, you can try to specify the way Kyligence Enterprise gets these information by displaying environment variables. For instance:

```shell
export HADOOP_CONF_DIR=/etc/hadoop/conf
export HIVE_LIB=/usr/lib/hive
export HIVE_CONF=/etc/hive/conf
export HCAT_HOME=/usr/lib/hive-hcatalog
```

> Notice: you can check the running environment manually at any time. Run the following command:
>
> ```shell
> $KYLIN_HOME/bin/check-env.sh
> ```

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

### Use Kyligence Enterprise

After you start Kyligence Enterprise, you can visit KAP website `http://<host_name>:7070/kylin`. Please replace `host_name` with the specific machine name, IP address, or domain name. The default port is `7070`. The default username and password are `ADMIN` and `KYLIN` . After using the default user name / password for the first time, please reset the administrator password according to the password rule.

> **Password rules:**
>
> It should be at least 8 bytes.
>
> It should have at least one number/ one letter/ one special characters(~!@#$%^&*(){}|:"<>?[];',./`).

Once login to Kyligence Enterprise successfully, you can validate the installation by building a sample cube. Please continue to [Install Validation](install_validate.en.md).

### Stop Kyligence Enterprise
Run the following command to stop Kyligence Enterprise:

```shell
$KYLIN_HOME/bin/kylin.sh stop
```

You can run the following command to see if the Kyligence Enterprise process has stopped.

```shell
ps -ef | grep kylin
```

