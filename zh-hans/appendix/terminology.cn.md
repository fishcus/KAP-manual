## 词汇表

本节介绍了在Kyligence Enterprise中使用的基础概念。

### Cube

- __Table__ - 源数据表，在创建 Cube 之前，Kyligence Enterprise 需要从数据源（通常为Hive）同步表的元数据，包含表名、列名、列属性等。
- __Data Model__ - 数据模型，定义了由若干张表的一个连接关系。Kyligence Enterprise 支持[星型模型](https://en.wikipedia.org/wiki/Star_schema)和[雪花模型](https://en.wikipedia.org/wiki/Snowflake_schema)的多维分析；在创建 Cube 之前，用户需定义这么一个数据模型。
- __Cube__ - 数据立方体，是一种多维分析的技术，通过预计算，将计算结果存储在某多个维度值所映射的空间中；在运行时通过对 Cube 的再处理而快速获取结果。
- __Partition__ - 分区，用户可以定义一个分区日期或时间列，随后对 Cube 的构建按此列的值范围而进行，从而将Cube 分成多个 Segment。
- __Cube Segment__ - 每个 Cube Segment 是对特定时间范围的数据计算而成的预计算数据结果。
- __Aggregation Group__ - 聚合组，每个聚合组是全部维度的一个子集；通过将很多个维度分组，并把常一起使用的维度放在一起，可以有效降低 Cube 的组合数。

### 维度 & 度量

- __Mandatory__ - 必需的维度：这种类型用于对 Cube 生成树做剪枝：如果一个维度被标记为 “Mandatory”，会认为所有的查询都会包含此维度，故所有不含此维度的组合，在 Cube 构建时都会被剪枝（不计算）.
- __Hierarchy__ - 层级维度：如果多个维度之间有层级（或包含）的关系，通过设置为 ”Hierarchy”，那些不满足层级的组合会被剪枝。如果 A， B， C 是层级，并且 A>B>C，那么只需要计算组合 A，AB，ABC；其它组合如 B， C， BC， AC 将不做预计算。 
- __Derived__ - 衍生维度：维度表的列值，可以从它的主键值衍生而来，那么通过将这些列定义为衍生维度，可以仅将主键加入到 Cube 的预计算来，而在运行时通过使用维度表的快照，衍生出非主键列的值，从而起到降维的效果。
- __Count Distinct(HyperLogLog)__ - 基于 HyperLogLog 的 COUNT DISTINCT：快速、精确的 COUNT DISTINCT 是较难计算的，一个近似的轻量级算法 - [HyperLogLog](https://en.wikipedia.org/wiki/HyperLogLog) 为此而发明，能够在大规模数据集上做去重并保持较低的误差率。
- __Count Distinct(Bitmap)__ - 基于 Bitmap 的 COUNT DISTINCT，可以精确去重，但是存储开销较大。目前只支持 int 的数据类型。
- __Top N__ - 通过预计算得出的某些记录顶部数据的度量，如交易量最大的1000个卖家。

### Cube 操作

- __BUILD__ - 构建：给定一个时间范围，根据 Cube 定义将源数据通过运算生成一个新的 Segment。
- __REFRESH__ - 刷新：对某个已经构建过的 Segment，重新从数据源抽取数据并构建，从而获得更新。
- __MERGE__ - 合并：将多个 Segment 合并为一个 Segment。这个操作可以减少Segment的数量，同时减少Cube的存储空间。
- __PURGE__ - 清空：将 Cube 的所有 Segment 删除。

### 任务状态

- __PENDING__ - 等待被调度执行的任务.
- __RUNNING__ - 正在运行的任务。
- __FINISHED__ - 正常完成的任务（终态）。
- __ERROR__ - 执行出错的任务。
- __DISCARDED__ - 被终止的任务（终态）。

### 任务操作

- __RESUME__ - 恢复：处于错误状态的任务，用户在排查或解决问题后，通过此操作来重试执行。
- __DISCARD__ - 终止：立即停止该任务并且无法再恢复。