## 查询基本原理

Kyligence Enterprise 是一种预计算系统。构建 Cube 的过程即是数据加载的过程，也是预计算的过程。当 Cube 构建任务完成，系统会自动把 Cube 的状态切换为就绪（Ready），就可以服务于查询了。



### 预计算查询执行过程

与普通查询的执行过程不同，Kyligence Enterprise 在执行 SQL 时会用预计算结果代替在线计算，极大地减少在线计算量，并提升查询性能。为了便于理解，执行过程简化后可以描述为：

1. 解析 SQL 语句，提取查询中所有的 `FROM` 子句。

2. 为每个 `FROM` 子句寻找**与之匹配**的且**代价最小**的 Cube。
   **与之匹配**需满足以下几点：
   
   -  `FROM` 子句中出现的表和它们间的关联必需与 Cube 模型中定义事实表和维表的关联一致。部分特殊情况下，可以通过配置允许 `LEFT JOIN` 模型回答部分等价语义的 `INNER JOIN` 查询，详见[使用 Left Join 模型回答等价语义的 Inner Join 查询](query_enhanced.cn.md)。
   - 对于聚合查询，`GROUP BY` 子句中的聚合列必需是 Cube 中定义的维度，同时 `SELECT` 子句中的聚合函数必需是 Cube 中定义的度量。
   - 对于非聚合查询（即不带聚合函数），Cube 中必需定义有表索引，否则匹配失败。同时查询中所有的列都必需包含在表索引中。
   
   **代价最小**指当有多个可能的匹配时，Kyligence Enterprise 会根据执行代价最低的原则，自动挑选一个最优的匹配。比如，表索引其实也可以匹配聚合查询，但由于需要作在线聚合运算，执行代价很高。因此，用表索引匹配聚合查询是最后的选择，只会发生在所有 Cube 都无法匹配的时候。
   
3. 若所有 `FROM` 子句均匹配成功，那么 Kyligence Enterprise 将使用 Cube（包括表索引）执行查询。
  
   查询中所有的 `FROM` 子句将被替换成预计算结果，然后执行并获得查询结果。如果您在 Web UI 执行查询，查询成功后，可以在屏幕下方的**查询引擎**条目中找到命中 Cube 的名字。详见[在用户界面执行 SQL 查询](insight.cn.md)。
   
4. 若有个别 `FROM` 子句无法找到匹配的 Cube，那么 Kyligence Enterprise 无法用 Cube（包括表索引）执行查询。

   查询将报错，出错信息为 `no model found` 或 `no realization found`。

   作为特例，如果查询下压被启用，那么 Kyligence Enterprise 将不会报错，而是转发这种无法匹配的查询到下压查询引擎执行。更多请见[查询下压的详细介绍](pushdown.cn.md)。

> **提示**：如果您期望一条 SQL 命中某个 Cube 但却无法匹配，可以使用[验证 SQL 功能](../model/cube_design/verify_sql.cn.md)定位无法匹配的详细原因，并获得修改建议。




### 预计算查询性能示例

我们以 Kyligence Enterprise 样例数据为例，展示预计算查询与普通查询的巨大性能差别。首先切换到**分析**页面，在 Web UI 上选择本案例所用的 `learn_kylin` 项目。然后根据数据模型的设计，在查询输入框中输入 SQL 语句，然后单击**提交**按钮。下面是一些样例查询以及在 Kyligence Enterprise 和 Hive 1.x 的性能比较，两系统所有查询缓存都被关闭。



#### 单表行数统计

```sql
SELECT COUNT(*) FROM KYLIN_SALES
```

这条 SQL 用于查询 KYLIN_SALES 表中总行数，读者可以同时在 Hive 中执行同样的查询进行性能对比。在测试环境中，Hive 查询耗时 29.385 秒，Kyligence Enterprise 查询耗时 0.18 秒。



#### 多表连接
```sql
SELECT
  KYLIN_SALES.PART_DT
  ,KYLIN_SALES.LEAF_CATEG_ID
  ,KYLIN_SALES.LSTG_SITE_ID
  ,KYLIN_CATEGORY_GROUPINGS.META_CATEG_NAME
  ,KYLIN_CATEGORY_GROUPINGS.CATEG_LVL2_NAME
  ,KYLIN_CATEGORY_GROUPINGS.CATEG_LVL3_NAME
  ,KYLIN_SALES.LSTG_FORMAT_NAME
  ,SUM(KYLIN_SALES.PRICE)
  ,COUNT(DISTINCT KYLIN_SALES.SELLER_ID)
FROM KYLIN_SALES as KYLIN_SALES
  INNER JOIN KYLIN_CAL_DT as KYLIN_CAL_DT
  ON KYLIN_SALES.PART_DT = KYLIN_CAL_DT.CAL_DT
  INNER JOIN KYLIN_CATEGORY_GROUPINGS as KYLIN_CATEGORY_GROUPINGS
  ON KYLIN_SALES.LEAF_CATEG_ID = KYLIN_CATEGORY_GROUPINGS.LEAF_CATEG_ID AND KYLIN_SALES.LSTG_SITE_ID = KYLIN_CATEGORY_GROUPINGS.SITE_ID
GROUP BY
  KYLIN_SALES.PART_DT
  ,KYLIN_SALES.LEAF_CATEG_ID
  ,KYLIN_SALES.LSTG_SITE_ID
  ,KYLIN_CATEGORY_GROUPINGS.META_CATEG_NAME
  ,KYLIN_CATEGORY_GROUPINGS.CATEG_LVL2_NAME
  ,KYLIN_CATEGORY_GROUPINGS.CATEG_LVL3_NAME
  ,KYLIN_SALES.LSTG_FORMAT_NAME
```

这条 SQL 将事实表 KYLIN_SALES 和两张维度表根据外键进行了内部连接。在测试环境中，Hive 查询耗时 34.361 秒，Kyligence Enterprise 查询耗时 0.33 秒。



#### 维度列 COUNT_DISTINCT

```sql
SELECT
  COUNT(DISTINCT KYLIN_SALES.PART_DT)
FROM KYLIN_SALES as KYLIN_SALES
  INNER JOIN KYLIN_CAL_DT as KYLIN_CAL_DT
  ON KYLIN_SALES.PART_DT = KYLIN_CAL_DT.CAL_DT
  INNER JOIN KYLIN_CATEGORY_GROUPINGS as KYLIN_CATEGORY_GROUPINGS
  ON KYLIN_SALES.LEAF_CATEG_ID = KYLIN_CATEGORY_GROUPINGS.LEAF_CATEG_ID AND KYLIN_SALES.LSTG_SITE_ID = KYLIN_CATEGORY_GROUPINGS.SITE_ID
```

这条 SQL 对 PART_DT 字段进行了 COUNT_DISTINCT 查询，但是该字段并没有被添加为 COUNT_DISTINCT 的度量。Kyligence Enterprise 会在运行时做一些在线计算。在测试环境中，Hive 查询耗时 44.911 秒，Kyligence Enterprise 查询耗时 0.12 秒。



#### 全表查询
```sql
SELECT * FROM KYLIN_SALES
```

假如没有启用表索引，Kyligence Enterprise 默认不对原始数据的明细进行保存，因此并不支持类似的不带 `GROUP BY` 的查询。但是，用户经常希望通过执行 `SELECT *` 获取部分样例数据；因此 Kyligence Enterprise 对这种 SQL 会返回不精确的查询结果（通过隐式地 GROUP BY 所有维度）。如果用户希望 Kyligence Enterprise 支持原始数据的保存和查询，可以在 Cube 中启用表索引。



#### 展示查询计划

Kyligence Enterprise 可以在查询的前面添加 `explain plan for` 以获得执行计划，例如:

```sql
explain plan for select count(*) from KYLIN_SALES
```

请留意返回的执行计划是一个多行的大字符串，前端展示只显示了第一行，可以通过导出结果功能查看完整的执行计划。
