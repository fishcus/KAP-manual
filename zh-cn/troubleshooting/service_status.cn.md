## 环境依赖检测

从KAP V2.5.6开始，对于ADMIN权限用户，KAP会每15分钟检测环境依赖并提供分级警示信息，方便用户了解到KAP所依赖服务的状态。

![服务状态检测](images/service_status.cn.png)

KAP主要从以下几个方面进行检测：

* MetaStore活性检查：检查metastore的可连通性，读写正确性，和响应速度
* Hive连通性检查：检查Hive/Beeline的可连通性，kerberos ticket可用
* Metadata完整性检查：检查metadata一致性、是否损坏
* Metadata同步检查：检查metadata同步异常，并自动重载元数据
* Spark context活性检查：检查pushdown spark cluster活性
* Zookeeper活性检查：检查zookeeper的可连通性，加锁操作，和响应速度
* 任务执行引擎活性检查：检查job engine活性

状态检测使用绿色、黄色和红色分别表示健康，警告和错误三种状态。用户还可以通过移动鼠标到状态栏来查看二级信息。

### 使用命令行进行单独诊断

KAP还提供了命令行来进行每个环境依赖检测，方便用户排错。同时检测结果将被保留在单独的日志文件里（canary.log），并包括在KyBot诊断包中。

运行方法如下：

在$KYLIN_HOME/bin 目录下执行

`./kylin.sh io.kyligence.kap.canary.CanaryCommander <canaries-to-test>`

> <canaries-to-test>可替换为对应的检测命令参数：
>
> •MetaStore活性：MetaStoreCanary 
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

![canary command line](images/canary.png)