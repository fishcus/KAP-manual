## 基本配置参数

`kylin.properties` 在 Kyligence Enterprise 的配置文件中占据重要位置。本节内容将对一些常用的配置项进行详细介绍。

用户可以将个性化配置写在 `kylin.properties.override` 文件中，这个文件中的配置项将会覆盖 `kylin.properties` 中的默认值。在系统升级中，用户仅需复制 `kylin.properties.override` 到新版本的 conf 路径，即可实现配置升级。

* **kylin.metadata.url**

  该参数指定 Kyligence Enterprise 元数据库路径。默认值为 HBase 中的 *kylin_metadata* 表，用户可以手动修改参数值以自定义的名称命名元数据库。在同一个集群上部署多个 Kyligence Enterprise 实例时，可以为每个Kyligence Enterprise 实例配置一个独有的元数据库路径，以实现多个 Kyligence Enterprise 实例间的隔离。例如，Production 实例设置该值为 *kylin\_metadata\_prod*，Staging 实例设置该值为 *kylin\_metadata\_staging*，那么在 Staging 实例中的操作不会对 Production 实例产生任何影响。

* **kylin.env.hdfs-working-dir**

  该参数指定 Kyligence Enterprise 服务所用的 HDFS 路径。默认值为 HDFS 上的`/kylin`，以元数据库路径中的 HTable 表名为子目录。例如，假设元数据库路径参数值为``kylin_metadata@hbase``，那么该 HDFS 路径默认值就是`/kylin/kylin_metadata`。请预先确保启动 Kyligence Enterprise 实例的用户有读写该目录的权限。

* **kylin.server.mode**

  该参数指定 Kyligence Enterprise 实例的运行模式，参数值可以是 *all*，*job*，*query* 中的任意一个，默认值为 *all*。*job* 模式表示该服务仅用于 Cube 任务调度，不用于 SQL 查询；*query* 模式表示该服务仅用于 SQL 查询，不用于 Cube 构建任务的调度；*all* 模式表示该服务同时用于任务调度和 SQL 查询。

* **kap.server.schema-editable**
  该参数指定 Kyligence Enterprise 实例中元数据是否可编辑，默认参数值为 true。将该参数设置为 false 时，对元数据的编辑功能以及相应的REST API将被禁用，具体包括：1. 数据源功能下的加载数据源表和加载kafka集群。2. 新建、编辑或克隆模型。3. 新建、编辑或克隆 cube。4. 自动建模。其中加载数据源表REST API参见[数据源API](../../rest/data_source_api.cn.md)，克隆模型REST API参见[模型API](../../rest/model_api.cn.md)，克隆 cube REST API参见[管理cube API](../../rest/cube_api/cube_manage_api.cn.md)。

* **kylin.source.hive.database-for-flat-table**

  该参数指定 Hive 中间表保存在哪个 Hive 数据库中，默认值为 *default*。如果执行 Kyligence Enterprise 的用户没有操作 *default* 数据库的权限，可以修改此参数的值以使用其他数据库。

* **kylin.storage.hbase.compression-codec**

  该参数指定 Kyligence Enterprise 创建的 HTable 所采用的压缩算法。默认值为 *none*，即不启用压缩。请根据实际业务情况，选择合适的压缩算法，如 *snappy*、*lzo*、*gzip*、*lz4* 等。

* **kylin.security.profile**

  该参数指定 Kyligence Enterprise 服务启用的安全授权方案，可以是 *ldap*、*testing*。默认值为 *testing*，即使用固定的测试账号进行登录。用户可以修改此参数以接入已有的企业级认证体系，如 *ldap*。具体设置可以参考[安全控制](../../security/README.md)章节。
  
* **kylin.security.job-list-visible-for-query-enabled**
  
  该参数指定 Kyligence Enterprise 的查询用户是否能看到任务列表，默认值为 *false*，即仅有项目的operation权限的用户才可以看到任务列表。当该参数设置为 *true* 时，具有当前项目查询权限的用户就可以看到任务列表了。该参数可在项目级别重写。
  
* **kylin.security.allow-non-admin-generate-job-diag-package**

  该参数指定 Kyligence Enterprise 的查询用户是否可以生成任务诊断包，默认值为 *false*。当该参数和 *kylin.security.job-list-visible-for-query-enabled* 同时设置为 *true* 时, 当前项目的查询（或具有更高权限的，如当前项目的操作和管理员）用户就可以生成任务诊断包了。
  
* **kylin.web.timezone**

  该参数指定 Kyligence Enterprise 的 REST 服务所使用的时区。默认值为 *GMT+8*。用户可以根据具体应用的需要修改此参数。

* **kylin.source.hive.client**

  该参数指定 Hive 命令行类型，可以是 *cli* 或 *beeline*。默认值为 *cli*，即 hive cli。如果系统只支持 beeline 作为 Hive 命令行，可以修改此配置为 *beeline*。

* **kylin.source.hive.beeline-params**

  当使用 *beeline* 做为 hive 的 client 工具时，需要配置此参数，以提供更多信息给 *beeline*。举例，如果您需要这样使用 *beeline* 来执行一个 sql 文件的话：

  ```sh
  beeline -n root -u 'jdbc:hive2://localhost:10000' -f abc.sql
  ```

  那么，请设置此参数为：

  ```sh
  kylin.source.hive.beeline.params=-n root -u 'jdbc:hive2://localhost:10000'
  ```

* **kylin.query.force-limit**

  BI 工具往往会发送类似`select * from fact_table`的查询语句，对于表格数据特别多的表格，数据返回时间较长，造成BI工具的长时间卡顿。该参数通过为`select *`语句强制添加 LIMIT 分句，达到缩短数据返回时间的目的。启动该功能的方法为将该设置的值设置为正整数，如1000，该值会被用在 LIMIT 分句，查询语句最终会被转化成`select * from fact_table limit 1000`。该参数可在**项目**级别重写。

* **kylin.query.disable-cube-noagg-sql**

  Cube 中存储的是经过预处理的数据，这些数据在大多数情况下和原数据存在差异，例如聚合操作合并了一些数据行。这导致非聚合查询从 Cube 拿到的数据不准确。该参数被用来解决该问题，如果它被设置成  true ，Cube 则不能被用于回答非聚合查询，一个典型的例子为`select * from fact_table limit 1000`。其他符合条件的 Table Index 和 Query Pushdown 会代替 Cube 回答此类查询。该参数可在 Cube 级别重写。

* **kylin.query.convert-create-table-to-with (Beta)**

  有一些BI工具会在查询中创建临时表获中间表。将该参数设置为 true 可以将查询中创建表的语句转成 with 语句，当后续查询需要使用到该临时表获中间表时，会被转化成包含 With 的查询语句。修改这个配置后，创建中间表获临时表的查询可以击中可匹配的 Cube。

* **kylin.query.pushdown.cache-enabled**

  通过 Kyligence Enterprise 进行下压查询时，可以开启缓存来提高相同 sql 语句的查询效率。该参数默认为开启状态，将该参数设置为 false 时，关闭该功能。
  
* **kylin.query.pushdown.permissive-enabled**

  该参数决定在进行下压查询时是否开启容忍模式。该参数默认为关闭状态，将该参数设置为 `true` 时，被Calcite语法解析失败的查询也会被下压引擎执行。
  
* **kylin.query.max-result-rows**

  该参数限制了查询返回结果的最大行数。当 limit 分句、`kylin.query.force-limit` 参数、JDBC `Statement.setMaxRows()` 等方法也在限制返回结果时，这些参数会与 `kylin.query.max-result-rows` 参数进行数值比较，较小的参数将作为返回结果的行数限制。该参数作用于所有连接方式，包括用户界面、异步查询、JDBC Driver 与 ODBC Driver。该参数可在项目级别重写。该参数有效取值范围为不超过 2147483647 的正整数。默认值为 0，表示不设限制。

* **kap.smart.conf.model.cc.enabled**

  通过 SQL 语句自动补全建模中，当 SQL 语句中含有表达式时，需要创建可计算列。将该参数设置为 true 时，Kyligence Enterprise 会根据 SQL 语句自动创建相应的可计算列，需要注意的是可计算列会被自动设置为维度。

  > 当前仅支持以下函数：SUM({EXPR})，AVG({EXPR})，array[{INDEX}]，CASE .. WHEN ..

* **kylin.cube.is-automerge-enabled**

  该参数指定了 segment 自动合并功能。默认状态下为开启状态。将该参数设置为 false 时，自动合并功能会被关闭。即使 cube 更新设置中，添加了自动合并阈值也不会触发合并任务。

* **kap.job.merge-dict-on-yarn**

  Merge dictionary这个步骤, 非常的消耗内存，有可能导致Kyligence Enterprise进程出现OOM，如果开启了这个配置，Merge dictionary这个步骤就会放到YARN上执行，使用MapReduce job来完成。该参数默认状态是关闭的，如果遇到Merge dictionary步骤OOM或者内存吃紧的情况，可以把该参数置为 true。

* **kap.storage.columnar.start-own-spark**

  该参数指定了是否启动 Spark 查询集群。默认状态下为 true，将该参数设置为 false 时，关闭该功能。读写分离中，构建集群推荐关闭该功能。

* **kap.storage.init-spark-at-starting**

  在 Kyligence Enterprise 启动时，同时启动 Spark 查询集群。默认状态下为 true，将该参数设置为 false 时，关闭该功能。

* **kap.storage.columnar.spark-conf.spark.yarn.queue**

  通过配置该参数，将指定 Spark 查询集群所使用的 YARN queue。

* **kap.storage.columnar.spark-conf.spark.master**

  spark 的部署一般分为 spark on YARN 模式，spark on Mesos 模式，和 standalone 模式，我们默认使用 YARN 模式下的 Spark 作查询任务。该配置参数可以指定 Kyligence Enterprise 所使用 standalone 模式下的 spark 集群，使 Kyligence Enterprise 将任务提交到指定的 spark-master-url。

* **kylin.source.hive.default-varchar-precision**

  当前 Kyligence Enterprise 版本暂时不支持 string 类型，当 string 类型的字段导入 Kyligence Enterprise 时，会自动转化为 varchar。该参数指定了转化后 varchar 字段的最大长度，默认值为4096。

* **kylin.metadata.hbase-client-scanner-timeout-period**

  该参数指定了 HBase 扫描数据的超时时间，默认值为10000毫秒。

* **kylin.metadata.hbase-rpc-timeout**

  该参数指定了执行 RPC 操作的超时时间，默认值为5000毫秒。

* **kylin.metadata.hbase-client-retries-number**

  该参数指定了 HBase 重试次数，默认值为1次。

* **kylin.job.retry**

  该参数指定了任务自动重试次数，默认值为 0，即任务出错时不会进行自动重试。启用该参数（设置为大于 1 的值）会作用于任务中每一具体步骤的重试次数，当该具体步骤完成后，将重置该参数。

* **kylin.job.retry-interval**

  该参数指定了任务重试的间隔，默认值为 30000，单位毫秒。当配置了上述任务重试次数后，该参数才生效。

* **kylin.dictionary.shrunken-from-global-enabled**

  该参数指定了是否开启shrunken dictionary，当在Cube中对一个高基数列使用了count_distinct(bitmap)，有时你会发现build base cuboid步骤不能在一个合理时间段内成功完成，其原因是mapper发生了频繁的词典缓存换入换出。Shrunken dictionary是一个优化项，用于减少这种情况。默认值是`true`。

* **kylin.engine.mr.mapper-input-rows**
  
  Hive构建时，Redistribute Flat Hive Table 步骤中将平表保存为大小均等的小块，每一小块包含该参数指定的行数。这个参数会影响到在后面几步的 mapper 个数，如资源充足而并发不够，可以将这个值调小，则会起更多的 mapper 。默认值为1000000， 即每个均分的小块中包含一百万行。
  
* **kylin.engine.mr.reduce-input-mb**  
  
  MR Job启动前会依据输入预估 Reducer 接收数据的总量，再除以该参数得出 Reducer 的数目。如果存在数据倾斜，即某个 Cuboid 特别大，造成构建的时候在一个 Reducer 里花费特别多的时间，拖慢整体构建速度，可以调整这个参数。参数表示每个 Reducer 负责多大的输入数据，默认500 MB。通过缩小参数值可以增加 Reducer 的数目，让一个 Reducer 负责更少的 cuboid/shard。

* **kylin.engine.mr.min-reducer-number** 
  
  和 `kylin.engine.mr.reduce-input-mb` 配套使用，M/R 作业中 Reducer 数目的最小值，默认值为1

* **kylin.engine.mr.max-reducer-number** 

  和 `kylin.engine.mr.reduce-input-mb` 配套使用，M/R 作业中 Reducer数目的最大值，默认值为500

* **kylin.engine.mr.uhc-reducer-count** 

  默认在 Extract Fact Table Distinct Column 这一步对于每一列分配一个 Reducer，对于超高列会在一个 Reducer上造成瓶颈，可以通过此参数增加 Reducer 数量。设置为5，表明为每个UHC列分配5个reducer。此参数可以在Cube级别覆盖。

* **kylin.engine.mr.table-ext-col-divisor-for-mapper-enabled** 

  该参数指定了在表采样时是否把列数当作计算mapper数量的考虑因素，默认为`false`。该参数可在**项目**级别重写。

* **kylin.engine.mr.table-ext-col-divisor-for-mapper** 
  
  该参数指定了表采样时把列数当作计算mapper数量的影响因子的除数，仅在`kylin.engine.mr.table-ext-col-divisor-for-mapper-enabled=true`时生效，默认值为20。计算表采样时mapper数量的公式为 **wantedMapperCount=`ceil((rowCount/1,000,000,000) * (columnCount/columnDivisor))`**, 其中rowCount为表的行数，columnCount为表的列数，ceil代表向上取整。 该参数可在**项目**级别重写。

> wantedMapperCount和真实启动的mapper数量可能会有误差，仅供参考。
  
* **kap.metric.diagnosis.graph-writer-type**

  该参数指定了是否把Kyligence Enterprise的metric信息写入InfluxDB，默认值为`BLACK_HOLE`，即不写入。当配置为`INFLUX`时，会把metric信息写入InfluxDB。
  
* **kap.metric.diagnosis.influxDB-database**

  该参数指定了保存metric信息的InfluxDB数据库名称，默认值为`KAP_METRIC`。

* **kap.metric.diagnosis.influxDB-address**

  该参数指定了Kyligence Enterprise连接的InfluxDB地址。
  
* **kap.metric.diagnosis.influxDB-username**

  该参数指定了Kyligence Enterprise连接的InfluxDB用户名，默认值为`root`。
  
* **kap.metric.diagnosis.influxDB-password**

  该参数指定了Kyligence Enterprise连接的InfluxDB密码，默认值为`root`. 注意，密码支持两种配置方式，第一种是明文密码，第二种是加密后的密码。目前不支持InfluxDB密码为空。
  加密方法为，运行`$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.general.CryptTool AES your_password`得到加密后的密码，加密后的密码记作`encrypted_pass`, 然后配置`kap.metric.diagnosis.influxDB-password=${encrypted_pass}`即可。

* **kylin.engine-yarn.application-name.hive.enabled**

  该参数控制了是否在 `hive` 命令提交的 `yarn` 任务名上添加 `host_port` 后缀，默认值为 `false`。
  
  > 当 `Hive` 认证方式为 `SQLStdAuth` 时启用该参数会导致构建报错，需要在 `Hive` 的配置参数 `hive.security.authorization.sqlstd.confwhitelist` 上额外添加 `park.app.name|mapred.job.name|hive.session.id` 三项。

### JVM 参数

在`$KYLIN_HOME/conf/setenv.sh` （如果版本低于2.4.0，`$KYLIN_HOME/bin/setenv.sh`) 中，为KYLIN_JVM_SETTINGS 给出了两种示例配置。默认配置使用的内存较少，用户可以根据自己的实际情况，注释掉默认配置并取消另一配置前的注释符号以启用另一配置，从而为 Kyligence Enterprise 示例分配更多的内存资源。

该项配置的默认值如下:

```
export KYLIN_JVM_SETTINGS="-server -Xms1g -Xmx4g -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:G1HeapRegionSize=16m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m -XX:+PrintFlagsFinal -XX:+PrintReferenceGC -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintAdaptiveSizePolicy -XX:+UnlockDiagnosticVMOptions -XX:+G1SummarizeConcMark  -Xloggc:$KYLIN_HOME/logs/kylin.gc.$$  -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=64M"
# export KYLIN_JVM_SETTINGS="-server -XX:+UseG1GC -Xms24g -Xmx24g -XX:MaxGCPauseMillis=200 -XX:G1HeapRegionSize=32m -XX:MetaspaceSize=256m -XX:+PrintFlagsFinal -XX:+PrintReferenceGC -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintAdaptiveSizePolicy -XX:+UnlockDiagnosticVMOptions -XX:+G1SummarizeConcMark  -Xloggc:$KYLIN_HOME/logs/kylin.gc.$$  -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=64M"
```

### 启用邮件通知

当任务完成或失败时，Kyligence Enterprise 可以发送邮件通知用户。如用户需要启用该功能，请在`$KYLIN_HOME/conf/kylin.properties`中配置如下内容：

```properties
kylin.job.notification-enabled=true|false
kylin.job.notification-mail-enable-starttls=true|false
kylin.job.notification-mail-host=your-smtp-server
kylin.job.notification-mail-port=your-smtp-port
kylin.job.notification-mail-username=your-smtp-account
kylin.job.notification-mail-password=your-smtp-pwd
kylin.job.notification-mail-sender=your-sender-address
kylin.job.notification-admin-emails=administrator-address
```

之后请重启 Kyligence Enterprise 以使得上述配置项生效。

一个例子：

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

### 关于配置参数修改时 Kyligence Enterprise 的热启动说明

kylin.properties 中定义的参数（全局）会在启动 Kyligence Enterprise 时默认加载，修改后需重新启动 Kyligence Enterprise 方可生效。

对于 Hive 和 MapReduce 参数，kylin_hive_conf.xml、kylin_job_conf.xml 和 kylin_job_conf_inmem.xml 中定义修改后无需重启 Kyligence Enterprise，但需要重新提交构建 Job。每次构建 Job 提交给 YARN 时会实时读取修改的参数。注意，这些配置项会覆盖 Hadoop 集群中 hive-stie.xml、mapred-site.xml 等的默认参数；同时可以被项目和 Cube 配置重写所覆盖。



### 生产环境推荐配置

Kyligence Enterprise的配置文件包括几个部分：

- **kylin.properties**，包含系统的主要配置参数；
- **kylin_hive_conf.xml**，作用于系统提交的Hive任务；
- **kylin_job_conf.xml**，作用于系统提交的MapReduce任务；
- **kylin_job_conf_inmem.xml**，作用于一些有较高内存需求的MapReduce任务。

以下推荐配置将按照集群的规模分类，系统性能可能受其它外部系统参数影响，这里推荐仅作为经验值。

**Sandbox**表示用于单机sandbox虚拟机测试的环境，2核，10GB内存，10GB硬盘

**Prod**表示生产环境推荐配置，通常至少由5个节点组成的Hadoop集群，单机32核，128GB内存，20TB硬盘。

> 提示：产品自带了**Sandbox**和**Prod**的两套推荐配置。其中默认配置为**Sandbox**，并可以通过修改profile的软连接指向来切换到**Prod**配置：
>
> ```bash
> cd $KYLIN_HOME/conf
> 
> # Use sandbox(min) profile
> ln -sfn profile_min profile
> 
> # Or use production(prod) profile
> ln -sfn profile_prod profile
> ```



**kylin.properties**

| Properties Name                                  | Sandbox    | Prod       |
| ------------------------------------------------ | ---------- | ---------- |
| kylin.job.max-concurrent-jobs                    | 10         | 20         |
| kylin.job.sampling-percentage                    | 100        | 100        |
| kylin.engine.mr.yarn-check-interval-seconds      | 10         | 10         |
| kylin.engine.mr.reduce-input-mb                  | 100        | 500        |
| kylin.engine.mr.max-reducer-number               | 100        | 500        |
| kylin.engine.mr.mapper-input-rows                | 200000     | 1000000    |
| kylin.cube.algorithm                             | auto       | auto       |
| kylin.cube.algorithm.layer-or-inmem-threshold    | 8          | 8          |
| kylin.cube.aggrgroup.max-combination             | 4096       | 4096       |
| kylin.dictionary.max.cardinality                 | 5000000    | 5000000    |
| kylin.snapshot.max-mb                            | 300        | 300        |
| kylin.query.scan-threshold                       | 10000000   | 10000000   |
| kylin.query.memory-budget-bytes                  | 3221225472 | 3221225472 |
| kylin.query.derived-filter-translation-threshold | 100        | 100        |

| Properties Name                                          | Sandbox | Prod  |
| -------------------------------------------------------- | ------- | ----- |
| kap.storage.columnar.spark-conf.spark.driver.memory      | 512m    | 8192m |
| kap.storage.columnar.spark-conf.spark.executor.memory    | 512m    | 4096m |
| kap.storage.columnar.spark-conf.spark.yarn.am.memory     | 512m    | 4096m |
| kap.storage.columnar.spark-conf.spark.executor.cores     | 1       | 5     |
| kap.storage.columnar.spark-conf.spark.executor.instances | 1       | 4     |
| kap.storage.columnar.page-compression                    | N/A     | N/A   |
| kap.storage.columnar.ii-spill-threshold-mb               | 128     | 512   |



**kylin_hive_conf.xml**

| Properties Name                                  | Sandbox   | Prod                                      |
| ------------------------------------------------ | --------- | ----------------------------------------- |
| dfs.replication                                  | 2         | 2                                         |
| hive.exec.compress.output                        | true      | true                                      |
| hive.auto.convert.join.noconditionaltask         | true      | true                                      |
| hive.auto.convert.join.noconditionaltask.size    | 100000000 | 100000000                                 |
| mapreduce.map.output.compress.codec              | N/A       | org.apache.hadoop.io.compress.SnappyCodec |
| mapreduce.output.fileoutputformat.compress.codec | N/A       | org.apache.hadoop.io.compress.SnappyCodec |
| mapreduce.output.fileoutputformat.compress.type  | BLOCK     | BLOCK                                     |
| mapreduce.job.split.metainfo.maxsize             | -1        | -1                                        |



**kylin_job_conf.xml**

| Properties Name                                  | Sandbox | Prod                                      |
| ------------------------------------------------ | ------- | ----------------------------------------- |
| mapreduce.job.split.metainfo.maxsize             | -1      | -1                                        |
| mapreduce.map.output.compress                    | true    | true                                      |
| mapreduce.map.output.compress.codec              | N/A     | org.apache.hadoop.io.compress.SnappyCodec |
| mapreduce.output.fileoutputformat.compress       | true    | true                                      |
| mapreduce.output.fileoutputformat.compress.codec | N/A     | org.apache.hadoop.io.compress.SnappyCodec |
| mapreduce.output.fileoutputformat.compress.type  | BLOCK   | BLOCK                                     |
| mapreduce.job.max.split.locations                | 2000    | 2000                                      |
| dfs.replication                                  | 2       | 2                                         |
| mapreduce.task.timeout                           | 3600000 | 3600000                                   |



**kylin_job_conf_inmem.xml**

| Properties Name                                  | Sandbox  | Prod                                      |
| ------------------------------------------------ | -------- | ----------------------------------------- |
| mapreduce.job.split.metainfo.maxsize             | -1       | -1                                        |
| mapreduce.map.output.compress                    | true     | true                                      |
| mapreduce.map.output.compress.codec              | N/A      | org.apache.hadoop.io.compress.SnappyCodec |
| mapreduce.output.fileoutputformat.compress       | true     | true                                      |
| mapreduce.output.fileoutputformat.compress.codec | N/A      | org.apache.hadoop.io.compress.SnappyCodec |
| mapreduce.output.fileoutputformat.compress.type  | BLOCK    | BLOCK                                     |
| mapreduce.job.max.split.locations                | 2000     | 2000                                      |
| dfs.replication                                  | 2        | 2                                         |
| mapreduce.task.timeout                           | 7200000  | 7200000                                   |
| mapreduce.map.memory.mb                          | 1024     | 4096                                      |
| mapreduce.map.java.opts                          | -Xmx700m | -Xmx3700m                                 |
| mapreduce.task.io.sort.mb                        | 100      | 200                                       |
