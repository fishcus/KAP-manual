## 从 Apache Kylin 升级

Kyligence Enterprise 是基于 Apache Kylin 的商业版产品，本章介绍如何从 Apache Kylin v2.3+ 快速便捷地升级至最新版本的 Kyligence Enterprise 3.x 软件。 


### 准备工作

- 停止正在运行的 Apache Kylin 实例：
  ```shell
  $KYLIN_HOME/bin/kylin.sh stop
  ```

  确认示例已停止：

  ```shell
  ps -ef | grep kylin
  ```

- 备份 Kylin 安装目录和元数据：

  ```shell
  cp -r $KYLIN_HOME ${KYLIN_HOME}.backup
  $KYLIN_HOME/bin/metastore.sh backup
  ```

- 解压缩 Kyligence Enterprise 安装包。更新 `KYLIN_HOME` 环境变量值：

  ```shell
  tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
  export KYLIN_HOME={your-unpack-folder}
  ```


### 配置修改

- 快速配置 Kyligence Enterprise

  Kyligence Enterprise 中提供了两套配置参数：`$KYLIN_HOME/conf/profile_prod` 和 `$KYLIN_HOME/conf/profile_min`。前者是默认方案，适用于实际生产环境；后者使用较少的资源，适用于沙箱等资源有限的环境。如果您的单点环境资源有限，可以切换到 `profile_min` 配置。

  ```shell
  rm $KYLIN_HOME/conf/profile
  ln -s $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
  ```

- 将 Kylin 中的配置修改手动在 Kyligence Enterprise 中修改

  > **注意**：配置文件并不完全兼容，请**不要**直接拷贝替换配置文件。

  - 将 `$KYLIN_HOME/conf/` 中的改动在 Kyligence Enterprise 的 `$KYLIN_HOME/conf/` 中重做一遍；
  - 将 `$KYLIN_HOME/bin/setenv.sh` 中的改动在 Kyligence Enterprise 的 `$KYLIN_HOME/conf/setenv.sh` 中重做一遍。

    > 提示：`setenv.sh` 所在路径发生了改变，在 Kyligence Enterprise 中该文件位于 `$KYLIN_HOME/conf/` 目录下。


- 如果需要使用已有的元数据，需要在 `$KYLIN_HOME/conf/kylin.properties` 修改如下配置：

  ```properties
  kylin.metadata.url={your_kylin_metadata_url}
  ```

- 由于在 Kyligence Enterprise 中 Cube 允许设置一些高级设置，因此需要您手动地刷新 Cube 信息：

  ```shell
  $KYLIN_HOME/bin/metastore.sh refresh-cube-signature
  ```

- 由于在 Kyligence Enterprise 引入了用户组的概念，因此需要对 Apache Kylin 中的用户进行升级操作：

  ```shell
  $KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.metadata.UserAuthorityUpgraderCLI
  ```

  升级完成后，还需要对 ADMIN 用户进行密码重置：

  ```shell
  $KYLIN_HOME/bin/kylin.sh admin-password-reset
  ```


### 启用 Kyligence Enterprise 示例

执行以下命令启动：
```shell
$KYLIN_HOME/bin/kylin.sh start
```


### 升级存储引擎

Apache Kylin 使用 HBase 作为存储引擎，而 Kyligence Enterprise 默认使用 KyStorage 作为存储引擎，升级存储引擎的步骤如下：

- 备份当前元数据

  ```shell
  $KYLIN_HOME/bin/metastore.sh backup
  ```

- 对备份好的元数据进行升级以使其适应 KyStorage 存储引擎

  ```shell
  $KYLIN_HOME/bin/metastore.sh promote $KYLIN_HOME/meta_backups/<metadata-backup-folder>
  ```

- 恢复升级后的元数据

  ```shell
  $KYLIN_HOME/bin/metastore.sh restore $KYLIN_HOME/meta_backups/<metadata-backup-folder>
  ```

- 在 Kyligence Enterprise 网页的**系统**页面点击**重载元数据**后，清除所有 Cube Segment，重新构建所有 Cube。

