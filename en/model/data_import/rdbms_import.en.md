### Import RDBMS Data Source

Our product supports datasets from RDBMS source since version 3.0. 

### Installation

In order to connect with RDBMS datasets, users need to do the preparation work.

- Download RDBMS official JDBC Driver Jar
- Download Kyligence specific SDK jar package ( get the SDK jar package from Kyligence account site or contact Kyligence Support.)
- Copy related jar packages to  `$KYLIN_HOME/ext`. 
- Copy related jar packages to `<sqoop_installation_directory> /lib`, check global parameters, and add kylin.source.jdbc.sqoop-home=&lt;sqoop_path&gt; to `kylin.properties`. sqoop_path is the file where the sqoop command locates.

### Connection Configuration

Users can set the following configurations in *project configuration* or *global configuration*:

| Parameter                        | Description                        |
| -------------------------------- | ---------------------------------- |
| kylin.source.jdbc.driver         | JDBC Driver Class Name             |
| kylin.source.jdbc.connection-url | JDBC Connection String             |
| kylin.source.jdbc.user           | JDBC Connection Username           |
| kylin.source.jdbc.pass           | JDBC Connection Password           |
| kylin.source.jdbc.dialect        | Dialect to the Data Source         |
| kylin.source.default             | Type of Data Source (16 for RDBMS) |
| kylin.source.jdbc.adaptor        | JDBC Data Source Adaptor           |

To enable query pushdown, following configuration is required:

`kylin.query.pushdown.runner-class-name=io.kyligence.kap.query.pushdown.PushdownRunnerSDKImpl`

### Create Project with RDBMS Data Source

Taking Greenplum as an example. We connect Greenplum data source with PostgreSQL JDBC Driver, followings are the steps:

1. Log in Kyligence Enterprise Web UI.
2. Add a new project by clicking the `+` at the top right on Web UI. 
3. Type `project name` (required) and `descriptions` on the pop up page; click OK to finish.
4. Select `Data Source` under *Studio* section of your project.
5. Click the blue `Data Source` button.
6. Select *RDBMS* as data source (as shown below).
7. Set configuration in project configuration (please refer to supported RDBMS parameter project configuration)

8. Click `NEXT` and enter the *Load RDBMS Table Metadata* page; you can select tables you want from *Hive Table* on the left. 
9. Click `sync` to synchronize/load the data. 

### Supported RDBMS Parameters in Project Configuration

- Basic Configuration

```properties
kylin.source.jdbc.connection-url=jdbc:<sqlserver>://<HOST>:<PORT>;database=<DATABASE_NAME>
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password> 
```

- Greenplum Data Source

```properties
kylin.source.jdbc.driver=com.pivotal.jdbc.GreenplumDriver
kylin.source.jdbc.dialect=greenplum
```

- MySQL Data Source

```properties
kylin.source.jdbc.driver=com.microsoft.sqlserver.jdbc.SQLServerDriver
kylin.source.jdbc.dialect=mssql
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.MssqlAdaptor
```

- SQL Server Data Source

  This data source need external SDK, you can get data source SDK from Kyligence account site.

```properties
kylin.source.jdbc.driver=com.microsoft.sqlserver.jdbc.SQLServerDriver
kylin.source.jdbc.dialect=mssql
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.Mssql08Adaptor
```

> Tips: Supported SQL SERVER data source has limitations.
>
> - Not support sub-query with limit clause
> - Not support 'geometric','geography'
> - Not support INITCAP, MEDIAN, STDDEV_POP, FIRST_VALUE functions
> - Not support aggregate functions like avg/count/max/min/sum
> - Not support windowing functions: over()
