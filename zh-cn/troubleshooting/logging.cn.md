## 日志
KAP 顺利启动后，默认会在安装目录下生成`logs/`目录，所有 KAP 运行过程中生成的日志文件会保存在该目录中。

### 日志文件
KAP 生成的日志文件如下：
#### `kylin.log`
该文件是主要的日志文件，其中与 KAP 相关的日志级别默认是DEBUG。

#### `kylin.out`
该文件是标准输出的重定向文件，一些非KAP生成的标准输出（如 tomcat 启动输出、Hive 命令行输出等）将被重定向到该文件。

#### `kylin.gc`
该文件是KAP的Java进程记录的 GC(Garbage Collection) 日志。为避免多次启动，旧文件被覆盖，该日志使用了进程号作为文件名后缀（如 `kylin.gc.20003.0.current`）。

#### `canary.log`
该文件是`KAP v2.5.6`版本开始增加的每15分钟进行环境检测功能的日志。另外在命令行进行对每个服务状态检测的结果也将保存在该文件中。

#### `check-env.out`
该文件是执行`check-env.sh`脚本标准输出的重定向文件。

#### `check-env.error`
该文件是执行`check-env.sh`脚本错误信息的日志文件。

#### `shell.stderr`
该文件是在命令行界面执行操作生成的日志文件。

#### `shell.stdout`
该文件是在命令行界面执行操作的标准输出的重定向文件。

#### `cluster.info`
该文件是集群的信息文件。

### 日志分析
以查询为例，在 Web UI 执行一个查询，当查询结束，我们会在`kylin.log`看到如下日志片段：

```
==========================[QUERY]===============================
SQL: select * from kylin_sales
User: ADMIN
Success: false
Duration: 3.558
Project: learn_kylin
Realization Names: [CUBE[name=kylin_sales_cube]
Cuboid Ids: [99]
Total scan count: 66
Total scan bytes: 1903
Result row count: 0
Accept Partial: true
Is Partial Result: false
Hit Exception Cache: false
Storage cache used: false
Is Query Push-Down: false
Is Prepare: false
Trace URL: null
Message: Something complex went wrong. null Please contact KAP technical support for more details. 
==========================[QUERY]===============================
```
上述片段中主要字段的介绍如下：

* `SQL`： 查询所执行的SQL语句
* `User`： 执行查询的用户名
* `Success`： 该查询是否成功
* `Duration`： 该查询所用时间（单位：秒）
* `Project`： 该查询所在项目
* `Realization Names`： 该查询所击中的Cube名称
* `Hit Exception Cache`： 该查询是否击中查询缓存
* `Is Query Push-Down`：该查询是否下压到其他查询引擎
* `Message`：该查询的页面提示信息

### 日志配置
KAP使用 log4j 对日志进行配置，用户可以编辑 `$KYLIN_HOME/conf/` 目录中的 `kylin-server-log4j.properties` 文件，对日志级别、路径等进行修改。
修改后，需要重启KAP使配置生效。

#### 日志输出类型配置
在 `kylin-server-log4j.properties` 文件中可以对日志输出类型进行配置。<br />
KAP 默认的日志输出类型是`org.apache.log4j.RollingFileAppender`，即文件大小到达指定尺寸的时候产生一个新文件，日志的指定大小由 `log4j.appender.file.MaxFileSize` 控制，默认每个日志文件最大为268435456字节（即256M）；
如果您想要每天产生一个日志文件，可以修改 `log4j.appender.file` 参数为 `org.apache.log4j.DailyRollingFileAppender`。

#### 日志数量配置
在 `kylin-server-log4j.properties` 文件中可以对日志数量进行配置。
日志数量由参数 `log4j.appender.file.MaxBackupIndex` 控制，默认值为10，即最多保留10个日志文件。

