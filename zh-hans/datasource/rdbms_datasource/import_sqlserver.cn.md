## 导入 MS SQL Server 数据源

Kyligence Enterprise 从 3.0 开始支持 SQL Server 作为数据源，目前支持的 SQL Server 版本为 SQL Server 2012 及更高版本。

> 注：本文介绍的 MS SQL Server 连接方案属于二次开发方案，不建议直接在生产环境使用。如果您有需求，请在 Kyligence 服务人员的支持下使用。

### 驱动程序

- 使用官方 Microsoft SQL Server JDBC Driver (推荐 sqljdbc4.1 及以上版本)
- 访问[Kyligence Download](http://download.kyligence.io/#/addons)下载 Kyligence Data Source Adaptor for Microsoft SQL Server

### 连接参数配置

请参考[连接 RDBMS 数据源](README.md)中的介绍配置连接参数，以下是一个连接 SQL Server 数据源的配置样例：

```properties
kylin.source.jdbc.driver=com.microsoft.sqlserver.jdbc.SQLServerDriver
kylin.source.jdbc.connection-url=jdbc:<sqlserver>://<host>:<port>;database=<database_name>
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
kylin.source.jdbc.dialect=mssql
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.MssqlAdaptor
```