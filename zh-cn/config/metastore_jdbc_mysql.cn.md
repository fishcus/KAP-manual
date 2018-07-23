## 基于关系型数据库（MySQL）的 Metastore 配置

Kyligence Enterprise支持基于MySQL 5.1.41进行Metastore配置。

### 将 metadata 从 HBase 迁移至关系型数据库

迁移方法可参考：[将 metadata 从 HBase 迁移至关系型数据库](.\metastore_jdbc_move.cn.md)

### 准备 JDBC Driver

  1. Kyligence Enterprise 自带 MySQL 5.1.41 的 JDBC 驱动，该驱动包含在`$KYLIN_HOME/lib/kap-ext-{version}.jar`中 。
  2. 如果使用的是其他关系型数据库，请准备对应的 JDBC 驱动,并放置到  `$KYLIN_HOME/ext` 目录下。
  3. 如果使用的是其他关系型数据库或使用其他版本的MySQL JDBC driver，请准备对应的 JDBC 驱动, 并放置到 `$KYLIN_HOME/ext` 目录下 。

### 配置方法
以下以 MySQL 为例说明配置步骤
1. 在 MySQL 数据库中新建名为 `kylin` 的数据库

2. 在 Kyligence Enterprise 安装目录下的 `$KYLIN_HOME/conf/kylin.properties` 配置文件中，将 `kylin.metadata.url` 修改为 `{metadata_name}@jdbc`，`{metadata_name}` 修改为用户的 metadata 数据表名，如 `kylin_default_instance@jdbc`。如果表已存在，则会使用现有表；如果不存在，则会自动创建新表。

3. 设置JDBC连接字符串及其他配置项，完整例子如：`kylin.metadata.url=kylin_default_instance@jdbc,url=jdbc:mysql://localhost:3306/kylin,username=root,password=,maxActive=10,maxIdle=10`。

   配置项的含义如下，其中`url`，`username`和`password`为必须配置项，其余项若不配置将使用默认配置项：

     *url*：JDBC 的url；
     *username*：JDBC 的用户名；

     *password*：JDBC 的密码；

     *driverClassName*：JDBC 的 driver 类名，默认值为 `com.mysql.jdbc.Driver`；

     *maxActive*：最大数据库连接数，默认值为 `5`；

     *maxIdle*：最大等待中的连接数量，默认值为 `5`；

     *maxWait*：最大等待连接毫秒数，默认值为 `1000`；

     *removeAbandoned*：是否自动回收超时连接，默认值为 `true`；

     *removeAbandonedTimeout*：超时时间秒数，默认为 `300`；
   
     *passwordEncrypted*: 是否对JDBC密码进行了加密，默认为 `false`；
   
4. 对JDBC的密码进行加密方法为：在`$KYLIN_HOME/tomcat/webapps/kylin/WEB-INF/lib`目录下运行`java -classpath kap.jar:spring-beans-4.3.10.RELEASE.jar:spring-core-4.3.10.RELEASE.jar:commons-codec-1.7.jar org.apache.kylin.rest.security.PasswordPlaceholderConfigurer AES <your_password>`

5. 将 JDBC 的 connector jar 包拷贝至 $KYLIN_HOME/ext

6. 由于 metadata 不依赖于 hbase，所以需要在配置文件 `$KYLIN_HOME/conf/kylin.properties` 中添加 zookeeper 的连接项 `kylin.env.zookeeper-connect-string`，若部署 Kyligence Enterprise 的 server 同时部署有
   zookeeper，可配置为 `kylin.env.zookeeper-connect-string=localhost:2181`

7. 启动 Kyligence Enterprise

