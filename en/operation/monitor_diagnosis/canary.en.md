## Environment Dependency Check

Since Kyligence Enterprise v2.5.6, environment dependency will be detected every 15 minutes. ADMIN users can view the service status and related information visually on the WEB UI and diagnose environment problem conveniently.

Services status turns green for being good, yellow for warning and red for error. More detailed information can be viewed by hovering above the specific detection item.

### Environment Dependency Check Item

Service status detection mainly focuses on following aspects：

- Hive availability: to check the connectivity of Hive and Beeline.
- File system availability: to check the availability of file system.
- Metadata store availability: to check the metastore’s connectivity, functionality and response time 
- Metadata availability: to check the metadata consistency and metadata garbage files
- ZooKeeper availability: to check the connectivity and response speed of ZooKeeper
- Spark cluster availability: to check the availability of Spark 
- Garbage cleanup: to check the size of system storage garbage files
- Metadata synchronization: to check the whether metadata is synchronized successfully and if not, metadata will be reloaded automatically
- Job Engine availability: to check the availability of job engines

### Three levels of Service Status 

- Green: Good, indicating that the service status is healthy
- Yellow: Warning, indicating that there are some problems which may impact Kyligence Enterprise performance.
- Red: Error or crash, indicating that there is something wrong with the service status or the service throws exception. 


### Detailed Criteria for Service Status

| Canary Items          | Status: Yellow                                               | Status: Red                                                  |
| --------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| HiveCanary            | Listing Hive databases exceeds 20 seconds                    | Listing Hive databases exceeds 30 seconds                    |
| FileSystemCanary            |    | File system closes accidently   |
| MetaStoreCanary       | Writing, reading and deleting on metadata exceeds 300 milliseconds. | 1.Writing, reading and deleting on metadata exceeds 1000 milliseconds <br>2.Metastore failed to read the latest written data |
| MetadataCanary        | 1.Verifying the consistency of metadata exceeds 10 seconds <br> 2. Existing metadata garbage and the time period to last metadata cleanup operation exceed the parameter `kap.canary.metadata-enable-warning-after-cleanup-days`, 7 days by default  | 1.Verifying the consistency of metadata exceeds 30 seconds<br>2.Broken metadata exists |
| ZookeeperCanary       | Checking ZooKeeper's availability, locking and unlocking exceeds 3 seconds | 1.Checking ZooKeeper's availability, locking and unlocking exceeds 10 seconds <br>2.ZooKeeper is not alive <br>3.Failed to require or release ZooKeeper lock |
| SparkSqlContextCanary | The time of calculating the sum from 0 to 100 exceeds 10 seconds | The time of calculating the sum from 0 to 100 exceeds 30 seconds |
| GarbageCanary         | 1. The number of garbage files produced by Cube is larger than 50<br>2. The amount of garbage is larger  than 5G |                                                              |
| MetaSyncErrorCanary   | Metastore fails to synchronize                               |                                                              |
| JobEngineCanary       |                                                              | 1.One of the Kyligence Enterprise nodes failed to report Job Engine status<br>2.There is no active Job Engine node |

### Check Service Status Manually

Kyligence Enterprise also supports users to check service status manually through command lines, and the results will be logged in `$KYLIN_HOME/logs/canary.log`.

You can run the command line `$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.canary.CanaryCLI <canaries-to-test>`, in which  `canaries-to-test` could be replaced by the following parameters,

- Hive availability: `HiveCanary`
- File system availability: `FileSystemCanary`
- Metadata store availability: `MetaStoreCanary`
- Metadata integrity: `MetadataCanary`
- ZooKeeper availability: `ZookeeperCanary`
- Spark cluster availability:  not yet supported
- Garbage cleanup: `GarbageCanary`
- Metadata synchronization: `MetaSyncErrorCanary`
- Job Engine availability: `JobEngineCanary`


### How to enable Canary Email Notification function

Kyligence Enterprise provides *Email Notification* function, which will send emails to administrators when service status is not healthy.

Following configurations in `$KYLIN_HOME/conf/kylin.properties` is required

```
kylin.job.notification-enabled=true|false  # set to true to enable the function
kylin.job.notification-mail-enable-starttls=true|false    
kylin.job.notification-mail-host=your-smtp-server  # address of SMTP server
kylin.job.notification-mail-port=your-smtp-port  # port of SMTP server
kylin.job.notification-mail-username=your-smtp-account  # SMTP account username
kylin.job.notification-mail-password=your-smtp-pwd  # SMTP account password
kylin.job.notification-mail-sender=your-sender-address  # sender address
kylin.job.notification-admin-emails=adminstrator-address
kylin.job.notification-alert-receiver-emails=alert-receiver-address # notification list
```

Restart Kyligence Enterprise to make configurations work.
