## 流式构建 Cube

本产品从 2.3.x 开始提供了流式构建的功能，用户能够以 Kafka 为数据源，根据时间间隔流式构建 cube。本文档提供了一个简单的教程，向用户展示如何创建流式 cube。

有关 Kafka 数据源导入以及从流式数据定义事实表的信息，参见本章“数据导入”一节下面的[导入 Kafka 数据源](data_import/kafka_import.cn.md)。

### 创建model

定义好事实表以后，我们就可以开始定义数据模型了。这一步和定义一个普通的数据模型没有太大不同。不过，您需要留意如下两点：

- 对于流式Cube，Kyligence Enterprise暂时还不支持维度表，因此，在定义model的时候请不要引入维度表。
- 请选择 "MINUTE_START" 属性作为partition column, 这样Kyligence Enterprise可以以分钟为间隔构建Cube。不要直接选择时间戳ORDER_TIME属性（因为其粒度太小）。

这里，我们选择８个属性作为dimension，２个属性作为measure。

![](images/s7.png)
 	
![](images/s8.png)
 	
![](images/s9.png)

​	
选择 "MINUTE_START" 属性作为partition column，保存数据模型。

![](images/s10.png)



### 创建cube

流式Cube与常规Cube在大部分情况下都十分相似，不过，您需要特别留意如下几点：

* 不要使用"order\_time"作为dimension，因为这个属性是一个十分细粒度的属性。这里，我们建议您使用"mintue\_start", "hour\_start" 等时间属性。
* 在"refresh setting" 步骤，您可以定义更多的构建间隔时间，例如0.5小时，4小时，１天，７天等。这有助于Segment的自动合并。
* "minute_start"是model的分区列，需要被定义为Dimension。
* 在选择"rowkeys" 的环节, 请将"minute\_start" 拖拽到所有属性的最顶部。对于基于流式Cube的查询，时间维度会是一个经常被用到的维度，因此，将其放在rowkeys前面有助于快速过滤。

 ![](images/s11.png)

 ![](images/s12.png)
 ​	
 ![](images/s13.png)

 ![](images/s14.png)

保存Cube。

### 触发Cube构建

您可以直接在WebUI中，点击“Actions” -> “Build”来触发Cube构建，当然，你也可以通过curl指令结合Kyligence Enterprise的RESTfulAPI触发cube构建

	curl -X PUT --user ADMIN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" -d '{ "sourceOffsetStart": 0, "sourceOffsetEnd": 9223372036854775807, "buildType": "BUILD"}' http://localhost:7070/kylin/api/cubes/{your_cube_name}/build_streaming

请特别注意，API是以"_streaming"结尾的，这跟常规构建中以"build"结尾不同。
同时，语句中的数字０指的是Cube开始构建的偏移量，而9223372036854775807指的是Long.MAX_VALUE的值，指的是Kyligence Enterprise的构建会用到Topic中目前为止拥有的所有消息。

在触发了Cube构建以后，在“Monitor” 页面，我们可以观察到一个新的构建任务，接下来，我们只需耐心等待Cube构建完成。

在Cube构建完成后，进入 “Insight” 页面, 并执行sql语句，确认流式Cube可用

	SELECT MINUTE_START, COUNT(*), SUM(AMOUNT), SUM(QTY) FROM KAFKA_TABLE_1 GROUP BY MINUTE_START ORDER BY MINUTE_START


### 自动触发Cube定期构建

在第一次构建完成以后，你可以以一定周期定时触发构建任务。Kyligence Enterprise会自动记录每次构建的偏移量，每次触发构建的时候，Kyligence Enterprise都会自动从上次结束的位置开始构建。您可以使用Linux上的crontab指令定期触发构建任务:

	crontab -e　*/5 * * * * curl -X PUT --user ADMIN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" -d '{ "sourceOffsetStart": 0, "sourceOffsetEnd": 9223372036854775807, "buildType": "BUILD"}' http://localhost:7070/kylin/api/cubes/{your_cube_name}/build_streaming
现在，您可以看到Cube已经可以自动定期构建了。同时，当累积的segments超过一定阈值时，Kyligence Enterprise会自动触发segments合并。



### 一些常见问题

1. 在运行“kylin.sh”的时候，您可能会遇到如下错误:

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

这是由于Kyligence Enterprise无法找到 Kafka客户端的jar包导致的。请确认您是否已经正确设置了 “KAFKA_HOME”。 

2. 在构建Cube时，遇到 “killed by admin” 错误

这个问题主要是由于在使用Sandbox时，MR任务请求的内存过多，从而被YARN拒绝导致的。您可以通过修改“conf/kylin_job_conf_inmem.xml”配置，调低请求的内存大小来解决这个问题
​	
	<property>
	    <name>mapreduce.map.memory.mb</name>
	    <value>1072</value>
	    <description></description>
	</property>
	
	<property>
	    <name>mapreduce.map.java.opts</name>
	    <value>-Xmx800m</value>
	    <description></description>
	</property>

如果topic中已经有大量的消息，您最好不要从头开始构建，建议您选择队列的尾部作为构建的起始点。如下所示：

	curl -X PUT --user ADMIN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" -d '{ "sourceOffsetStart": 0, "sourceOffsetEnd": 9223372036854775807, "buildType": "BUILD"}' http://localhost:7070/kylin/api/cubes/{your_cube_name}/init_start_offsets

3. 如果某次构建发生了错误，并且您丢弃了这次构建，则Cube中会由于缺失了这次构建的segment而产生一个"空洞"。由于Kyligence Enterprise的自动构建总是从最后的位置开始，正常的构建将无法填补这些空洞。您需要使用Kyligence Enterprise提供的工具找出这些"空洞"并且重新触发构建将其填补。

```
curl -X GET --user ADMINN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" http://localhost:7070/kylin/api/cubes/{your_cube_name}/holes
```

如果curl结果为空数组，则表示没有任何空洞，否则，我们则需要手动触发Kyligence Enterprise的构建来填补这些空洞：

	curl -X PUT --user ADMINN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" http://localhost:7070/kylin/api/cubes/{your_cube_name}/holes


### 通过样例程序快速创建流式Cube

Kyligence Enterprise内置了样例流式Cube和Kafka测试数据生成脚本。

在Kyligence Enterprise路径下，执行`bin/sample.sh`将创建`kylin_streaming_table`数据表，创建`kylin_streaming`模型，创建`kylin_streaming_cube` Cube 。其中`kylin_streaming_table`关联了运行在localhost:9092的Kafka节点，名为`kylin_streaming_topic`的Kafka Topic。

假设在localhost:9092 确实运行有kafka节点，并且Kyligence Enterprise启动时，`KAFKA_HOME`已经被正确设置，下一步将通过`sample-streaming.sh`脚本，创建`kylin_streaming_topic`的Kafka Topic，并以每秒钟100个消息的速度发送随机消息到该topic。

在Kyligence Enterprise的Cube构建界面，用户可以点击`构建`来触发流式构建，多次点击将触发多个Job并行地构建。

