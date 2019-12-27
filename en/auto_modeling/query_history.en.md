## Query History

The *Query History* includes some of the SQL statements you have queried, including Slow and Pushdown. You can check the query content, latency, start time and type of each SQL statement and filter by the type of the queries.

The default threshold for a slow query is 90 seconds, so the query will be classified as *Slow* if its response time is over 90s. This parameter can be changed by adding `kylin.query.badquery-alerting-seconds` into file `$KYLIN_HOME/conf/kylin.properties`.

> Notice: Kyligence Enterprise stores 500 unique SQL statements by default. It could be changed by setting the value of `kylin.query.badquery-history-number` in `$KYLIN_HOME/conf/kylin.properties`. If the number of SQL statements in the query history is more than the setting value, the oldest SQL statement will be replaced by the new one automatically.

![Query History](images/query_history/query_history.en.png)

The default threshold for a timeout query is 300 seconds, so the query will be killed by system if its response time is over 300s. .This parameter can be changed by adding `kylin.query.timeout-seconds` into file `$KYLIN_HOME/conf/kylin.properties`.

The system will check the slow query and timeout query at intervals. The default check interval is 36s. The calculation method is : min( `kylin.query.badquery-alerting-seconds `, `kylin.query.timeout-seconds` ) \* `kylin.query.timeout-seconds-coefficient`

`kylin.query.timeout-seconds-coefficient` default is 0.4. You can add this configuration into file` $ KYLIN_HOME / conf / kylin.properties` to adjust it.

> Note: Queries that exceed the specified timeout period will not be killed by the system immediately, but will be killed when the system performs the next check.
>
> eg: The system sets a query with a query delay of ≥60s as a slow query，a timeout query with a query delay of ≥100s will be killed by the system, and the slow query and timeout query check will be performed every 30s.
>
> Currently, a slow query has been executed for 80s. It is expected that after 30s, that is, the next check, the query has been executed for 110s and will be killed by the system. But if just before the next check, the system performed a full gc of 60s, the system will be suspended during full gc, the check will resume after the full gc is over, so the next check, the query has been executed for 170s and will be killed by system.



On *Query History* page, you can choose SQL statements and click *Export*, which can export SQL statements as txt file.

![Export query history](images/query_history/query_download.en.png)
