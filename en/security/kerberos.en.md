## Integrate with Kerberos

Kerberos is a computer network authentication protocol that works on the basis of tickets. If the Hadoop platform where Kyligence Enterprise is installed enables this protocol, some configurations need to be changed to support that. This mainly includes two parts: Kerberos configurations in Kyligence Enterprise & Hadoop platform configurations.

### Kerberos Configuration in Kyligence Enterprise ###

There are some parameters about Kerberos in `$KYLIN_HOME/conf/kylin.properties`.

Mandatory parameters：

   - kap.kerberos.enabled: whether Kerberos needs to be implemented from Kyligence Enterprise. The value can be set to either `true` or `false` (`false` as default)
   - kap.kerberos.platform: Hadoop platform where Kyligence Enterprise is installed. The value can be set to either `Standard` or `FI` (`Standard` as default)
   - kap.kerberos.principal: the principal to be used
   - kap.kerberos.keytab: the name of keytab file

Optional parameters：

   - kap.kerberos.ticket.refresh.interval.minutes: the refresh interval of tickets. The unit is minute and the default value is 720 minutes
   - kap.kerberos.krb5.conf: the config file name of Kerberos. Default value is `krb5.conf`
   - kap.kerberos.cache: the name of ticket cache file. Default value is `kap_kerberos.cache`

### Hadoop Platform Configuration

**Huawei FusionInsight Platform**

1. Create a **Machine-Machine** user. This user need to have the permission of HDFS, HBase, Yarn, Spark, Hive, Kafka and Zookeeper. 

2. Export the configuration of this user including `keytab` and `krb5.conf` file. For more details, please refer to the FusionInsight document:

   * [FI Machine-Machine](http://support.huawei.com/hedex/hdx.do?docid=EDOC1000130553&lang=en) 
   * [Export user configuration](http://support.huawei.com/hedex/hdx.do?docid=EDOC1000130553&lang=en)

   In addition to this, the user also need to set the following configurations:

   * The access permision of Hive databases for Kyligence Enterprise
   * The write permission to `kylin.env.hdfs-working-dir`
   * The write permission to `kylin.source.hive.database-for-flat-table`

   For Kyligence Enterprise configurations, please refer to [Important Configurations](../config/basic_settings.en.md).

3. Copy the `keytab` file and the `krb5.conf` file to `$KYLIN_HOME/conf` , which are exported in step2.

4. Choose the certification of FusionInsight: **cache** or **keytab**.

   * **Use cache certification**

     Create `jaas.conf` file with the following content in `$KYLIN_HOME/conf` .

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

     1. Open the  `$KYLIN_HOME/conf/kylin.properties` and add the configurations of `user.principal` and `user.kytab` in beeline connection url.

        * `user.principal= {your_principal_name}` , which indicates the value of  `kap.kerberos.principal` 
        * `user.keytab = {path_of_your_keytab_file}`, which indicates the value of  `kap.kerberos.keytab`. The value should be the excatly file path, such as `${KYLIN_HOME}/conf/user.keytab`.

        Here is an example and please replace some values based on your **Hadoop** environment.

        ```properties
        kylin.source.hive.beeline-params=-u 'jdbc:hive2://10.1.2.34:24002,10.1.2.35:24002,10.1.2.36:24002/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2;sasl.qop=auth-conf;auth=KERBEROS;principal=hive/hadoop.hadoop.com@HADOOP.COM;user.keytab=/root/testkylinadmin/user.keytab;user.principal=testkylinadmin'
        ```

     2. Add the following configurations in `$KYLIN_HOME/conf/kylin.properties`:

        ```properties
        kap.kerberos.enabled=true
        kap.kerberos.platform=FI
        kap.kerberos.principal={your_principal_name}
        kap.kerberos.keytab={your_keytab_file_name}
        kap.storage.columnar.spark-conf.spark.yarn.principal = {your_principal_name}
        kap.storage.columnar.spark-conf.spark.yarn.keytab = {path_of_your_keytab_file}
        ```

     3. Create `jaas.conf` file with the following content in `$KYLIN_HOME/conf` .

        ```
        Client{
            com.sun.security.auth.module.Krb5LoginModule required
            useKeyTab=true
            useTicketCache=false
            storeKey=true
            debug=false;
        };
        ```

     Tip: For Huawei FI C80 cluster deployment, please do the following steps:

     * Check the consistency of `krb5.conf` file in every Hadoop node with `$KYLIN_HOME/conf/krb5.conf`; If the files are different, please copy the exported file `krb5.conf` to every node in FI cluster, such as `/etc/krb5.conf`.

     * Copy the `$KYLIN_HOME/conf/jaas.conf` from Kyligence Enterprise node to every node in FI cluster, such as `/etc/jaas.conf`.

     * Set the following configurations in `$KYLIN_HOME/conf/kylin.properties` to ensure this product to be able to read the Kerberos configuration file.

       ```properties
       kap.storage.columnar.spark-conf.spark.executor.extraJavaOptions=-Djava.security.auth.login.config={jaas.conf_path} -Djava.security.krb5.conf={krb5.conf_path}
       
       kap.storage.columnar.spark-conf.spark.driver.extraJavaOptions=-Djava.security.auth.login.config={jaas.conf_path} -Djava.security.krb5.conf={krb5.conf_path} -Dhive.metastore.sasl.enabled=true -Dhive.metastore.kerberos.principal={principal}
       ```

       > Please use the exactly file path to replace `{jaas.conf_path}` and  `{krb5.conf_path}` 
       >
       > `{principal}` indicates the principal which is used to access Hive Metastore, such as `hive/hadoop.hadoop.com@HADOOP.COM` 


**CDH / HDP Platform**

1. Add corresponding user of Kerberos on the node of YARN NodeManager installation. For instance, the Kerberos user is `kylin`, then there shall be a user `kylin` in operating system of NodeManager node.

2. Place the file `keytab` required for authentication on the directory `$KYLIN_HOME/conf`.

3. Set Kerberos parameters on the file `$KYLIN_HOME/conf/kylin.properties` as:

   ```properties
   kap.kerberos.enabled=true
   kap.kerberos.platform=Standard
   kap.kerberos.principal={your_principal_name}
   kap.kerberos.keytab={your_keytab_name} 
   ```

4. Copy file `{hadoop_conf}/mapred-site.xml` to the directory `$KYLIN_HOME/conf`. In this file, add the following configurations:

   ```xml
   <property>
      <name>mapreduce.job.complete.cancel.delegation.tokens</name>
         <value>false</value>
   </property>
   ```

5. If the read/write splitting deployment is applied, please add the following configurations in the file `$KYLIN_HOME/conf/kylin.properties`:

   ```xml
   kap.storage.columnar.spark-conf.spark.yarn.access.namenodes=hdfs://readcluster,hdfs://writecluster
   ```

Notice: For CDH Platform, some Hadoop jar files in directory `$KYLIN_HOME/spark/jars` need to be replaced with the corresponded jar files in your Hadoop environment.

- Look for Hadoop jar files in your environment

  ```shell
  find /{hadoop_lib} | grep hadoop
  ```

- Back up the directory `$KYLIN_HOME/spark/`

  ```shell
  cp -r $KYLIN_HOME/spark ${KYLIN_HOME}.spark_backup
  ```

- Copy the Hadoop related jar files to `$KYLIN_HOME/spark/jars`

- Please delete and copy the jar files refer to your production environment. Here is a table using Hadoop 2.7 as an example.

| Hadoop jar files before replacement         | Hadoop jar files after replacement                     |
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