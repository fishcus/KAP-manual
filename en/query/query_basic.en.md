# Basic Query Execution

Kyligence Enterprise is a kind of precalculation system. The cube building is a data loading process, and is also a precalculation process. After the building job is completed, the status of cube will become **READY**  and the cube is ready to answer queries.



### Query Execution Process with Precalculation

Different from normal query engines, Kyligence Enterprise use precalculated results to replace real time calculation, in order to improve the query performance and concurrency. A simplified version of query execution process can be described as below:

1. Parse SQL statement and extract all the `FROM` clauses. 

2. Find the **matching** and **minimum cost** cube for each `FROM` clause.

   The **matching** here means:

   * The relationship of tables used in `FROM` clause must match the fact and dimension tables defined in cube and model. Please note that the relationship of `LEFT JOIN` does not match `INNER JOIN`.
   * For aggregate queries, the columns in `GROUP BY` clause must be defined as dimensions in cube. Meanwhile, the aggregate functions in `SELECT` clause must be defined as measures in cube. 
   * For non-aggregate queries, table index must be defined in cube and all columns appear in query must be contained in the table index.

   The **minimum cost** here means that Kyligence Enterprise will automatically select the minimum cost cube if there are multiple matching cubes. For example, table index can also serve aggregate queries, but its cost is high because of the real time calculation. Therefore, using table index to answer aggregate query is always the last option and only happens when all cubes cannot match.

3. If all the `FROM` clauses match successfully, Kyligence Enterprise will execute the query using cube data (including table index).

   All the `FROM` clauses will be replaced by precalculated results, and the query will execute from there to get the final result. If you execute queries via Web UI, you can find the name(s) of the answering cube(s) in the **Query Engine** field after a query returns successfully. For more details, please refer to [Execute SQL Statements in Web UI](insight.en.md).

4. If there is one or more `FROM` clause cannot find a matching cube, then Kyligence Enterprise cannot execute the query using cube data (including table index).

   The query will fail with an error message of `no model found` or `no realization found`. This means the data required for this query does not exist in the system.

   As a special case, if the pushdown engine is enabled, then Kyligence Enterprise will not report error, and instead route this query to the pushdown engine. For more details, please refer to [Query Pushdown](pushdown.en.md).

> **Note**: If you expect a query to hit a cube but it didn't, you can use the [Verify SQL](../model/cube_design/verify_sql.en.md) function to find the cause of mismatch and get suggestions on how to modify your query.



### Performance Examples of Precalculation Queries

We will use the `learn_kylin` project as an example to illustrate the high performance of precalculation query. Go to the **Insight** page and select `learn_kylin` project. Enter query in the input box and hit **Submit** button to run. Below is a few queries and their response time compared with Hive 1.x. Cache is disabled in both systems for all tests.



#### Row Count of a Single Table

```sql
SELECT COUNT(*) FROM KYLIN_SALES
```

This query returns the total row count of KYLIN_SALES table. User can run the same query in Hive to compare correctness and speed. For your reference, in the writer's test, Hive query took 29.385 seconds, while Kyligence Enterprise returned in 0.18 second.



#### Joint of Multiple Tables

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

This SQL joins KYLIN_SALES and two lookup tables, sums sales price group by date and category. In writer's test, Hive query took 34.361 seconds and Kyligence Enterprise returned in 0.33 second. 



#### COUNT_DISTINCT on Dimension Column

```sql
SELECT
  COUNT(DISTINCT KYLIN_SALES.PART_DT)
FROM KYLIN_SALES as KYLIN_SALES
  INNER JOIN KYLIN_CAL_DT as KYLIN_CAL_DT
  ON KYLIN_SALES.PART_DT = KYLIN_CAL_DT.CAL_DT
  INNER JOIN KYLIN_CATEGORY_GROUPINGS as KYLIN_CATEGORY_GROUPINGS
  ON KYLIN_SALES.LEAF_CATEG_ID = KYLIN_CATEGORY_GROUPINGS.LEAF_CATEG_ID AND KYLIN_SALES.LSTG_SITE_ID = KYLIN_CATEGORY_GROUPINGS.SITE_ID
```

This query applies count_distinct function on the PART_DT column, which is an undefined measure. In this case, Kyligence Enterprise will do some calculation on-the-fly and still quickly returns. In writer's test, Hive query took 44.911 seconds and Kyligence Enterprise returned in 0.12 second.



#### Table Index Scan

```sql
SELECT * FROM KYLIN_SALES
```

If table index is not enabled, which is the default behavior, Kyligence Enterprise does not memorize raw records, thus it cannot answer queries that do not have a `GROUP BY` clause. However, users often like to "`SELECT *`" to peek a few sample records. In such cases, Kyligence Enterprise will return the result at the best effort, by grouping all dimensions implicitly. Such result is not accurate but gives a signal to users that the cube is loaded with expected data. If you want Kyligence Enterprise to store and return raw records, please enable table index in cube definition.



#### Display Execution Plans

Kyligence Enterprise supports using `explain plan for` to displays execution plans. For example:

```sql
explain plan for select count(*) from KYLIN_SALES
```

Please note the returned plan is a big string squeezed in a small cell. It is best to export the result to a text file to have a good view.

