## 使用 MySQL 作为元数据存储

### 准备工作

1. Kyligence Enterprise 自带 MySQL 5.1.41 的 JDBC 驱动，该驱动包含在 `$KYLIN_HOME/lib/kap-ext-{version}.jar` 中 。
2. 如果使用其他版本的 MySQL，请准备对应的 JDBC 驱动, 并放置到 `$KYLIN_HOME/ext` 目录下。

### 配置方法
以下以 MySQL 5.1.41 为例说明配置步骤：
1. 在 MySQL 数据库中新建名为 `kylin` 的数据库

2. 在 Kyligence Enterprise 安装目录下的 `$KYLIN_HOME/conf/kylin.properties` 配置文件中，配置 `kylin.metadata.url = {metadata_name}@jdbc`，`{metadata_name}` 需要替换为您需要的元数据表名，如 `kylin_default_instance@jdbc`。

   > 如果该表已存在，则会使用现有的表；如果不存在，则会自动创建该表。

   具体示例如下：

   `kylin.metadata.url=kylin_default_instance@jdbc,url=jdbc:mysql://localhost:3306/kylin,username=root,password=,maxActive=20,maxIdle=20`。

   如需使用 MySQL Cluster 支持负载均衡时，需要在连接字符串中加入该参数，具体示例如下：

   `kylin.metadata.url=kylin_default_instance@jdbc,url=jdbc:mysql:loadbalance://host1:port1,host2:port2/kylin,username=root,password=root,maxActive=20,maxIdle=20`

   各配置项的含义如下，其中 `url`，`username` 和 `password` 为必须配置项，其余项若不配置将使用默认配置值：

    **url**：JDBC 的 url；
    **username**：JDBC 的用户名；

    **password**：JDBC 的密码；

    **driverClassName**：JDBC 的 driver 类名，默认值为 `com.mysql.jdbc.Driver`；

    **maxActive**：最大数据库连接数，默认值为 `5`；

    **maxIdle**：最大等待中的连接数量，默认值为 `5`；

    **maxWait**：最大等待连接毫秒数，默认值为 `1000`；

    **removeAbandoned**：是否自动回收超时连接，默认值为 `true`；

    **removeAbandonedTimeout**：超时时间秒数，默认为 `300`；

    **passwordEncrypted**: 是否对 JDBC 密码进行加密，默认为 `false`；

3. 如果您需要对 JDBC 的密码进行加密，请在 `$KYLIN_HOME/tomcat/webapps/kylin/WEB-INF/lib` 目录下运行如下命令：

   ```shell
   java -classpath kap.jar:spring-beans-4.3.14.RELEASE.jar:spring-core-4.3.14.RELEASE.jar:commons-codec-1.7.jar org.apache.kylin.rest.security.PasswordPlaceholderConfigurer AES <your_password>
   ```

4. 由于元数据不依赖于 HBase，所以需要在配置文件 `$KYLIN_HOME/conf/kylin.properties` 中添加 zookeeper 的连接项 `kylin.env.zookeeper-connect-string=host:port`，如 `kylin.env.zookeeper-connect-string=localhost:2181`。

5. 启动 Kyligence Enterprise

### 将元数据从 HBase 迁移至关系型数据库

迁移方法可参考：[将元数据从 HBase 迁移至关系型数据库](../rdbms_metastore/migrate_metastore_to_rdbms.cn.md)

