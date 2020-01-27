### Query Pushdown

Kyligence Enterprise supports query pushdown from KE 2.4. If there are queries which cannot be fulfilled through customized cubes, you may simply leverage the query pushdown to redirect the query to Spark SQL, Hive or Impala, making a trade-off  between query latency and query flexibility to obtain a better experience. 


#### Enable Query Pushdown

The precondition for query pushdown is that there exists at least one table which has been loaded.

Query pushdown is turned off by default. To turn it on, please refer to [Pushdown Configurations](../installation/pushdown/README.md) for more information.

After you turn on the query pushdown, all source tables you have synchronized will be shown without building the corresponding cubes. When you submit a query, you will find *Pushdown* in the *Query Engine* item below *Status*, if query pushdown works. 

![pushdown](./images/pushdown/pushdown.en.png)

