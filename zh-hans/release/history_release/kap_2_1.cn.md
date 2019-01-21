## Kyligence Enterprise 2.1 发行说明

下面的段落将介绍Kyligence Enterprise 2.1新引进的功能

### Kyligence Enterprise 2.1 新功能及特性

**KyStorage 列式存储引擎**

KyStorage 是 Kyligence 基于HDFS全新研发的拥有自主知识产权的列式存储引擎。本次更新主要功能如下：

* 支持明细数据查询。KyStorage 突破了传统 OLAP 引擎仅能查询聚合数据的局限，全面地支持了明细数据的查询。
* 优化了对宽表的支持。降低了数据建模的难度，更好地服务数据探索式分析场景。
* 针对稀疏列等场景优化了编码算法。

**KyAnalyzer 敏捷BI工具**

KyAnalyzer 是 Kyligence 研发的敏捷BI自助多维分析工具。本次主要更新如下：

* 优化了元数据同步的流程，实现了数据模型一键同步，不再需要重新定义数据源。
* 支持 Distinct Count／TopN 的查询
* 支持报表分享和导出

**KyBot客户端整合**

KyBot 是 Kyligence 提供的在线智能诊断和优化服务，为 Apache Kylin 和 Kyligence Enterprise 系统提供监控、性能优化、智能诊断服务。

KyBot 客户端简化运维人员收集运行状态信息，降低运维成本。Kyligence Enterprise 2.1 集成了 KyBot 客户端。

**更多企业级功能更新**

* 支持单元格级别访问控制。突破传统 Kylin 只能支持项目和 Cube 级别的访问权限控制，提供单元格级别的访问控制能力，允许与用户已有账号、权限、组织结构系统深度集成，从而实现对行、列、单元格的访问权限管理。
* 支持 Percentile 等高级分析函数





### Apache Kylin Core 升级

Kyligence Enterprise 基于 Apache Kylin 内核引擎，与 Apache Kylin 完全兼容，本次发布基于1.5.4.1版本，完整发布公告参见[链接](http://kylin.apache.org/docs15/release_notes.html)。主要新功能如下：

* 支持 SQL Window 操作

* 支持 SQL Grouping Set s操作
* 优化 TopN 度量，支持更多维度



### Hadoop 发行版支持

产品认证：

* Cloudera CDH 5.7/5.8

兼容性测试：

* HBase 0.98+，Hive 0.14+

* Hortonworks HDP 2.2/2.3/2.4

* Microsoft HDInsight

* Amazon EMR

* 华为 FusionInsight C50/C60

* 亚信 OCDP 2.4

### 下载地址

[http://kyligence.io/kyligence-analytics-platform/](http://kyligence.io/kyligence-analytics-platform/)


