##基于关系型数据库（SQL Server）的Metastore配置
Kylin 使用 HBase 作为 Metastore 存储数据库，KAP 2.4+ 版本可以支持关系型数据库作为 Metastore 存储，使用标准 JDBC Driver 连接 Metastore 数据库。

###配置方法
以下为以 SQL Server 作为 Metastore 的配置步骤：
1. 在 SQL Server 数据库中新建名为 `kylin` 的数据库。

2. 在 KAP 安装目录下的 `$KYLIN_HOME/conf/kylin.properties` 配置文件中，将 `kylin.metadata.url` 修改为用户的 metadata 数据表名，如 `kylin_default_instance@jdbc` 。如果表已存在，则会使用现有表；如果不存在，则会自动创建新表。

3. 设置 JDBC 连接字符串及其他配置项，完整例子如下：`kylin.metadata.jdbc.dialect=sqlserver` `kylin.metadata.url=kylin_default_instance@jdbc,url=jdbc:sqlserver://localhost:1433;database=kylin,username=sa,password=sa,driverClassName=com.microsoft.sqlserver.jdbc.SQLServerDriver,maxActive=10,maxIdle=10`  。

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

4. 核对运行环境 Java 版本，准备相对应的 JDBC 驱动程序, 如：对应 JRE7 的SQL Server JDBC 驱动程序为 `sqljdbc41.jar` ， 并将相对应的 SQL Server JDBC 驱动程序的 Jar 包拷贝至 `$KYLIN_HOME/ext`  目录下。

5. 由于 metadata 不依赖于 Hbase，所以需要在配置文件 `$KYLIN_HOME/conf/kylin.properties` 中添加 zookeeper 的连接项 `kylin.env.zookeeper-connect-string`，若部署 KAP 的 server 同时部署有zookeeper，可配置为 `kylin.env.zookeeper-connect-string=localhost:2181` 。

6. 启动KAP。

### 如何将 metadata 从 hbase 迁移至 JDBC

1. 将 `$KYLIN_HOME/conf/kylin.properties` 的 metadata 配置项 `kylin.metadata.url` 修改为待迁移的 hbase metadata 配置，如：`kylin_default_instance@hbase` 。
2. 运行 `$KYLIN_HOME/bin/metastore.sh backup` 命令备份 metadata，获取备份地址 。
3. 将 metadata 配置改为 JDBC 配置 。
4. 运行 `$KYLIN_HOME/bin/metastore.sh restore /path/to/backup` 的 restore 命令实现 metadata 的迁移，如 `metastore.sh restore meta_backups/meta_2016_06_10_20_24_50` 。