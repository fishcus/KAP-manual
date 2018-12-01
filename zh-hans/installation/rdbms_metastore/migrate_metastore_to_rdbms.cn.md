## 将元数据从 HBase 迁移至 RDBMS

### 迁移方法

1. 运行元数据备份命令，备份元数据。

   ```shell
   $KYLIN_HOME/bin/metastore.sh backup 
   ```

2. 将元数据配置改为 JDBC 配置，具体步骤请参考对应的手册章节。

3. 配置完成后，启动 Kyligence Enterprise。如正常启动，则表示配置正确。

   ```shell
   $KYLIN_HOME/bin/kylin.sh start
   ```

4. 运行元数据恢复指令，进行元数据迁移。

   ```shell
   $KYLIN_HOME/bin/metastore.sh restore {path_to_backup}
   ```

