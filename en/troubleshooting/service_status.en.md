## Service Status Detection

Since KAP V2.5.6, the service status will be checked every 15 minutes. For ADMIN users,  it is clear to check the related information and warning notices, which could help users understand the service status. The user interface is shown as following.

Service status uses green, yellow and red to show *health*, *error* and *warning*. Users could also check the specific items to get the detailed information.

KAP supports to use command lines to diagnose the individual service status. Meanwhile, the results will be stored in a log file named *canary.log* (`$KYLIN_HOME/logs/canary.log`), which will also be stored in the KyBot diagnostic package.

![service status](images/service_status.en.png)

This function will mainly focus on these aspects：

- Metastore availability：check the connectivity, functionality, and response of metastore 
- Hive connectivity：check the connectivity of Hive/Beeline and usability of Kerberos ticket
- Metadata consistency：check the consistency and integrity of metadata
- Metadata synchronization：check the synchronous exception of metadata and reload metadata automatically
- Spark context availability：check the availability of  pushdown spark cluster
- Zookeeper availability：check the connectivity of zookeeper including response and functionality
- Job Engine：check the availability of job engine

### Using Command Line to Diagnose Separately

You can run the following command lines in `$KYLIN_HOME/bin`

`./kylin.sh io.kyligence.kap.canary.CanaryCommander <canaries-to-test>`

> <canaries-to-test> could be replaced as the following parameters :
>
> •MetaStore availability: MetaStoreCanary 
>
> •Hive connection test: HiveCanary
>
> •Metadata consistency: MetadataCanary
>
> •Metadata synchronization: MetaSyncErrorCanary
>
> •Zookeeper availability: ZookeeperCanary
>
> •Job engine availability: JobEngineCanary
>
> The command line is not currently supported to diagnose Spark context availability.

![canary command line](images/canary.png)

### The Description of Service Status

The status is mainly shown as following:

- GOOD: The service status is healthy
- WARNING: There are some problems which may impact KAP performance. For example,

> MetaStoreCanary WARNING [WARNING: Creating metadata (40 bytes) is slow and it may impact KAP performance and availability.]

- ERROR: There is something wrong with the dependency service. For example,

> ERROR [JobEngineCanary-191152] canary: No active job node found.

- CRASH: The service throws the exception. For example,

> 2018-03-19 12:07:30,218 INFO  [SparkSqlContextCanary-191207] canary : Completed > SparkSqlContextCanary CRASH [CRASH: Cannot call methods on a stopped SparkContext.
> This stopped SparkContext was created at:
> org.apache.spark.sql.SparderFunc.init(SourceFile)
> io.kyligence.kap.rest.init.KapInitialTaskManager.checkAndInitSpark(SourceFile:69)
> io.kyligence.kap.rest.init.KapInitialTaskManager.afterPropertiesSet(SourceFile:44)
> org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.invokeInitMethod
>  s(AbstractAutowireCapableBeanFactory.java:1687)
> org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.initializeBean(AbstractAutowireCapableBeanFactory.java:1624)
> (No active SparkContext.)

The detection standards of WARNING and ERROR can be summarised as following situations:

- MetaStoreCanary
  - The operations of writing, reading and deleting exceed 300 milliseconds. WARNING
  - The operations of writing, reading and deleting exceed 1000 milliseconds. ERROR
  - Metastore failed to read a newly created resource. ERROR(msg: Metadata store failed to read a newly created resource.)
- HiveCanary
  - The time of querying all the databases in hive exceeds 20 seconds. WARNING
  - The time of querying all the databases in hive exceeds 30 seconds. ERROR
- MetadataCanary
  - The time of verifying the consistency of metadata exceeds 10 seconds. WARNING
  - The time of verifying the consistency of metadata exceeds 30 seconds. ERROR
  - There are some problems in the consistency of metadata. ERROR(msg: Metadata {entities} corrupt, with rule --{rule})
- MetaSyncErrorCanary
  - Metastore synchronize failed. WARNING(msg: Metadata synchronization error detected (from {node1} to {node2}). Network was unstable or overloaded? Auto recovery attempted.)
- ZookeeperCanary
  - The time of detecting the functionality of Zookeeper exceeds 3 seconds. WARNING
  - The time of detecting the functionality of Zookeeper exceeds 10 seconds. ERROR
  - ZooKeeper is not alive. ERROR(msg: Zookeeper with connection {url} is not alive.)
  - Failed to require zookeeper lock. ERROR(msg: Failed to require zookeeper lock.)
  - Failed to release zookeeper lock. ERROR(msg: Failed to release zookeeper lock.)
- JobEngineCanary
  - One of the KAP nodes failed to report job engine status. ERROR(msg: Node {node} failed to report job engine status)
  - There is no active job engine node found. ERROR(msg: No active job node found.)
- SparkSqlContextCanary
  - The time of using spark context to continuously add integer exceeds 10 seconds. WARNING
  - The time of using spark context to continuously add integer exceeds 30 seconds. ERROR

