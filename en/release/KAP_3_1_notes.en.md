## Kyligence Enterprise 3.1 Release Note

We're happy to annource the GA of Kyligence Enterprise 3.1.0. In this new release, we support MySQL as data source to offload its analytical workloads. We simplified the deployment of R/W separation and implemented a more flexiable authorization control at all data granularity. For application deployment or migration between Kyligence systems, we added import/export function of project metadata. 

**New Read/Write Separation Architecutre and Deployment**

With more rational design, we simplified the deployment process of R/W separation, to achieve a more stable system via separating workloads between query and cube data loading on different Hadoop clusters.

**Flexiable Data Access Authorization**

Supporting explicit / implicit granting access to data tables, as well as more powerful REST APIs, we eanble much more flexiable and secure data access control at all granularities for enterpriese applications.

**Export / Import Metadata by Projects**

For more convinient and efficient deployment / migration of Kyligence applicaitons between clusters, we support export / import metadata by projects.

### Supported Hadoop Distributions

Certified Hadoop Distributions:

​	Cloudera CDH 5.7/5.8/5.11/5.12

  	MapR 5.2.1

Compatible Hadoop Distributions:

​	HBase 0.98+，Hive 0.14+

  	Hortonworks HDP 2.4

  	Huawei FusionInsight C60/C70

### Product Download

Kyligence Enterprise v3.1 is now available for download. Please visit [Kyligence Account](http://download.kyligence.io/) for more information.