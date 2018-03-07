## Use JDBC (SQL Server) to connect other database as metastore

KAP Plus uses KyStorage to store cube data, therefor hbase only works as a storage for metadata. From KAP 2.4.x, KAP supports storing metadata to other databases with JDBC.

### Config metadata in the form of JDBC

Steps below are with the case of SQL Server:

1. Create database  `kylin` in SQL Server.

2. In KAP's installation directory, set configuration item `kylin.metadata.url` of configuration file `$KYLIN_HOME/conf/kylin.properties`  to`{metadata_name}@jdbc`,
   replace `{metadata_name}` as user's metadata name, for example,  `kylin_default_instance@jdbc` .

3. Set configuration items for JDBC, for example: `kylin.metadata.jdbc.dialect=sqlserver` `kylin.metadata.url=kylin_default_instance@jdbc,url=jdbc:sqlserver://localhost:1433;database=kylin,username=sa,password=sa,driverClassName=com.microsoft.sqlserver.jdbc.SQLServerDriver,maxActive=10,maxIdle=10` .

    All items are as below, configs for `url`, `username` and `password` must be set. For others, if not set, default values will be used:

    *url*: JDBC's url;

    *username*: JDBC's username;

    *password*: JDBC's password;

    *driverClassName*: jdbc's driver class name, default value is `com.mysql.jdbc.Driver`;

    *maxActive*: max number of database's connection number, default value is `5`;

    *maxIdle*: max number of database's waiting connection number, default value is `5`;

    *maxWait*: max waiting milliseconds for connecting, default value is `1000`;

    *removeAbandoned*: whether remove timeout connection automatically, default value is `true`;

    *removeAbandonedTimeout*: timeout milliseconds, default value is `300`；

4. Check the JAVA version of the environment and prepare the JDBC Driver for it ，then copy the JDBC Driver to `$KYLIN_HOME/ext` , for example, `$KYLIN_HOME/ext/sqljdbc41.jar` for JRE7.

5. For metadta doesn't depend on hbase, user is required to add configuration item `kylin.env.zookeeper-connect-string` of configuration file `$KYLIN_HOME/conf/kylin.properties` to zookeeper's url and port. If the server of KAP installs zookeeper as well, it can be set as `kylin.env.zookeeper-connect-string=localhost:2181` .

6. Start KAP.

