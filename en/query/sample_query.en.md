## Query Samples

When build completes, the status of cube will become "Ready", meaning it is ready to serve query. In this section we use Kyligence Enterprise sample data to introduce how to query simple SQL statements in Kyligence Enterprise.

> Note: In production, it is more common to connect Kyligence Enterprise via a programming interface, like Rest API or ODBC/JDBC. However Kyligence Enterprise also provides a query UI to facilitate simple SQL ability mostly for demo and testing.

To run a query, first select the `learn_kylin` project, and then go to the **Insight** page. Find a big input box where you can enter SQL according to the relational data model. Click **Submit** button to run a query. Below is a few query examples and their result.  



### Row Count of a Single Table

```sql
SELECT COUNT(*) FROM KYLIN_SALES
```

This query returns the total row count of KYLIN_SALES table. User can run the same query in Hive to compare correctness and speed. For reference, in the writer's test, Hive query took 29.385 seconds, while Kyligence Enterprise returned in 0.18 second. 



### Joint of Multiple Tables

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



### COUNT_DISTINCT on Dimension Column

```sql
SELECT
COUNT(DISTINCT KYLIN_SALES.PART_DT)
FROM KYLIN_SALES as KYLIN_SALES
INNER JOIN KYLIN_CAL_DT as KYLIN_CAL_DT
ON KYLIN_SALES.PART_DT = KYLIN_CAL_DT.CAL_DT
INNER JOIN KYLIN_CATEGORY_GROUPINGS as KYLIN_CATEGORY_GROUPINGS
ON KYLIN_SALES.LEAF_CATEG_ID = KYLIN_CATEGORY_GROUPINGS.LEAF_CATEG_ID AND KYLIN_SALES.LSTG_SITE_ID = KYLIN_CATEGORY_GROUPINGS.SITE_ID
```

This query applies count_distinct function on the PART_DT column, which is a undefined measure. In this case, Kyligence Enterprise will do calculation on-the-fly and still quickly returns. In writer's test, Hive query took 44.911 seconds and Kyligence Enterprise returned in 0.12 second.



### Table Index Scan

```sql
SELECT * FROM KYLIN_SALES
```

By default, Kyligence Enterprise does not memorize raw records, thus cannot answer queries that does not have a `GROUP BY` clause. However, user often like to "`SELECT *`" to peek a few sample records. In such cases, Kyligence Enterprise will return result at the best effort, by grouping all dimensions implicitly. Such result is not accurate but gives a signal to user that the cube is loaded with good data. If you want Kyligence Enterprise to store and return raw records, please define table index(raw table) in cube definition.



### Display Execution Plans

Kyligence Enterprise supports using `explain plan for` to displays execution plans. For example,

```sql
explain plan for select count(*) from KYLIN_SALES
```

However, the results of the execution plans have not been optimized. You could use the export function to view the results.
