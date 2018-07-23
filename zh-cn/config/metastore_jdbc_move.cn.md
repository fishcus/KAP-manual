## 将 metadata 从 HBase 迁移至 JDBC

### 迁移方法

1. 将 `$KYLIN_HOME/conf/kylin.properties` 的 metadata 配置项 `kylin.metadata.url` 修改为待迁移的 HBase metadata 配置，如：`kylin_default_instance@hbase` 。
2. 运行 `$KYLIN_HOME/bin/metastore.sh backup` 命令备份 metadata，获取备份地址 。
3. 将 metadata 配置改为 JDBC 配置 。
4. 运行 `$KYLIN_HOME/bin/metastore.sh restore /path/to/backup` 的 restore 命令实现 metadata 的迁移，如 `metastore.sh restore meta_backups/meta_2016_06_10_20_24_50` 。