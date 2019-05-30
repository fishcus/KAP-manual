## SUM Expression (Beta)

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

这里我们将以产品自带的样例数据集为例进行说明，有关样例数据集的详细信息请参考[样例数据集](../../../appendix/sample_dataset.cn.md)。



**sum(case when) 函数**

例如，默认状态下，如下 SQL 语句缺省无法执行。

```sql
select
  sum(case when LSTG_FORMAT_NAME='ABIN' then price else null end)
from KYLIN_SALES
```

启用 sum(expression) 功能后，并在 Cube 设置了 `LSTG_FORMAT_NAME` 维度和 `sum(price)` 度量后，您将可以用 Cube 执行上述语句。




**sum(column*constant) 函数**

例如，默认状态下，如下 SQL 语句缺省无法执行。

```sql
select sum(price*3) from KYLIN_SALES
```

启用 sum(expression) 功能后，并在 Cube 中设置了 `sum(price)` 度量后，您将可以用 Cube 执行上述语句。



**sum(constant) 函数**

例如，默认状态下，如下 SQL 语句缺省无法执行。

```sql
select sum(3) from KYLIN_SALES
```

启用 sum(expression) 功能后，您将可以用 Cube 执行上述语句。



### 已知限制

1. 由于对于 null 值的处理较为复杂，因此在当前版本中暂时不支持解析 `sum(column+column)` 或 `sum(column+constant)` 等类型的函数。如您需要需要使用这些函数，您可以通过创建可计算列或表索引满足上述需求。
2. 在当前版本中暂时不支持 `count(distinct)` 与 `sum(case when)` 同时使用。