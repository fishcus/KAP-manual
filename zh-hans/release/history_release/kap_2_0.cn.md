## Kyligence Enterprise 2.0 发行说明

下面的段落将介绍Kyligence Enterprise 2.0 新引进的功能

### Kyligence Enterprise 2.0 新功能特性

**KyStorage 列式存储引擎**

KyStorage 是 Kyligence 基于 HDFS 全新研发的拥有自主知识产权的列式存储引擎。主要新功能如下：

* 将存储引擎从 HBase 透明替换为 KyStorage，相对 **Apache Kylin** 查询性能有几倍到几十倍的提升，存储空间节省超过50%

* 支持多路复合索引，针对超高基数维度、复杂过滤条件等的场景进行了专门优化

**KyAnalyzer 敏捷BI工具**

KyAnalyzer 是 Kyligence 研发的敏捷BI自助多维分析工具。主要新功能如下：

* 支持导入 Kyligence Enterprise 中的 Cube 定义
* 提供元数据编辑器，允许在线编辑所导入的 Cube 定义
* 发布 Kyligence Enterprise 兼容的 kylin-mondrian 插件
* 集成了 Kyligence Enterprise 访问认证系统
* 支持 MDX 语法

**更多企业级功能更新**

* 开箱即用的用户管理。内置用户友好的管理界面，快速配置用户账号和权限，实现开箱即用
* 支持多国语言。支持中英两种语言，支持可扩展语言包
* 任务引擎高可用。支持基于 ZooKeeper 的任务引擎高可用，自动恢复



### Apache Kylin Core 升级

Kyligence Enterprise 基于 Apache Kylin 内核引擎，与 Apache Kylin 完全兼容，本次发布基于1.5.3版本，完整发布公告参见[链接](http://kylin.apache.org/docs15/release_notes.html)。

主要新功能如下：

* 支持精确去重度量
* 支持全局字典编码
* 支持 Cube 级别配置重写
* 精简 JDBC 依赖
* 通过标准 Hadoop API 获取任务状态



### Hadoop发行版支持

产品认证：

* Cloudera CDH 5.7

兼容性测试：

* HBase 0.98+，Hive 0.14+
* Hortonworks HDP 2.2/2.3/2.4
* Microsoft HDInsight
* Amazon EMR



### 下载地址

http://kyligence.io/kyligence-analytics-platform/
