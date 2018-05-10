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
> •Garbage cleanup: GarbageCanary
>
> The command line is not currently supported to diagnose Spark context availability.

### The Description of Service Status

The status is mainly shown as following:

- Green: Good, the service status is healthy
- Yellow: Warning, there are some problems which may impact KAP performance. 


- Red: Error or crash, there is something wrong with the dependency service or the service throws the exception. The dependency services or cluster information need to be checked.

There are more details about the criterias.

| Canary Items          | Status: Yellow                                               | Status: Red                                                  |
| --------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| MetaStoreCanary       | The operations including writing, reading and deleting on metadata take more than 300 milliseconds. | 1.The operations including writing, reading and deleting on metadata take more than 1000 milliseconds <br>2.Metastore failed to read a newly created resource |
| HiveCanary            | Listing Hive databases exceeds 20 seconds                    | Listing Hive databases exceeds 30 seconds                    |
| MetadataCanary        | Verifying the consistency of metadata exceeds 10 seconds     | 1.Verifying the consistency of metadata exceeds 30 seconds<br>2.Broken metadata exists |
| MetaSyncErrorCanary   | Metastore synchronize failed                                 |                                                              |
| ZookeeperCanary       | The operation of checking zookeeper's availability / locking / unlocking exceeds 3 seconds | 1.The operation of checking zookeeper's availability / locking / unlocking exceeds 10 seconds <br>2.ZooKeeper is not alive <br>3.Failed to require/release zookeeper lock |
| JobEngineCanary       |                                                              | 1.One of the KAP nodes failed to report job engine status<br>2.There is no active job engine node found |
| SparkSqlContextCanary | The time of calculating the sum from 0 to 100 exceeds 10 seconds | The time of calculating the sum from 0 to 100 exceeds 30 seconds |
| GarbageCanary         | 1. The number of metadata garbage is larger than 50 <br>2. The number of garbage files produced by cube is larger than 50<br>3. The amount of garbage is larger  than 5G |                                                              |

