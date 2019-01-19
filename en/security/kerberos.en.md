## Integrate with Kerberos

## Kerberos Integration ##

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

**Other Hadoop Platform**

1. On the node where YARN NodeManager is installed, the OS user which Kerberos uses needs to be created. For example, if Kerberos user `kylin` needs to be used to run this product, this user should exist in the OS of YARN NodeManager node

2. Copy the keytab file to `$KYLIN_HOME/conf` directory

3. Configure below parameters about Kerberos in `$KYLIN_HOME/conf/kylin.properties`

   ```properties
   kap.kerberos.enabled=true
   kap.kerberos.platform=Standard
   kap.kerberos.principal={your principal name}
   kap.kerberos.keytab={your keytab name} 
   ```