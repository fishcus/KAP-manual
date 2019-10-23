## Sum Expression (Beta)

在很多业务的数据分析场景中，sum(expression) 是比较常见的 SQL 用法。

在之前版本中，需要通过创建表索引或可计算列的方式满足该类查询。而在 v3.3.2 版本后，支持通过 Cube 直接回答部分 sum(expression) 的查询。

###  使用方法

该功能默认为关闭状态，需在 `$KYLIN_HOME/conf/kylin.properties` 中配置参数开启。
```properties
kap.query.enable-convert-sum-expression=true
```

目前在 Kyligence Enterprise 中支持了以下三种 sum(expression) 函数：

- sum(case when)
- sum(column * constant)
- sum(constant)

这里我们将以产品自带的样例数据集为例说明具体用法。有关样例数据集的更多信息请参考[样例数据集](../../../appendix/sample_dataset.cn.md)。



**sum(case when) 函数**

以下面 SQL 为例：

```sql
select
  sum(case when LSTG_FORMAT_NAME='ABIN' then PRICE else null end)
from KYLIN_SALES
```

要执行它，启用 sum(expression) 功能后，还需如下设置 Cube：

- 将 `when` 子句中出现的所有列定义为维度，如此例中的 `LSTG_FORMAT_NAME` 维度
- 将 `then` 子句中出现的所有列定义为 Sum 度量，如此例中的 `sum(PRICE)` 度量

然后，Cube 即可执行上述 SQL。



**sum(column*constant) 函数**

以下面 SQL 为例：

```sql
select sum(PRICE * 3) from KYLIN_SALES
```

要执行它，启用 sum(expression) 功能后，还需如下设置 Cube：

- 将 Sum 函数中的列定义为 Sum 度量，如此例中的 `sum(PRICE)` 度量

然后，Cube 即可执行上述 SQL。



**sum(constant) 函数**

以下面 SQL 为例：

```sql
select sum(3) from KYLIN_SALES
```

要执行它，只需启用 sum(expression) 功能即可，无需在 Cube 上做其他设置。



### 已知限制

1. 由于对于 null 值的处理较为复杂，因此在当前版本中暂时不支持解析 `sum(column+column)` 或 `sum(column+constant)` 等类型的函数。如您需要需要使用这些函数，您可以通过创建可计算列或表索引满足上述需求。
2. 在当前版本中暂时不支持 `count(distinct)` 与 `sum(case when)` 同时使用。
2. 在当前版本中暂时不支持 `count(distinct)` 与 `sum(case when)` 同时使用。
3. 在当前版本中，对于嵌套子查询暂不支持 `sum(column*constant)` 或 `sum(column/constant)`
以下面 SQL 为例, 暂时不被 sum(expression) 支持

```sql
select sum(t.a1 * 2) 
from (select sum(PRICE) as a1, sum(ITEM_COUNT) as a2 from KYLIN_SALES group by PART_DT) t
```

可以改写 SQL 为

```sql
select sum(t.a1) * 2 
from (
select sum(PRICE) as a1, sum(ITEM_COUNT) as a2 from KYLIN_SALES group by PART_DT
) t
```

或
```sql
select sum(PRICE * 2) as a1, sum(ITEM_COUNT) as a2 from KYLIN_SALES group by PART_DT
```