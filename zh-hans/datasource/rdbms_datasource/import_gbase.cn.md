## 导入 GBase 数据源

Kyligence Enterprise 从 3.3.0 开始支持 GBase 作为数据源，目前支持的 GBase 版本为 GBase 8a。

您可以参考[连接 RDBMS 数据源](README.md)中的介绍配置连接，本文着重介绍针对 GBase 的特殊配置。

> 注：本文介绍的 GBase 连接方案属于二次开发方案，不建议直接在生产环境使用。如果您有需求，请在 Kyligence 服务人员的支持下使用。

### 驱动程序

- 使用官方 GBase JDBC Driver (推荐版本 gbase-connector-java-8.3.81.51-build-53.6-bin.jar)
- 访问[Kyligence Download](http://download.kyligence.io/#/addons)下载 Kyligence Data Source Adaptor for GBase

### 连接参数

请参考[连接 RDBMS 数据源](README.md)中的介绍配置连接参数，以下是一个连接 GBase 数据源的配置样例：

```properties
kylin.source.jdbc.driver=org.gjt.mm.gbase.Driver
kylin.source.jdbc.connection-url=jdbc:gbase://<host>:<port>/<database_name>
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
kylin.source.jdbc.dialect=gbase8a
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.Gbase8aAdaptor
```