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

   ```sh
   kap.storage.columnar.spark-conf.spark.yarn.access.namenodes=hdfs://readcluster,hdfs://writecluster
   ```

   For Cloudera CDH Platform, some Hadoop jar files in directory `$KYLIN_HOME/spark/jars/` need to be replaced with the corresponding jar files in your Hadoop environment. If Kerberos is enabled in your system, the jar files will be replaced automatically when the system starts for the first time. If those files are not replaced properly, you can execute the following command:

   ```sh
   bin/do-exchange-spark-for-kerberos.sh
   ```

   
### About FusionInsight C80
If you encounter Kerberos issues in FusionInsight C80, you may try the below steps as a workaround.

**Note**: This is just a workaround rather than the correct way of configuring Kerberos. Please contact your Hadoop administrator for more information about Kerberos on FusionInsight C80.

* Check the consistency of `krb5.conf` file in every Hadoop node with `$KYLIN_HOME/conf/krb5.conf`; If the files are different, please copy the exported file `krb5.conf` to every node in FI cluster, such as `/etc/krb5.conf`.
* Copy the `$KYLIN_HOME/conf/jaas.conf` from Kyligence Enterprise node to every node in FI cluster, such as `/etc/jaas.conf`.
* Set the following configurations in `$KYLIN_HOME/conf/kylin.properties` to ensure this product to be able to read the Kerberos configuration file.
  ```properties
  kap.storage.columnar.spark-conf.spark.executor.extraJavaOptions=-Djava.security.auth.login.config={jaas.conf_path} -Djava.security.krb5.conf={krb5.conf_path}
  kap.storage.columnar.spark-conf.spark.driver.extraJavaOptions=-Djava.security.auth.login.config={jaas.conf_path} -Djava.security.krb5.conf={krb5.conf_path} -Dhive.metastore.sasl.enabled=true -Dhive.metastore.kerberos.principal={principal}
  ```
  > **Note:**
  >
  > 1. Please use the exactly file path to replace `{jaas.conf_path}` and  `{krb5.conf_path}` 
  > 2. `{principal}` indicates the principal which is used to access Hive Metastore, such as `hive/hadoop.hadoop.com@HADOOP.COM` 
