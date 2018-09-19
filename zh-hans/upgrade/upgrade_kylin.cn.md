## 从 Apache Kylin 2.3+ 升级至 Kyligence Enterprise 3.X

Kyligence Enterprise 是基于 Apache Kylin 的商业版产品，支持从 Apache Kylin 快速便捷地升级至 Kyligence Enterprise。需要注意的是 Kyligence Enterprise 使用了全新的存储引擎 KyStorage。因此从 Apache Kylin 升级至 Kyligence Enterprise 时，需要对存储引擎进行相关的升级。具体升级步骤如下：

### 升级步骤

1. 停止正在运行的 Apache Kylin 实例：

   ```shell
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```

2. 备份 Kylin 安装目录和元数据：

   ```shell
   cp -r $KYLIN_HOME ${KYLIN_HOME}.backup
   $KYLIN_HOME/bin/metastore.sh backup
   ```

3. 解压缩 Kyligence Enterprise 安装包。更新 `KYLIN_HOME` 环境变量值：

   ```shell
   tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
   export KYLIN_HOME={your-unpack-folder}
   ```

4. 修改配置参数：

   Kyligence Enterprise 中提供了两套配置参数：`conf/profile_prod/`和`conf/profile_min/`，默认情况下选择前者。如果是在沙箱等资源较为紧缺的环境下运行 Kyligence Enterprise，请执行如下操作将配置参数切换至`conf/profile_min/`：

   ```shell
   rm $KYLIN_HOME/conf/profile
   ln -s $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
   ```

5. 更新配置文件：

   * 手动地将在老版本`$KYLIN_HOME/conf`中的改动在新版本的`$KYLIN_HOME/conf`中重做一遍。

   * 手动地将在老版本`$KYLIN_HOME/bin/setenv.sh`中的改动在新版本的`$KYLIN_HOME/conf/setenv.sh`中重做一遍。

   > 请注意：
   >
   > * `setenv.sh`的目录发生了改变，在 Kyligence Enterprise 中该文件夹位于`$KYLIN_HOME/conf`下
   >
   > * 配置文件并不完全兼容，请不要直接拷贝替换配置文件
   >
   > * 如果需要继承已有的元数据，需要在 `$KYLIN_HOME/conf/kylin.properties` 修改以下配置
   >
   >   ```properties
   >   kylin.metadata.url = {your_kylin_metadata_url}
   >   ```

6. 由于在 Kyligence Enterprise 中 Cube 允许设置一些高级设置，因此需要您手动地刷新 Cube 信息：

   ```shell
   $KYLIN_HOME/bin/metastore.sh refresh-cube-signature
   ```

7. 由于在 Kyligence Enterpise 引入了用户组的概念，因此需要对 Apache Kylin 中的用户进行升级操作：

   ```shell
   $KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.metadata.UserAuthorityUpgraderCLI
   ```

   升级完成后，还需要对 ADMIN 用户进行密码重置：

   ```shell
   $KYLIN_HOME/bin/kylin.sh admin-password-reset
   ```

8. 启动Kyligence Enterprise实例：

   ```shell
   $KYLIN_HOME/bin/kylin.sh start
   ```

9. 升级 Cube 存储引擎：

  升级后新建的 Cube 默认使用 KyStorage 作为存储引擎，原先的 Cube 则使用 HBase 作为存储引擎。如果您还想继续保留之前的 Cube，可以按照如下步骤进行升级并**重新构建**：

  - 备份当前元数据至`$KYLIN_HOME/meta_backups/<path_of_BACKUP_FOLDER>`路径下：

    ```shell
    $KYLIN_HOME/bin/metastore.sh backup
    ```

  - 对`meta_backups/`路径下的元数据进行升级以使其适应KyStorage：

    ```shell
    $KYLIN_HOME/bin/metastore.sh promote $KYLIN_HOME/meta_backups/<path_of_BACKUP_FOLDER>
    ```

  - 将`meta_backups/`路径下的元数据恢复以覆盖原先的元数据：

    ```shell
    $KYLIN_HOME/bin/metastore.sh restore $KYLIN_HOME/meta_backups/<path_of_BACKUP_FOLDER>
    ```

  - 在Kyligence Enterprise GUI上重载元数据后，手动清理所有Cube中的数据并重新构建。 