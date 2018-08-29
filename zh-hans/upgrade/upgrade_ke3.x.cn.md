## 从 Kyligence Enterprise 3.x 升级至最新版本 ##

Kyligence Enterprise 与更高版本之间兼容元数据。因此在从 Kyligence Enterprise 3.x 升级至更高版本时，无需对元数据进行升级，只需要覆盖软件包、更新配置文件即可。

### 升级准备工作 ###

1. 停止所有 Kyligence Enterprise 服务，确保没有活动的 Kyligence Enterprise 进程影响升级。

### 具体升级步骤 ###

1. 停止并确认没有正在运行的 Kyligence Enterprise 进程：

   ```shell
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```

2. 备份 Kyligence Enterprise 安装目录和元数据：

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

   * 将老版本中 `$KYLIN_HOME/conf` 文件拷贝并覆盖到新版本中的 `$KYLIN_HOME/conf` 中。
   * 在`conf/kylin.properties`中删除`kylin.server.init-tasks`这一行。 

5. 如果当前部署方式为[通过 Redis 共享信息的集群部署](../installation/advancing_installation/advancing_installation_load_balance.cn.md)，您还需要进行以下操作：

   * 将老版本中 `$KYLIN_HOME/tomcat/lib/` 目录下 Redis 相关 jar 包拷贝到新版本对应的位置。
   * 将老版本中 `$KYLIN_HOME/tomcat/context.xml` 文件拷贝并覆盖到新版本对应的位置。

6. 启动 Kyligence Enterprise。

   ```shell
   $KYLIN_HOME/bin/kylin.sh start
   ```

7. 至此升级成功。

   之前备份的 Kyligence Enterprise 安装目录和元数据可以安全删除。

### 升级 FAQ ###

**Q：假如升级不成功，如何回滚到原版本？**

如果在升级前有备份 Kyligence Enterprise 安装目录和元数据，可以按以下步骤回滚：

   * 停止并确认没有正在运行的 Kyligence Enterprise 进程：

     ```shell
     $KYLIN_HOME/bin/kylin.sh stop
     ps -ef | grep kylin
     ```

   * 恢复原 Kyligence Enterprise 安装目录

     ```shell
     rm -rf $KYLIN_HOME
     cp -r ${KYLIN_HOME}.backup $KYLIN_HOME
     ```

   * 恢复元数据

     ```shell
     $KYLIN_HOME/bin/metastore.sh restore {your-backup-metadata-folder}
     ```

   * 回滚完毕，重新启动原 Kyligence Enterprise

     ```shell
     $KYLIN_HOME/bin/kylin.sh start
     ```
