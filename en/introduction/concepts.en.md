### Basic Concepts

This section introduces the basic concepts used in KAP.

### Cube
* _Table_ - Table is the source data of cube. Before creating a cube, KAP need to sync tables from data source (typically Hive), including table name, columns, and types etc.

* _Data Model_ - Data model defines a set of connected tables and their joining conditions. KAP supports [star schema](https://en.wikipedia.org/wiki/Star_schema) as the base of multi-dimensional analysis. User has to define a data model before a cube can be created.

* _Cube_ - Cube is a technology for multi-dimensional analytics. By calculating a cube, pre-aggregated values are stored in a multi-dimensional space. At query time, result is created by lightweight processing these pre-calculated values, thus boost query speed. 

* _Partition_ - A date/time column can be defined to partition data. Later cube can be built by time ranges and creates one or more cube segments.

* _Cube Segment_ - A cube segment is the result of pre-calculation from the data of a certain time range. If HBase is storage, each cube segment corresponds to a HTable.

* _Aggregation Group_ - An aggregation group is a sub-set of all dimensions with filtering rules. By grouping common used dimensions and applying filtering rules, the amount of calculation can be greatly reduced. 

### Dimensions & Measures
* _Mandatory_ - Mandatory dimension is a dimension that will be involved in all queries. Thus all branches that does not contain the mandatory dimension can be safely skipped during cube building to save computation and storage.

* _Hierarchy_ - Hierarchy is a group of dimensions that forms a "contains" relationship. By defining hierarchy, those combinations that do not match hierarchy will be pruned. E.g., if A=>B=>C is a hierarchy, then only combination A, AB, and ABC will be calculated, other combinations among A, B, C will be skipped.

* _Derived_ - Derived dimensions are dimensions on lookup table. They can be derived at runtime by searching lookup table using primary key, thus do not have to be stored in cube.

* _Count Distinct(HyperLogLog)_ - Precise count distinct on big data is known to be difficult and inefficient. [HyperLogLog](https://en.wikipedia.org/wiki/HyperLogLog) is an approximate algorithm for COUNT DISTINCT. With very small error and memory footprint, it can calculate COUNT DISTINCT on huge data set efficiently.

* _Count Distinct(Bitmap)_ - Precise count distinct based on bitmap. It is much more memory consuming than HyperLogLog, but gives precise result. Currently only integer type (or other types that can converts to integer by a dictionary) is supported.

* _Top N_ - A pre-calculation of top N items based on the Space-Saving algorithm. It can pre-calculate e.g. the top 1000 buyers of day.

### Cube Operations
* _BUILD_ - Given a time range, pull records from data source and build a cube segment.
* _REFRESH_ - Refresh a built segment, pull latest records from data source and rebuilt the cube segment.
* _MERGE_ - Merge multiple segments into a bigger segment. Reduce cube storage and speed up queries a bit. 
* _PURGE_ - Purge all segments in a cube.

### Job Status
* *NEW* - New job, just created.
* _PENDING_ - Job waiting for resource to run.
* _RUNNING_ - Job is running.
* _FINISHED_ - Job finished successfully, end state.
* _ERROR_ - Jos has error, need fix and then can resume.
* _DISCARDED_ - Job is discarded, end state.

### Job Operations
* _RESUME_ - Resume a job that is in ERROR status. User resolves the cause of error, and then resume the job from where it stopped.
* _DISCARD_ - Discard a job and its related segment if there is one.

