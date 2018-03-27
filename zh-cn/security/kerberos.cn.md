## 集成Kerberos
Kerberos 是一种支持票证身份验证的安全协议。如果KAP部署的平台开启了kerberos服务，需要通过本文的配置让KAP集成平台的kerberos服务运行。
### KAP 配置
KAP 的`$KYLIN_HOME/conf/kylin.properties`配置文件中，kerberos相关参数。

必选参数：

   - kap.kerberos.enabled : 是否启用kerberos认证，默认为false，可选true，false
   - kap.kerberos.platform : 认证平台，可选FI，Standard
   - kap.kerberos.principal : principal名称
   - kap.kerberos.keytab : keytab文件名

可选参数：

   - kap.kerberos.ticket.refresh.interval.minutes : ticket刷新周期，单位分钟，默认值720分钟
   - kap.kerberos.krb5.conf : kerberos配置文件名, 默认krb5.conf
   - kap.kerberos.cache : ticket cache文件名称, 默认kap_kerberos.cache

### 标准配置(非华为FusionInsight)
1. 需要在安装yarn的NodeManager的节点上，添加kerberos对应的用户。

   例如：
   kerberos用户kylin, 需要在NodeManager所在的节点的操作系统也拥有kylin用户。
2. 设置kerberos相关参数。

   - kap.kerberos.enabled=true
   - kap.kerberos.platform=Standard
   - kap.kerberos.principal={your principal name}
   - kap.kerberos.keytab={your keytab name}

3. 将认证keytab文件放到`$KYLIN_HOME/conf`目录下。   

### FI(华为FusionInsight)配置

1. 设置kerberos相关参数。

   - kap.kerberos.enabled=true
   - kap.kerberos.platform=FI
   - kap.kerberos.principal={your principal name}
   - kap.kerberos.keytab={your keytab name}

2. 配置FI机机类型账户，需要配置该用户拥有HDFS、HBase、Yarn、Spark、Hive、Kafka和Zookeeper相关权限，并将该账户(包含keytab和krb5.conf文件)导出。

   FI 账户配置请参考如下链接(如果链接打不开，请复制url到浏览器地址栏访问)：

   - [FI配置机机账户](http://support.huawei.com/hedex/hdx.do?docid=EDOC1000130541&id=it_61_50_000019&text=%252525u521B%252525u5EFA%252525u7528%252525u6237&lang=zh) URL:http://support.huawei.com/hedex/hdx.do?docid=EDOC1000130541&id=it_61_50_000019&text=%252525u521B%252525u5EFA%252525u7528%252525u6237&lang=zh

   - [导出账户](http://support.huawei.com/hedex/hdx.do?docid=EDOC1000130541&id=it_61_50_000030&text=%252525u5BFC%252525u51FAKeytab%252525u6587%252525u4EF6&lang=zh) URL: http://support.huawei.com/hedex/hdx.do?docid=EDOC1000130541&id=it_61_50_000030&text=%252525u5BFC%252525u51FAKeytab%252525u6587%252525u4EF6&lang=zh

 机机账户需设置:
    - KAP期望读取的hive数据库  读权限
    - kylin.env.hdfs-working-dir 写权限
    - kylin.source.hive.database-for-flat-table 写权限

 KAP参数说明，请参考：[KAP参数列表](http://docs.kyligence.io/v2.5/zh-cn/config/basic_settings.cn.html)

3. 将步骤2中导出的keytab文件以及配置文件krb5.conf放到`$KYLIN_HOME/conf`目录下。
4. FI认证配置有以下两种：


- Cache认证

1. 新建jaas.conf文件，并放置`$KYLIN_HOME/conf` 目录下。

```
Client{
	com.sun.security.auth.module.Krb5LoginModule required
	useKeyTab=false
	useTicketCache=true
	storeKey=true
	debug=false;
};
```

- Keytab认证

1. 配置kylin.properties,在beeline的连接字符串添加user.principal(对应kap.kerberos.principal参数)以及user.keytab(对应kap.kerberos.keytab参数)

   > 注：user.keytab 应为具体的文件路径名， 如 ${KYLIN_HOME}/conf/user.keytab

2. 配置kylin.properties,添加kylin.engine.spark-conf.spark.yarn.principal(对kap.kerberos.principal参数)以及kylin.engine.spark-conf.spark.yarn.keytab(对应kap.kerberos.keytab参数)

   > 注：user.keytab 应为具体的文件路径名，如 ${KYLIN_HOME}/conf/user.keytab

3. 新建jaas.conf文件，并放置`$KYLIN_HOME/conf` 目录下。

```
Client{
	com.sun.security.auth.module.Krb5LoginModule required
	useKeyTab=true
	useTicketCache=false
	storeKey=true
	debug=false;
};
```
