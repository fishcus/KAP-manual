## Kyligence Enterprise 3.4 发布声明

近期我们发布了 Kyligence Enterprise v3.4。在该版本中，Kyligence Enterprise 支持了构建节点多活的机制，允许多个构建节点同时工作，既提升了构建性能，又能保证构建节点的高可用；完善了 Kafka 数据源项目的相关功能，并支持了批流融合场景的数据分析；在数据安全方面，新增的守护进程可以确保 Kyligence Enterprise 的业务不中断；此外，Kyligence Enterprise v3.4 还支持了更多的查询函数。


### 任务引擎多活
允许多个构建节点同时具备执行构建任务的能力，当某个构建节点出现故障时，集群中的其他构建节点仍可保证构建任务的正常执行，实现了构建任务的高并发和高可用。


### 查询增强
#### 新增查询函数
* 交集函数：用户可以使用交集函数计算两个数据集的交集的值。
* 条件函数：IF(condition, value_if_true, value_if_false)、nvl(value1, value2)
* 类型转换函数：CAST(value AS type)，使用CAST函数可以将 value 强制转换成 type 的类型
* Bitmap函数：用户可以使用 Bitmap 函数，从多个模型中分别计算出去重后的 bitmap 结果，再对子查询的 bitmap 做交集操作。
* 差集函数：用户可以使用交集函数计算两个数据集的差集的值。

#### 为查询指定 Cube 优先级
当一条查询可被多个Cube回答时，用户可以指定希望击中的 Cube 替代系统的自动选择。


### 流式项目功能增强
* 完善流式建模。优化了加载表的逻辑，增加了重载表的功能。这使得用户可以像处理 Hive 数据源项目一样灵活地处理 Kafka 数据源项目。
* 批流融合场景。在流式项目中允许同时存在以 Hive 表为事实表的模型和以 Kafka 表为事实表的模型，这使得用户可以查询到历史和实时融合的数据，丰富了用户的查询场景。
* 流式项目迁移。新增流式项目的元数据导入导出功能，用户可以在不同KE版本中迁移流式项目。
* 构建性能提升。为流式构建提供复用维表快照和物化视图功能，极大缩短了构建时间。


### 模型增强
* 提供更丰富的建模支持。允许一张维表在模型中被多次关联，为增量模型提供了更多时间分区列的格式支持。
* 支持将数据源中的备注字段对接到 Tableau 中的能力。支持同步 Hive 备注到 Cube 的维度和度量描述，并导出到 TDS 文件中。
* 支持 Last Child 半累加度量。半累加度量可以用于处理证券、账户余额、人力资源等业务领域。比如在银行在使用账户交易记录数据来统计储蓄账户余额时，对于非时间维度，使用正常的求和，而对于时间维度，则需要取最后一条记录的值。


### 安全控制

#### 守护进程
守护进程会实时检测 Kyligence Enterprise 进程的健康状态，以降低服务能力或重启的方式保证 Kyligence Enterprise 进程的高可用性。 

#### Hive权限映射
Kyligence Enterprise 在 Hortonworks HDP 和华为 FusionInsight 平台上支持 Hive 数据源的权限映射，当用户如项目管理员、建模人员加载 Hive 数据源中的表时，其仅能看到其在 Hive 中拥有权限的表。


### Hadoop 发行版本支持
下述企业级数据管理平台及其相应 Hadoop 版本已经了过我们的兼容性测试，如果您的 Hadoop 版本不在其中，请联系 Kyligence 技术支持获取解决方案：

* Cloudera CDH 5.8/5.14/6.0/6.1/6.2.1/6.3.1
* Hortonworks HDP 2.4
* 华为 FusionInsight C70 / 6.5.1
* AWS EMR 5.23
* MapR 6.1.0


> 以下 Hadoop 版本曾经测试可用，但已不再维护测试：
>
> - MapR 6.0
>
> 对于 Hortonworks HDP 3.1 版本已支持下压至原生 Spark SQL。


### **产品下载**

Kyligence Enterprise 已经开放下载试用，更多产品信息请见 [Kyligence Enterprise产品页面](http://kyligence.io/zh/)。