## 环境依赖服务检测

Kyligence Enterprise 从 v2.5.6 版本开始，增加了环境依赖服务检测的功能，每15分钟进行环境检测。系统管理员可以在界面上清晰地看到相关环境依赖服务信息与分级的警示提醒，帮助诊断环境问题。

环境依赖的服务状态（以下简称为服务状态）检测使用**绿色**、**黄色**和**红色**分别表示**正常**、**警告**和**错误**三种状态。当出现非正常状态时，您还可以通过移动鼠标到检测项来查看二级信息。

### 环境依赖检测项目说明

* Hive 可用性：检查 Hive/Beeline 的可连通性
* 文件系统可用性: 检查文件系统的可用性
* 元数据库可用性：检查元数据库的可连通性、读写正确性和响应速度
* 元数据完整性：检查元数据的一致性及判断是否存在元数据垃圾
* Zookeeper 可用性：检查 ZooKeeper 的可连通性、加锁操作和响应速度
* Spark 集群可用性：检查 Spark 的可用性
* 垃圾清理：检查存储系统中垃圾文件大小
* 元数据同步：检查元数据同步是否异常，异常时系统将尝试重载元数据
* 任务执行引擎可用性：检查任务执行引擎的活性

### 服务状态说明

服务状态分为以下三种：

+ **绿色**：正常，表示该项服务状态检测正常。
+ **黄色**：警告，表示某项服务状态的检测时间超过警告时限，可能会影响 Kyligence Enterprise 性能，但是并不影响使用。
+ **红色**：错误，表示某项服务的检测存在异常或者检测时间超过错误时限。

### 服务状态的检测标准

| 检测项目              | 服务状态 - 黄色                                              | 服务状态 - 红色                                              |
| --------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| HiveCanary            | 在 Hive 中执行列出所有数据库超过 20 秒                       | 在 Hive 中执行列出所有数据库超过 30 秒                       |
| FileSystemCanary   |  | 文件系统异常关闭|
| MetaStoreCanary       | 执行元数据读、写、删操作超过 300 毫秒                        | 1. 执行元数据读、写、删操作超过 1000 毫秒 <br />2. 对元数据执行写操作后，未能读取到新写的数据 |
| MetadataCanary        | 1. 验证元数据完整性超过 10 秒<br>2. 存在元数据垃圾文件, 且距离上一次元数据清理超过`kap.canary.metadata-enable-warning-after-cleanup-days` 参数配置的时间阈值, 默认为7                                   | 1. 验证元数据完整性超过 30 秒 <br />2. 元数据完整性存在错误  |
| ZookeeperCanary       | 查看 ZooKeeper 活性、加锁、解锁超过 3 秒                     | 1. 查看 ZooKeeper 活性、加锁、解锁超过10秒<br />2. ZooKeeper 处于非活跃状态<br />3. ZooKeeper 加锁／解锁失败 |
| SparkSqlContextCanary | 使用 Spark Context 进行一次整数连加操作超过 10 秒            | 使用 Spark Context 进行一次整数连加操作超过 30 秒            |
| GarbageCanary         | 1. Cube 构建产生的垃圾文件数超过50个及以上<br>2. 垃圾数据的数据量达到5G及以上 |                                                              |
| MetaSyncErrorCanary   | Metastore 同步失败                                           |                                                              |
| JobEngineCanary       |                                                              | 没有活跃状态的任务构建引擎节点 |

### 使用命令行进行单独诊断
Kyligence Enterprise还提供了命令行工具来执行对每个服务状态检测，方便进行实时检查和排除错误。同时，检测结果将被保留在单独的日志文件（`$KYLIN_HOME/logs/canary.log`）里。

执行 `$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.canary.CanaryCLI <canaries-to-test>`，其中  <code>canaries-to-test</code> 可替换的对应的检测参数如下：

 * Hive 可用性： `HiveCanary`
 * 文件系统可用性： `FileSystemCanary`
 * 元数据库可用性： `MetaStoreCanary`
 * 元数据完整性： `MetadataCanary`
 * Zookeeper 可用性： `ZookeeperCanary`
 * Spark 集群可用性：暂时无法使用命令行来进行单独检测
 * 垃圾清理： `GarbageCanary`
 * 元数据同步： `MetaSyncErrorCanary`
 * 任务执行引擎可用性： `JobEngineCanary`


### 服务状态检测结果邮件报警

Kyligence Enterprise 提供了邮件通知的功能，可以将服务状态检测结果通过邮件发送给运维人员。

如果需要开启服务状态检测结果邮件报警，请在配置文件 `$KYLIN_HOME/conf/kylin.properties` 中进行如下设置:

```
kylin.job.notification-enabled=true|false  # 设置为true将开启邮件通知功能
kylin.job.notification-mail-enable-starttls=true|false
kylin.job.notification-mail-host=your-smtp-server  # 设置该项为邮件的SMTP服务器地址
kylin.job.notification-mail-port=your-smtp-port
kylin.job.notification-mail-username=your-smtp-account  # 设置该项为邮件的SMTP登录用户名
kylin.job.notification-mail-password=your-smtp-pwd  # 设置该项为邮件的SMTP登录密码
kylin.job.notification-mail-sender=your-sender-address  # 设置该项为邮件的发送邮箱地址
kylin.job.notification-admin-emails=adminstrator-address
kylin.job.notification-alert-receiver-emails=alert-receiver-address #设置该项为收件人通知列表
```

设置完毕后，请重新启动 Kyligence Enterprise 使配置生效。

