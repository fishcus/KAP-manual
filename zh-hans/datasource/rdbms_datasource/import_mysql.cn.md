## 导入 MySQL 数据源

Kyligence Enterprise 从 3.0 版本开始支持 MySQL 作为数据源，目前支持的 MySQL 版本包括 5.5，5.6，5.7。

您可以参考[连接 RDBMS 数据源](README.md)中的介绍配置连接，本文着重介绍针对 Impala 的特殊配置。

### 驱动程序

- 使用官方 MySQL JDBC Driver（推荐版本为 MySQL 5.1.41）
- 使用 Kyligence Enterprise 内置的 Data Source Adaptor for MySQL

### 连接参数

请参考[连接 RDBMS 数据源](README.md)中的介绍配置连接参数，以下是一个连接 MySQL 数据源的配置样例：

```properties
kylin.source.jdbc.driver=com.mysql.jdbc.Driver
kylin.source.jdbc.connection-url=jdbc:mysql://<HOST>:<PORT>/<DATABASE_NAME>
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
kylin.source.jdbc.dialect=mysql
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.MysqlAdaptor
```