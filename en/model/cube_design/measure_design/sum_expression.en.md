## Sum Expression (Beta)

Sum(expression) is a common usage in SQL and is often needed by various data analysis scenarios.

In the previous versions, table index or computed column is required for sum(expression) to work. Since v3.3.2, Kyligence Enterprise can answer some kind of sum(expression) using cube.

### How to Use

This feature is off by default. To enable it, please set the configuration in `$KYLIN_HOME/conf/kylin.properties`.

```properties
kap.query.enable-convert-sum-expression=true
```

Currently, three kinds of sum (expression) usages are supported, namely

- sum(case when)
- sum(column*constant)
- sum(constant)

We will use the sample dataset to introduce how to use. For more details, please refer to [Sample Dataset](../../../appendix/sample_dataset.en.md).



**sum(case when) function**

For example, the SQL below is not supported by default:

```sql
select
  sum(case when LSTG_FORMAT_NAME='ABIN' then price else null end)
from KYLIN_SALES
```

With sum(expression) enabled, and `LSTG_FORMAT_NAME` dimension and `sum(price)` measure defined in cube, you will be able to run the above SQL in cube.



**sum(column*constant) function**

For example, the SQL below is not supported by default:

```sql
select sum(price*3) from KYLIN_SALES
```

With sum(expression) enabled, and `sum(price)` measure defined in cube, you will be able to run the above SQL in cube.



**sum(constant) function**

For example, the SQL below is not supported by default:

```sql
select sum(3) from KYLIN_SALES
```

With sum(expression) enabled, you will be able to run the above SQL in cube.




### Known Limitation

1. Due to the complexity of `null` value, `sum(column+column)` and `sum(column+constant)` are not supported yet. If you need use the above syntax, please use computed column or table index.
2. In the current version, `count(distinct)` is not supported to use together with ` sum(case when)`.

