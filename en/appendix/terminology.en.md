## Terminologies

This section introduces the basic concepts used in Kyligence Enterprise.

### Cube
* **Table** - Table is the source data of cube. Before creating a cube,  loading tables from data source (typically Hive) is needed, which includes table name, columns, and data types etc.

* **Data Model** - Data model defines a set of connected tables and their joining conditions. Kyligence Enterprise supports [star schema](https://en.wikipedia.org/wiki/Star_schema) and [snow schema](https://en.wikipedia.org/wiki/Snowflake_schema) as the base of multi-dimensional analysis. User has to define a data model before a cube created.

* **Cube** - Cube is a technology for multi-dimensional analytics. By calculating a cube, pre-aggregated values are stored in a multi-dimensional space. At query time, result is created by lightweight processing these pre-calculated values, thus boost query speed. 

* **Partition** - A date/time column can be defined to partition data. Later cube can be built by time ranges and creates one or more cube segments.

* **Cube Segment** - A cube segment is the result of pre-calculation from the data of a certain time range.

* **Aggregation Group** - An aggregation group is a sub-set of all dimensions with filtering rules. By grouping common used dimensions and applying filtering rules, the amount of calculation can be greatly reduced. 

### Dimensions & Measures
* **Mandatory** - Mandatory dimension is a dimension that will be contained in all queries. Therefore, all combinations without this dimension will be pruning during cube building.
* **Hierarchy** - Hierarchy is a group of dimensions that forms a "contains" relationship. By defining hierarchy, those combinations that do not match hierarchy will be pruned. For example, if A=>B=>C is a hierarchy, then only combination A, AB, and ABC will be calculated, other combinations among A, B, C will be pruned.
* **Derived** - Derived dimensions are dimensions on lookup table. They can be derived at runtime by searching snapshots of lookup table by using primary key.
* **Count Distinct(HyperLogLog)** - Precise count distinct on big data is difficult and inefficient. [HyperLogLog](https://en.wikipedia.org/wiki/HyperLogLog) is an approximate algorithm for COUNT DISTINCT. With very small error and memory footprint, it can calculate COUNT DISTINCT on huge data set efficiently.
* **Count Distinct(Bitmap)** - Precise count distinct based on bitmap. It is much more memory consuming than HyperLogLog, but gives precise result. Currently only integer type (or other types that can converts to integer by a dictionary) is supported.
* **Top N** - A pre-calculation of top N items based on the Space-Saving algorithm, such as the top 1000 buyers of day.

### Cube Operations
* **BUILD** - Given a time range, fetch data from data source and build a cube segment.
* **REFRESH** - Refresh a built segment, fetch latest data from data source and rebuilt the cube segment.
* **MERGE** - Merge multiple segments into a bigger segment. Reduce cube storage and speed up queries a bit. 
* **PURGE** - Purge all segments in a cube.

### Job Status
* **PENDING** - Job waiting for resource to run.
* **RUNNING** - Job is running.
* **FINISHED** - Job finished successfully, end state.
* **ERROR** - Jos has error, need fix and then can resume.
* **DISCARDED** - Job is discarded, end state.

### Job Operations
* **RESUME** - Resume a job that is in ERROR status. User resolves the cause of error, and then resume the job from where it stopped.
* **DISCARD** - Discard a job and will not be abled to ruseme.

