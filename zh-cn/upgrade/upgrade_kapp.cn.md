## 从 KAP Plus 2.x 升级至 Kyligence Enterprise 3.x 最新版本 ##

从 3.x 开始，Kyligence Analytics Platform (KAP) 正式改名为 Kyligence Enterprise。

KAP Plus 2.x 与更高版本之间兼容元数据。因此在从 KAP Plus 2.x 升级至更高版本时，无需对元数据进行升级，只需要覆盖软件包、更新配置文件即可。

### 升级准备工作 ###

1. 为了获得更佳的查询性能，升级过程中将对 Cube 和 Segment 进行升级。作为先决条件，**请确保没有处于构建状态的 Segment，构建状态包括等待、运行、错误和暂停**。

2. 停止所有 KAP 服务，确保没有活动的 KAP 进程影响升级。

3. 本产品要求 JDK 8 或更高，您可以通过以下命令查看 JDK 版本。如果您的 JDK 版本不满足要求，请留意下面升级文档中的额外步骤。

   ```bash
   java -version
   ```
### 具体升级步骤 ###

1. 停止并确认没有正在运行的 KAP 进程：

   ```shell
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```

2. 备份 KAP 安装目录和元数据：

   ```shell
   cp -r $KYLIN_HOME ${KYLIN_HOME}.backup
   $KYLIN_HOME/bin/metastore.sh backup
   ```

3. 解压缩新版本的 Kyligence Enterprise 安装包，更新 KYLIN_HOME 环境变量：

   ```shell
   tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
   export KYLIN_HOME={your-unpack-folder}
   ```

4. 更新配置文件。

   从 KAP 2.4 及以上版本升级：

   * 将老版本中`$KYLIN_HOME/conf`文件拷贝并覆盖到新版本中的 `$KYLIN_HOME/conf`中。
   * 在`conf/kylin.properties`中删除`kylin.server.init-tasks`这一行。 

   从 KAP 2.3 及以下版本升级：

   > 注意，对于 KAP 2.3 以下版本
   >    * `setenv.sh`的目录发生了改变，2.4 版本后位于`$KYLIN_HOME/conf`下
   >    * 配置文件并不完全兼容，请不要直接拷贝替换配置文件

   * 手动地将在老版本`$KYLIN_HOME/conf`中的改动在新版本的`$KYLIN_HOME/conf`中重做一遍。

   * 手动地将在老版本`$KYLIN_HOME/bin/setenv.sh`中的改动在新版本的`$KYLIN_HOME/conf/setenv.sh`中重做一遍。

   * 在`$KYLIN_HOME/conf/kylin.properties`中删除`kylin.server.init-tasks`这一行。 

   * 手动地对ACL数据进行迁移，执行下述命令：

     ```shell
     $KYLIN_HOME/bin/kylin.sh org.apache.kylin.tool.AclTableMigrationCLI MIGRATE
     ```

5. 如果您的 Hadoop 集群为 JDK 7

   请执行 [如何在低版本 JDK 上运行 Kyligence Enterprise](../installation/about_low_version_jdk.cn.md) 中的配置步骤。

6. 启动 Kyligence Enterprise。

   在第一次启动过程中，Kyligence Enterprise 会对 Cube 和 Segment 进行自动升级。升级时间取决于您的数据大小，可能达到一个小时或更久。

   ```shell
   $KYLIN_HOME/bin/kylin.sh start
   ```

   升级成功后，将在命令行提示：
   ```
   Segments have been upgraded successfully.
   ```

7. 至此升级成功。

   之前备份的 KAP 安装目录和元数据可以安全删除。

### 升级 FAQ ###

**Q：如果我的 Hadoop 集群用的是 JDK 7，还可以升级到 Kyligence Enterprise 吗？**

可以。请参考 [如何在低版本 JDK 上运行 Kyligence Enterprise](../installation/about_low_version_jdk.cn.md)。

**Q：需要我手动升级 Cube 和 Segment 吗？**

不需要，在您第一次启动 Kyligence Enterprise 时，会自动执行升级操作。

**Q：如何确定升级成功还是失败？**

升级后第一次启动过程中，会有以下提示：

   * 升级成功后将会提示

     ```
     Segments have been upgraded successfully.
     ```

   * 失败则会提示
     ```
     Upgrade failed. Please try to run
     bin/kylin.sh io.kyligence.kap.tool.migration.ProjectDictionaryMigrationCLI FIX
     to fix.
     ```

**Q：升级 Cube 和 Segment 失败如何处理？**

如果升级 Cube 和 Segment 失败，请运行如下命令进行修复：
```bash
bin/kylin.sh io.kyligence.kap.tool.migration.ProjectDictionaryMigrationCLI FIX
```
修复成功后，将会看到 “Segments have been upgraded successfully” 提示。如果修复任然失败，请您联系Kyligence Support。

**Q：假如升级不成功，如何回滚到原版本？**

如果在升级前有备份 KAP 安装目录和元数据，可以按以下步骤回滚：

   * 停止并确认没有正在运行的 KAP 进程：

     ```shell
     $KYLIN_HOME/bin/kylin.sh stop
     ps -ef | grep kylin
     ```

   * 恢复原 KAP 安装目录

     ```shell
     rm -rf $KYLIN_HOME
     cp -r ${KYLIN_HOME}.backup $KYLIN_HOME
     ```

   * 恢复元数据

     ```shell
     $KYLIN_HOME/bin/metastore.sh restore {your-backup-metadata-folder}
     ```

   * 回滚完毕，重新启动原 KAP

     ```shell
     $KYLIN_HOME/bin/kylin.sh start
     ```
