## 生产环境推荐配置

Kyligence Enterprise的配置文件包括几个部分：

- *kylin.properties*，包含系统的主要配置参数；
- *kylin_hive_conf.xml*，作用于系统提交的Hive任务；
- *kylin_job_conf.xml*，作用于系统提交的MapReduce任务；
- *kylin_job_conf_inmem.xml*，作用于一些有较高内存需求的MapReduce任务。

以下推荐配置将按照集群的规模分类，系统性能可能受其它外部系统参数影响，这里推荐仅作为经验值。

*Sandbox*表示用于单机sandbox虚拟机测试的环境，2核，10GB内存，10GB硬盘

*Prod*表示生产环境推荐配置，通常至少由5个节点组成的Hadoop集群，单机32核，128GB内存，20TB硬盘。

> 提示：产品自带了*Sandbox*和*Prod*的两套推荐配置。其中默认配置为*Sandbox*，并可以通过修改profile的软连接指向来切换到*Prod*配置：
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



