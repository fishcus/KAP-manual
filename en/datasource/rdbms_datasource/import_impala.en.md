## Import Data from Impala

Kyligence Enterprise supports Impala as data source since version 3.2. 

You can refer to [Import Data from RDBMS](README.md) to configure connection, and this article will introduce specific configuration for Impala.

### Drivers

- Use official [Impala JDBC Driver](https://www.cloudera.com/downloads/connectors/impala/jdbc/2-6-4.html)
- Download Data Source Adaptor for Impala from [Kyligence Account](http://download.kyligence.io/#/addons)

### Configure Connection

Please refer to [Import Data from RDBMS](README.md) to configure. Following is an example connecting with Impala:

```properties
kylin.source.jdbc.driver=io.kyligence.kap.impala.jdbc41.WrappedDriver
kylin.source.jdbc.connection-url=jdbc:impala-wrapped://<host>:<port>/<database>
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
kylin.source.jdbc.dialect=impala
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.ImpalaAdaptor
```