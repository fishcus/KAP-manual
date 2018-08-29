## 检查运行环境

Kyligence Enterprise 运行在 Hadoop 集群上，对各个组件的版本、访问权限及 CLASSPATH 等都有一定的要求。因此 Kyligence Enterprise 在运行时，为了避免遇到各种环境问题，提供了环境检测的功能。

```shell
cd $KYLIN_HOME
bin/check-env.sh
```

当初次启动 Kyligence Enterprise 时，`check-env.sh` 将自动运行。

### 检查步骤的详细说明

- Checking Kerberos
  如果启用 Kerberos，检查 `kinit` 能正常登录。
- Checking Hadoop Configuration
  检查能找到 Hadoop 配置文件目录 (HADOOP_CONF_DIR)。


- Checking Permission of HBase's Table
  检查当前用户是否对 HBase 的表有读写权限。


- Checking Permission of HBase's Root Dir
  检查当前用户能访问 HBase 根目录。


- Checking Permission of HDFS Working Dir
  检查当前用户是否对 Kyligence Enterprise 工作目录 (`kylin.env.hdfs-working-dir`) 有读写权限。


- Checking Hive Classpath
  检查 Hive Classpath，特别是 HCatalog 类库是否存在。


- Checking Hive Usages
  检查当前用户是否对 Hive 有读写权限，包括 Hive 表的创建、插入、删除等。同时检查是否可以通过 HCatalog 读取 Hive 数据。


- Checking Java Version
  检查 Java 版本，并确定版本高于 1.8。


- Checking JDBC Usages
  如果配置了 JDBC 为元数据存储，检查当前环境的 JDBC 数据库是否可用。


- Checking Legacy Sample Cubes
  检查老版本的 Sample Cube 是否需要更新。
- Checking ACL Migration Status
  检查老版本的 ACL 元数据是否需要迁移，并在需要时给出迁移的方法。


- Checking OS Commands
  检查当前环境是否支持需要的系统命令。


- Checking Ports Availability
  检查当前环境下，Kyligence Enterprise 需要的服务端口是否可用。如被占用，则需要释放被占用端口或者修改 Kyligence Enterprise 使用的服务端口。


- Checking Snappy Availability
  检测当前环境是否支持 Snappy 压缩，主要是测试 Snappy 是否在 MapRecude 任务中可用。


- Checking Spark Availablity
  检查 Spark 是否可用。同时读取环境中 YARN 的资源信息，检查 `kylin.properties` 里关于 Spark Executor 的资源配置是否合理，并给出相关建议。
- Checking Metadata Accessibility
  检查元数据能正常读写。

