## 下压至 Hive


本产品使用 Hive 作为 Cube 的数据源，也可以将其配置为查询下压（Query Pushdown）的备用查询引擎。在未构建 cube 时，查询下压适用于探索式的分析场景，以及对查询频率不高或者对响应时间无太高要求的查询。

1. 修改配置文件`kylin.properties`打开 Query Pushdown 注释掉的配置项`kylin.query.pushdown.runner-class-name`，设置为`org.apache.kylin.query.adhoc.PushDownRunnerJdbcImpl`

2. 在配置文件`kylin.properties`添加如下配置项并重启。其中`kylin.query.pushdown.jdbc.url`，`kylin.query.pushdown.jdbc.driver`和`kylin.query.pushdown.jdbc.username`为必须配置项，其余项若不配置将使用默认配置项。

   ```properties
   #Hive Jdbc的url，例如jdbc:hive2://sandbox:10000/default
   kylin.query.pushdown.jdbc.url

   #Hive Jdbc的driver类名，例如org.apache.hive.jdbc.HiveDriver
   kylin.query.pushdown.jdbc.driver

   #Hive Jdbc对应数据库的用户名
   kylin.query.pushdown.jdbc.username

   #Hive Jdbc对应数据库的密码，默认为空字符串
   kylin.query.pushdown.jdbc.password

   #Hive Jdbc连接池的最大连接数，默认值为8
   kylin.query.pushdown.jdbc.pool-max-total

   #Hive Jdbc连接池的最大等待连接数，默认值为8
   kylin.query.pushdown.jdbc.pool-max-idle

   #Hive Jdbc连接池的最小等待连接数，默认值为0
   kylin.query.pushdown.jdbc.pool-min-idle
   ```

注：

1. 若配置了 kerberos，其中 principle 应为集群 hive-site.xml 中，配置项 'hive.server2.authentication.kerberos.principal' 对应的值 'hive/[_HOST@hadoop-r.com](mailto:_HOST@hadoop-r.com)'，_HOST 替换为部署 hiveserver2 的主机名

> 例如：
> kylin.query.pushdown.jdbc.url=jdbc:hive2://127.0.0.1:10000/default;principal=hive/cdh-54-02@hadoop-r.com

2. 在 HDP 中配置下压至 Hive，需要将 hive-site.xml 中的配置项删除：

   > <property>
   > <name>hive.exec.post.hooks</name>
   > <value>org.apache.atlas.hive.hook.HiveHook</value>
   > </property>