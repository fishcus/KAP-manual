## 非等值连接查询（Beta）

在很多业务的数据分析场景中，非等值连接是比较常见的 SQL 用法。

在之前版本中，某些带有非等值连接的查询无法正常回答。而在 v3.4.5.2107 版本后，支持通过 Cube 直接回答部分非等值连接的查询。

###  使用方法

在 v3.4.5.2107 - v3.4.5.2113 版本中，该功能默认为开启状态，在 v3.4.5.2114 及后续版本中，该功能默认为关闭状态。
如果想要启用该功能，则需在 `$KYLIN_HOME/conf/kylin.properties` 中配置参数启用。

```properties
kylin.query.revert-non-equi-join-support=false
kylin.query.non-equi-join-enabled=true
```

目前在 Kyligence Enterprise 中支持了>, <等 非等值连接的查询。

这里我们将以产品自带的样例数据集为例说明具体用法。有关样例数据集的更多信息请参考[样例数据集](../appendix/sample_dataset.cn.md)。

以下面 SQL 为例：
```sql
SELECT CAL_DT, SUM(KYLIN_SALES.PRICE) AS SUM_EXPR, COUNT(1) AS CNT
 FROM KYLIN_SALES
 LEFT JOIN TEST_SITES
  ON KYLIN_SALES.LSTG_SITE_ID > TEST_SITES.SITE_ID
  AND KYLIN_SALES.SELLER_ID = 10000005
 GROUP BY KYLIN_SALES.CAL_DT
 ORDER BY KYLIN_SALES.CAL_DT ASC
```

```sql
SELECT KYLIN_SALES.SELLER_ID AS SELLER_ID, FACT.CAL_DT as CAL_DT
FROM KYLIN_SALES KYLIN_SALES
LEFT JOIN KYLIN_SALES FACT ON KYLIN_SALES.SELLER_ID < FACT.SELLER_ID
WHERE FACT.CAL_DT = '2013-12-02'
limit 10000
```

### 已知限制

1. 由于目前不支持非等值连接关系的建模，所以非等值连接查询可能会有一定的性能问题，因此请谨慎使用。
