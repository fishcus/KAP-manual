##Import RDBMS Data Source

RDBMS is supported as data source since KAP 3.0. In order to load the RDBMS tables, JDBC Driver Jar and SDK jar packages are needed to put in  `$KYLIN_HOME/ext`.  The jar packages are also needed to copy to `<sqoop_installation_directory>/lib`, because *sqoop* is used in the process of cube building,

> To obtain the SDK jar package, please contack Kyligence Support.

Then, please set the following configurations in *project configuration* or *kylin.properties*:

| Parameter                        | Description                                                  |
| -------------------------------- | ------------------------------------------------------------ |
| kylin.source.jdbc.driver         | JDBC Driver Class Name                                       |
| kylin.source.jdbc.connection-url | JDBC Connection String                                       |
| kylin.source.jdbc.user           | JDBC Connection Username                                     |
| kylin.source.jdbc.pass           | JDBC Connection Password                                     |
| kylin.source.jdbc.dialect        | Dialect to the data source (Currently only support greenplum and default) |
| kylin.source.default             | Type of Data Source (16 for Greenplum and RDBMS)             |
| kylin.source.jdbc.adaptor        | JDBC Data Source Adaptor                                     |

To enable query pushdown, following configration is required:

`kylin.query.pushdown.runner-class-name=io.kyligence.kap.query.pushdown.PushdownRunnerSDKImpl`

> Tips:  `kylin.source.jdbc.sqoop-home=<sqoop_path>` should be added in `kylin.properties` , which cannot   be applied in project configuration. Sqoop_path is the path of your sqoop directory. 

After the configuration finished, users can access RDBMS Data Source on Web UI now.

### Create Project

Using SQL Server as an example, we connect SQL Server data source with PostgreSQL JDBC Driver, followings are the steps:

1. Download PostgreSQL JDBC Driver and SDK jar packages, and put them under `$KYLIN_HOME/ext` and `<sqoop_installation_directory>/lib`.
2. In KAP, project is the workspace of tables, models and cubes. To create a sample project, open the web UI of KAP and click the plus icon at the top to create a new project like below.![create project](images/rdbms_import.en.png)



3. Select the project you just created on the upper corner of the web UI, all our following operations will be within the project.![select data source](images/rdbms_import2.en.png)
4. Set following configuration in project configuration:

```
kylin.source.jdbc.driver=com.microsoft.sqlserver.jdbc.SQLServerDriver
kylin.source.jdbc.connection-url=jdbc:sqlserver://<HOST>:<PORT>;database=<DATABASE_NAME>
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
kylin.query.pushdown.runner-class-name=io.kyligence.kap.query.pushdown.PushdownRunnerSDKImpl
kylin.source.jdbc.dialect=mssql
kylin.source.default=16
kylin.source.jdbc.sqoop-home=/usr/hdp/current/sqoop-client/bin
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.MssqlAdapter
```

5. After the configuration finished users can access SQL Server data source on Web UI now.



### Synchronize RDBMS Table

RDBMS tables need to be synchronized into KAP before they can be used. To make things easy, we synchronize by using following button to load the RDBMS tables.

![synchronize table's metadata](images/rdbms_import3.en.png)

In the dialog box, expand the ssb schema and select the desired five tables.

![table sampling](images/rdbms_import4.en.png)

After importing, the system will automatically scan the tables to collect basic statistics of the data. Wait a few minutes, we can view the details under the "Data Source" tab.