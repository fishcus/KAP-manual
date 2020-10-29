## Non-Equal Join Query(Beta)

Non-Equal Join is a common usage in SQL and is often needed by various data analysis scenarios.

In the previous versions, some queries with non-equal join could not be answered. Since v3.4.5.2107, Kyligence Enterprise can answer some kind of non-equal join query using cube.

### How to Use

Since 3.4.5.2107 to 3.4.5.2113, the feature is enabled by default. From 3.4.5.2114 and above version, this feature is changed to be disabled by defualt.
To enable it, please set the configuration in $KYLIN_HOME/conf/kylin.properties.

```properties
kylin.query.revert-non-equi-join-support=false
kylin.query.non-equi-join-enabled=true
```

Currently, Kyligence Enterprise  supports >, <, etc. non-equal join queries.


We will use the sample dataset to introduce the usage. Read more about the [Sample Dataset](../appendix/sample_dataset.en.md).

For example:
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

### Known Limitation

1. Since the modeling of non-equal join relations is currently not supported, non-equal join queries may have certain performance problems, so please use it with caution.
