## 日志
当KAP顺利启动之后，默认会在安装目录下产生一个logs目录，该目录保存KAP运行过程中产生的所有日志文件。

### 日志文件
KAP的日志主要包含以下文件：
#### kylin.log
该文件是主要的日志文件，所有的logger默认写入该文件，其中与KAP相关的日志级别默认是DEBUG。

#### kylin.out
该文件是标准输出的重定向文件，一些非KAP产生的标准输出（如tomcat启动输出、Hive命令行输出等）将被重定向到该文件。
#### kylin.gc
该文件是KAP的Java进程记录的GC日志。为避免多次启动覆盖旧文件，该日志使用了进程号作为文件名后缀（如kylin.gc.9188）。

#### spark_driver.log

该文件是KAP高级版使用Spark作为查询引擎时产生的日志文件，如果是查询期间发生问题，可以到该文件查找线索。

#### spark_driver.out
该文件是KAP高级版使用Spark作为查询引擎时产生的重定向文件，如果是spark进程启动阶段的问题，可以到该文件查找线索。

### 日志分析

在这里，我们以查询为例，简单介绍一下如何在日志中获取查询的更多信息。首先在Web UI执行一个查询，然后马上到kylin.log文件尾部查找相关日志。当查询结束，我们会看到如下的记录片段：

```
2016-06-10 10:03:03,800 INFO  [http-bio-7070-exec-10] service.QueryService:251 :
==========================[QUERY]===============================
SQL: select * from kylin_sales
User: ADMIN
Success: true
Duration: 2.831
Project: learn_kylin
Realization Names: [kylin_sales_cube]
Cuboid Ids: [99]
Total scan count: 9840
Result row count: 9840
Accept Partial: true
Is Partial Result: false
Hit Exception Cache: false
Storage cache used: false
Message: null
==========================[QUERY]===============================
```
下表是对上述片段中主要字段的介绍：

* SQL: 查询所执行的SQL语句
* User: 执行查询的用户名
* Success: 该查询是否成功
* Duration: 该查询所用时间（单位：秒）
* Project: 该查询所在项目
* Realization Names: 该查询所击中的Cube名称

### 日志配置
以上日志均可以通过修改配置文件进行调整。KAP使用log4j对日志进行配置，用户可以编辑KAP安装目录下conf目录中的kylin-server-log4j.properties文件，对日志级别、路径等进行修改。修改后，需要重启KAP服务才可生效。

### 日志文件滚动

在kylin-server-log4j.properties可以配置日志文件滚动。支持基于”最大单个文件“+”最多日志文件“两个规则实现日志文件的滚动更新。默认，log4j.appender.file.MaxFileSize=268435456，每个log文件最大为268435456字节（即256M）；log4j.appender.file.MaxBackupIndex=10，最多保留10个log文件。

