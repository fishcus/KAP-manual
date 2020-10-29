## 使用 Left Join 模型回答等价语义的 Inner Join 查询

Kyligence Enterprise 在默认情况下，查询 SQL 中表的关联关系必需与 Cube 模型中定义事实表和维表的关联关系一致，即 `Left Join` 的 Cube 模型不能回答 `Inner Join` 的查询。

但在某些情况下，部分 `Left Join` 查询在语义上可以等价转化为 `Inner Join` 查询，因此我们提供了配置参数，可以允许用户使用 `Left Join` 的 Cube/模型回答等价语义的 `Inner Join` 查询。

配置参数开始生效版本为 Kyligence Enterprise 3.4.5.2114，默认关闭，支持项目级以及查询级别重写。



### 场景一
`[Table A] Left Join [Table B] Inner Join [Table C]` 语义等价于 `[Table A] Inner Join [Table B] Inner Join [Table C]`。

原因是，当 `Left Join` 之后再做 `Inner Join` ，与最后一个右表不匹配的行都会被筛除，所以上述两个表达式在语义上是等价的。

使用 `kylin.query.match-join-enhanced-mode-enabled=true` 配置，Kyligence Enterprise 可以支持 `Left Join` 的 Cube/模型回答上述等价语义的 `Inner Join` 查询。

#### 举例 1
模型定义为 `KYLIN_SALES Left Join KYLIN_ACCOUNT Inner Join KYLIN_COUNTRY`

有 SQL 如下：

```sql
select kylin_country.name
from kylin_sales inner join kylin_account on kylin_sales.buyer_id = kylin_account.account_id
inner join kylin_country on kylin_account.account_country = kylin_country.country
```

上述 Cube/模型 可以回答此 SQL。

#### 举例 2
模型定义为 `[Table A] Left Join [Table B]  Left Join [Table C] Inner Join [Table D] Left Join [Table E]`

有 SQL 如下：
`[Table A] Inner Join [Table B] Inner Join [Table C] Inner Join [Table D] Left Join [Table E]`

上述 Cube/模型 可以回答此 SQL。



### 场景二

有 SQL 具有如下特征： `[Table A] Left Join [Table B]` 且过滤条件中 `[Table B]`的任意列具有非空约束，则该 SQL 语义等价于 `[Table A] Inner Join [Table B]`。

使用 `kylin.query.match-join-with-filter-enabled=true` 配置，Kyligence Enterprise 可以支持 `Left Join` 的 Cube/模型回答上述等价语义的 `Inner Join` 查询。

其中列具有非空约束需要同时满足条件：

1. 不存在 `isNull` 类过滤条件，`isNull` 的定义为 SQL 中的 `is null` 关键字。
2. 存在 `isNotNull` 类过滤条件，`isNotNull` 对应常见比较运算符：`=`, `<>`, `>`, `<`, `<=`, `>=`, `like`, `in`, `not like`, `not in`等。

同时，目前暂不支持 or 连接的过滤条件的等价转换，or 两边的过滤条件会被自动忽略，见已知限制1。

#### 举例 1
模型定义为：`TEST_ACCOUNT left join TEST_ORDER left join TEST_ACCOUNT`

有 SQL 如下，可以击中上述模型，因为存在非空约束的过滤条件。

```sql
select SUM(a.ITEM_COUNT) as SUM_ITEM_COUNT 
from TEST_KYLIN_FACT a 
left join TEST_ORDER b on a.ORDER_ID = b.ORDER_ID 
inner join TEST_ACCOUNT c on b.BUYER_ID = c.ACCOUNT_ID 
where c.ACCOUNT_COUNTRY = 'CN' and (c.ACCOUNT_COUNTRY like '%US' or c.ACCOUNT_COUNTRY is null)
```

但有 SQL 如下，无法命中上述模型，原因是 or 两边的过滤条件会被自动忽略，非空约束不成立。

```sql
select SUM(a.ITEM_COUNT) as SUM_ITEM_COUNT 
from TEST_KYLIN_FACT a 
left join TEST_ORDER b on a.ORDER_ID = b.ORDER_ID 
inner join TEST_ACCOUNT c on b.BUYER_ID = c.ACCOUNT_ID 
where c.ACCOUNT_COUNTRY = 'CN' or c.ACCOUNT_COUNTRY like '%US'
```

```sql
select SUM(a.ITEM_COUNT) as SUM_ITEM_COUNT
from TEST_KYLIN_FACT a
left join TEST_ORDER b on a.ORDER_ID = b.ORDER_ID
inner join TEST_ACCOUNT c on b.BUYER_ID = c.ACCOUNT_ID
where c.ACCOUNT_COUNTRY is null or (c.ACCOUNT_COUNTRY like '%US' and c.ACCOUNT_COUNTRY = 'CN')
```

#### 举例 2
模型定义为： `[Table A] inner join [Table B]`

有 SQL 如下，可以击中此模型：

```sql
A left join B where B.nonfk = '123' and B.col1 in ('ab', 'ac')
A left join B where A.col is null and B.col1 like ('xxx')
A left join B where B.col between 100 and 100000
A left join B where A.fk is null and B.col1 = 'something'
A left join B where b.col = 'something' and (b.col = 'xxx' or b.col is null)
A left join B where abs(b.col) = 123
A left join B where floor(b.col) = 123
```

如下SQL无法击中此的模型：

```sql
A left join B where B.col1 = 'xx' or B.col2 is null
A left join B where B.col1 = 'xx' and B.col2 is null
```



### 场景三

现在有模型`[Table A] Left Join [Table B] left join [Table C]`。

如下SQL如下，可以击中此模型：
```sql
A inner join B inner join C where C.col = 'abc'
```

原因是表 C 中的列存在非空约束，因此查询可以等价为：

```sql
A LEFT_OR_INNER join B LEFT_OR_INNER join C where C.col = 'abc'
```

场景三是场景一和场景二的混合，需要上述两个参数同时开启。



### 已知限制

1. 对于场景二，目前暂不支持 or 连接的过滤条件的等价转换，or 两边的过滤条件会被自动忽略。
2. 对于场景二，在非空约束的判断中，暂不支持 `NOT SIMILAR TO`, `IS TRUE`，`IS FALSE`，`IS NOT TRUE`, `IS NOT FALSE`，`NOT BETWEEN AND`, `IS DISTINCT FROM`, `IS NOT DISTINCT FROM` 表达式。

