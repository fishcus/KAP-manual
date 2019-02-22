## Integrate with Kerberos

This chapter introduces how to integrate Kyligence Enterprise with Kerberos.

### Prerequisites

**CDH/HDP/MapR Platform**

1. Add corresponding user of Kerberos on the node of YARN NodeManager installation. For instance, the Kerberos user is `kylin`, then there shall be a user `kylin` in operating system of NodeManager node.
2. Place the file `keytab` required for authentication on the directory `$KYLIN_HOME/conf/`.

**Huawei FusionInsight Platform**

1. Create a **Machine-Machine** user. This user need to have the following permissions,
  - Permission on HDFS, HBase, Yarn, Spark, Hive, Kafka and Zookeeper. 
  - Read/Write permission on Hive. Hive for Kyligence Enterprise is specified by the property `kylin.source.hive.database-for-flat-table` in `kylin.properties` with the default value `default`.

  - Read/Write permission on HDFS working directory. HDFS working directory is specified by the property `kylin.env.hdfs-working-dir` in `kylin.properties` with the default value `\kylin`.

2. Export the configuration of this user including `keytab` and `krb5.conf` file. For more details, please refer to the FusionInsight document:
   - [FI Machine-Machine](http://support.huawei.com/hedex/hdx.do?docid=EDOC1000130553&lang=en) 
   - [Export user configuration](http://support.huawei.com/hedex/hdx.do?docid=EDOC1000130553&lang=en)


3. Copy the `keytab` file and the `krb5.conf` file to `$KYLIN_HOME/conf/`.
4. Choose the certification of FusionInsight: **cache** or **keytab**.
   * **Use cache certification**

     Create `jaas.conf` file with the following content in `$KYLIN_HOME/conf/`.

     ```
     Client{
         com.sun.security.auth.module.Krb5LoginModule required
         useKeyTab=false
         useTicketCache=true
         storeKey=true
         debug=false;
     };
     ```

   * **Use keytab certification**

     Create `jaas.conf` file with the following content in `$KYLIN_HOME/conf/`.

     ```
     Client{
          com.sun.security.auth.module.Krb5LoginModule required
          useKeyTab=true
          useTicketCache=false
          storeKey=true
          debug=false;
      };
     ```

For Huawei FI C80, please continute with the following steps:

* Check the consistency of `krb5.conf` file in every Hadoop node with `$KYLIN_HOME/conf/krb5.conf`; If the files are different, please copy the exported file `krb5.conf` to every node in FI cluster, such as `/etc/krb5.conf`.
* Copy the `$KYLIN_HOME/conf/jaas.conf` from Kyligence Enterprise node to every node in FI cluster, such as `/etc/jaas.conf`.
* Set the following configurations in `$KYLIN_HOME/conf/kylin.properties` to ensure this product to be able to read the Kerberos configuration file.
  ```properties
  kap.storage.columnar.spark-conf.spark.executor.extraJavaOptions=-Djava.security.auth.login.config={jaas.conf_path} -Djava.security.krb5.conf={krb5.conf_path}
  kap.storage.columnar.spark-conf.spark.driver.extraJavaOptions=-Djava.security.auth.login.config={jaas.conf_path} -Djava.security.krb5.conf={krb5.conf_path} -Dhive.metastore.sasl.enabled=true -Dhive.metastore.kerberos.principal={principal}
  ```
  > **Note:**
  > 1. Please use the exactly file path to replace `{jaas.conf_path}` and  `{krb5.conf_path}` 
  > 2. `{principal}` indicates the principal which is used to access Hive Metastore, such as `hive/hadoop.hadoop.com@HADOOP.COM` 

### Configuration

The following configurations are set in `$KYLIN_HOME/conf/kylin.properties`.

1. Use keytab authentication

  For CDH/HDP/MapR, set Kerberos parameters in `$KYLIN_HOME/conf/kylin.properties` as below:

  ```properties
  kap.kerberos.enabled=true
  kap.kerberos.platform=Standard
  kap.kerberos.principal={your_principal_name}
  kap.kerberos.keytab={your_keytab_name}
  ```

  For Huawei FusionInsight, please follow the two steps below:

  - Add `user.principal` and `user.keytab` in the beeline connection string. Sample configuration is as below:

    ```properties
    kylin.source.hive.beeline-params=-u 'jdbc:hive2://10.1.2.34:24002,10.1.2.35:24002,10.1.2.36:24002/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2;sasl.qop=auth-conf;auth=KERBEROS;principal=hive/hadoop.hadoop.com@HADOOP.COM;user.keytab=/root/testkylinadmin/user.keytab;user.principal=testkylinadmin'
    ```

    > **Note:**
    > - `user.principal` uses the value of `kap.kerberos.principal` property.
    > - `user.keytab` uses the value of `kap.kerberos.keytab` property, and it suppose to be a specific file path.

  - Add the following properties.

    ```
    kap.kerberos.enabled=true
    kap.kerberos.platform=FI
    kap.kerberos.principal={your_principal_name}
    kap.kerberos.keytab={your_keytab_file_name}
    kap.storage.columnar.spark-conf.spark.yarn.principal={your_principal_name}
    kap.storage.columnar.spark-conf.spark.yarn.keytab={path_of_your_keytab_file}
    # e.g. kap.storage.columnar.spark-conf.spark.yarn.keytab=/app/kylin/Kyligence-Enterprise-3.2.2.2022-GA-fi/conf/user.keytab
    ```

   
2. Copy file `$HADOOP_CONF_DIR/mapred-site.xml` to the directory `$KYLIN_HOME/conf/`. In this file, add the following configurations:
  ```xml
  <property>
     <name>mapreduce.job.complete.cancel.delegation.tokens</name>
        <value>false</value>
  </property>
  ```
3. If the read/write splitting deployment is applied, please add the following configurations in the file `$KYLIN_HOME/conf/kylin.properties`,
  ```xml
  kap.storage.columnar.spark-conf.spark.yarn.access.namenodes=hdfs://readcluster,hdfs://writecluster
  ```
4. For CDH Platform, some Hadoop jar files in directory `$KYLIN_HOME/spark/jars/` need to be replaced with the corresponded jar files in your Hadoop environment.
  - Look for Hadoop jar files in your environment
    ```sh
    find /{hadoop_lib} | grep hadoop
    ```

  - Back up the directory `$KYLIN_HOME/spark/`
    ```sh
    cp -r $KYLIN_HOME/spark ${KYLIN_HOME}.spark_backup
    ```

  - Copy the Hadoop related jar files to `$KYLIN_HOME/spark/jars/`

  - Please delete and copy the jar files refer to your production environment. Here is a table using Hadoop 2.7 as an example.

    | Files list before update                    | File list after udpate                                 |
    | ------------------------------------------- | ------------------------------------------------------ |
    | hadoop-annotations-2.6.5.jar                | hadoop-annotations-2.7.2.jar                           |
    | hadoop-auth-2.6.5.jar                       | hadoop-auth-2.7.2.jar                                  |
    | hadoop-client-2.6.5.jar                     | hadoop-client-2.7.2.jar                                |
    | hadoop-common-2.6.5.jar                     | hadoop-common-2.7.2.jar                                |
    | hadoop-hdfs-2.6.5.jar                       | hadoop-hdfs-2.7.2.jar                                  |
    | hadoop-mapreduce-client-app-2.6.5.jar       | hadoop-mapreduce-client-app-2.7.2.jar                  |
    | hadoop-mapreduce-client-common-2.6.5.jar    | hadoop-mapreduce-client-common-2.7.2.jar               |
    | hadoop-mapreduce-client-core-2.6.5.jar      | hadoop-mapreduce-client-core-2.7.2.jar                 |
    | hadoop-mapreduce-client-jobclient-2.6.5.jar | hadoop-mapreduce-client-jobclient-2.7.2.jar            |
    | hadoop-mapreduce-client-shuffle-2.6.5.jar   | hadoop-mapreduce-client-shuffle-2.7.2.jar              |
    | hadoop-yarn-api-2.6.5.jar                   | hadoop-yarn-api-2.7.2.jar                              |
    | hadoop-yarn-client-2.6.5.jar                | hadoop-yarn-client-2.7.2.jar                           |
    | hadoop-yarn-common-2.6.5.jar                | hadoop-yarn-common-2.7.2.jar                           |
    | hadoop-yarn-server-common-2.6.5.jar         | hadoop-yarn-server-common-2.7.2.jar                    |
    | hadoop-yarn-server-web-proxy-2.6.5.jar      | hadoop-yarn-server-web-proxy-2.7.2.jar                 |
    |                                             | hadoop-archives-2.7.2.jar                              |
    |                                             | hadoop-aws-2.7.2.jar                                   |
    |                                             | hadoop-hdfs-client-2.7.2.jar                           |
    |                                             | hadoop-hdfs-colocation-2.7.2.jar                       |
    |                                             | hadoop-yarn-server-applicationhistoryservice-2.7.2.jar |
    |                                             | hadoop-yarn-server-resourcemanager-2.7.2.jar           |

### FAQ

**Q: If the check environment failed when integrated with Kerberos in FusionInsight C70, how to resolve it?**

For C70, if you need to integrate with Kerberos and the property `hive.server2.enable.doAs` is false in `hive-site.xml`, please add the following configuration:

```properties
kylin.source.hive.table-dir-create-first=true
```