## Use the Left Join model to answer Inner Join queries with equivalent semantics

By default in Kyligence Enterprise, the relationship between tables in the query SQL must be consistent with the relationship between the fact tables and dimension tables defined in the Cube/model, that is, the Cube/model of `Left Join` cannot answer the query of `Inner Join`.

But in some cases,  part of `Left Join` queries can be semantically equivalently transformed into `Inner Join` queries, so we provide configuration parameters that allow users to use `Left Join`  Cube/model to answer equivalent semantics `Inner Join` query.

The configuration parameters starts to take effect from version of Kyligence Enterprise 3.4.5.2114, which is closed by default. And they supports project-level and query-level rewriting.



### Scene one
`[Table A] Left Join [Table B] Inner Join [Table C]` is semantically equivalent to `[Table A] Inner Join [Table B] Inner Join [Table C]`.

The reason is that when `Inner Join` is performed after `Left Join`, the rows that do not match the last right table will be filtered out, so the above two expressions are semantically equivalent.

Using the `kylin.query.match-join-enhanced-mode-enabled=true` configuration, Kyligence Enterprise can support `Left Join` Cubes/models to answer the above equivalent semantic `Inner Join` queries.

#### Example 1
The model is defined as `KYLIN_SALES Left Join KYLIN_ACCOUNT Inner Join KYLIN_COUNTRY`

The SQL is as follows:

```sql
select kylin_country.name
from kylin_sales inner join kylin_account on kylin_sales.buyer_id = kylin_account.account_id
inner join kylin_country on kylin_account.account_country = kylin_country.country
```

The above Cube/model can answer this SQL.

#### Example 2
The model is defined as `[Table A] Left Join [Table B] Left Join [Table C] Inner Join [Table D] Left Join [Table E]`

The SQL is as follows:
`[Table A] Inner Join [Table B] Inner Join [Table C] Inner Join [Table D] Left Join [Table E]`

The above Cube/model can answer this SQL.



### Scene Two

SQL has the following characteristics: `[Table A] Left Join [Table B]` and any column of `[Table B]` in the filter condition has a non-null constraint, then the SQL semantics is equivalent to `[Table A] Inner Join [Table B]`.

Using `kylin.query.match-join-with-filter-enabled=true` configuration, Kyligence Enterprise can support `Left Join` Cube/model to answer the above equivalent semantic `Inner Join` query.

The columns with non-null constraints need to meet the conditions at the same time:

1. There is no `isNull` type filter condition, and the definition of `isNull` is the `is null` keyword in SQL.
2. There are `isNotNull` filter conditions, `isNotNull` corresponds to common comparison operators: `=`, `<>`, `>`, `<`, `<=`, `>=`, `like`, `In`, `not like`, `not in` etc.

At the same time, the filter conditions connected with `or` is currently not supported, and the filter conditions on both sides of `or` will be automatically ignored. See the known limitation 1.

#### Example 1
The model is defined as: `TEST_ACCOUNT left join TEST_ORDER left join TEST_ACCOUNT`

There are SQL as follows, which can hit the above model because there is a non-null constraint filter condition.

```sql
select SUM(a.ITEM_COUNT) as SUM_ITEM_COUNT
from TEST_KYLIN_FACT a
left join TEST_ORDER b on a.ORDER_ID = b.ORDER_ID
inner join TEST_ACCOUNT c on b.BUYER_ID = c.ACCOUNT_ID
where c.ACCOUNT_COUNTRY ='CN' and (c.ACCOUNT_COUNTRY like'%US' or c.ACCOUNT_COUNTRY is null)
```

However, there are SQL as follows, which cannot hit the above model because the filter conditions on both sides of `or` will be automatically ignored, and the non-null constraint is not established.

```sql
select SUM(a.ITEM_COUNT) as SUM_ITEM_COUNT
from TEST_KYLIN_FACT a
left join TEST_ORDER b on a.ORDER_ID = b.ORDER_ID
inner join TEST_ACCOUNT c on b.BUYER_ID = c.ACCOUNT_ID
where c.ACCOUNT_COUNTRY ='CN' or c.ACCOUNT_COUNTRY like'%US'
```

```sql
select SUM(a.ITEM_COUNT) as SUM_ITEM_COUNT
from TEST_KYLIN_FACT a
left join TEST_ORDER b on a.ORDER_ID = b.ORDER_ID
inner join TEST_ACCOUNT c on b.BUYER_ID = c.ACCOUNT_ID
where c.ACCOUNT_COUNTRY is null or (c.ACCOUNT_COUNTRY like'%US' and c.ACCOUNT_COUNTRY ='CN')
```

#### Example 2
The model is defined as: `[Table A] inner join [Table B]`

There are SQL as follows that can hit this model:

```sql
A left join B where B.nonfk = '123' and B.col1 in ('ab','ac')
A left join B where A.col is null and B.col1 like ('xxx')
A left join B where B.col between 100 and 100000
A left join B where A.fk is null and B.col1 ='something'
A left join B where b.col ='something' and (b.col ='xxx' or b.col is null)
A left join B where abs(b.col) = 123
A left join B where floor(b.col) = 123
```

The following SQL cannot hit this model:

```sql
A left join B where B.col1 ='xx' or B.col2 is null
A left join B where B.col1 ='xx' and B.col2 is null
```



### Scene Three

Now there is the model `[Table A] Left Join [Table B] left join [Table C]`.

The following SQL is as follows, you can hit this model:
```sql
A inner join B inner join C where C.col ='abc'
```

The reason is that the columns in table C have non-null constraints, so the query can be equivalent to:

```sql
A LEFT_OR_INNER join B LEFT_OR_INNER join C where C.col ='abc'
```

Scene three is a mixture of scene one and scene two, and the above two parameters need to be enabled at the same time.



### Known limitations

1. For Scene two, the equivalent conversion of filter conditions connected with `or`  is currently not supported, and the filter conditions on both sides of `or` will be automatically ignored.
2. For  Scene two, judgment of non-null constraints don't include `NOT SIMILAR TO`, `IS TRUE`, `IS FALSE`, `IS NOT TRUE`, `IS NOT FALSE`, `NOT BETWEEN AND` , `IS DISTINCT FROM`, `IS NOT DISTINCT FROM` expressions.
