## Kyligence Enterprise 2.1 Release Notes

### KyStorage: Columnar Storage Engine

KyStorage, is a HDFS based columnar storage engine developed by Kyligence with independent intellectual property. The main updates including:

* Support raw data query. KyStorage breaks the limitation of traditional OLAP engine on querying aggregation data only, provides fully support for the raw data query.

* Optimize the wide table support. It reduces the data modeling difficulty, thus would offer better service for data-exploratory analysis scenarios.

* Optimize coding algorithm for sparse columns and other such scenarios.  

### KyAnalyzer: Agile Self-serve OLAP BI Tool

KyAnalyzer is a multi-dimension agile BI tool developed by Kyligence. The main updates including:

* Realize sync Kyligence Enterprise/Kylin data model by one click. The process of metadata synchronization is optimized and there is no need to redefine Data Source.
* Support Distinct Count query／TopN query
* Support report sharing and export

### KyBot Client Integration

KyBot is an online intelligent diagnosis and optimization service provided by Kyligence, which provides monitoring, cube optimizing, intelligent diagnosis and ticket service. 

KyBot client aims to simplify the operating and maintaining information collection by administrator to reduce operation cost. Kyligence Enterprise 2.1 integrated KyBot client.

### More Enterprise-Level Features

* Support cell level access control. Kyligence Enterprise 2.1 breaks the limitation that Apache Kylin can only support the project and cube level access control. It provides cell level access control capability, allows integrating with user existing AAA system, thus managing the access rights for rows, columns, and cells.
* Support Percentile and more advanced analysis functions



### Apache Kylin Core Upgrade

Kyligence Enterprise is based on core engine of the Apache Kylin, thus is totally compatible with the Apache Kylin. This release is based on the Apache Kylin 1.5.4.1. Please find the complete release announcement through the [Link](http://kylin.apache.org/docs15/release_notes.html). The highlight features including:

* Support SQL Window action

* Support SQL Grouping Sets action

* Optimize TopN measure; support more dimensions



### Hadoop Distribution Support

Certificated distributions:

* Cloudera CDH 5.7/5.8

Compatible distributions:

* HBase 0.98+, Hive 0.14+

* Hortonworks HDP 2.2/2.3/2.4

* Microsoft HDInsight

* Amazon EMR

* Huawei FusionInsight C50/C60

* AsiaInfo OCDP 2.4



### Download link

[http://kyligence.io/kyligence-analytics-platform/](http://kyligence.io/kyligence-analytics-platform/)

