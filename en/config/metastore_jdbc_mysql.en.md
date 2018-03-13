## Use JDBC to connect MySQL as metastore



### Prepare JDBC Driver

1. KAP has 5.4.1 version of MySQL JDBC driver that drives in the `$KYLIN_HOME/ext ` directory.
2. If you are using another relational database , prepare the corresponding JDBC driver and place it in the `$KYLIN_HOME/ext` directory.
3. If you are using a different version of the MySQL JDBC driver, replace the `$KYLIN_HOME/ext/mysql-connector-java-5.1.41.jar`.

### Config metadata in the form of JDBC

Steps below are with the case of MYSQL:

1. Install KAP Plus

2. Create database `kylin` in MYSQL

3. In KAP's installation directory, set configuration item `kylin.metadata.url` of configuration file `$KYLIN_HOME/conf/kylin.properties` to `{metadata_name}@jdbc`,
   replace `{metadata_name}` as user's metadata name, for example, `{metadata_name}@jdbc`. 

4. Set configuration items for JDBC, for example: `kylin.metadata.url=kylin_default_instance@jdbc,url=jdbc:mysql://localhost:3306/kylin,username=root,password=,maxActive=10,maxIdle=10`. 
   All items are as below, configs for `url`, `username` and `password` must be set. For others, if not set, default values will be used:

     *url*: JDBC's url;

     *username*: JDBC's username;

     *password*: JDBC's password;

     *driverClassName*: JDBC's driver class name, default value is `com.mysql.jdbc.Driver`;

     *maxActive*: max number of database's connection number, default value is `5`;

     *maxIdle*: max number of database's waiting connection number, default value is `5`;

     *maxWait*: max waiting milliseconds for connecting, default value is `1000`;

     *removeAbandoned*: whether remove timeout connection automatically, default value is `true`;

     *removeAbandonedTimeout*: timeout milliseconds, default value is `300`;
     
     *passwordEncrypted*: whether JDBC's password is encrypted，default value is `false`；
     
5. Under directory `$KYLIN_HOME/tomcat/webapps/kylin/WEB-INF/lib`, run command `java -classpath kap.jar:spring-beans-4.3.10.RELEASE.jar:spring-core-4.3.10.RELEASE.jar:commons-codec-1.7.jar org.apache.kylin.rest.security.PasswordPlaceholderConfigurer AES <your_password>` to get the encrypted value

6. Copy the JDBC connector jar to $KYLIN_HOME/ext

7. For metadta doesn't depend on HBase, user is required to add configuration item `kylin.env.zookeeper-connect-string` of configuration file `$KYLIN_HOME/conf/kylin.properties` to zookeeper's url and port. If the server of KAP installs zookeeper as well, it can be set as `kylin.env.zookeeper-connect-string=localhost:2181`

8. Start KAP

### How to migrate metadata from HBase to JDBC

1. Set configuration item `kylin.metadata.url` of configuration file `$KYLIN_HOME/conf/kylin.properties` to the HBase metadata to be migrated
2. Run `$KYLIN_HOME/bin/metastore.sh backup` to backup metadata, and get the backup path
3. Set the metadata's settings to JDBC
4. Run `$KYLIN_HOME/bin/metastore.sh restore /path/to/backup` to restore metadata, for example `metastore.sh restore meta_backups/meta_2016_06_10_20_24_50`
