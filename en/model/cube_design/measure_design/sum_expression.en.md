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

We will use the sample dataset to introduce the usage. Read more about the [Sample Dataset](../../../appendix/sample_dataset.en.md).



**sum(case when) function**

For example:

```sql
select
  sum(case when LSTG_FORMAT_NAME='ABIN' then PRICE else null end)
from KYLIN_SALES
```

In order to run this SQL, set your cube as below in addition to enable sum(expression):

- Define all columns in the `when` clause as dimensions, like the `LSTG_FORMAT_NAME` in this example.
- Define all columns in the `then` clause as Sum measure, like the `sum(PRICE)` in this example.

Then, the cube will be able to run the above SQL.



**sum(column*constant) function**

For example:

```sql
select sum(PRICE * 3) from KYLIN_SALES
```

In order to run this SQL, set your cube as below in addition to enable sum(expression):

- Define the column in the `sum` function as Sum measure, like the `sum(PRICE)` in this example.

Then, the cube will be able to run the above SQL.



**sum(constant) function**

For example:

```sql
select sum(3) from KYLIN_SALES
```

In order to run this SQL, just enable the sum(expression) feature. No other setting on cube is needed.




### Known Limitation

1. Due to the complexity of `null` value, `sum(column+column)` and `sum(column+constant)` are not supported yet. If you need use the above syntax, please use computed column or table index.
2. In the current version, `count(distinct)` is not supported to use together with ` sum(case when)`.
3. In the current version, `sum(column*constant)` or `sum(column/constant)` are not supported for the nested subquery

For example, the SQL shows bellow is not supported by Sum(expression)

```sql
select sum(t.a1 * 2) 
from (select sum(PRICE) as a1, sum(ITEM_COUNT) as a2 from KYLIN_SALES group by PART_DT) t
```

The SQL could be changed as below

```sql
select sum(t.a1) * 2 
from (
select sum(PRICE) as a1, sum(ITEM_COUNT) as a2 from KYLIN_SALES group by PART_DT
) t
```

or

```sql
select sum(PRICE * 2) as a1, sum(ITEM_COUNT) as a2 from KYLIN_SALES group by PART_DT
