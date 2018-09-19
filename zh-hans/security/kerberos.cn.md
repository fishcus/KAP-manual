## 集成 Kerberos
Kerberos 是一种支持票证身份验证的安全协议。如果 Kyligence Enterprise 部署的 Hadoop 平台开启了 Kerberos 服务，需要通过本文的配置让 Kyligence Enterprise 集成平台的 Kerberos 服务运行，这些配置主要分为两部分，Kyligence Enterprise 中的配置及 Hadoop 平台中的配置。

### Kerberos 配置参数介绍
以下是 Kyligence Enterprise 的 `$KYLIN_HOME/conf/kylin.properties` 配置文件中与 Kerberos 相关的配置参数。

必选参数：

   - kap.kerberos.enabled：是否启用 Kerberos 认证（默认为 false，可选 true、false）
   - kap.kerberos.platform：认证平台（可选FI、Standard）
   - kap.kerberos.principal：principal 名称
   - kap.kerberos.keytab：keytab 文件名

可选参数：

   - kap.kerberos.ticket.refresh.interval.minutes：ticket 刷新周期（单位分钟，默认值720分钟）
   - kap.kerberos.krb5.conf：Kerberos 配置文件名，默认 `krb5.conf`
   - kap.kerberos.cache：ticket cache 文件名，默认 `kap_kerberos.cache`

### Hadoop 平台中配置

**华为 FusionInsight 平台**

1. 配置 FusionInsight **机机类型**账户，该机机类型用户需要拥有HDFS、HBase、Yarn、Spark、Hive、Kafka 和Zookeeper 的相关权限。

2. 导出该账户的配置（包含 `keytab` 和 `krb5.conf `文件）。具体操作步骤可以参考如下 FusionInsight 文档：

   - [FI配置机机账户](http://support.huawei.com/hedex/hdx.do?docid=EDOC1000130541&id=it_61_50_000019&text=%252525u521B%252525u5EFA%252525u7528%252525u6237&lang=zh)

   - [导出账户](http://support.huawei.com/hedex/hdx.do?docid=EDOC1000130541&id=it_61_50_000030&text=%252525u5BFC%252525u51FAKeytab%252525u6587%252525u4EF6&lang=zh)

    除此之外，机机账户需设置：

   - 对于 Kyligence Enterprise 期望读取的 Hive 数据库的读权限
   - 对于 `kylin.env.hdfs-working-dir` 的写权限
   - 对于 `kylin.source.hive.database-for-flat-table` 的写权限

    Kyligence Enterprise参数说明，请参考：[重要参数配置](../config/basic_settings.cn.md)

3. 将步骤2中导出的 `keytab` 文件以及配置文件 `krb5.conf` 放到 `$KYLIN_HOME/conf` 目录下。

4. 配置 FusionInsight 认证方式为 **cache** 认证或 **keytab** 认证。

   * **配置 cache 认证**

     新建 `jaas.conf` 文件包括以下内容，放置在 `$KYLIN_HOME/conf` 目录下。

   ```
   Client{
       com.sun.security.auth.module.Krb5LoginModule required
       useKeyTab=false
       useTicketCache=true
       storeKey=true
       debug=false;
   };
   ```

   * **配置 keytab 认证**

     1. 在 `$KYLIN_HOME/conf/kylin.properties` 中，在 beeline 的连接字符串添加 `user.principal` 及`user.kytab` 相关参数。

        * `user.principal= {your_principal_name}` ，对应 `kap.kerberos.principal` 参数
        * `user.keytab = {path_of_your_keytab_file}`，对应 `kap.kerberos.keytab` 参数，应为具体的文件路径名，如`${KYLIN_HOME}/conf/user.keytab`

         以下是一个我们实际使用的例子，供您参考。请根据您的 **Hadoop** 环境替换参数值。

        ```properties
        kylin.source.hive.beeline-params=-u 'jdbc:hive2://10.1.2.34:24002,10.1.2.35:24002,10.1.2.36:24002/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2;sasl.qop=auth-conf;auth=KERBEROS;principal=hive/hadoop.hadoop.com@HADOOP.COM;user.keytab=/root/testkylinadmin/user.keytab;user.principal=testkylinadmin'
        ```

     2. 在 `$KYLIN_HOME/conf/kylin.properties` 中，添加以下配置：

        ```properties
        kap.kerberos.enabled=true
        kap.kerberos.platform=FI
        kap.kerberos.principal={your_principal_name}
        kap.kerberos.keytab={your_keytab_file_name}
        kap.storage.columnar.spark-conf.spark.yarn.principal = {your_principal_name}
        kap.storage.columnar.spark-conf.spark.yarn.keytab = {path_of_your_keytab_file}
        ```

     3. 新建 `jaas.conf` 文件包括以下内容，放置在 `$KYLIN_HOME/conf` 目录下。

        ```xml
        Client{
            com.sun.security.auth.module.Krb5LoginModule required
            useKeyTab=true
            useTicketCache=false
            storeKey=true
            debug=false;
        };
        ```

     注意：对于华为 FI C80 多节点部署时，请您进行以下操作：

     - 确认 FI Hadoop 集群中每个节点的 `krb5.conf` 文件与导出的 `$KYLIN_HOME/conf/krb5.conf`文件一致；如果不一致请先将其备份，然后将导出的 `krb5.conf` 文件拷贝至FI集群中**每个节点**， 如`/etc`目录下。

     - 将 Kyligence Enterprise 节点的 `$KYLIN_HOME/conf/jaas.conf` 文件拷贝至 FI 集群每个节点上，如`/etc` 目录下。

     - 在 `$KYLIN_HOME/conf/kylin.properties` 中做如下配置，使 Kyligence Enterprise 能正确地读取 Kerberos 配置文件:

       ```properties
       kap.storage.columnar.spark-conf.spark.executor.extraJavaOptions=-Djava.security.auth.login.config={jaas.conf_path} -Djava.security.krb5.conf={krb5.conf_path}
       
       kap.storage.columnar.spark-conf.spark.driver.extraJavaOptions=-Djava.security.auth.login.config={jaas.conf_path} -Djava.security.krb5.conf={krb5.conf_path} -Dhive.metastore.sasl.enabled=true -Dhive.metastore.kerberos.principal={principal}
       ```

       > 请将您在 FI 各节点实际存放的配置文件路径替换 `{jaas.conf_path}` 和 `{krb5.conf_path}` 
       >
       > `{principal}` 为访问 Hive Metastore 需要的 principal，如 `hive/hadoop.hadoop.com@HADOOP.COM` 

**非华为 FusionInsight 平台**

1. 在安装 YARN NodeManager 的节点上，添加 Kerberos 对应的用户。如 Kerberos 用户是 `kylin`，则在 NodeManager 所在的节点的操作系统也应存在 `kylin` 用户。

2. 将认证所需 keytab 文件放到 `$KYLIN_HOME/conf` 目录下。 

3. 在 `$KYLIN_HOME/conf/kylin.properties` 中设置 如下Kerberos 相关参数。

   ```properties
   kap.kerberos.enabled=true
   kap.kerberos.platform=Standard
   kap.kerberos.principal={your_principal_name}
   kap.kerberos.keytab={your_keytab_name} 
   ```

