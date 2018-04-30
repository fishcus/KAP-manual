## Service Status Detection

Since KAP V2.5.6, the service status will be checked every 15 minutes. ADMIN users can check the status of services visually on the KAP WEB UI, as shown in the following picture. 

Services status turns green for being good, yellow for warnings  and red for error. Users could also click to get more detailed information.

![service status](images/service_status.en.png)

This function will mainly focus on these aspects：

- Hive availability: to check the connectivity and speed of Hive
- Metadata store availability: to check the metastore’s connectivity, functionality and response time 
- Metadata integrity: to check the consistency of metadata
- Zookeeper availability: to check the availability and speed of zookeeper
- Spark cluster availability: to check the availability of  Spark session
- Garbage cleanup: to check the size of garbage
- Metadata synchronization: to check the synchronous exception of metadata and reload metadata automatically
- Job Engine: to check the availability of job engine

### Using Command Line to  Check Manually

Command lines are also supported to check the individual service status manually. Meanwhile, the results will be stored in a log file named *canary.log* (`$KYLIN_HOME/logs/canary.log`), which will also be included in the KyBot diagnostic package.

You can run the following command line `$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.canary.CanaryCLI <canaries-to-test>`. 

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

- Green: Good, the service status is healthy
- Yellow: Warning, there are some problems which may impact KAP performance. 


- Red: Error or crash, there is something wrong with the dependency service or the service throws the exception. The dependency services or cluster information need to be checked.


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

