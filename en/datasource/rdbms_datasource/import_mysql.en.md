## Import Data from MySQL

Kyligence Enterprise supports MySQL as data source since version 3.0. Supported MySQL versions are 5.5，5.6 and 5.7.

You can refer to [Import Data from RDBMS](README.md) to configure connection, and this article will introduce specific configuration for MySQL.

### Drivers

- Use official MySQL JDBC Driver (Recommend MySQL 5.1.41)
- Use embeded Data Source Adaptor for MySQL

### Configure Connection

Please refer to [Import Data from RDBMS](README.md) to configure. Following is an example connecting with MySQL:

```properties
kylin.source.jdbc.driver=com.mysql.jdbc.Driver
kylin.source.jdbc.connection-url=jdbc:mysql://<HOST>:<PORT>/<DATABASE_NAME>
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
kylin.source.jdbc.dialect=mysql
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.MysqlAdaptor
```