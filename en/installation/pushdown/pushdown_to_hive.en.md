## Pushdown to Hive

Kyligence Enterprise supports Query Pushdown since 2.4. If the query is Cube incapable, Kyligence Enterprise will route the query to the pushdown query engine, such as **Spark SQL** / **Hive** / **Impala**. Therefore, users can have a more flexible experience, which can be used in forecast analysis scenarios as well as queries with low frequency or that do not require high performance.

###Turn on Query Pushdown to Hive

1. Add configurations to enable query pushdown engine in  `$KYLIN_HOME/conf/kylin.properties`.

   ```properties
   kylin.query.pushdown.runner-class-name=org.apache.kylin.query.adhoc.PushDownRunnerJdbcImpl
   ```

2. Add Hive JDBC configurations in `kylin.properties` and restart Kyligence Enterprise to take effect. The following configurations are required.

   | Properties                         | Description                 | Default                            |
   | ---------------------------------- | --------------------------- | ---------------------------------- |
   | kylin.query.pushdown.jdbc.url      | Hive JDBC url               | jdbc:hive2://sandbox:10000/default |
   | kylin.query.pushdown.jdbc.driver   | Hive JDBC Driver class name | org.apache.hive.jdbc.HiveDriver    |
   | kylin.query.pushdown.jdbc.username | JDBC user name              | hive                               |

   >Besides, there are also some advanced configurations provided.
   >
   > | Properties                               | Description                                            | Default      |
   > | ---------------------------------------- | ------------------------------------------------------ | ------------ |
   > | kylin.query.pushdown.jdbc.password       | JDBC password                                          | empty string |
   > | kylin.query.pushdown.jdbc.pool-max-total | max number of database's connection number             | 8            |
   > | kylin.query.pushdown.jdbc.pool-max-idle  | max number of database's waiting connection number     | 8            |
   > | kylin.query.pushdown.jdbc.pool-min-idle  | minimum number of database's waiting connection number | 0            |


**Note:**

1. If Kerberos is configured, the principal information should also be added.

   ```properties
   kylin.query.pushdown.jdbc.url=jdbc:hive2://sandbox:10000/default;principal=hive/host@hadoop.com
   ```

   In addition to this, the principal should be consistent with the value of `hive.server2.authentication.kerberos.principal` in `hive-site.xml` and the `host` should be replaced by the host name of `HiverServer2`, such as

   ```properties
   kylin.query.pushdown.jdbc.url=jdbc:hive2://127.0.0.1:10000/default;principal=hive/cdh-54-02@hadoop.com
   ```

2. If you need to configure the Pushdown to Hive in HDP environmet, please delete the configurations below in `hive-site.xml`:

   ```xml
   <property>
   		<name>hive.exec.post.hooks</name>
   		<value>org.apache.atlas.hive.hook.HiveHook</value>
   </property>
   ```

   