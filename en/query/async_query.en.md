## Asynchronous Queries

Async query supports users to execute queries asynchronously and download the result. In some scenarios, e.g. the result set of a query is extremely large (million-scale) or the execution time of a SQL query is too long, async queries could help you export result set in the background.

Currently, through REST API is the only way to execute async queries, and please read [Async Query API](../rest/async_query_api.en.md) for the detailed information about how to use async query.