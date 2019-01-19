## Compression Configuration

By default, Kyligence Enterprise does not enable compression, in order to maximize the out-of-box compatibility. However a suitable compression algorithm could reduce storage and save network I/O at the cost of a little CPU cycles. This can benefit many production deployments. There are three kinds of compression settings in Kyligence Enterprise: Cube data compression, Hive output compression and MR job output compression.

**Notice: all configurations below requires a restart to take effect. **

###Cube Data Compression

The compression setting is defined in `kylin.properties` by `kap.storage.columnar.page-compression`. The default value is "", which means no compression. Change it to "**SNAPPY**" to enable cube data compression.

```properties
kap.storage.columnar.page-compression=SNAPPY
```

Also please make sure snappy algorithm is supported on your Hadoop cluster.

> Notice: The default value of this configuration is SNAPPY before Kyligence Enterprise 3.1.0. 
>
> Please consider your cluster to choose whether enabling this compression.

### Hive Output Compression

The compression settings are defined in `kylin_hive_conf.xml`. The default setting is empty which means the Hive default configuration takes effect. If you want to override the settings, please add (or replace) the following properties into `kylin_hive_conf.xml`. Take the snappy compression for example: 

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

### MR Jobs Output Compression

The compression settings are defined in `kylin_job_conf.xml` and `kylin_job_conf_inmem.xml`. The default setting is empty which means the MR default configuration takes effect. If you want to override the settings, please add (or replace) the following properties into `kylin_job_conf.xml` and `kylin_job_conf_inmem.xml`. Take the snappy compression for example: 

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