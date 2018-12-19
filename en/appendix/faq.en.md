## FAQ

The following a list of frequently asked questions about Kyligence Enterprise.

### Design

**Q: What is the maximum number of dimensions that Kyligence Enterprise can support?**

A: It can be a lot. The multidimensional cube that Kyligence Enterprise supports has a "physical" limit of dimensions which is 62. However, user can go beyond the limit by using the dimension table and defining "Derived" dimensions. This can support hundreds of dimensions in this way. It is generally recommended that the physical dimensions of the cube (excluding the derived dimensions) be less than 15 assuming the dimensions are mostly independent. When there are more dimensions, it is important to analyze query patterns and relationships between columns, to take advantage of aggregation groups and fine tune the dimensions using **Mandatory**, **Hierarchy**, and **Joint** concepts. With these methods, the explosion of dimension combinations becomes controllable in building time and space cost.

**Q: How long does it take to build a cube? Sometimes it is slow, how to optimize?**

A: The time of cube build is usually from tens of minutes to hours. It depends on the amount of data, model complexity, dimension cardinality, and cluster computing power. Optimization is often case by case. Be free to contact our [customer support](https://support.kyligence.io/#/) for help.

**Q: How to deal with Out of Memory (OOM) problem that happens during cube build?**

A: It depends on the step where the OOM error occurs. If it is the "Build Dictionary" step, then perhaps an ultra-high cardinality dimension is using the dictionary encoding. You can change it to other encodings, like integer encoding, if that is the case. If the OOM happens during the "Build Cube" steps, you may need to give more memory to the MapReduce jobs (the config file is `conf/kylin_job_conf.xml`). If you are using the "InMem" cube build mode, try switch to the "Layered" mode which consumes less memory (set `kylin.cube.algorithm=layer` in `conf/kylin.properties`).

**Q: What is the difference between Derived dimension and Normal dimension?**

A: Unlike normal dimension, a derived dimension does not participate in the dimension combination calculation. Instead, the "Foreign Key" of derived dimension involves in the combination calculation, which reduces the total number of dimension combinations. When querying, the query of derived dimension will be converted to the FK dimension first, and as the result, it is often slower than a normal dimension.

**Q: Does the sequence of Hierarchy Dimension matters?**

A: Yes it matters. In side a hierarchy, the dimensions must be declared in the order from low cardinality to high cardinality.

**Q: How to model multiple fact tables?**

A: You can define one cube for each fact table, and use sub-query to query these tables together. Or use Hive view to join multiple fact tables into a wide table, then use this wide table to define models and cubes. Queries should be written based on the wide table.

**Q: Does the number of segments affect the query performance? Can a large segment split into smaller ones?**

A: The number of segments affects query performance to some extent, since a query will be completed by scanned every segment files. It is recommended to perform segment merge on a regular basis in order to control the total number of segments. For this reason, please properly plan the granularity of segment building.

**Q: What if the source table schema changes?**

A: Adding new fields is not a problem, however deleting or modifying fields may cause broken model and cube definition, and should be avoid at best effort. If the change in source table schema is unavoidable, it is recommended to create a Hive view to shield the changes from impacting models and cubes.

**Q: How to load data from traditional relational databases?**

A: Since Kyligence Enterprise v3.0, using RDBMS as data source is supported. For more details, please refer to [Import Data from RDBMS](../datasource/rdbms_datasource/README.md).

**Q: Does this product support snowflake model?**

A: Yes, it does.

**Q: Can a query involves columns across multiple Aggregation Groups?**

A: The purpose of Aggreation Group is to reduce dimension combinations. For best performance,  query should happen within one Aggregation Group. If multiple groups are queried together, post aggregation needs to be done on top of the base cuboid, which will impact the performance.

**Q: Is it better to create a large flat table in Hive rather than using a star model?**

A: There is no difference between the two in terms of build performance. However a star model supports derived dimension. It gives more flexibility when you want to balance the storage and query performance.

**Q: How compression settings helps cube build?**

A: When the data volume grows, the network I/O often becomes a system bottleneck. Turning on compression allows each I/O operation to process more data, and compression can improve the performance of network transfers. Although it takes some CPU time to compress and decompress, usually the compression time is less than the network time if data is not compressed. And as a result, enabling compression let the entire MR job complete faster.

To set the compression configuration, please refer to [compression settings](../installation/config/compression_config.en.md) section.

### Query Engine

**Q: What are query engines?**

A: Kyligence Enterprise supports three query engines: Cube Engine, Table Index Engine, and Pushdown Engine.

The cube engine is widely used for aggregated queries, like OLAP analysis scenarios.

The table index engine is a columnar storage engine designed for detail queries. In such scenario, user can drill through the aggregated data to the lowest level of raw records.

The pushdown engine is an external SQL on Hadoop engine, including Hive, SparkSQL, Impala, and others. When a query is not suitable for the previous two engines, the query is pushed down to the external engine for execution. In this case, the query latency is often extended to minutes.

**Q: How do multiple query engines work together?**

A: There are two types of queries: aggregate queries and detailed queries. Queries with "group by" are aggregate queries; other queries are detailed queries.

For aggregate queries, Kyligence Enterprise follows the order: Cube Engine > Table Index Engine > Pushdown Engine.

For detailed queries, Kyligence Enterprise follows the order: Table Index Engine > Cube Engine > Pushdown Engine.

Each engine has its own query capabilities (by dimension, metric, column definition), and if the query does not match the current engine, the query is routed to the next engine.

**Q: How to turn on/off the query engine**

A: Each query engine can be enabled and disabled independently. If table index is not configured during the cube design phase, the table index engine is disabled for related queries. The pushdown engine needs manual configuration to enable. For cube engine, it can also be disabled to answer detailed queries by setting `kylin.query.disable-cube-noagg-sql=true`.

### Query

**Q: Does this product support MDX queries?**

A: Yes, MDX is supported by the Kyligence MDX Service component.

**Q: How to view the execution plan of a query?**

A: You can add `explain plan for` in front of a query to get its execution plan. For example, `explain plan for select count(*) from airline`. However, the visualization of the execution plan is not optimized at the moment.

**Q: Does this product support fuzzy query?**

A: Using `like` as a filter is supported and it is recommended to use **fuzzy** index for those columns. For more details, please refer to [Table Index](../model/cube_design/table_index.en.md). 

**Q: What SQL standard and SQL functions are supported?**

A: This product supports SQL 92 standard, using Apache Calcite as SQL parser. For SQL reference, please refer to https://calcite.apache.org/docs/reference.html

**Q: The query result returns the column name as upper case. How to return lower case column name?**

A: Use a statement like `select column_A as "test" from table` to escape the column-sensitive pseudo-name with double quotes to return a case-sensitive column name.

**Q: Do you support Distinct Count?**

A: Yes, we do. The product provides two methods of distinct count: fuzzy count distinct based on HyperLogLog algorithm and accurate count distinct based on Bitmap. The resource and performance features of the two methods are different. Please choose one of them according your resource and performance needs.

**Q: Given a model that contains inner join, why sometimes the query result is less than what Hive returns?**

A: This is by design. The product will first read the raw data from the data source and generate a large flat table according to the definition of the model. When the product extracts data from Hive, it will join all the tables according to the way defined in the Model to retrieve data. If there is Inner Join, some data that cannot be matched will be directly filtered during the pull process. If the query matches the model, with all the tables, the query results are fine. If the query only matches a partial table, it is possible that the query result will be less than when only partial tables are queried in Hive.

In real practice, if the source data quality cannot be guaranteed, it is recommended to use Left Join; if you want to use Inner Join, please ensure that the dimension table and the fact table are updated synchronously.

**Q: Do you suggest using a BI system with this product?**

A: Yes. The core capability of the product is a powerful backend that provides sub-second query latency. At the same time, it also has a good integration with external BI platforms, and provides a rich API for custom development. We recommend using this product with other BI systems.

Also recommend the Kyligence Insight for Superset, which is a powerful BI solution that seamlessly integrates with Kyligence Enterprise.

### Comparison

**Q: What is the difference between this product and Spark / Impala?**

A: From the experience of the industry, several technologies are currently available for query analysis on the Hadoop platform include pre-computation (this product), memory computing (represented by Spark), inverted index (represented by ElasticSearche), and columnar storage (represented by Impala).

Technically, the pre-computation technology aggregates the data in advance by dimensional combinations, and saves the result as a materialized view. After aggregation, the size of the materialized view will only be determined by the cardinality of the dimension, and will no longer grow linearly as the amount of data grows. Taking e-commerce as an example, if the business expands, the transaction volume increases by 10 times, but as long as the dimensions of the transaction data are unchanged (the number of suppliers/commodities is constant), the aggregated materialized view will still be the original size. The speed of the query will also remain the same, that is, the computation time complexity will remain O(1) regardless of the data volume.

The techniques of memory calculation, inverted index, columnar storage, etc., are all online calculations at query execution time. Their performance is acceptable for small to medium data sizes, like million to tens of million rows. However, as the amount of data grows rapidly, the hardware resources do not scale as easily, and the query speed will drop linearly with the increase of the data volume. The computation time complexity for these technologies is O(N). 

From the perspective of big data, various data such as web logs, system logs, and the internet of things are rapidly and continuously generated. For big data query analysis, the amount of data it faces will be growing explosively. Therefore, pre-calculation is the only technology that ease the pressure of data growth and keep the computation time complexity at O(1). It is the most ideal and suitable technology looking forward.

**Q: What is the difference between this product and Druid?**

A: Druid was originally designed for real-time analysis. This product is more focused on solving OLAP problems. Initially Druid can support real-time streaming Kafka. Now Kyligence Enterprise also supports reading messages directly from Kafka. It has the ability to build cubes in real time and provides near real-time. Druid uses bitmap index as internal data structure, this product also uses bitmap to index for cube; Druid uses its own defined query language, this product supports ANSI SQL; Druid has restrictions on supporting table joins; The product supports star and snowflake models; Druid is not friendly enough with BI tools, this product support most BI tools, such as Tableau, Excel. Because this product supports MOLAP cube, it can answer complex query on very large dataset with high performance. Druid needs to scan all indexes for every query, and when the data is massive and query range is large, Druid performance suffers. This product depends on Hadoop cluster to run, while Druid deploys its own computing and storage cluster. For users who have a running Hadoop cluster, the deployment of this product is simply unpack and run, however Druid needs to deploy a full new cluster to run.

