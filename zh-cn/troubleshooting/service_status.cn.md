## 环境依赖服务检测

KAP从v 2.5.6版本开始增加了环境依赖服务检测的功能，每15分钟进行环境检测。对于ADMIN权限用户，可以在界面上清晰地看到相关信息与分级的警示提醒，帮助管理员诊断问题。

环境依赖的服务状态（以下简称为服务状态）检测使用绿色、黄色和红色分别表示正常、警告和错误三种状态。当出现非正常状态时，您还可以通过移动鼠标到检测项来查看二级信息。

![服务状态检测](images/service_status.cn.png)

环境依赖检测主要从以下几个方面进行：

* Hive可用性检查：检查Hive/Beeline的可连通性


* 元数据库活性检查：检查元数据储存的可连通性、读写正确性和响应速度
* 元数据完整性检查：检查元数据的一致性及判断元数据是否损坏
* Zookeeper活性检查：检查zookeeper的可连通性、加锁操作和响应速度
* Spark集群可用性：检查Spark的可用性
* 垃圾清理：检查垃圾文件大小
* 元数据同步检查：检查元数据同步是否异常，异常时尝试重载元数据
* 任务执行引擎活性检查：检查任务执行引擎的活性


### 使用命令行进行单独诊断

KAP还提供了命令行工具来进行每个服务状态检测，方便进行及时检查和排除错误。同时，检测结果将被保留在单独的日志文件里（`$KYLIN_HOME/logs/canary.log`），并包括在KyBot诊断包中。

运行方法如下：

在`$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.canary.CanaryCLI <canaries-to-test>`，检测结果如下图所示：

> <canaries-to-test>可替换为对应的检测命令参数：
>
> •元数据储存活性：MetaStoreCanary 
>
> •Hive连通性：HiveCanary
>
> •元数据完整性：MetadataCanary
>
> •元数据同步一致性：MetaSyncErrorCanary
>
> •Zookeeper活性：ZookeeperCanary
>
> •任务执行引擎活性：JobEngineCanary
>
> Spark相关检测目前暂时无法使用命令行来进行单独检测。

![使用命令行工具进行单独检测](images/canary.png)

### 服务状态检测说明

服务状态分为以下四种：

+ 绿色：正常，表示该项服务状态检测正常。
+ 黄色：警告，某项服务状态的检测时间超过警告时限，可能会影响Kyligence Enterprise的性能，但是并不影响使用。


+ 红色：错误，某项依赖服务的检测存在异常或者检测时间超过错误时限

  > 例如，MetaStore服务状态为错误时，将提示MetaStore活性检查时间超过错误阈值，请您检查相关环境依赖。MetaStore存在异常时，将提示MetaStoreCanary存在严重异常，请查看canary.log获取详情。


各项服务状态的检测标准（WARNING和ERROR）主要如下：
+ MetaStoreCanary
  - **WARNING**：执行metadata读、写、删操作超过300毫秒。
  - **ERROR**：执行metadata读、写、删操作超过1000毫秒。
  - **ERROR**：对metadata执行写操作后，未能读取到新写的数据。

+ HiveCanary
  - **WARNING**：查询hive所有database超过20秒。
  - **ERROR**：查询hive所有database超过30秒。

+ MetadataCanary
  - **WARNING**：验证metadata完整性超过10秒。
  - **ERROR**：验证metadata完整性超过30秒。
  - **ERROR**：Metadata完整性存在错误。

+ MetaSyncErrorCanary
  - **WARNING**：Metastore同步失败。

+ ZookeeperCanary
  - **WARNING**：查看ZooKeeper活性、加锁、解锁超过3秒。
  - **ERROR**：查看ZooKeeper活性、加锁、解锁超过10秒。
  - **ERROR**：ZooKeeper非活跃状态。
  - **ERROR**：加锁失败。
  - **ERROR**：解锁失败。

+ JobEngineCanary
  - **ERROR**：有KAP节点未能返回job engine状态。
  - **ERROR**：没有活跃状态的任务构建引擎节点。

+ SparkSqlContextCanary
  - **WARNING**：使用spark context进行一次整数连加操作超过10秒
  - **ERROR**：使用spark context进行一次整数连加操作超过30秒。