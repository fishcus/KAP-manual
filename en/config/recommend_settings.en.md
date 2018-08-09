## Recommended Configurations for Production

The configuration files of Kyligence Enterprise include: 

- *kylin.properties*, the major configuration file of the system; 

- *kylin_hive_conf.xml*, applies to Hive jobs launched by the system; 

- *kylin_job_conf.xml*, applies to MapReduce jobs launched by the system; 

- *kylin_job_conf_inmem.xml*, applies to the special MapReduce jobs that have high demand of memory.

The following recommended configurations are classified according to the size of the cluster, system performance could be influenced by other external system parameters. Here our recommending configurations are based on experience.

*Sandbox* refers the testing environment for single machine sandbox virtual machine, dual core, 10 GB internal storage, 10 GB hard disk.

*Prod* represents recommended configuration for the production environment, usually, the Hadoop cluster consisting of at least 5 nodes, single machine 32 core, 128 GB internal storage, 20 TB hard disk.

> Tip: The product ships with sample configurations for *Sandbox* and *Prod* profiles. *Sandbox* is used as default profile and can be switched by rebuild soft link:
>
> ```bash
> cd $KYLIN_HOME/conf
>
> # Use sandbox(min) profile
> ln -sfn profile_min profile
>
> # Or use production(prod) profile
> ln -sfn profile_prod profile
> ```

### kylin.properties

| Properties Name                                  | Sandbox    | Prod       |
| ------------------------------------------------ | ---------- | ---------- |
| kylin.job.max-concurrent-jobs                    | 10         | 20         |
| kylin.job.sampling-percentage                    | 100        | 100        |
| kylin.engine.mr.yarn-check-interval-seconds      | 10         | 10         |
| kylin.engine.mr.reduce-input-mb                  | 100        | 500        |
| kylin.engine.mr.max-reducer-number               | 100        | 500        |
| kylin.engine.mr.mapper-input-rows                | 200000     | 1000000    |
| kylin.cube.algorithm                             | auto       | auto       |
| kylin.cube.algorithm.layer-or-inmem-threshold    | 8          | 8          |
| kylin.cube.aggrgroup.max-combination             | 4096       | 4096       |
| kylin.dictionary.max.cardinality                 | 5000000    | 5000000    |
| kylin.snapshot.max-mb                            | 300        | 300        |
| kylin.query.scan-threshold                       | 10000000   | 10000000   |
| kylin.query.memory-budget-bytes                  | 3221225472 | 3221225472 |
| kylin.query.derived-filter-translation-threshold | 100        | 100        |

| Properties Name                                          | Sandbox | Prod  |
| -------------------------------------------------------- | ------- | ----- |
| kap.storage.columnar.spark-conf.spark.driver.memory      | 512m    | 8192m |
| kap.storage.columnar.spark-conf.spark.executor.memory    | 512m    | 4096m |
| kap.storage.columnar.spark-conf.spark.yarn.am.memory     | 512m    | 4096m |
| kap.storage.columnar.spark-conf.spark.executor.cores     | 1       | 5     |
| kap.storage.columnar.spark-conf.spark.executor.instances | 1       | 4     |
| kap.storage.columnar.page-compression                    | N/A     | N/A   |
| kap.storage.columnar.ii-spill-threshold-mb               | 128     | 512   |




### kylin_hive_conf.xml

| Properties Name                          | Sandbox   | Prod                                     |
| ---------------------------------------- | --------- | ---------------------------------------- |
| dfs.replication                          | 2         | 2                                        |
| hive.exec.compress.output                | true      | true                                     |
| hive.auto.convert.join.noconditionaltask | true      | true                                     |
| hive.auto.convert.join.noconditionaltask.size | 100000000 | 100000000                                |
| mapreduce.map.output.compress.codec      | N/A       | org.apache.hadoop.io.compress.SnappyCodec |
| mapreduce.output.fileoutputformat.compress.codec | N/A       | org.apache.hadoop.io.compress.SnappyCodec |
| mapreduce.output.fileoutputformat.compress.type | BLOCK     | BLOCK                                    |
| mapreduce.job.split.metainfo.maxsize     | -1        | -1                                       |

### kylin_job_conf.xml

| Properties Name                          | Sandbox | Prod                                     |
| ---------------------------------------- | ------- | ---------------------------------------- |
| mapreduce.job.split.metainfo.maxsize     | -1      | -1                                       |
| mapreduce.map.output.compress            | true    | true                                     |
| mapreduce.map.output.compress.codec      | N/A     | org.apache.hadoop.io.compress.SnappyCodec |
| mapreduce.output.fileoutputformat.compress | true    | true                                     |
| mapreduce.output.fileoutputformat.compress.codec | N/A     | org.apache.hadoop.io.compress.SnappyCodec |
| mapreduce.output.fileoutputformat.compress.type | BLOCK   | BLOCK                                    |
| mapreduce.job.max.split.locations        | 2000    | 2000                                     |
| dfs.replication                          | 2       | 2                                        |
| mapreduce.task.timeout                   | 3600000 | 3600000                                  |

### kylin_job_conf_inmem.xml

| Properties Name                          | Sandbox  | Prod                                     |
| ---------------------------------------- | -------- | ---------------------------------------- |
| mapreduce.job.split.metainfo.maxsize     | -1       | -1                                       |
| mapreduce.map.output.compress            | true     | true                                     |
| mapreduce.map.output.compress.codec      | N/A      | org.apache.hadoop.io.compress.SnappyCodec |
| mapreduce.output.fileoutputformat.compress | true     | true                                     |
| mapreduce.output.fileoutputformat.compress.codec | N/A      | org.apache.hadoop.io.compress.SnappyCodec |
| mapreduce.output.fileoutputformat.compress.type | BLOCK    | BLOCK                                    |
| mapreduce.job.max.split.locations        | 2000     | 2000                                     |
| dfs.replication                          | 2        | 2                                        |
| mapreduce.task.timeout                   | 7200000  | 7200000                                  |
| mapreduce.map.memory.mb                  | 1024     | 4096                                     |
| mapreduce.map.java.opts                  | -Xmx700m | -Xmx3700m                                |
| mapreduce.task.io.sort.mb                | 100      | 200                                      |
