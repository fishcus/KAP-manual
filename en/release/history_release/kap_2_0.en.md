## Kyligence Enterprise 2.0 Release Notes

### KyStorage: Columnar Storage Engine

KyStorage is a columnar storage engine based on HDFS and developed by Kyligence with independent intellectual property. The main updates including:

* Compared with Apache Kylin, Kyligence Enterprise improves query performance from 3 to 40 times and reduces over 50%  storage space.

* It supports multiplexed indexes, specially optimizes for ultra-high cardinality dimensions and complex filtering conditions.

### KyAnalyzer: Agile Self-serve OLAP BI Tool

KyAnalyzer is a self-serve agile BI tool developed by Kyligence. The main updates including:

* Sync Cube's definition from Kyligence Enterprise/Apache Kylin

* Online metadata editor 

* Kylin-mondrian component designed for Kyligence Enterprise/Apache Kylin

* Integrate authentication with Kyligence Enterprise/Apache Kylin

* Support MDX syntax

### More Enterprise Level Features

* Build-in Out of box user management; allow quick configuration of user accounts and access

* Internationalize support. It supports both Chinese and English version as well as extensible language packages. 

* Support Job Server high availability. It supports Job Server high availability built on Zookeeper and is automatically restored. 



### Apache Kylin Core Upgrade

Kyligence Enterprise is based on core engine of Apache Kylin, thus is totally compatible with the Apache Kylin. This release is based on the Apache Kylin 1.5.3. Please find the complete release announcement through the [link](http://kylin.apache.org/docs15/release_notes.html). The highlight features including:

- Realize accurate distinct count function

- Support global dictionary encoding

- Support Cube level configuration overriding
- Simplify JDBC dependency
- Retrieve task status by standard API Hadoop



### Hadoop Distribution Certification Support

Certificated distributions: 

* Cloudera CDH 5.7

Compatible distributions: 

* HBase 0.98+, Hive 0.14+

* Hortonworks HDP 2.2/2.3/2.4

* Microsoft HDInsight

* Amazon EMR



### Download link

http://kyligence.io/kyligence-analytics-platform/