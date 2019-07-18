## Pushdown to Hive

Kyligence Enterprise supports Query Pushdown since version 2.4. If the query is Cube incapable, Kyligence Enterprise will route the query to the pushdown query engine, such as **Spark SQL** / **Hive** / **Impala**, for execution. Query pushdown suits for exploratory analytics where queries are free style and has a lower demand of response time and concurrency.

###Turn on Query Pushdown to Hive

1. Add configurations to enable query pushdown engine in  `$KYLIN_HOME/conf/kylin.properties`.

   ```properties
   kylin.query.pushdown.runner-class-name=org.apache.kylin.query.adhoc.PushDownRunnerJdbcImpl
   ```

2. Add Hive JDBC configurations in `kylin.properties` and restart Kyligence Enterprise to take effect. The following configurations are required.

   ```properties
   # Hive JDBC connection string
   kylin.query.pushdown.jdbc.url=jdbc:hive2://sandbox:10000/default
   
   # Hive JDBC driver class
   kylin.query.pushdown.jdbc.driver=org.apache.hive.jdbc.HiveDriver
   
   # Hive user name
   kylin.query.pushdown.jdbc.username=hive
   
   # Hive password
   kylin.query.pushdown.jdbc.password=
   ```

   >Besides, there are also some advanced configurations provided.
   > 
   > ```properties
   > # Max connections in connection pool
   > kylin.query.pushdown.jdbc.pool-max-total=8
   > 
   > # Max idle connections in connection pool
   > kylin.query.pushdown.jdbc.pool-max-idle=8
   > 
   > # Min idle connections in connection pool
   > kylin.query.pushdown.jdbc.pool-min-idle=0
   > ```

**Note:**

- If Kerberos is configured, the principal information should also be added.

  ```properties
  kylin.query.pushdown.jdbc.url=jdbc:hive2://sandbox:10000/default;principal=hive/host@hadoop.com
  ```

  In addition to this, the principal should be consistent with the value of `hive.server2.authentication.kerberos.principal` in `hive-site.xml` and the `host` should be replaced by the host name of `HiverServer2`, such as

  ```properties
  kylin.query.pushdown.jdbc.url=jdbc:hive2://127.0.0.1:10000/default;principal=hive/cdh-54-02@hadoop.com
  ```

