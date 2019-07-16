## 下压至 Hive

本产品从 2.4 版本开始支持查询下压。当用户需要执行定制的 Cube 无法满足的查询时，可以使用查询下压，将该查询下压至 **SparkSQL**／**Hive**／**Impala**，从而在查询中获取更灵活的使用体验。查询下压适用于探索式的分析场景，以及对查询频率不高或者对响应时间无太高要求的查询。

### 开启查询下压至 Hive

1. 在 `$KYLIN_HOME/conf/kylin.properties` 新增如下参数配置开启查询下压开关。

   ```properties
   kylin.query.pushdown.runner-class-name=org.apache.kylin.query.adhoc.PushDownRunnerJdbcImpl
   ```

2. 在 `kylin.properties` 文件中配置 Hive JDBC 接口连接信息，配置完毕后需要重启生效。其中以下参数为**必填项**。

   | 配置项                             | 描述                  | 默认值                             |
   | ---------------------------------- | --------------------- | ---------------------------------- |
   | kylin.query.pushdown.jdbc.url      | Hive JDBC 连接串      | jdbc:hive2://sandbox:10000/default |
   | kylin.query.pushdown.jdbc.driver   | Hive JDBC Driver 类名 | org.apache.hive.jdbc.HiveDriver    |
   | kylin.query.pushdown.jdbc.username | 对应数据库的用户名    | hive                               |

   > 除此之外，还有一些高级配置。
   >
   > | 配置项                                   | 描述                   | 默认值   |
   > | ---------------------------------------- | ---------------------- | -------- |
   > | kylin.query.pushdown.jdbc.password       | 对应数据库的密码       | 空字符串 |
   > | kylin.query.pushdown.jdbc.pool-max-total | 连接池最大连接数       | 8        |
   > | kylin.query.pushdown.jdbc.pool-max-idle  | 连接池最大等待连接数   | 8        |
   > | kylin.query.pushdown.jdbc.pool-min-idle  | 连接池的最小等待连接数 | 0        |

**注意：**

1. 如果您配置了 Kerberos，还需要在原有的连接串中添加 principal 信息。

  ```properties
  kylin.query.pushdown.jdbc.url=jdbc:hive2://sandbox:10000/default;principal=hive/host@hadoop.com
  ```

  其中 principle 的值应和集群 `hive-site.xml` 中的配置项 `hive.server2.authentication.kerberos.principal` 保持一致， `host` 需要替换为部署的 `HiveServer2` 的主机名，例如：

  ```properties
  kylin.query.pushdown.jdbc.url=jdbc:hive2://127.0.0.1:10000/default;principal=hive/cdh-54-02@hadoop.com
  ```

2. 如果您在 HDP 环境中配置下压至 Hive，需要将环境中 `hive-site.xml` 如下配置项删除：

   ```xml
   <property>
   		<name>hive.exec.post.hooks</name>
   		<value>org.apache.atlas.hive.hook.HiveHook</value>
   </property>
   ```

   