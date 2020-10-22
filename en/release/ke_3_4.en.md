## Kyligence Enterprise 3.4 Release Notes

We're happy to announce the GA of Kyligence Enterprise 3.4. In this new release, Kyligence Enterprise supports the mechanism of multi-active construction nodes, allowing multiple construction nodes to work at the same time, which not only improves the construction performance, but also ensures the high availability of the construction nodes; improves the relevant functions of the Kafka data source project, and Supports data analysis of batch fusion scenarios; in terms of data security, the new daemon process can ensure that Kyligence Enterprise's business is not Interrupt; In addition, Kyligence Enterprise v3.4 also supports more query functions.

### The task engine is more active
Multiple construction nodes are allowed to perform construction tasks at the same time. When a construction node fails, other construction nodes in the cluster can still ensure the normal execution of the construction tasks, achieving high concurrency and high availability of construction tasks.


### Query enhancement
#### New query function
* Intersection function: The user can use the intersection function to calculate the intersection value of two data sets.
* Condition function: IF (condition, value_if_true, value_if_false), nvl (value1, value2)
* Type conversion function: CAST (value AS type), CAST function can be used to force the conversion of value into type type
* Bitmap function: The user can use the Bitmap function to calculate the bitmap result after repeated calculation from multiple models, and then perform the intersection operation on the subquery bitmap.
* Difference function: users can use the intersection function to calculate the difference between two data sets.

#### Specify the Cube priority for the query
When a query can be answered by multiple cubes, the user can specify the automatic selection of the cube replacement system that he wants to hit.


### Streamlined project enhancements
* Improve streaming modeling. Optimized the logic of loading tables and added the function of reloading tables. This allows users to handle Kafka data source projects as flexibly as they do Hive data source projects.
* Batch flow fusion scene. In a streaming project, a model that uses a Hive table as a fact table and a model that uses a Kafka table as a fact table are allowed to exist at the same time, which allows users to query historical and real-time fusion data, enriching the user's query scenarios.
* Streaming project migration. Added the function of importing and exporting metadata of streaming projects, users can migrate streaming projects in different KE versions.
* Build performance improved. Provide multiplexed dimension table snapshot and materialized view function for streaming construction, greatly reducing the construction time.


### Model enhancement
* Provide richer modeling support. Allows a dimension table to be related multiple times in the model, providing more time partition column format support for the incremental model.
* Support the ability to dock the memo field in the data source to Tableau. Supports synchronizing the dimensions and measurement descriptions of Hive notes to Cube and exporting them to TDS files.
* Support Last Child semi-cumulative measurement. Semi-cumulative metrics can be used to handle business areas such as securities, account balances, and human resources. For example, when a bank uses account transaction record data to count savings account balances, the normal summation is used for the non-time dimension, and for the time dimension, the value of the last record needs to be taken.


### safely control

#### Daemon Process
The daemon will detect the health status of the Kyligence Enterprise process in real time and ensure the high availability of the Kyligence Enterprise process by reducing service capabilities or restarting.

#### Hive permission mapping
Kyligence Enterprise supports permission mapping of Hive data sources on Hortonworks HDP and Huawei FusionInsight platforms. When users such as project administrators and modelers load tables in Hive data sources, they can only see the tables that have permissions in Hive. .


### Supported Hadoop Distributions ###

The following enterprise-level data management platforms and their corresponding Hadoop versions have passed our compatibility tests. If your Hadoop version is not included, please contact Kyligence Technical Support to obtain a solution.

* Cloudera CDH 5.8 / 5.14 / 6.0 / 6.1 / 6.2.1 / 6.3.1
* Hortonworks HDP 2.4
* Huawei FusionInsight C70 / 6.5.1
* AWS EMR 5.23
* MapR 6.1.0


> The following Hadoop distributions used to be verified but the tests are not maintained any more:
>
> - MapR 6.0

### Product Download

Kyligence Enterprise v3.4 is now available for download. Please visit [Kyligence Download](http://download.kyligence.io/) for more information.
