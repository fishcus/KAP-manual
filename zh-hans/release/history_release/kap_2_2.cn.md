## 	Kyligence Enterprise 2.2 发行说明

下面的段落将介绍Kyligence Enterprise 2.2新引进的功能

### Kyligence Enterprise 2.2 新功能及特性

**增强的源数据统计收集**

更全面采样源数据，支持Hive视图，收集基数、特征值、样本数据等元信息，有效辅助建模。

**增强的建模辅助**

支持批量创建维度和指标，支持实时展示 Cuboid 组合数和统计元信息，避免 Cuboid 组合爆炸问题。

**优化的 KyStorage**

改进明细数据查询性能和稳定性，升级编码机制，更加节省存储空间。

**其它更新还包括**

- 支持友好的 Cube 级别配置重写，提高可配置能力
- 支持构建任务的暂停和恢复，便于问题调试
- 提供多套出厂默认配置，针对测试和集群生产环境优化默认配置
- 简化 Cube 和项目级别的元数据备份



### Apache Kylin Core 升级到1.6，支持流式构建 Cube

Kyligence Enterprise 基于 Apache Kylin 内核引擎，与 Apache Kylin 完全兼容，本次发布基于1.6.0版本，完整发布公告参见[链接](https://kylin.apache.org/docs16/release_notes.html)。主要新功能如下：

* 支持可伸缩的流式 Cube 构建，支持 Kafka 数据源。
* TopN 性能增强
* 支持多 Segments 并行构建／合并／刷新



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


