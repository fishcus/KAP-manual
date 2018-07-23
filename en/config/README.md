## Kyligence Enterprise configuration
This chapter introduces some configurations about Kyligence Enterprise.

After deploying Kyligence Enterprise on your cluster, you need to configure Kyligence Enterprise so that it could interact with Apache Hadoop, Apache HBase and Apache Hive on your cluster. It's also possible for the performance of Kyligence Enterprise to be optimized via configuring according to conditions of your own environment. 

### Kyligence Enterprise Configuration File List

|Component|File|Description|
|---|---|---|
|Kylingence Enterprise|kylin.properties|This is the global configuration file, with all configuration properties about Kyligence Enterprise in it. Details will be discussed in the subsequent chapter. |
|Kylingence Enterprise|kylin\_hive\_conf.xml|Apache Hive related configurations, which are used for generating intermediate table in the first step of cube building, locate in this file. |
|Kylingence Enterprise|kylin\_job\_conf\_inmem.xml|Map Reduce configurations, which are used for Fast Cubing, locate in this file.|
|Kylingence Enterprise|kylin\_job\_conf.xml|Map Reduce configurations, which are used for lack of kylin\_job\_conf\_inmem.xml, or for Laying Cubing, locate in this file. |
|Hadoop|core-site.xml|Global configuration file used by Hadoop, which defines system-level parameters such as HDFS URLs and Hadoop temporary directories, etc.|
|Hadoop|hdfs-site.xml|HDFS configuration file, which defines HDFS parameters such as the storage location of NameNode and DataNode and the number of file copies, etc.|
|Hadoop|yarn-site.xml|Yarn configuration file,which defines Hadoop cluster resource management system parameters, such as ResourceManader, NodeManager communication port and web monitoring port, etc.|
|Hadoop|mapred-site.xml|Map Reduce configuration file used in Hadoop,which defines the default number of reduce tasks, the default upper and lower limits of the memory that the task can use, etc.|
|Hbase|hbase-site.xml|Hbase configuration file, which defines Hbase parameters such as master machine name and port number, root data storage location, etc.|
|Hive|hive-site.xml|Hive configuration file, which defines Hive parameters such as hive data storage directory and database address, etc.|

>Notice:
>+ Unless otherwise specified, the configuration file such as `kylin.properties` mentioned in this manual refer to the corresponding configuration file in the list.
>+ You can get the path of each listed configuration file from the `$KYLIN_HOME/logs/kylin.log` file when the system is started. The log format is `/kylin/conf/kylin.properties is used as kylin.properties`.

Continue reading:

[Basic Configuration](basic_settings.en.md)

[Recommended Configuration](recommend_settings.en.md)

[Configuration Override](config_override.en.md)

[KyStorage Configuration](kystorage_settings.en.md)

[JDBC Metastore Configuration](metadata_jdbc.en.md)

[Spark Dynamic Allocation](spark_dynamic_allocation.en.md)

[Use SparkSQL during Cube Build](use_sparksql_during_cube_build.en.md)

[Configure Spark Build Engine](spark_engine_conf.en.md)

[Compression Settings](compression_settings.en.md)

[Query Pushdown Configuration](pushdown/README.md)
