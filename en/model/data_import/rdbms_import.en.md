### Import RDBMS Datasource

Our product supports datasets from RDBMS source since version 3.0.. 

### Setup

In order to connect with RDBMS datasets, users need to do the preparation work.

- Download RDBMS official JDBC Driver Jar
- Copy related jar packages to  `$KYLIN_HOME/ext`. 
- Copy related jar packages to `<sqoop_installation_directory> /lib`,  check global parameters, and add kylin.source.jdbc.sqoop-home=&lt;sqoop_path&gt; to `kylin.propertiess`. sqoop_path is the file where the sqoop command locates.

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

To enable query pushdown, following configration is required:

`kylin.query.pushdown.runner-class-name=io.kyligence.kap.query.pushdown.PushdownRunnerSDKImpl`

### Create Project with RDBMS Data Source

Taking Greenplum for instance. We connect Greenplum datasource with PostgreSQL JDBC Driver, followings are the steps:

1. log in on Kyligence Enterprise Web UI.
2. add a new project by clicking the `+` at the top right on Web UI. 
3. type `project name` (required) and `dscriptions` on the pop up page; click OK to finish creating a project.
4. select `Data Source` under *Studio* section of your project.
5. click the blue `Data Source` button.
6. select *RDBMS* as data source (as shown below).
7. Set configuration in project configuration (please refer to supported RDBMS parameter project configuration)

8. click `NEXT` and enter the *Load RDBMS Table Metadata* page; you can select tables you want from *Hive Table* on the left. 
9. click `sync` to load the data. 

### Supported RDBMS Parameter Project Configuration

- Basic Configuration

```properties
kylin.source.jdbc.connection-url=jdbc:<sqlserver>://<HOST>:<PORT>;database=<DATABASE_NAME>
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password> 
```

- Greenplum Datasource

```properties
kylin.source.jdbc.driver=com.pivotal.jdbc.GreenplumDriver
kylin.source.jdbc.dialect=greenplum
```

- Mysqul Datasource

```properties
kylin.source.jdbc.driver=com.microsoft.sqlserver.jdbc.SQLServerDriver
kylin.source.jdbc.dialect=mssql
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.MssqlAdaptor
```

- SQL SERVER Datasource

```properties
kylin.source.jdbc.driver=com.microsoft.sqlserver.jdbc.SQLServerDriver
kylin.source.jdbc.dialect=mssql
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.MssqlAdaptor
```

> Tip: Supported SQL SERVER datasource has limitations.
>
> - not support sub query with limit clause
> - not support 'geometric','geography'
> - not support INITCAP,MEDIAN,STDDEV_POP,FIRST_VALUE functions
> - not support avg/count/max/min/sum over() grammar