# FAQ

# Kyligence Enterprise FAQ

The following is a collection of some of the problems that users often encounter while using Kyligence Enterprise.

### Design

**Q: What is the maximum size that Kyligence Enterprise can support?**

A: It depends; first, kylin's multidimensional cube has a "physical" dimension of up to 62, but users can derive a dimension by using the dimension table + defining the "Derived" dimension. More dimensions to reach cubes that support hundreds of dimension queries. It is generally recommended that the physical dimensions of the cube (excluding the derived dimensions) be less than 15. When there are more dimensions, it is important to analyze the user query patterns and data distribution characteristics, take the dimension grouping, define advanced methods such as mandatory, hierarchy, and joint to avoid dimensions. The combination of the two ("dimensional disaster"), so that the cube's build time and space occupied is controllable.

**Q: Can the dimension be dynamically increased or reduced ?**

A: When adding or subtracting dimensions, the cube needs to be recalculated; if you don't want to recalculate the history cube, you can define a new cube, then make a combination of the old and new cubes (Hybrid), and respond to the user query together.

**Q: How long does it take for this product to build a cube? Sometimes it is slow, how to optimize?**

A: Usually cube is built in tens of minutes to hours, depending on the amount of data, model complexity, dimension base, cluster computing power and configuration. Optimization requires specific analysis of specific issues.

**Q: When building a cube, often OOM, how to adjust? Can I turn off InMem mode?**

A: OOM needs to look at which step to take and take different measures; if it is in the "Build Dictionary", you need to review the cube definition to see if there is a dictionary encoding for the ultra-high cardinality dimension (you can use other encoding methods); If it happens during the "Build cube", you need to check the memory allocation settings of Yarn; to turn off the InMem mode, you can set kylin.cube.algorithm=layer in conf/kylin.properties.

**Q: When the dimension exceeds 10, the build process can't run. How to optimize?**

A: See the answer to the first question.

**Q: What do the Derived and Normal dimensions mean?**

A: Derived dimension is not involved in the combination calculation of dimensions. Compared with Normal, his FK participates in dimension combination calculation, which reduces the number of dimension combinations. When querying, the query of Dervied dimension will be converted to the FK dimension first. Query, so it will sacrifice a small amount of performance.

**Q: Does Hierarchy Dimension have a sequential relationship?**

A: It has a relationship, to be declared in order from big to small.

**Q: If there are multiple fact sheets, how do I use this product?**

A: You can define a cube for each fact table, and then use sub query to combine the queries of these tables. Or use Hive view to join multiple fact tables into a wide table, then use this wide table to define the model and cube, and the query is done in a wide table.

**Q: Does the number of segments affect the performance of the query? Can a large segment be split into small ones?**

A: The number of segments will affect the query performance, because this product needs to scan each segment sequentially, so it is usually recommended to perform segment merge on a regular basis; large segments do not need to be split into small (and can't be split); when stored in HBase Cut into multiple regions, so don't worry about query performance.

**Q: What should I do if the source data model changes?**

A: Specific analysis of specific problems; adding fields is no problem, deleting or modifying fields may cause metadata confusion. Therefore, it is recommended not to modify the original data model; if it is unavoidable, it is recommended to create a Hive view on the source model, and then define the cube based on the view; when the source model changes (such as column name changes), just update the view, the cube is not influences.

**Q: How does the relational database use this product?**

A: Use tools (such as sqoop) to import data from RDBMS to Hive first.

**Q: Does this product support the snowflake model?**

A: Yes, it does.

**Q: Define multiple Aggregation Groups. Can the query conditions cross the Aggregation Group?**

A: The purpose of the Aggreation Group is to reduce the dimension. The best query conditions are only in one Aggregation Group. If the Aggregation Group is crossed, Post Processing needs to be performed from the Base Cuboid, which will affect the performance of the query.

**Q: Is it better to create a large flat table with Hive than a star model?**

A: There is no difference in performance, but the dimension of the star model can use the derived dimension to make it more compact.

**Q: What does the Kyligence Enterprise compression configuration do for building a cube?**

A: When the amount of data that needs to be processed becomes larger and larger, the network I/O is becoming more and more restrictive. Turning on compression allows each I/O operation to process more data, and compression can improve the performance of network transfers. Although it takes some time for the CPU to compress and decompress the data, usually these times are much less than the time consumed by I/O and network I/O, allowing the entire MR task to complete faster.

> To set the compression configuration, please refer to the manual compression configuration chapter

### Query Engine

**Q: What is the query engine?**

A: Kyligence Enterprise supports three query engines: cube engine, Table Index engine, and Pushdown engine.

The cube engine is a widely used query engine designed for aggregated queries for OLAP analysis scenarios.

The table index engine is a columnar storage engine designed for detailed query scenarios. In the analysis scenario, the user can drill through the aggregated data to the lowest level of detail data.

The pushdown engine is another SQL on Hadoop engine, including Hive, SparkSQL, Impala, and others. When a query is not suitable for the precomputing engine, the query is pushed down to other downstream query engines. In this case, the query latency is usually extended to the minute level.

**Q: How do multiple query engines work together?**

A: There are two types of queries: aggregate queries and detailed queries, with "group by" for aggregate queries, and other queries for detailed queries.

For aggregate queries, Kyligence Enterprise follows the order: cube Engine > Table Index Engine > Down Engine

For detailed queries, Kyligence Enterprise follows the order: Table Index Engine > cube Engine > Down Engine

Each engine has its own query capabilities (by dimension, metric, column definition), and if the query does not match the current engine, the query is routed to the next engine.

**Q: How to turn on/off the query engine**

A: Each query engine can independently enable and disable query capabilities. If the table index is not configured during the cube design phase, the table indexing engine ignores all queries. In some scenarios, if the engine under the query is not launched through the configuration file, the query will also be ignored by the down engine. cube can also disable the processing of the detail query by the cube by setting the parameter kylin.query.disable-cube-noagg-sql to true.

### Query

**Q: Does this product support MDX?**

A: It can be supported by the Kyligence MDX Service component.

**Q: How do I check the execution plan of this product?**

A: You can add an explain plan for the execution plan in front of the query, such as explain plan for select count(*) from airline. However, the display of the results of the execution plan has not been optimized and can be viewed through the front-end export results feature.

**Q: Does this product support fuzzy query?**

A: Support like as a filter.

**Q: What are the supported SQL standards? What are the functions?**

A: This product supports SQL92 standard, using Apache Calcite as sql parser, so the sql standard of this product can refer to https://calcite.apache.org/docs/reference.html

**Q: This product will return the column name to uppercase. What should I do if I need a lowercase column name?**

A: Use a statement like select column_A as "test" from table to escape the column-sensitive pseudo-name with double quotes to return a case-sensitive column name.

**Q: Do you support Distinct Count?**

A: Yes, we do. This product provides two ways to count the number of indicators: fuzzy deduplication based on HyperLogLog algorithm and accurate deduplication based on Bitmap. The resources and performance required for the two methods are different, and users can choose to use them according to their needs.

**Q: Inner Join multiple tables in the model, but when querying the fact table, why sometimes the query results are less than Hive?**

A: This is in line with our design. The product will first read the raw data from the data source and generate a large flat table according to the definition of the model. When the product extracts data from Hive, it will join all the tables according to the way defined in the Model to retrieve data; if there is Inner Join, some data that cannot be matched will be directly filtered during the pull process. If the query matches the model, with all the tables, the query results are fine. If the query only matches a partial table, it is possible that the query result will be less than when only partial tables are queried in Hive.

In actual practice, if the source data quality cannot be guaranteed, it is recommended to use Left Join; if you want to use Inner Join, you must ensure that the dimension table and the fact table are updated synchronously.

**Q: Do you still need a BI system to use this product?**

A: The core of the product itself is a powerful backend that provides sub-second response to data analysis. At the same time, it also has a good integration with external BI platforms, and also provides a rich API for secondary development. Therefore, this product needs to be used together with other BI systems.

Recommend our Kyligence Insight for Superset, a powerful BI solution that seamlessly integrates with Kyligence Enterprise.

### Comparison

**Q: What is the difference between this product and Spark and Impala?**

A: From the experience of the industry, several technologies currently available for query analysis on the Hadoop platform include pre-computation (this product), memory computing (represented by Spark), inverted index (represented by ElasticSearche), and Columnar storage (represented by Impala).

From the technical principle, the pre-computation technology aggregates the data in advance by dimensional combination, and saves the result as a materialized view. After aggregation, the size of the materialized view will only be determined by the cardinality of the dimension, and will no longer grow linearly as the amount of data grows. Taking e-commerce as an example, if the business expands, the transaction volume increases by 10 times, but as long as the dimensions of the transaction data are unchanged (the number of suppliers/commodities is constant), the aggregated materialized view will still be the original size. The speed of the query will also remain the same, that is, the computation time complexity is relative to the data volume is O(1).

The techniques of memory calculation, inverted index, columnar storage, etc., although their technical principles are different, are all online summary statistics of detailed data during query execution (runtime), so these technologies have fewer data records. At times (million to ten million), performance is still within acceptable limits. However, as the amount of data grows rapidly (the hardware resources do not increase), the query speed will also increase linearly with the increase of the data volume, so the computation time complexity is relative to the data volume O(N). 

The calculation time complexity of various technologies is shown in the figure below. From the perspective of big data, various data such as web logs, system logs, and the Internet of Things are rapidly and continuously generated. For big data query analysis, the amount of data it faces will be an explosive growth model. Therefore, pre-computing this kind of technology that can block the computational pressure brought by the burst of data volume and keep the computation time complexity O(1) will be the most ideal and most suitable technology.

**Q: What is the difference between this product and Druid?**

A: Druid was originally designed for real-time analysis. This product is more focused on solving OLAP problems. Initially Druid can support real-time streaming Kafka. Now Kyligence Enterprise also supports reading messages directly from Kafka. It has the ability to build cubes in real time and provides near real-time. Analyze processing power; Druid uses bitmap index as internal data structure, this product also uses bitmap to index for cube; Druid uses its own defined query language, and this product supports ANSI SQL; Druid has restrictions on supporting table connection; The product supports star model; Druid is not friendly enough with the first-used BI tools. This product can support most BI tools, such as Tableau, Excel. Because this product supports MOLAP cube, complex query on very large dataset. High performance. Druid needs to scan all indexes. If the data set , or the query range is too large, the performance loss is greater. This product relies on Hadoop to build the cube. Druid uses its own computing and storage technology. For the case where Hadoop has been deployed, the deployment of this product is only a small extra work, and Druid needs to redeploy the full cluster.