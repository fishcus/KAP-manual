## Quick Install Kyligence Enterprise on a Single Node

In this guide, we will explain how to quickly install Kyligence Enterprise on a single node.

Before proceeding, please make sure [the prerequisite of Kyligence Enterprise](hadoop_env.en.md) is satisfied.

### Download and Install Kyligence Enterprise

1. Get the Kyligence Enterprise software package. You can visit [Kyligence Enterprise Release Notes](../release/README.md) and choose the right version that suits your environment.

2. Decide the install location and the Linux account to run Kyligence Enterprise. All the examples below are based on the following assumptions:
   * Assume the install location is `/usr/local/`.
   * Assume the Linux account to run Kyligence Enterprise is `root`. It is called the **Linux account** hereafter.
   * Please replace the above with your real install location and Linux account in all the steps in this guide. For example, the default user for the CDH sandbox should be `cloudera` rather than `root`.
3. Copy the Kyligence Enterprise software package to your server or VM, and unpack.

   ```shell
   cd /usr/local
   tar -zxvf Kyligence-Enterprise-{version}.tar.gz
   ```
4. Set environment variable `KYLIN_HOME` to the path where Kyligence Enterprise is unpacked:

   ```shell
   export KYLIN_HOME=/usr/local/Kyligence-Enterprise-{version}
   ```

5. Create a working directory for Kyligence Enterprise on HDFS and grant the Linux account with the permission to read and write. The default working directory is `/kylin`. Also ensure the Linux account has access to its home directory on HDFS.

   ```shell
   hdfs dfs -mkdir /kylin
   hdfs dfs -chown root /kylin
   hdfs dfs -mkdir /user/root
   hdfs dfs -chown root /user/root
   ```
   
   If necessary, you can modify the path of the Kyligence Enterprise working directory in `$KYLIN_HOME/conf/kylin.properties`.

   > Notice: If you do not have permission to execute the above commands, you can `su` to HDFS account and try again.
   >
   > ```shell
     su hdfs
     # then retry the above hdfs dfs commands
     ```
### Fast Configuration for Kyligence Enterprise


Under `$KYLIN_HOME/conf/`, there are two sets of configuration ready for use: `profile_prod` and `profile_min`. The former is the default configuration, which suits for production environment. The latter uses minimal resource, and is suitable for sandbox and other limited single node. Run the following command to switch to `profile_min` if your environment is limited on resource:

```shell
rm -f $KYLIN_HOME/conf/profile
ln -sfn $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
```

### If You Use Beeline to Connect Hive

If you use Beeline to connect Hive, you need to modify `conf/kylin.properties ` as below to ensure it uses the correct account to execute Hive commands:

- Please note the  `-n root` should be replaced with your Linux account.
- Please note the `jdbc:hive2://localhost:10000` should be replaced with the Beeline service address in your enviroment.

```properties
kylin.source.hive.beeline-params=-n root -u jdbc:hive2://localhost:10000 --hiveconf hive.security.authorization.sqlstd.confwhitelist.append='mapreduce.job.*|dfs.*'
```

And add the following to your `hive-site.xml` to give Kyligence Enterprise some permission to adjust the Hive execution parameters at runtime:

```properties
hive.security.authorization.sqlstd.confwhitelist=dfs.replication|hive.exec.compress.output|hive.auto.convert.join.noconditionaltask.*|mapred.output.compression.type|mapreduce.job.split.metainfo.maxsize
```

> Refer to [Beeline command options](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-BeelineCommandOptions) for more information.

### If You Use Kerberos

If your cluster enables Kerberos security, the Spark embeds in Kyligence Enterprise needs proper configuration to access your cluster resource securely.

- First, if you have SPARK_HOME environment variable defined, please make sure it points to the Spark embeds in Kyligence Enterprise.

  ```shell
  export SPARK_HOME=$KYLIN_HOME/spark
  ```

- Then, modify `kylin.properties` to let Kyligence Enterprise read the correct Kerberos configuration file in your environment.

  - Please replace `/opt/spark/cfg/jaas-zk.conf` with your `jaas` configuration file path

  - Please replace `/opt/spark/cfg/kdc.conf` with your `kdc` configuration file path

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

- Finally, Kyligence Enterprise needs to use the correct Kerberos configuration to access the Hive Metastore. There are two ways to do it.

  - Method 1: Further modify the `kylin.properties` to use the `hive` principal to access Hive Metastore.

    ```properties
    kap.storage.columnar.spark-conf.spark.driver.extraJavaOptions=\
      -Djava.security.auth.login.config=/opt/spark/cfg/jaas-zk.conf \
      -Djava.security.krb5.conf=/opt/spark/cfg/kdc.conf \
      -Dhive.metastore.sasl.enabled=true \
      -Dhive.metastore.kerberos.principal=hive/XXX@XXX.com
    ```

  - Method 2: Copy the environment `hive-site.xml` (or soft link it) into`$KYLIN_HOME/spark/conf`.

> Notice: Once Kyligence Enterprise is started, if the log reports that the system has no write permission to `/tmp/hive-scratch` or other temporary HDFS directory, you can fix it by granting permissions (like `hadoop fs -chmod -R 777 /tmp/hive-scratch`), and then restart Kyligence Enterprise.
> 
> For more information, please refer to [Kerberos integration](../security/kerberos.en.md).

### If Your Cluster is Based on JDK 7

Please follow the steps in [How to Run Kyligence Enterprise on Lower Version JDK](about_low_version_jdk.en.md).

### Environment Check

When starting Kyligence Enterprise for the first time, the system will perform environment check automatically. If any problem is found, you will see warning or error messages in the console.

Some of the problems may be due to the inability to detect Hadoop dependencies. If such problem is met, you can try explicitly specify the Hadoop dependencies via environment variables. For instance:

```shell
export HADOOP_CONF_DIR=/etc/hadoop/conf
export HIVE_LIB=/usr/lib/hive
export HIVE_CONF=/etc/hive/conf
export HCAT_HOME=/usr/lib/hive-hcatalog
```

> Notice: You can manually run the environment check at any time using the following command:
>
> ```shell
> $KYLIN_HOME/bin/check-env.sh
> ```

### Start Kyligence Enterprise

Run the following command to start Kyligence Enterprise:

```shell
${KYLIN_HOME}/bin/kylin.sh start
```

> If you want to observe the detailed startup progress, run:
>
> ```shell
> tail -f $KYLIN_HOME/logs/kylin.log
> ```

Once the startup is completed, you will see information prompt in the console. Run the below command to check the Kyligence Enterprise process at any time.

```shell
ps -ef | grep kylin
```

### Use Kyligence Enterprise

After Kyligence Enterprise is started, visit its web GUI at `http://{host}:7070/kylin`. Please replace `host` with your machine name, IP address, or domain name. The default port is `7070`. The default username and password are `ADMIN` and `KYLIN` . After the first login, please reset the administrator password according to the password rule.

> Password rule:
>
> - At least 8 characters
> - Contains at least one number, one letter, and one special character (~!@#$%^&*(){}|:"<>?[];',./`).

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

