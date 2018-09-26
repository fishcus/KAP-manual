## 查询样例
当 Cube 构建任务完成，系统一般会自动把 Cube 的状态切换为就绪（Ready）。我们以 Kyligence Enterprise 样例数据为例介绍 SQL 查询方式。首先切换到 **分析**页面，在 Web UI 上选择本案例所用的 *Kylin_Sample_1* 项目。然后根据数据模型的设计，在查询输入框中输入 SQL 语句，然后单击**提交**按钮。下面给出以下 SQL 查询的例子和相应的结果介绍。

### 单表行数统计
```sql
SELECT COUNT(*) FROM KYLIN_SALES
```

这条 SQL 用于查询 KYLIN_SALES 表中总行数，读者可以同时在 Hive 中执行同样的查询进行性能对比。在笔者的对比中，Hive 查询耗时 29.385 秒，Kyligence Enterprise 查询耗时 0.18 秒。

### 多表连接
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

这条 SQL 将事实表 KYLIN_SALES 和两张维度表根据外键进行了内部连接。在笔者的对比试验中，Hive 查询耗时 34.361 秒，Kyligence Enterprise 查询耗时 0.33 秒。

### 维度列 COUNT_DISTINCT

```sql
SELECT
COUNT(DISTINCT KYLIN_SALES.PART_DT)
FROM KYLIN_SALES as KYLIN_SALES
INNER JOIN KYLIN_CAL_DT as KYLIN_CAL_DT
ON KYLIN_SALES.PART_DT = KYLIN_CAL_DT.CAL_DT
INNER JOIN KYLIN_CATEGORY_GROUPINGS as KYLIN_CATEGORY_GROUPINGS
ON KYLIN_SALES.LEAF_CATEG_ID = KYLIN_CATEGORY_GROUPINGS.LEAF_CATEG_ID AND KYLIN_SALES.LSTG_SITE_ID = KYLIN_CATEGORY_GROUPINGS.SITE_ID
```

这条 SQL 对 PART_DT 字段进行了 COUNT_DISTINCT 查询，但是该字段并没有被添加为 COUNT_DISTINCT 的度量。Kyligence Enterprise 会在运行时计算结果。在笔者的对比试验中，Hive 查询耗时 44.911 秒，Kyligence Enterprise 查询耗时 0.12 秒。

### 全表查询
```sql
SELECT * FROM KYLIN_SALES
```

默认的，Kyligence Enterprise 并不对原始数据的明细进行保存，因此并不支持类似的不带 GROUP BY 的查询。但是，用户经常希望通过执行 `SELECT *` 获取部分样例数据；因此 Kyligence Enterprise 对这种 SQL 会返回不精确的查询结果（通过隐式地 GROUP BY 所有维度）。如果用户希望 Kyligence Enterprise 支持原始数据的保存和查询，可以在 Cube 中定义 RAW 类型的度量。

### 展示查询计划

Kyligence Enterprise 可以在查询的前面添加 `explain plan for` 以获得执行计划，例如:

```sql
explain plan for select count(*) from KYLIN_SALES
```

但是执行计划的结果的展示并没有被优化，可以通过前端的导出结果功能查看。
