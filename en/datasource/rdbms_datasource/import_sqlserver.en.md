## Import Data from Microsoft SQL Server

MS SQL Server is supported as the default data source since Kyligence Enterprise 3.0, including SQL Server version SQLServer2008 and SQLServer2012. To load the SQL Server tables, SQL Server Driver Jar package is needed to put in  `$KYLIN_HOME/ext`.  The recommended Driver is sqlserver08:4-4.0.

Then, please set the following configurations in *kylin.properties* or *project configuration*:

| Parameter                        | Description                |
| -------------------------------- | :------------------------- |
| kylin.source.jdbc.driver         | JDBC Driver Class Name     |
| kylin.source.jdbc.connection-url | JDBC Connection String     |
| kylin.source.jdbc.user           | JDBC Connection Username   |
| kylin.source.jdbc.pass           | JDBC Connection Password   |
| kylin.source.jdbc.dialect        | Dialect to the data source |
| kylin.source.jdbc.adaptor        | JDBC Data Source Adaptor   |

To enable query pushdown, following configration is required:

`kylin.query.pushdown.runner-class-name=io.kyligence.kap.query.pushdown.PushdownRunnerSDKImpl`

> Tips:  `kylin.source.jdbc.sqoop-home=<sqoop_path>` should be added in `kylin.properties` , which cannot be applied in project configuration. Sqoop_path is the path of your sqoop directory. 



### Create Project with SQL Server Data Source

**Step 1:** Log in to Kyligence Enterprise Web UI, then add a new project by clicking the `+` at the top right on Web UI. Type project name (required) and descriptions on the pop-up page; click `OK` to finish creating a project.

![](/Users/sijie.chen/Documents/GitHub/KAP-Manual/en/datasource/images/dataimport_1.png)

**Step 2:** Select `Data Source` under *Studio* section of your project. Click the blue `Data Source` button and select RDBMS as data source (as shown below).

![](../images/rdbms_import2.en.png)

**Step 3:** Set following configuration in project configuration:

```properties
kylin.source.jdbc.sqoop-home=/usr/hdp/current/sqoop-client
kylin.source.jdbc.driver=com.microsoft.sqlserver.jdbc.SQLServerDriver
kylin.source.jdbc.connection-url=jdbc:<sqlserver>://<HOST>:<PORT>;database=<DATABASE_NAME>
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
kylin.source.jdbc.dialect=mssql
kylin.source.default=16
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.MssqlAdaptor
```

**Step 4:** After the configuration finished users can access SQL Server data source on Web UI now.

**Step 5:** Click `NEXT` and enter the *Load SQL Server Table Metadata* page; you can select tables you want from *SQL Server Table* on the left. Keyword search is also supported.



> **Note:** There are several known limitations for Microsoft SQL SERVER 2008.
>
> - Not support sub-query with limit clause
> - Not support 'geometric','geography'
> - Not support INITCAP, MEDIAN, STDDEV_POP, FIRST_VALUE functions
> - Not support aggregate functions like avg/count/max/min/sum
> - Not support windowing functions: over()
