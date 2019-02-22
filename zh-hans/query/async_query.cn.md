## 异步查询

异步查询支持用户异步地执行 SQL 查询，并提供更高效的数据导出方式。比如如果一条 SQL 查询的结果集过大（百万条结果）或 SQL 执行时间过长，通过异步查询，可以高效地把查询结果集导出，实现自助取数等各种应用场景。

目前异步查询仅支持调用 REST API 方式，关于如何使用异步查询 API，请阅读 [异步查询 API](../rest/async_query_api.cn.md)。

异步查询支持在 `kylin.properties` 进行以下配置：
- `kylin.query.async.cache-expire-days`：异步查询结果缓存在 HDFS 中的失效时间，默认为 10 天，即超过 10 天的数据结果文件将被清理。
- `kylin.query.async.cache-maximum-size`：异步查询结果缓存支持的最大查询条数，默认 1000 条，即当执行 1001 条异步查询时，第 1 条的查询结果将被清理。
> **注意：** 当 Kyligence Enterprise 重启后，以上配置将被重置。
