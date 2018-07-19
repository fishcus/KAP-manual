## 	Kyligence Enterprise 2.3 发行说明

### Kyligence Enterprise 2.3新功能

下面将介绍Kyligence Enterprise 2.3新引进的特征和功能更新

#### 智能的辅助建模

1. 在模型构建时，Kyligence Enterprise将根据数据源表结构特征智能地为用户推荐不同的维度和度量设置，极大地简化了建模的操作，提升系统易用性。
2. 提升源数据采样的效率，支持超大规模表的轻量级采样与统计，为建模过程提供数据特征采样支持。

#### 全面优化存储引擎KyStorage

1. 内置配置调优工具，自动根据集群环境规模，推荐最优配置，从而充分利用集群并行化资源，提升查询效率。
2. 默认启用snappy存储压缩，更加节省存储空间。
3. 下压过滤算子，提升过滤类查询效率20%以上。
4. 支持动态分配查询节点（即Spark节点）计算资源，允许根据查询请求负载程度自适应分配集群资源。

#### 改进的Kafka Topic导入流程

提升Kafka为核心数据源，支持一键式Topic导入，支持流数据采样，方便用户集成流数据解决方案。

#### 支持超大结果集异步导出

允许用户提交异步查询请求，检查查询进度，支持导出千万级别以上查询结果集，Kyligence Enterprise可以用于数据预处理系统。


#### 其它更新还包括

- 简化诊断包生成和上传流程，支持一键上传KyBot诊断包。
- 简化Kylin到Kyligence Enterprise迁移过程，支持一键式升级。
- 升级Cube膨胀率计算方法，新方法更合理，数据用户可验证。
- 支持集成用户环境的Spark集群，简化了集群的管理。
- 支持多种云端Hadoop文件系统作为Kylin工作目录。

#### Hadoop发行版支持

  产品认证：

  	Cloudera CDH 5.7/5.8/5.9

  兼容性测试：

  	HBase 0.98+，Hive 0.14+

  	Hortonworks HDP 2.2/2.3/2.4/2.5

  	Microsoft HDInsight

  	Amazon EMR

  	华为 FusionInsight C50/C60

  	亚信 OCDP 2.4

  

### 下载地址

[http://kyligence.io/kyligence-analytics-platform/](http://kyligence.io/kyligence-analytics-platform/)


