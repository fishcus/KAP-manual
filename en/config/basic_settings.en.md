## Important Configurations
The file *kylin.properties* occupies an important position among all Kyligence Enterprise configurations. This section will give detailed explanations of some common properties in it. 

User could put the customized config items into *kylin.properties.override*, the items in this file will override the default value in *kylin.properties* at runtime. The benefit is easy to upgrade. In the system upgrade, put the *kylin.properties.override* together with new version *kylin.properties*. 

### kylin.metadata.url
Kyligence Enterprise metadata path is specified by this property. The default value is *kylin_metadata* table in HBase while users can customize it to store metadata into any other table. When deploying multiple Kyligence Enterprise instances on a cluster, it's necessary to specify a unique path for each of them to guarantee the isolation among them. For example, the value of this property for Production instance could be `kylin_metadata_prod`, while that for Staging instance could be `kylin_metadata_staging`, so that Production instance wouldn't be interfered by operations on Staging instance. 

### kylin.env.hdfs-working-dir
Working path of Kyligence Enterprise instance on HDFS is specified by this property. The default value is `/kylin` on HDFS, with HTable name in metadata path as the sub-directory. For example, suppose the metadata path is ``kylin_metadata@hbase``, the HDFS default path should be `/kylin/kylin_metadata`. Please make sure the user running Kyligence Enterprise instance has read/write permissions on that directory. 

### kylin.server.mode
Kyligence Enterprise instance running mode is specified by this property. Optional values include `all`, `job` and `query`, among them `all` is the default one. *job* mode means the Kyligence Enterprise instance schedules Cube task only; *query* mode means the instance serves SQL queries only; *all* mode means the instance handles both of them.

### kylin.source.hive.database-for-flat-table
This property specifies which Hive database intermediate tables will locate in. The default value is *default*. If the user running Kyligence Enterprise doesn't have permission to access *default* database, it's adequate to alter the property to use databases with other names. 

### kylin.storage.hbase.compression-codec
The compression algorithm used in HTables created by Kyligence Enterprise is specified by this property. The default value is *none*, which means no compression adopted. Choose appropriate compression algorithm, such as *snappy*, *lzo*, *gzip* or *lz4*, according to support for those algorithms in your situation. 

### kylin.security.profile
Kyligence Enterprise instance security profile is specified by this property. Optional values include *ldap*, *saml* and *testing*, among them *testing* is the default one which means testing account enabled. You can alter its value to plug into existing enterprise authentication systems, such as *ldap* and *saml*. For more information, refer to section [Security and Access Control](../security/README.md). 

### kylin.web.timezone
Time zone used for Kyligence Enterprise Rest service is specified by this property. The default value is *GMT+8*. You can alter it according to the requirement of your applications. 

### kylin.source.hive.client
Type of hive command line is specified by this property. Option values include  *cli* and *beeline*, among them *cli* is the default one, which means Hive CLI is adopted. You can alter it to *beeline* if Hive beeline is the only supported command line. 

### kylin.source.hive.beeline-params
This configuration is required when *beeline* is set in previous property. For example, if you want to execute SQL with beeline in the way below:
```
beeline -n root -u 'jdbc:hive2://localhost:10000' -f abc.sql
```

Please set the value of the property as:
```
kylin.source.hive.beeline.params=-n root -u 'jdbc:hive2://localhost:10000'
```

### kylin.env
The usage of the Kyligence Enterprise instance is specified by this property. Optional values include *DEV*, *PROD* and *QA*, among them *PROD* is the default one. In *DEV* mode some developer functions are enabled. 

### kylin.query.force-limit
Some BI tools always send query like `select * from fact_table`, but the process may stuck if the table size is extremely large. LIMIT clause helps in this case, and setting the value of this property to a positive integer make Kyligence Enterprise append LIMIT clause if there's no one. For instance the value is 1000, query "select \* from fact\_table" will be transformed to "select \* from fact\_table limit 1000". This configuration can be overridden at **project** level.

### kylin.query.disable-cube-noagg-sql
Cube stores the pre-processed data, which is different from original data in most cases. It results in inaccurate answer from Cube if the query has no aggregation function. 
This configuration is used to address the issue. If it's set to *true*, Cube is forbidden to answer queries that contain no aggregation functions, such as query `select * from fact_table limit 1000`, Table Index or Query Pushdown will answer the query instead of Cube in this case. This configuration can be overridden at **Cube** level.

### kylin.query.convert-create-table-to-with (Beta)

Some BI software will send Create Table statement to create a permanent or temporary table in the data source. If this setting is set to true, the create table statement in the query will be converted to a with statement, when a later query utilizes the table that the query created in the previous step, the create table statement will be converted into a subquery, which can hit on a Cube if there is one to serve the query. 

### kap.smart.conf.model.cc.enabled

Using SQL statements to generate model, the calculated columns will be needed if SQL statements may contain expressions. If this setting is set to true, Kyligence Enterprise will automatically generate the calculated columns and those calculated columns will be set as dimension.

> Only these functions are currently supported : SUM({EXPR}), AVG({EXPR}), array[{INDEX}], CASE .. WHEN ..

### kylin.query.pushdown.update-enabled

This property specifies whether opending the update function in pushdown query. The default value is false.  If this setting is set to true, the function will be opened. 

### kylin.query.pushdown.cache-enabled

This property specifies the function of cache enabled. The default value is true. If this setting is set to false, the function will be closed. 

### kylin.cube.is-automerge-enabled

The auto merge function is enabled by default. If this setting is set to false, the function will be closed. Although the auto merge thresholds were setted, the merge job would not be built.

### kap.storage.columnar.start-own-spark

This property specifies whether starting the spark query cluster. The default value is true. If this setting is set to false, the function will be closed. In Read/Write Deployment, the property is recommended set as false in job cluster.

### kap.storage.init-spark-at-starting

This property specifies that spark query cluster will be started together when Kyligence Enterprise is started. The default value is true. If this setting is set to false, the function will be closed. 

### kap.storage.columnar.spark-conf.spark.yarn.queue

This property specifies the yarn queue which is used by spark query cluster.

### kap.storage.columnar.spark-conf.spark.master

Spark deployment is normally divided into *Spark on YARN*, *Spark on Mesos*, and *standalone*. We usually use Spark on Yarn as default. This property enables Kyligence Enterprise to use standalone deployment, which could submit jobs to the specific spark-master-url.

### kylin.source.hive.default-varchar-precision

The string datatype is not supported in Kyligence Enterprise. Therefore, the string column will transform into varchar automatically.  This property specifies the maximum length of the transformed filed and the default value is 256.

### kylin.metadata.hbase-client-scanner-timeout-period

This property specifies the timeout threshold of scanning operation and the default value is 10000 ms.

### kylin.metadata.hbase-rpc-timeout

This property specifies the timeout threshold of rpc operation and the default value is 5000 ms.

### kylin.metadata.hbase-client-retries-number

This property specifies the retry times of HBase and the default value is 1.

## JVM Configuration Setting

In `$KYLIN_HOME/conf/setenv.sh` (for version lower than 2.4, `$KYLIN_HOME/bin/setenv.sh`), two sample settings for `KYLIN_JVM_SETTINGS` environment variable are given. The default setting use relatively less memory. You can comment it and then uncomment the next line to allocate more memory for Kyligence Enterprise. The default configuration is: 

```
export KYLIN_JVM_SETTINGS="-Xms1024M -Xmx4096M -Xss1024K -XX:MaxPermSize=128M -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:$KYLIN_HOME/logs/kylin.gc.$$ -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=64M"
# export KYLIN_JVM_SETTINGS="-Xms16g -Xmx16g -XX:MaxPermSize=512m -XX:NewSize=3g -XX:MaxNewSize=3g -XX:SurvivorRatio=4 -XX:+CMSClassUnloadingEnabled -XX:+CMSParallelRemarkEnabled -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:CMSInitiatingOccupancyFraction=70 -XX:+DisableExplicitGC -XX:+HeapDumpOnOutOfMemoryError"
```



## Enable Email Notification

Kyligence Enterprise can send email notification on job complete/fail. To enable this, edit `conf/kylin.properties`, set the following parameters: 

```properties
kylin.job.notification-enabled=true|false
kylin.job.notification-mail-enable-starttls=true|false
kylin.job.notification-mail-host=your-smtp-server
kylin.job.notification-mail-port=your-smtp-port
kylin.job.notification-mail-username=your-smtp-account
kylin.job.notification-mail-password=your-smtp-pwd
kylin.job.notification-mail-sender=your-sender-address
kylin.job.notification-admin-emails=adminstrator-address
```

Restart Kyligence Enterprise server to take effective. 

One example:

```properties
kylin.job.notification-enabled=true
kylin.job.notification-mail-enable-starttls=true
kylin.job.notification-mail-host=smtp.office365.com
kylin.job.notification-mail-port=587
kylin.job.notification-mail-username=kylin@example.com
kylin.job.notification-mail-password=mypassword
kylin.job.notification-mail-sender=kylin@example.com
```

To disable, set `kylin.job.notification-enabled` back to `false`.

Administrator will get notifications for all jobs. Modeler and Analyst need entering email address into the `Notification List` at the first page of Cube wizard, and then will get notifications for that Cube.

### Notes for Kyligence Enterprise Warm Start after Config Parameters Modified

The parameters defined in kylin.properties (global) will be loaded by default when Kyligence Enterprise is started. Once being modified, they will not take effect until Kyligence Enterprise is restarted.

For the parameters of Hive and MapReduce, when the modifications are defined in kylin_hive_conf.xml, kylin_job_conf.xml and kylin_job_conf_inmem.xml, Kyligence Enterprise needs not to be restarted, but the build Job shall be resubmitted. Each time the build Job is submitted to Yarn, the modified parameters will be read in real time. Please note that the configuration items will override the default parameters (such as hive-stie.xml and mapred-site.xml) in Hadoop cluster and can also be overwritten by Project and Cube configuration overriding.
