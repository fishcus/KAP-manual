## 流式 Cube

本产品从 2.3 开始提供了流式构建的功能，用户能够以 Kafka 为数据源，根据时间间隔构建流式cube。有关 Kafka 数据源导入以及从流式数据定义事实表的信息，参见本章的[导入 Kafka 数据源](data_import/kafka_import.cn.md)。

### 通过样例程序快速创建流式模型

Kyligence Enterprise内置了样例流式Cube和Kafka测试数据生成脚本，方便您快速体验流式数据建模与数据构建。

在本产品二进制包安装路径下，执行`bin/sample.sh`将创建`kylin_streaming_table`数据表，创建`kylin_streaming`模型，创建`kylin_streaming_cube` Cube 。其中`kylin_streaming_table`关联了运行在localhost:9092的Kafka节点，名为`kylin_streaming_topic`的Kafka Topic。

假设在localhost:9092 确实运行有kafka节点，并且Kyligence Enterprise启动时，`KAFKA_HOME`已经被正确设置，下一步将通过`sample-streaming.sh`脚本，创建`kylin_streaming_topic`的Kafka Topic，并以每秒钟100个消息的速度发送随机消息到该topic。



### 创建流式数据模型

本产品支持将消息流抽象为事实表。定义好事实表后，就可以开始定义数据模型。这一步和定义一个普通的数据模型没有太大不同（[通用模型设计](data_modeling.cn.md)）。不过，您需要留意如下两点：

- 对于流式数据，Kyligence Enterprise暂时还不支持添加维度表。
- 定义事实表上的维度和度量时，可以参照一般的业务逻辑。本例中，将 `country(国家)、category(品类)、device（设备）、user_gender(用户性别)、user_age(用户年龄)`作为维度（dimension/D），将`amount(商品总量)、QTY(商品数)`作为度量(measure/M)。
- 保存模型时，请选择 MINUTE_START 属性作为分区列（partition column）, 后续构建对应cube时可以以分钟为间隔构建Cube。不要直接选择ORDER_TIME（因为其数据类型为timestamp, 构建粒度太小）。	

### 创建流式cube

流式Cube与常规Cube在大部分情况下都十分相似([通用cube设计](cube/create_cube.cn.md))。您需要特别留意以下几个方面。

##### Cube维度设置

- 不建议将order\_time作为维度（dimension），此列的数据类型是timestamp（粒度在毫秒级），将成为一个超高基的维度且一般的查询时间粒度都会大于毫秒。这里，推荐使用mintue\_start, hour\_start等时间维度。
- minute_start是本例中流式模型的分区列，需要被定义为维度。
- 在设置rowkeys时, 请将"minute\_start" 拖拽到所有属性的最顶部。对于基于流式Cube的查询，时间维度会是一个经常被用到的维度。因此，将其放在rowkeys前面有助于快速过滤。

##### 刷新设置

- 推荐设置自动合并数据块（segment），例如0.5小时，4小时，１天，７天等。合并segment有助于提升SQL查询性能。 

### 触发流式Cube构建

您可以直接在Web GUI中，点击cube的操作**构建**来触发Cube构建，当然，你也可以通过curl指令结合Kyligence Enterprise的RESTfulAPI触发cube构建

```shell
curl -X PUT --user ADMIN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" -d '{ "sourceOffsetStart": 0, "sourceOffsetEnd": 9223372036854775807, "buildType": "BUILD"}' http://localhost:7070/kylin/api/cubes/{your_cube_name}/build_streaming
```

> 注意：API是以"_streaming"结尾的，这跟常规构建中以"build"结尾不同。
> 同时，语句中的数字０指的是Cube开始构建的偏移量，而9223372036854775807指的是Long.MAX_VALUE的值，指的是Kyligence Enterprise的构建会用到Topic中目前为止拥有的所有消息。
>

在触发了Cube构建以后，在“Monitor” 页面，我们可以观察到一个新的构建任务，接下来，我们只需耐心等待Cube构建完成。在Cube构建完成后，进入 “Insight” 页面, 并执行sql语句，确认流式Cube可用。

```sql
SELECT MINUTE_START, COUNT(*), SUM(AMOUNT), SUM(QTY) FROM KAFKA_TABLE_1 GROUP BY MINUTE_START ORDER BY MINUTE_START
```


### 自动触发Cube定期构建

在第一次构建完成以后，你可以以一定周期定时触发构建任务。Kyligence Enterprise会自动记录每次构建的偏移量，每次触发构建的时候，Kyligence Enterprise都会自动从上次结束的位置开始构建。您可以使用Linux上的crontab指令定期触发构建任务:

```shell
crontab -e　*/5 * * * * curl -X PUT --user ADMIN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" -d '{ "sourceOffsetStart": 0, "sourceOffsetEnd": 9223372036854775807, "buildType": "BUILD"}' http://localhost:7070/kylin/api/cubes/{your_cube_name}/build_streaming
```
现在，您可以看到Cube已经可以自动定期构建了。同时，当累积的segments超过一定阈值时，本产品会自动触发segment合并。





### 常见问题答疑

1. 流式数据构建时，容易出现数据块（segment）空洞。比如如果某次构建发生了错误，并且您终止（discard）了这次构建，则Cube中会由于缺失了这次构建的segment而产生一个"空洞"。由于本产品的自动构建总是从最后的位置开始，正常的构建将无法填补这些空洞。您需要使用Kyligence Enterprise提供的工具找出这些"空洞"并且重新触发构建将其补全。

```shell
curl -X GET --user ADMINN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" http://localhost:7070/kylin/api/cubes/{your_cube_name}/holes
```

如果curl结果为空数组，则表示没有任何空洞。否则，我们则需要手动触发新构建任务（build job）来填补这些空洞：

```shell
curl -X PUT --user ADMINN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" http://localhost:7070/kylin/api/cubes/{your_cube_name}/holes
```

2. 如果topic中已经有大量的消息，您最好不要从头开始构建，建议您选择队列的尾部作为构建的起始点。如下所示：

```shell
curl -X PUT --user ADMIN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" -d '{ "sourceOffsetStart": 0, "sourceOffsetEnd": 9223372036854775807, "buildType": "BUILD"}' http://localhost:7070/kylin/api/cubes/{your_cube_name}/init_start_offsets
```

3. 在运行`kylin.sh`的时候，如果遇到如下错误:

```java
 Exception in thread "main" java.lang.NoClassDefFoundError: org/apache/kafka/clients/producer/Producer
 at java.lang.Class.getDeclaredMethods0(Native Method)
 at java.lang.Class.privateGetDeclaredMethods(Class.java:2615)
 at java.lang.Class.getMethod0(Class.java:2856)
 at java.lang.Class.getMethod(Class.java:1668)
 at sun.launcher.LauncherHelper.getMainMethod(LauncherHelper.java:494)
 at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:486)
 Caused by: java.lang.ClassNotFoundException: org.apache.kafka.clients.producer.Producer
 at java.net.URLClassLoader$1.run(URLClassLoader.java:366)
 at java.net.URLClassLoader$1.run(URLClassLoader.java:355)
 at java.security.AccessController.doPrivileged(Native Method)
 at java.net.URLClassLoader.findClass(URLClassLoader.java:354)
 at java.lang.ClassLoader.loadClass(ClassLoader.java:425)
 at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:308)
 at java.lang.ClassLoader.loadClass(ClassLoader.java:358)
 ... 6 more
```
这是由于Kyligence Enterprise无法找到 Kafka客户端的jar包导致的。请确认您是否已经正确设置了 `KAFKA_HOME`。 

