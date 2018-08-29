









## 重要参数配置

*kylin.properties* 在 Kyligence Enterprise 的配置文件中占据重要位置。本节内容将对一些常用的配置项进行详细介绍。

用户可以将个性化配置写在 *kylin.properties.override* 文件中，这个文件中的配置项将会覆盖*kylin.properties*中的默认值。在系统升级中，用户仅需复制*kylin.properties.override*到新版本的conf路径，即可实现配置升级。

### kylin.metadata.url
该参数指定Kyligence Enterprise元数据库路径。默认值为HBase中的*kylin_metadata*表，用户可以手动修改参数值以自定义的名称命名元数据库。在同一个集群上部署多个Kyligence Enterprise实例时，可以为每个Kyligence Enterprise实例配置一个独有的元数据库路径，以实现多个Kyligence Enterprise实例间的隔离。例如，Production实例设置该值为*kylin\_metadata\_prod*，Staging实例设置该值为*kylin\_metadata\_staging*，那么在Staging实例中的操作不会对Production实例产生任何影响。
### kylin.env.hdfs-working-dir
该参数指定Kyligence Enterprise服务所用的HDFS路径。默认值为HDFS上的`kylin/`，以元数据库路径中的HTable表名为子目录。例如，假设元数据库路径参数值为``kylin_metadata@hbase``，那么该HDFS路径默认值就是`/kylin/kylin_metadata`。请预先确保启动Kyligence Enterprise实例的用户有读写该目录的权限。
### kylin.server.mode
该参数指定Kyligence Enterprise实例的运行模式，参数值可以是*all*，*job*，*query*中的一个，默认值为*all*。*job*模式表示该服务仅用于Cube任务调度，不用于SQL查询；*query*模式表示该服务仅用于SQL查询，不用于Cube构建任务的调度；*all*模式表示该服务同时用于任务调度和SQL查询。
### kylin.source.hive.database-for-flat-table
该参数指定Hive中间表保存在哪个Hive数据库中，默认值为*default*。如果执行Kyligence Enterprise的用户没有操作*default*数据库的权限，可以修改此参数的值以使用其他数据库。
### kylin.storage.hbase.compression-codec
该参数指定Kyligence Enterprise创建的HTable所采用的压缩算法。默认值为*none*，即不启用压缩。请根据实际对压缩算法的支持情况，选择合适的压缩算法，如*snappy*、*lzo*、*gzip*、*lz4*等。
### kylin.security.profile
该参数指定Kyligence Enterprise服务启用的安全授权方案，可以是*ldap*、*saml*、*testing*。默认值为*testing*，即使用固定的测试账号进行登录。用户可以修改此参数以接入已有的企业级认证体系，如*ldap*、*saml*。具体设置可以参考[安全控制](../security/README.md)章节。
### kylin.web.timezone
该参数指定Kyligence Enterprise的REST服务所使用的时区。默认值为*GMT+8*。用户可以根据具体应用的需要修改此参数。
### kylin.source.hive.client
该参数指定Hive命令行类型，可以是*cli*或*beeline*。默认值为*cli*，即hive cli。如果系统只支持beeline作为Hive命令行，可以修改此配置为*beeline*。
### kylin.source.hive.beeline-params
当使用*beeline*做为hive的client工具时，需要配置此参数，以提供更多信息给*beeline*。举例，如果您需要这样使用*beeline*来执行一个sql文件的话：
```
beeline -n root -u 'jdbc:hive2://localhost:10000' -f abc.sql
```

那么，请设置此参数为：
```
kylin.source.hive.beeline.params=-n root -u 'jdbc:hive2://localhost:10000' -f abc.sql
```
### kylin.env
该参数指定Kyligence Enterprise部署的用途，可以是*DEV*、*PROD*、*QA*。出厂默认值为*PROD*。在*DEV*模式下一些开发者功能将被启用。

### kylin.query.force-limit
BI工具往往会发送类似`select * from fact_table`的查询语句，对于表格数据特别多的表格，数据返回时间较长，造成BI工具的长时间卡顿。该参数通过为“select \*”语句强制添加LIMIT分句，达到缩短数据返回时间的目的。启动该功能的方法为将该设置的值设置为正整数，如1000，该值会被用在LIMIT分句，查询语句最终会被转化成“select \* from fact\_table limit 1000”。该参数可在**项目**级别重写。

### kylin.query.disable-cube-noagg-sql
Cube中存储的是经过预处理的数据，这些数据在大多数情况下和原数据存在差异，例如聚合操作合并了一些数据行。这导致非聚合查询从Cube拿到的数据不准确。该参数被用来解决该问题，如果它被设置成 true ，Cube则不能被用于回答非聚合查询，一个典型的例子为`select * from fact_table limit 1000`。其他符合条件的Table Index 和 Query Pushdown 会代替Cube回答此类查询。该参数可在 Cube 级别重写。

### kylin.query.convert-create-table-to-with (Beta)
有一些BI工具会在查询中创建临时表获中间表。将该参数设置为true可以将查询中创建表的语句转成with语句，当后续查询需要使用到该临时表获中间表时，会被转化成包含With的查询语句。修改这个配置后，创建中间表获临时表的查询可以击中可匹配的Cube。

### kylin.query.pushdown.update-enabled

该参数指定了是否在查询下压中开启update。默认状态下为false，将该参数设置为true时，开启该功能。

### kylin.query.pushdown.cache-enabled

通过Kyligence Enterprise进行下压查询时，可以开启缓存来提高相同sql语句的查询效率。该参数默认为开启状态，将该参数设置为false时，关闭该功能。

### kap.smart.conf.model.cc.enabled

通过SQL语句自动补全建模中，当SQL语句中含有表达式时，需要创建可计算列。将该参数设置为true时，Kyligence Enterprise会根据SQL语句自动创建相应的可计算列，需要注意的是可计算列会被自动设置为维度。

> 当前仅支持以下函数：SUM({EXPR})，AVG({EXPR})，array[{INDEX}]，CASE .. WHEN ..

### kylin.cube.is-automerge-enabled

该参数指定了segment自动合并功能。默认状态下为开启状态。将该参数设置为false时，自动合并功能会被关闭。即使cube更新设置中，添加了自动合并阈值也不会触发合并任务。

### kap.storage.columnar.start-own-spark

该参数指定了是否启动Spark查询集群。默认状态下为true，将该参数设置为false时，关闭该功能。读写分离中，构建集群推荐关闭该功能。

### kap.storage.init-spark-at-starting

在Kyligence Enterprise启动时，同时启动Spark查询集群。默认状态下为true，将该参数设置为false时，关闭该功能。

### kap.storage.columnar.spark-conf.spark.yarn.queue

通过配置该参数，将指定Spark查询集群所使用的yarn queue。

### kap.storage.columnar.spark-conf.spark.master

spark的部署一般分为spark on YARN模式,spark on Mesos模式,和standalone模式，我们默认使用yarn模式下的spark作查询任务。该配置参数可以指定Kyligence Enterprise所使用standalone模式下的spark集群，使Kyligence Enterprise将任务提交到指定的spark-master-url。

### kylin.source.hive.default-varchar-precision

当前Kyligence Enterprise版本暂时不支持string类型，当string类型的字段导入Kyligence Enterprise时，会自动转化为varchar。该参数指定了转化后varchar字段的最大长度，默认值为256。

### kylin.metadata.hbase-client-scanner-timeout-period

该参数指定了HBase扫描数据的超时时间，默认值为10000毫秒。

### kylin.metadata.hbase-rpc-timeout

该参数指定了执行RPC操作的超时时间，默认值为5000毫秒。

### kylin.metadata.hbase-client-retries-number

该参数指定了HBase重试次数，默认值为1次。



## JVM参数

​        在`$KYLIN_HOME/conf/setenv.sh` （如果版本低于2.4.0，`$KYLIN_HOME/bin/setenv.sh`) 中，为KYLIN_JVM_SETTINGS给出了两种示例配置。默认配置使用的内存较少，用户可以根据自己的实际情况，注释掉默认配置并取消另一配置前的注释符号以启用另一配置，从而为Kyligence Enterprise示例分配更多的内存资源。

该项配置的默认值如下:

```
export KYLIN_JVM_SETTINGS="-Xms1024M -Xmx4096M -Xss1024K -XX:MaxPermSize=128M -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:$KYLIN_HOME/logs/kylin.gc.$$ -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=64M"
# export KYLIN_JVM_SETTINGS="-Xms16g -Xmx16g -XX:MaxPermSize=512m -XX:NewSize=3g -XX:MaxNewSize=3g -XX:SurvivorRatio=4 -XX:+CMSClassUnloadingEnabled -XX:+CMSParallelRemarkEnabled -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:CMSInitiatingOccupancyFraction=70 -XX:+DisableExplicitGC -XX:+HeapDumpOnOutOfMemoryError"
```



## 启用邮件通知

当任务完成或失败时，Kyligence Enterprise可以发送邮件通知用户。如用户需要启用该功能，请在`$KYLIN_HOME/conf/kylin.properties`中配置如下内容：

```properties
kylin.job.notification-enabled=true|false
kylin.job.notification-mail-enable-starttls=true|false
kylin.job.notification-mail-host=your-smtp-server
kylin.job.notification-mail-port=your-smtp-port
kylin.job.notification-mail-username=your-smtp-account
kylin.job.notification-mail-password=your-smtp-pwd
kylin.job.notification-mail-sender=your-sender-address
kylin.job.notification-admin-emails=adminstrator-address
```

之后请重启Kyligence Enterprise以使得上述配置项生效。

一个例子

```properties
kylin.job.notification-enabled=true
kylin.job.notification-mail-enable-starttls=true
kylin.job.notification-mail-host=smtp.office365.com
kylin.job.notification-mail-port=587
kylin.job.notification-mail-username=kylin@example.com
kylin.job.notification-mail-password=mypassword
kylin.job.notification-mail-sender=kylin@example.com
```

如需要停用该功能，请将上述配置项中的`kylin.job.notification-enabled`值设置为`false`。

管理员将会收到所有任务的通知。建模人员和分析师需要在Cube设计器页面中的第一页中，将自己的电子邮件地址输入至`通知邮件列表`框内，便能够收到该Cube相关任务的通知。更详细的通知事件过滤，可以在“需通知的事件”中设置。

###关于配置参数修改时 Kyligence Enterprise 的热启动说明

kylin.properties 中定义的参数（全局）会在启动 Kyligence Enterprise 时默认加载，修改后需重新启动 Kyligence Enterprise 方可生效。

对于 Hive 和 MapReduce 参数，kylin_hive_conf.xml、kylin_job_conf.xml 和 kylin_job_conf_inmem.xml 中定义修改后无需重启 Kyligence Enterprise，但需要重新提交构建 Job。每次构建 Job 提交给 Yarn 时会实时读取修改的参数。注意，这些配置项会覆盖 Hadoop 集群中 hive-stie.xml、mapred-site.xml 等的默认参数；同时可以被项目和 Cube 配置重写所覆盖。