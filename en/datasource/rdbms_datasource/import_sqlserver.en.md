## Import Data from Microsoft SQL Server

Kyligence Enterprise supports Microsoft SQL Server as data source since version 3.2. Support Microsoft SQL Server versions are SQL Server 2012 and higher.

You can refer to [Import Data from RDBMS](README.md) to configure connection, and this article will introduce specific configuration for Microsoft SQL Server.

> This solution requires customization and is not recommended to use in production environment, please contact Kyligence Service Team if you want to adopt this.

### Drivers

- Use official Microsoft SQL Server JDBC Driver (Recommend sqljdbc4.1)
- Download Data Source Adaptor for Microsoft SQL Server from [Kyligence Account](http://download.kyligence.io/#/addons)

### Configure Connection

Please refer to [Import Data from RDBMS](README.md) to configure. Following is an example connecting with Microsoft SQL Server:

```properties
kylin.source.jdbc.driver=com.microsoft.sqlserver.jdbc.SQLServerDriver
kylin.source.jdbc.connection-url=jdbc:<sqlserver>://<host>:<port>;database=<database_name>
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
kylin.source.jdbc.dialect=mssql
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.MssqlAdaptor
```