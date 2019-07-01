## Pushdown to Hive

Kyligence Enterprise uses Hive as cube's data source. Meanwhile, Hive can also be configured as Query Pushdown's backup query engine. For cases sqls which cannot be answered by cube, or no response time required cases, Kyligence Enterprise can push down such sqls to hive when no cubes are matched.

####Query Pushdown config

1. In Kyligence Enterprise's installation directory, uncomment configuration item `kylin.query.pushdown.runner-class-name` of config file `kylin.properties`, and set it to `org.apache.kylin.query.adhoc.PushDownRunnerJdbcImpl`

2. Add configuration items below in config file `kylin.properties` and restart. Configs for `kylin.query.pushdown.jdbc.url`, `kylin.query.pushdown.jdbc.driver` and `kylin.query.pushdown.jdbc.username` must be set. For others, if not set, default values will be used

   ```properties
   #Hive Jdbc's url, for example, jdbc:hive2://sandbox:10000/default
   kylin.query.pushdown.jdbc.url
   
   #Hive Jdbc's driver class name, for example, org.apache.hive.jdbc.HiveDriver
   kylin.query.pushdown.jdbc.driver
   
   #Hive Jdbc's user name
   kylin.query.pushdown.jdbc.username
   
   #Hive Jdbc's password, default value is empty string
   kylin.query.pushdown.jdbc.password
   
   #Hive Jdbc's connection pool's max connected connection number, default value is 8
   kylin.query.pushdown.jdbc.pool-max-total
   
   #Hive Jdbc's connection pool's max waiting connection number, default value is 8
   kylin.query.pushdown.jdbc.pool-max-idle
   
   #Hive Jdbc's connection pool's min waiting connected connection number, default value is 0
   kylin.query.pushdown.jdbc.pool-min-idle
   ```

Note:

1. If kerberos is configured, the principal should be the value of the configuration item 'hive.server2.authentication.kerberos.principal' in the cluster hive-site.xml, 'hive/[_HOST@hadoop-r.com](mailto:_HOST@ Hadoop-r.com)', _HOST is replaced with the hostname where hiveserver2 is deployed

   > For example：
   > kylin.query.pushdown.jdbc.url=jdbc:hive2://127.0.0.1:10000/default;principal=hive/cdh-54-02@hadoop-r.com

2. To configure the Pushdown to Hive at HDP, you need to delete the configuration items in hive-site.xml:

   ><property>
   ><name>hive.exec.post.hooks</name>
   ><value>org.apache.atlas.hive.hook.HiveHook</value>
   ></property>