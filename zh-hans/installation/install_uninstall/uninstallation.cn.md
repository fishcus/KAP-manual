## 卸载




在本节中，我们将为您介绍卸载 Kyligence Enterprise 的步骤。

完整卸载 Kyligence Enterprise 并清除所有相关数据的步骤如下：

1. 在所有 Kyligence Enterprise 节点上运行下述命令以停止 Kyligence Enterprise 实例： 

   ```shell
   $KYLIN_HOME/bin/kylin.sh stop
   ```

2. （可选的）数据清理和备份

   - 为确保 Kyligence Enterprise 在外部系统中的一些临时数据被删除，建议在正式卸载前先执行[垃圾清理](/operation/storage_cleanup.cn.md)操作。
   - 为以防万一，可以完全卸载前先备份元数据，以便在需要的时候恢复：
      ```shell
      $KYLIN_HOME/bin/metastore.sh backup
      ```

      > 提示：我们建议您在随后将元数据拷贝至更可靠的存储设备上。

3. 请您查看 `$KYLIN_HOME/conf/kylin.properties` 配置文件以确定工作目录的名称。假设您的相应配置项为：

   ```properties
   kylin.hdfs.working.dir=/kylin
   ```

   请您运行下述命令删除工作目录：

   ```shell
   hdfs dfs -rm -r /kylin
   ```

4. 请您查看 `$KYLIN_HOME/conf/kylin.properties` 配置文件以确定元数据表的名称。假设您的相应配置项为：

   ```properties
   kylin.metadata.url=kylin_metadata@hbase
   ```

   请您运行下述命令删除源数据表：

   ```shell
   hbase shell
   disable_all "kylin_metadata.*"
   drop_all "kylin_metadata.*"
   ```

5. 在所有 Kyligence Enterprise 节点上运行下述命令以删除 Kyligence Enterprise 安装：

   ```shell
   rm -rf $KYLIN_HOME
   ```


至此，Kyligence Enterprise 卸载完成。
