## KAP FAQ

**How Query Router works**

KAP supports three query engines: *Cube* Engine, *Table Index* Engine, and *Pushdown* Engine.

*Cube* Engine is the most widely used and designed for the aggregated query. It works for OLAP scenario.

*Table Index* Engine is the columnar storage engine and designed for detail query. In some case, a user wants to drill down the aggregated query to the lowest level detail data.

*Pushdown* Engine is another SQL-on-Hadoop engine, such as Hive, SparkSQL and Impala. It works when the pre-calculated engine does not fit the query. Then the query will be pushed down into the downstream query engine. The response latency may be minutes or more. 

So how these engines work together? What's the route priority? How does the Query Router work? 

Two kinds of queries: the aggregated query and the detail query. The aggregated query has `group by` clause, and the detail query has no such clause. 

For an aggregated query, KAP will check the engine by order: *Cube* > *Table Index* > *Pushdown*.

For a detail query, KAP will check the engine by order: *Table Index* > *Cube* > *Pushdown*.

Each engine could be turned on or off independently. For example, in many cases, *Table Index* is not configured and will be ignored during routing. And in some cases, the *Pushdown* engine is not enabled by default. The *Cube* engine could turn off the detail query capability by setting `kylin.query.disable-cube-noagg-sql` to true. 

Each engine has its own capability definition (dimensions, measures, and columns). If the capability could not meet the query condition, the query will be routed to the next engine. 

**How compression settings positively impact KAP during building Cube? **

With the increasing number of data volume, dealing with those data may suffer more restricts of network I/O. Enabling compression settings could help dealing with more data for each I/O operation, which could also improve the performance of network transmission. Although CPU may spend some time to compress and uncompress data, it still less than the time of I/O and network I/O when compression is disabled. Therefore,  the MR job could finish faster.

> For more details of compression settings, please refer to [compression settings](http://docs.kyligence.io/books/v2.5/en/config/compression_settings.en.html).