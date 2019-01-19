## Use MySQL as Metastore

### Prerequisites

1. Kyligence Enterprise  has prepared a 5.1.41 version of MySQL JDBC driver, which is contained in `$KYLIN_HOME/lib/kap-ext-{version}.jar `.
2. If you are using a different version of the MySQL JDBC driver, please put the driver in `$KYLIN_HOME/ext/`.

### Configuration Steps

The following steps illustrate how to connect MySQL as metastore. Here is an example for MySQL 5.1.41.

1. Create database `kylin` in MySQL

2. Set configuration item `kylin.metadata.url = {metadata_name}@jdbc` in `$KYLIN_HOME/conf/kylin.properties`,
   please replace `{metadata_name}` with your metadata name in MySQL, for example, `kylin_default_instance@jdbc`.

   > If the metadata name doesn't exist, it will be automatically created it in MySQL. Otherwise, Kyligence Enterprise will use the existing ones.

   For example: `kylin.metadata.url=kylin_default_instance@jdbc,url=jdbc:mysql://localhost:3306/kylin,username=root,password=,maxActive=10,maxIdle=10`.

   If you need to use MySQL cluster for load balance, please add the parameter in the connect string. For example,

   `kylin.metadata.url=kylin_default_instance@jdbc,url=jdbc:mysql:loadbalance://host1:port1,host2:port2/kylin,username=root,password=root,maxActive=20,maxIdle=20`

   The meaning of each parameter is as below,  `url`, `username`, and `password` are required parameters. For others, default values will be used if they are not indicated.

     **url**: JDBC's url;

     **username**: JDBC's username;

     **password**: JDBC's password;

     **driverClassName**: JDBC's driver class name, default value is `com.mysql.jdbc.Driver`;

     **maxActive**: max number of database's connection number, default value is `5`;

     **maxIdle**: max number of database's waiting connection number, default value is `5`;

     **maxWait**: max waiting milliseconds for connecting, default value is `1000`;

     **removeAbandoned**: whether remove timeout connection automatically, default value is `true`;

     **removeAbandonedTimeout**: timeout milliseconds, default value is `300`;

     **passwordEncrypted**: whether JDBC's password is encrypted，default value is `false`；

3. To encrypt the password, you can run the following command in `$KYLIN_HOME/tomcat/webapps/kylin/WEB-INF/lib`

   ```shell
   java -classpath kap.jar:spring-beans-4.3.10.RELEASE.jar:spring-core-4.3.10.RELEASE.jar:commons-codec-1.7.jar org.apache.kylin.rest.security.PasswordPlaceholderConfigurer AES <your_password>
   ```

4. It is required to add the zookeeper connection configuration `kylin.env.zookeeper-connect-string=host:port` in `$KYLIN_HOME/conf/kylin.properties`, such as  `kylin.env.zookeeper-connect-string=localhost:2181`, because the metadata has no dependency on HBase.

5. Start Kyligence Enterprise

### How to Migrate Metadata from HBase to Relational Database

For more details, please refer to [Migrate Metadata from HBase to Relational Database](../rdbms_metastore/migrate_metastore_to_rdbms.en.md)

