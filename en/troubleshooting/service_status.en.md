## Service Status

Since KAP V2.5.6, the service status is provided for ADMIN users to check the environment dependency, which will be checked every 15 minutes.

![service status](images/service_status.en.png)

This function will mainly focus on these aspects：

- Metastore availability：check the connectivity, functionality, and response of metastore 
- Hive connectivity：check the connectivity of Hive/Beeline and usability of kerberos ticket
- Metadata consistency：check the consistency and integrity of metadata
- Metadata synchronization：check the synchronous exception of metadata and reload metadata automatically
- Spark context availability：check the availability of  pushdown spark cluster
- Zookeeper availability：check the connectivity of zookeeper including response and functionality
- Job engine：check the availablity of job engine

Service status uses green, yellow and red to show *health*, *warning* and *crash*. Users could also move the mouse to specific items to get the detailed information.
