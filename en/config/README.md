## KAP configuration
This chapter introduces some configurations about KAP.

After deploying KAP on your cluster, you need to configure KAP so that it could interact with Apache Hadoop, Apache HBase and Apache Hive on your cluster. It's also possible for the performance of KAP to be optimized via configuring according to conditions of your own environment. 

All configuration files locate in `$KYLIN_HOME/conf/`. You can modify properties in those configuration files to achieve the adaptation to your environment as well as the optimization of the performance. Default files in `$KYLIN_HOME/conf/` include: 

### kylin.properties

This is the global configuration file, with all configuration properties about KAP in it. Details will be discussed in the subsequent chapter. 

### kylin\_hive\_conf.xml

Apache Hive related configurations, which are used for generating intermediate table in the first step of cube building, locate in this file. 

### kylin\_job\_conf\_inmem.xml

Map Reduce configurations, which are used for Fast Cubing, locate in this file. 

### kylin\_job\_conf.xml

Map Reduce configurations, which are used for lack of kylin\_job\_conf\_inmem.xml, or for Laying Cubing, locate in this file. 

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
