## Query History

The *Query History* includes some of the SQL you have queried, including Slow and Pushdown. You can check the query content, latency, start time and type of each SQL and filter by the type of queries.

The default latency time is 90s, so the query will be classfied as *Slow* if it responded over 90s. This parameter can be changed by add `kylin.query.badquery-alerting-seconds` into file `$KYLIN_HOME/conf/kylin.properties`.

> Notice: Kyligence Enterprise stores  500 unique sql statements by default. It could be changed by setting the value of `kylin.query.badquery-history-number` in `$KYLIN_HOME/conf/kylin.properties`. If the number of sql statements in query history is more than the setting, the oldest sql statement will be replaced by the new one automatically.

![Query History](images/query_history/query_history.en.png)



On *Query History* page, you can choose SQL statements and click *Export*, which can export SQL statements  as txt file.

![Export query history](images/query_history/query_download.en.png)