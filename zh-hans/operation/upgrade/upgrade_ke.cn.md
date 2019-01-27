## 升级至 Kyligence Enterprise 3.x 最新版本

本章介绍如何从 Kyligence Enterprise 的早期版本升级到最新版本的 Kyligence Enterprise 3.x 软件。

> 提示：从 3.x 开始，Kyligence Analytics Platform (KAP) 正式改名为 Kyligence Enterprise。

升级分为**主要版本**的升级和**次要版本**的升级。版本号前两位发生变化的是主要版本的升级，如 KAP 2.x 升级到 Kyligence Enterprise 3.x，如 Kyligence Enterprise 3.1.x 升级到 Kyligence Enterprise 3.2.x。反之，版本号前两位不发生变化则是次要版本升级，如 Kyligence Enterprise 3.2.1 升级到 Kyligence Enterprise 3.2.2。

次要版本之间兼容元数据，因此升级只需要覆盖软件包、更新配置文件即可；主要版本之间可能需要升级元数据、或者对已有的 Cube 数据进行升级，建议备份元数据和 Cube 数据以保证数据的最大安全性。

为了保障生产的安全稳定，我们不建议直接在生产环境升级 Kyligence Enterprise。我们推荐您准备一个测试环境进行升级的测试，直到在测试环境可以稳定使用 Kyligence Enterprise 后，才在生产环境升级。



### 升级前准备工作

1. 确保**没有**正在进行（即等待、运行、错误和暂停）的构建任务，即**所有任务都是完成状态**（即成功或者终止）。

2. Kyligence Enterprise 3.x 所在节点及其运行的 Hadoop 集群中的所有节点，需要的 Java 环境是：JDK 8 (64 bit) 及以上，您可以通过以下命令查看 JDK 版本：

   ```bash
   java -version
   ```
   如果您的 JDK 版本不满足要求，请参考 [如何在低版本 JDK 上运行](../../appendix/run_on_jdk7.cn.md)

3. 停止所有 Kyligence Enterprise 服务，确保没有活动的 Kyligence Enterprise 进程影响升级。

   ```sh
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```



### 数据备份

为了最大程度保障数据的安全性和服务的可用性，我们推荐在升级前备份元数据、安装目录。另对于主要版本升级，建议额外备份 Cube 数据。

- 备份元数据

  您可以通过以下命令执行元数据的备份：

  ```sh
  $KYLIN_HOME/bin/metastore.sh backup
  ```

- 备份安装目录

  您可以通过如下命令执行安装目录的备份：

  ```sh
  cp -r $KYLIN_HOME ${KYLIN_HOME}.backup
  ```

- 备份 Cube 数据（仅对主要版本升级）

  因为主要版本的升级可能会影响已有 Cube 数据，为了保证数据的最大安全性和可用性，我们推荐您对存储在 HDFS 上的 Cube 数据进行备份。

  - 请先确认您 HDFS 上空间足够，您可以通过以下命令查询 HDFS 上内存使用情况：
    ```sh
    hdfs dfs -df -h /
    ```
  - 通过以下命令确认 Kyligence Enterprise 工作目录的大小：
    > 提示：工作目录由配置文件中的 `$KYLIN_HOME/conf/kylin.properties` 的 `kylin.env.hdfs-working-dir` 参数指定，默认值为 `/kylin`
    ```sh
    hdfs dfs -du -h /kylin
    ```
  - 确认 HDFS 有足够内存支持拷贝 Kyligence Enterprise 工作目录，执行 Cube 数据备份
    ```sh
    hdfs dfs -cp /kylin /kylin_temp
    ```




### 更新安装目录

解压缩新版本的 Kyligence Enterprise 安装包，更新 `KYLIN_HOME` 环境变量：

```sh
tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
export KYLIN_HOME={your-unpack-folder}
```



### 更新配置文件

> 提示：
>
> 1. 以下使用 `$OLD_KYLIN_HOME` 代表升级前的安装目录，`KYLIN_HOME` 代表升级后的安装目录。
>
> 2. 为了保证您享用到新版本的新特性，请**不要**直接使用旧的配置文件夹覆盖新的配置文件夹。

- 快速配置

  Kyligence Enterprise 中提供了两套配置参数：`$KYLIN_HOME/conf/profile_prod` 和 `$KYLIN_HOME/conf/profile_min`。前者是默认方案，适用于实际生产环境；后者使用较少的资源，适用于沙箱等资源有限的环境。如果您的单点环境资源有限，可以切换到 `profile_min` 配置。

  ```sh
  rm $KYLIN_HOME/conf/profile
  ln -s $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
  ```

- 将之前版本 `conf/` 目录下的 `setenv.sh` 中的配置修改手动在新版本中的对应文件进行修改。

  > 提示：对于 KAP 2.3 及以下版本，`setenv.sh` 文件所在路径发生了改变，在 Kyligence Enterprise 中该文件位于 `$KYLIN_HOME/conf/` 目录下。

  - 与构建任务有关的配置文件可以覆盖，您可以执行如下命令使用之前版本的配置文件：
    ```sh
    cp $OLD_KYLIN_HOME/conf/kylin_*.xml $KYLIN_HOME/conf/
    ```

  - 在新版本的 `conf/` 目录下，备份 `kylin.properties` ，并将之前版本的 `kylin.properties` 拷贝至当前目录。
    ```sh
    mv $KYLIN_HOME/conf/kylin.properties $KYLIN_HOME/conf/kylin.properties.template
    cp $OLD_KYLIN_HOME/conf/kylin.properties $KYLIN_HOME/conf/
    ```

    > 提示：如果需要使用已有的元数据，您可以在 `$KYLIN_HOME/conf/kylin.properties` 按照之前配置文件进行修改，如下：
    >
    > ```properties
    > kylin.metadata.url = {your_kylin_metadata_url}
    > ```

- 如果您当前集群部署是通过 Redis 实现多个 Kyligence Enterprise 实例的 Session 共享，请参考[集群部署与负载均衡](../../installation/deploy/cluster_lb.cn.md) 进行配置。

- 如果您启用了 Kerberos 安全认证，请参考[与 Kerberos 集成](../../security/kerberos.cn.md)

- 如果您修改了 Kyligence Enterprise 启动端口，请拷贝并替换 `$OLD_KYLIN_HOME/tomcat/conf/server.xml` 至新的安装目录的相同路径。



### 启动 Kyligence Enterprise

执行如下命令启动：
```sh
$KYLIN_HOME/bin/kylin.sh start
```

> 提示：从 KAP 2.x 升级 Kyligence Enterprise 3.x 时，在**第一次启动**会对元数据进行升级，升级时间取决于您的数据大小，可能达到一个小时或更久。我们推荐您在升级前先通过 `$KYLIN_HOME/bin/metastore.sh clean [--delete true]` 进行元数据清理，减少无用的元数据，使得升级元数据时间变短。
> 
> 元数据升级成功后将会提示
> ```
> Segments have been upgraded successfully.
> ```
> 失败则会提示
> ```
> Upgrade failed. Please try to run
>   bin/kylin.sh io.kyligence.kap.tool.migration.ProjectDictionaryMigrationCLI FIX
> to fix.
> ```



### 测试升级后 Kyligence Enterprise 是否正常工作

> 提示：
> - 如果升级后有任何问题，请及时通过 [Support Portal](https://support.kyligence.io/#/) 联系 Kyligence 技术支持以寻求帮助。
> - 在测试期间，请**不要**执行垃圾清理操作以保证最大程度的数据安全性。

1. 确认 Kyligence Enterprise Web UI 能够正常显示、登录。

2. 进行构建、查询等基本操作，观察是否能正常工作及耗时是否正常。
   如果您升级前存在一些需要新版本修复的问题，请升级后及时测试新版本是否解决了您的问题。

3. 检验集成 Kyligence Enterprise 的第三方系统是否能够成功工作，如使用 JDBC 进行查询的客户端、如调用 REST API 进行查询的客户端、如 BI 工具等。



### 升级成功

经过测试确认过功能全部可用后，您可以删除在升级前备份的元数据、安装目录和 Cube 数据，以节省空间。



### 升级失败，需要回滚到之前版本

> **注意：** 请确保您在升级后遇到的问题已经联系过 Kyligence 技术支持、 Kyligence 技术支持无法对您的问题提供有效的解决方案且这个问题影响您的核心使用，再选择回滚。

1. 停止并确认没有正在运行的 Kyligence Enterprise 进程：
  ```sh
  $KYLIN_HOME/bin/kylin.sh stop
  ps -ef | grep kylin
  ```

2. 恢复原 Kyligence Enterprise 安装目录，更新 `KYLIN_HOME` 环境变量：
  ```sh
  rm -rf $KYLIN_HOME
  cp -r $OLD_KYLIN_HOME.backup $OLD_KYLIN_HOME
  cd $OLD_KYLIN_HOME
  export KYLIN_HOME=`pwd`
  ```

3. 恢复元数据
  ```sh
  $KYLIN_HOME/bin/metastore.sh restore {your_backup_metadata_folder}
  ```

4. （可选）恢复 Cube 数据
  ```sh
  hdfs dfs -rmr /kylin
  hdfs dfs -cp /kylin_temp /kylin
  ```

5. 启动 Kyligence Enterprise
  ```sh
  $KYLIN_HOME/bin/kylin.sh start
  ```
