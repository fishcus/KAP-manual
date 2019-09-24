## 导入 Oracle 数据源

Kyligence Enterprise 从 3.3.0 开始支持 Oracle 作为数据源，目前支持的 Oracle 版本为 Oracle 11g 及更高版本。

您可以参考[连接 RDBMS 数据源](README.md)中的介绍配置连接，本文着重介绍针对 Impala 的特殊配置。

> 注：本文介绍的 Oracle 连接方案属于二次开发方案，不建议直接在生产环境使用。如果您有需求，请在 Kyligence 服务人员的支持下使用。

### 驱动程序

- 使用官方 Oracle JDBC Driver (推荐 ojdbc6.jar 或者更高版本)
- 访问[Kyligence Download](http://download.kyligence.io/#/addons)下载 Kyligence Data Source Adaptor for Oracle

### 连接参数配置

请参考[连接 RDBMS 数据源](README.md)中的介绍配置连接参数，以下是一个连接 Oracle 数据源的配置样例：

```properties
kylin.source.jdbc.driver=oracle.jdbc.OracleDriver
kylin.source.jdbc.connection-url=jdbc:oracle:thin:@//<host>:<port>/<service_name> 
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
kylin.source.jdbc.dialect=oracle11g
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.Oracle11gAdaptor
```

如果需要开启查询下压，还需要配置以下参数：

```properties
kylin.query.pushdown.runner-class-name=io.kyligence.kap.query.pushdown.PushdownRunnerSDKImplForOracle
```

### 注意事项

- Oracle JDBC Driver 默认会把 `date` 类型转换成 `timestamp`, 就是 Oracle 可以创建 `date` 类型字段，但是通过jdbc获取到默认就是 `timestamp`. 为了避免不一致，尽量在 Oracle 里使用 `timestamp` 来代替 `date` 类型

- Oracle 使用 `number` 类型表示 `integer` 和 `double` 两种类型, 同步到Kyligence Enterprise为 `decimal`, 有些BI工具为因为是`decimal`类型在数字结尾拼接 `.0` 造成显示的不一致

