### Import RDBMS Datasource

Our product supports datasets from RDBMS source since version 3.0.. 

### Setup

In order to connect with RDBMS datasets, users need to do the preparation work.

- Download RDBMS official JDBC Driver Jar
- Download *Kyligence specific* SDK jar package (ITo obtain the SDK jar package, please contack Kyligence Support.)
- Copy related jar packages to  `$KYLIN_HOME/ext`. 
-  Copy related jar packages to `<sqoop_installation_directory>/lib`, 

> Note: Because *sqoop* is used in the process of cube building, JDBC needs to be configured to  / lib directory under sqoop installation path.

### Connection Configuration

Users can set the following configurations in *project configuration* or *global configuration*:

> Note: The global configuration file intalles in the kylin.properties configuration file in the /conf directory under the installation path by default.

| Parameter                        | Description                                                  |
| -------------------------------- | ------------------------------------------------------------ |
| kylin.source.jdbc.driver         | JDBC Driver Class Name                                       |
| kylin.source.jdbc.connection-url | JDBC Connection String                                       |
| kylin.source.jdbc.user           | JDBC Connection Username                                     |
| kylin.source.jdbc.pass           | JDBC Connection Password                                     |
| kylin.source.jdbc.dialect        | Dialect to the data source (Currently only support greenplum and default) |
| kylin.source.default             | Type of Data Source (16 for RDBMS)                           |
| kylin.source.jdbc.adaptor        | JDBC Data Source Adaptor                                     |

To enable query pushdown, following configration is required:

`kylin.query.pushdown.runner-class-name=io.kyligence.kap.query.pushdown.PushdownRunnerSDKImpl`

> Tips:  `kylin.source.jdbc.sqoop-home=<sqoop_path>` should be added in `kylin.properties` , which cannot   be applied in project configuration. Sqoop_path is the path of your sqoop directory. 

### Create Project with RDBMS Data Source

Taking Greenplum for instance. We connect Greenplum datasource with PostgreSQL JDBC Driver, followings are the steps:

1. log in on Kyligence Enterprise Web UI.

2. add a new project by clicking the `+` at the top right on Web UI. 

3. type `project name` (required) and `dscriptions` on the pop up page; click OK to finish creating a project.

4. select `Data Source` under *Studio* section of your project.

5. click the blue `Data Source` button.

6. select *RDBMS* as data source (as shown below).

   ![select data source](images/rdbms_import2.en.png)

Set following configuration in project configuration:

```
kylin.source.jdbc.driver=com.pivotal.jdbc.GreenplumDriver
kylin.source.jdbc.connection-url=jdbc:sqlserver://<HOST>:<PORT>;database=<DATABASE_NAME>
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
kylin.query.pushdown.runner-class-name=io.kyligence.kap.query.pushdown.PushdownRunnerSDKImpl
kylin.source.jdbc.dialect=mssql
kylin.source.default=16
kylin.source.jdbc.sqoop-home=/usr/hdp/current/sqoop-client/bin
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.MssqlAdapter
```

7. click `NEXT` and enter the *Load RDBMS Table Metadata* page; you can select tables you want from *Hive Table* on the left. 
8. click `sync` to load the data. 