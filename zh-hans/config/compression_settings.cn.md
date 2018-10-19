## 启用压缩

Kyligence Enterprise 在默认状态下不会启用压缩，这是为了保证产品在所有的环境下都能开箱即用。在多数生产环境，一个合适的压缩算法能够使用少量的 CPU 计算，来降低存储开销和网络开销，提高整体系统运行效率。Kyligence Enterprise 主要有三处使用压缩，分别是 Cube 数据压缩、Hive 输出压缩和 MR 任务输出压缩。

> **注意**：所有下述配置需要重启后方能生效。

### Cube 数据压缩

该项压缩通过 `kylin.properties` 中的 `kap.storage.columnar.page-compression` 参数进行配置，该配置决定了构建出的 Cube 数据是否压缩，及所使用的压缩算法。默认值为""，即不压缩数据。将其改为 **SNAPPY** 来启用压缩。

```properties
kap.storage.columnar.page-compression=SNAPPY
```
在修改压缩算法前，请确保你的 Hadoop 集群支持 SNAPPY 压缩算法。

> 注意：Kyligence Enterprise 3.1.0 版本后，该参数默认值由SNAPPY改为 ""。请您根据使用环境情况选择是否开启该压缩。

### Hive 输出压缩

该项压缩通过 `kylin_hive_conf.xml` 进行配置。默认配置为空，即直接使用 Hive 的默认配置。如想覆盖改配置，请添加下面的参数至 `kylin_hive_conf.xml` 中，或替换掉对应部分。此处以 **SNAPPY** 压缩算法为例：

```xml
<property>
    <name>mapreduce.map.output.compress.codec</name>
    <value>org.apache.hadoop.io.compress.SnappyCodec</value>
    <description></description>
</property>
<property>
    <name>mapreduce.output.fileoutputformat.compress.codec</name>
    <value>org.apache.hadoop.io.compress.SnappyCodec</value>
    <description></description>
</property>
```

### MR 任务输出压缩

该项压缩通过 `kylin_job_conf.xml` 和 `kylin_job_conf_inmem.xml` 进行配置。默认配置为空，即直接使用MR的默认配置。如想覆盖改配置，请添加下面的参数至 `kylin_job_conf.xml` 和 `kylin_job_conf_inmem.xml` 中，或替换掉对应部分。仍以 **SNAPPY** 压缩算法为例：

```xml
<property>
    <name>mapreduce.map.output.compress.codec</name>
    <value>org.apache.hadoop.io.compress.SnappyCodec</value>
    <description></description>
</property>
<property>
    <name>mapreduce.output.fileoutputformat.compress.codec</name>
    <value>org.apache.hadoop.io.compress.SnappyCodec</value>
    <description></description>
</property>
```

