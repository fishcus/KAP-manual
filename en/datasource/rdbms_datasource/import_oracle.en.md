## Import Data from Oracle

Oracle is supported as data source since Kyligence Enterprise 3.3.0, including Oracle 11g and higher versions. To load Oracle tables, Oracle driver jar package is needed to put in `$KYLIN_HOME/ext`. The recommended driver is ojdbc6.jar and higher.

Then please set the following configurations in `kylin.properties` or in project configuration:

| Parameter                        | Description                |
| -------------------------------- | :------------------------- |
| kylin.source.jdbc.driver         | JDBC Driver Class Name     |
| kylin.source.jdbc.connection-url | JDBC Connection String     |
| kylin.source.jdbc.user           | JDBC Connection Username   |
| kylin.source.jdbc.pass           | JDBC Connection Password   |
| kylin.source.jdbc.dialect        | Dialect to the data source |
| kylin.source.jdbc.adaptor        | JDBC Data Source Adaptor   |

To enable query pushdown, following configration is required:

```properties
kylin.query.pushdown.runner-class-name=io.kyligence.kap.query.pushdown.PushdownRunnerSDKImplForOracle
```

> **Note:**  `kylin.source.jdbc.sqoop-home=<sqoop_path>` should be added in `kylin.properties` , which cannot be applied in project configuration. Sqoop_path is the path of your sqoop directory. 



### Create Project with Oracle Data Source

**Step 1:** Log in to Kyligence Enterprise Web UI, then add a new project by clicking the **+** at the top right on Web UI. Type project name (required) and descriptions on the pop-up page; click **OK** to finish creating a project.

![Create project](../images/create_project.png)

**Step 2:** Select **Data Source** under **Studio** section of your project. Click the blue **Data Source** button and select RDBMS as data source (as shown below).

![Select data source](../images/rdbms_import_select_source.png)

**Step 3:** Set following configuration in project configuration:

```properties
kylin.source.jdbc.sqoop-home=/usr/hdp/current/sqoop-client
kylin.source.jdbc.driver=oracle.jdbc.OracleDriver
kylin.source.jdbc.connection-url=jdbc:oracle:thin:@//<host>:<port>/<service_name> 
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
kylin.source.jdbc.dialect=oracle11g
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.Oracle11gAdaptor
```

**Step 4:** After all the configuration above, you can access Oracle data source on Web UI now.

**Step 5:** Click **NEXT** and enter the **Load Oracle Table Metadata** page; you can select tables you want from the left panel. Keyword search is also supported.

### Important Notes

- Oracle transforms `date` type to `timestamp` by default through JDBC. To avoid inconsistency, we suggest to use `timestamp` instead of `date`

- Oracle uses `number` type for both `integer` and `double`, corresponding to `bigdecimal` in Kyligence Enterprise, some BI tools may add decimal numbers `.0` after numbers because of type `bigdecimal`.

