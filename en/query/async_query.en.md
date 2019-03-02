## Asynchronous Queries

Async query supports users to execute queries asynchronously and download the result. In some scenarios, e.g. the result set of a query is extremely large (million-scale) or the execution time of a SQL query is too long, async queries could help you export result set in the background.



Currently, through REST API is the only way to execute async queries, and please read [Async Query API](../rest/async_query_api.en.md) for the detailed information about how to use async query.



You can configure the following setting for async query in `kylin.properties`:

1. `kylin.query.async.cache-expire-days`: the validity period of the asynchronous query result file stored in HDFS. The default value is 10, which means result file older than 10 days will be deleted.

2. `kylin.query.async.cache-maximum-size`: the maximum number of asynchronous queries of which result files are stored in HDFS. The default value is 1000. If it exceeds the limit, Kyligence Enterprise will clean the oldest non-used query result.

> **Caution:** the cache will be reset after restarting Kyligence Enterprise.


