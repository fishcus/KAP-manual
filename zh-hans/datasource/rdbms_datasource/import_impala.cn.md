## 导入 Impala 数据源

Kyligence Enterprise 从 3.2 版本开始支持 Impala 作为数据源。

您可以参考[连接 RDBMS 数据源](README.md)中的介绍配置连接，本文着重介绍针对 Impala 的特殊配置。

> 注：本文介绍的 Impala 连接方案属于二次开发方案，不建议直接在生产环境使用。如果您有需求，请在 Kyligence 服务人员的支持下使用。

### 驱动程序

- 使用官方 [Impala JDBC 驱动程序](https://www.cloudera.com/downloads/connectors/impala/jdbc/2-6-4.html)
- 访问[Kyligence Download](http://download.kyligence.io/#/addons)下载 Kyligence Data Source Adaptor for Apache Impala

### 连接参数配置

请参考[连接 RDBMS 数据源](README.md)中的介绍配置连接参数，以下是一个连接 Impala 数据源的配置样例：

```properties
kylin.source.jdbc.driver=io.kyligence.kap.impala.jdbc41.WrappedDriver
kylin.source.jdbc.connection-url=jdbc:impala-wrapped://<host>:<port>/<database>
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
kylin.source.jdbc.dialect=impala
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.ImpalaAdaptor
```