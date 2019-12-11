## Import Data from Oracle

Kyligence Enterprise supports Oracle as data source since version 3.3. Supported Oracle version are 11g and higher.

You can refer to [Import Data from RDBMS](README.md) to configure connection, and this article will introduce specific configuration for Oracle.

> This solution requires customization and is not recommended to use in production environment, please contact Kyligence Service Team if you want to adopt this.

### Drivers

- Use official Oracle JDBC Driver (Recommend ojdbc6.jar)
- Download Data Source Adaptor for Oracle from [Kyligence Account](http://download.kyligence.io/#/addons)

### Configure Connection

Please refer to [Import Data from RDBMS](README.md) to configure. Following is an example connecting with Oracle:

```properties
kylin.source.jdbc.driver=oracle.jdbc.OracleDriver
kylin.source.jdbc.connection-url=jdbc:oracle:thin:@//<host>:<port>/<service_name> 
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
kylin.source.jdbc.dialect=oracle11g
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.Oracle11gAdaptor
```

To enable query pushdown, following configration is required:

```properties
kylin.query.pushdown.runner-class-name=io.kyligence.kap.query.pushdown.PushdownRunnerSDKImplForOracle
```

### Important Notes

- Oracle transforms `date` type to `timestamp` by default through JDBC. To avoid inconsistency, we suggest to use `timestamp` instead of `date` in Oracle tables.

- Oracle uses `number` type for both `integer` and `double`, which will be transformed to `bigdecimal` in Kyligence Enterprise, some BI tools may add decimal numbers `.0` after numbers because of data type transformation.

- When Connection Reset Errors occured while using sqoop, try to set `securerandom.source=file:/dev/../dev/urandom` in the `java.security` file to fix. See more details in [reference](https://sqoop.apache.org/docs/1.4.6/SqoopUserGuide.html#_oracle_ora_00933_error_sql_command_not_properly_ended)
