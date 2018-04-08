## Service Status Detection

Since KAP V2.5.6, the service status will be checked every 15 minutes. ADMIN users can check the status of services visually on the KAP WEB UI, as shown in the following picture. 

Services status turns green for being good, yellow for warnings  and red for error. Users could also click to get more detailed information.

![service status](images/service_status.en.png)

This function will mainly focus on these aspects：

- Metastore availability: to check the metastore’s connectivity, functionality and response time 
- Hive connectivity: to check the connectivity and speed of Hive
- Metadata consistency: to check the consistency of metadata
- Metadata synchronization: to check the synchronous exception of metadata and reload metadata automatically
- Spark context availability: to check the availability of  Spark session
- Zookeeper availability: to check the availability and speed of zookeeper
- Job Engine: to check the availability of job engine

### Using Command Line to  Check Manually

Command lines are also supported to check the individual service status manually. Meanwhile, the results will be stored in a log file named *canary.log* (`$KYLIN_HOME/logs/canary.log`), which will also be included in the KyBot diagnostic package.

You can run the following command line `$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.canary.CanaryCommander <canaries-to-test>`. 

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

![command line](images/canary.png)

### The Description of Service Status

The status is mainly shown as following:

- GOOD: The service status is healthy
- WARNING: There are some problems which may impact KAP performance. 


- ERROR: There is something wrong with the dependency service. You may need to check the dependency services or cluster information.


- CRASH: The service throws the exception. For example,

> There is serious exception in {canary name}. Please check canary.log for more details.
>
>  {canary name}'s response time exceeds threshold limit. Please check the dependency service.

There are more details about the criterias, especially for *ERROR* and *WARNING*.

- MetaStoreCanary
  - *WARNING* : The operations including writing, reading and deleting on metadata take more than 300 milliseconds. 
  - *ERROR*: The operations including writing, reading and deleting on metadata take more than 1000 milliseconds.
  - *ERROR*: Metastore failed to read a newly created resource.
- HiveCanary
  - *WARNING*: Listing Hive databases exceeds 20 seconds.
  - *ERROR*: Listing Hive databases exceeds 30 seconds.
- MetadataCanary
  - *WARNING*: Verifying the consistency of metadata exceeds 10 seconds. 
  - *ERROR*: Verifying the consistency of metadata exceeds 30 seconds. 
  - *ERROR*: Broken metadata exists.
- MetaSyncErrorCanary
  - *WARNING*: Metastore synchronize failed. 
- ZookeeperCanary
  - *WARNING*: The operation of checking zookeeper's availability / locking / unlocking exceeds 3 seconds. 
  - *ERROR*: he operation of checking zookeeper's availability / locking / unlocking exceeds 10 seconds. 
  - *ERROR*: ZooKeeper is not alive.
  - *ERROR*: Failed to require zookeeper lock. 
  - *ERROR*: Failed to release zookeeper lock. 
- JobEngineCanary
  - *ERROR*: One of the KAP nodes failed to report job engine status. 
  - *ERROR*: There is no active job engine node found. 
- SparkSqlContextCanary
  - *WARNING*: The time of calculating the sum from 0 to 100 exceeds 10 seconds.
  - *ERROR*: The time of calculating the sum from 0 to 100 exceeds 30 seconds.

