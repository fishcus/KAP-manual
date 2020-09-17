## 从 KAP 2.x 升级至 Kyligence Enterprise 3.x

> **提示：** 从 3.0 开始，Kyligence Analytics Platform (KAP) 正式改名为 Kyligence Enterprise。

本章介绍如何从 Kyligence 的早期软件版本升级到最新版本的 Kyligence Enterprise 3.x。

作为主要版本升级，除了在升级前备份元数据之外，您还需要备份 Cube 数据，请预留足够的存储空间。

如果升级前版本为 KAP 2.x 且一个项目中包含多种数据源（如 Hive 和 Kafka），升级后该项目需要选定默认数据源，选定后将无法修改，且在选择默认数据源时 RDBMS 数据源类型不可用。

为了保障生产的安全稳定，我们不建议直接在生产环境升级 Kyligence Enterprise。我们推荐您准备一个测试环境进行升级的测试，直到在测试环境可以稳定使用 Kyligence Enterprise 后，才在生产环境升级。


### 升级前的准备工作

1. 确保没有正在进行中（即等待、运行、错误和暂停）的构建任务，确保**所有任务都是完成状态**（即成功或者终止）。

   对于进行中的任务，您可以等待它们完成，或者终止它们。

   > **提示**：如果需要，您可以查看构建节点的 `kylin.log` 来确认所有任务的状态：
   >
   > ```
   > [JobFetcher-xxx] ... 0 running, 0 scheduled, 0 actual running, 0 stopped, 0 ready, 0 waiting, x succeed, 0 error, x discarded
   > ```

2. Kyligence Enterprise 3.x 所在节点及其运行的 Hadoop 集群中的所有节点，需要的 Java 环境是 **JDK 8 (64 bit)** 及以上，您可以通过以下命令查看 JDK 版本：

   ```bash
   java -version
   ```
   如果您的 JDK 版本不满足要求，请参考 [如何在低版本 JDK 上运行 Kyligence Enterprise](../../appendix/run_on_jdk7.cn.md)。

3. 停止所有 Kyligence Enterprise 实例，确保没有活动的 Kyligence Enterprise 进程影响升级。

   ```sh
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```

4. 清理过期数据

   如果您没有为 KAP 安排定期的清理过期数据的作业，强烈建议您先清理过期数据再继续。这可能大大减少后面备份数据所需的时间和空间。详细步骤请看文末的[清理过期数据步骤](#补充：清理过期数据)。



### 数据备份

为了最大程度地保障数据的安全性，在升级前需要备份元数据、Cube 数据、和原安装目录。

- 备份元数据

  您可以通过以下命令执行元数据的备份：

  ```sh
  $KYLIN_HOME/bin/metastore.sh backup
  ```

- 备份安装目录

  ```sh
cp -r $KYLIN_HOME ${KYLIN_HOME}.backup
  ```
  
- 备份 Cube 数据

  - 请先确认您 HDFS 上有足够空间：
    ```sh
    hdfs dfs -df -h /
    ```
  - 通过以下命令确认 Kyligence Enterprise 工作目录的大小：
    > 提示：工作目录由配置文件 `$KYLIN_HOME/conf/kylin.properties` 中的 `kylin.env.hdfs-working-dir` 参数指定，默认值为 `/kylin`。
    ```sh
    hdfs dfs -du -h /kylin
    ```
  - 如果空间允许，请备份 Cube 数据：
    ```sh
    hadoop distcp /kylin /kylin_temp
    ```
    确认备份目录 `/kylin_temp` 与原目录大小基本相同。



### 更新安装目录

解压缩新版本的 Kyligence Enterprise 安装包，更新 `KYLIN_HOME` 环境变量：

```sh
tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
export KYLIN_HOME={your-unpack-folder}
```



### 更新配置文件

> **提示：**
>
> 1. 以下使用 `$OLD_KYLIN_HOME` 代表升级前的安装目录，`KYLIN_HOME` 代表升级后的安装目录。
>
> 2. 为了保证您享用到新版本的新特性，请**不要**直接使用旧的配置文件夹覆盖新的配置文件夹。

- 将之前版本 `conf/` 目录下的 `setenv.sh` 中的配置修改手动在新版本中的对应文件进行修改。

  对于 KAP 2.3 及以下版本，`setenv.sh` 文件所在路径发生了改变，在 Kyligence Enterprise 中该文件位于 `$KYLIN_HOME/conf/` 目录下。

- 与构建任务有关的配置文件可以覆盖，您可以执行如下命令使用之前版本的配置文件：
  ```sh
  cp $OLD_KYLIN_HOME/conf/kylin_*.xml $KYLIN_HOME/conf/
  ```

- 在新版本的 `conf/` 目录下，备份 `kylin.properties` ，并将之前版本的 `kylin.properties` 拷贝至当前目录。
  ```sh
  mv $KYLIN_HOME/conf/kylin.properties $KYLIN_HOME/conf/kylin.properties.template
  cp $OLD_KYLIN_HOME/conf/kylin.properties $KYLIN_HOME/conf/
  # if kylin.properties.override is also used
  cp $OLD_KYLIN_HOME/conf/kylin.properties.override $KYLIN_HOME/conf/
  ```
  
  > **提示**：如果需要使用已有的元数据，您可以在 `$KYLIN_HOME/conf/kylin.properties` 按照之前配置文件进行修改，如下：
  >
  > ```properties
  > kylin.metadata.url = {your_kylin_metadata_url}
  > ```

- 新版 Kyligence Enterprise 携带了更高版本的 Spark 和 Tomcat，原有的 Spark 和 Tomcat 配置文件可能无法复制使用。请根据需要重新手工配置 Spark 或 Tomcat。配置目录为 `$KYLIN_HOME/spark/conf` 和 `$KYLIN_HOME/tomcat/conf`。

- 如果您当前集群部署是通过 Redis 实现多个 Kyligence Enterprise 实例的 Session 共享，请参考[集群部署与负载均衡](../../installation/deploy/cluster_lb.cn.md) 进行配置。

- 如果您启用了 Kerberos 安全认证，请参考[与 Kerberos 集成](../../security/kerberos.cn.md)。

- 申请新的 License 文件[申请许可证](../../appendix/apply_license.cn.md)。




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



### 验证升级后 Kyligence Enterprise 是否正常工作

> **提示：**
>
> - 如果升级后有任何问题，请及时联系 [Kyligence 技术支持](https://support.kyligence.io/)以寻求帮助。
> - 在测试期间，请**不要执行垃圾清理**以保证最大程度的数据安全性。

1. 确认 Kyligence Enterprise Web UI 能够正常显示、登录。
2. 进行构建、查询等基本操作，观察是否能正常工作及耗时是否正常。
   如果您升级前存在一些需要新版本修复的问题，请升级后及时测试新版本是否解决了您的问题。
3. 检验集成 Kyligence Enterprise 的第三方系统是否能够成功工作，如使用 JDBC 进行查询的客户端、如调用 REST API 进行查询的客户端、如 BI 工具等。



### 升级成功，清除备份文件与数据

经过测试确认过功能全部可用后，您可以删除在升级前备份的元数据、安装目录和 Cube 数据，以节省空间。



### 升级失败，回滚到之前版本

**建议您在决定回滚之前，先联系 Kyligence 技术支持获取帮助**。Kyligence 技术支持通常能帮您解决升级过程遇到的常见问题。

1. 停止并确认没有正在运行的 Kyligence Enterprise 进程：

   ```sh
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```

2. 恢复原 KAP 安装目录：

   ```sh
   rm -rf $KYLIN_HOME
   cp -r ${KYLIN_HOME}.backup $KYLIN_HOME
   ```

3. 恢复元数据

   ```sh
   $KYLIN_HOME/bin/metastore.sh restore {your_backup_metadata_folder}
   ```

4. 恢复 Cube 数据

   ```sh
   hdfs dfs -rmr /kylin
   hadoop distcp /kylin_temp /kylin
   ```

5. 重新启动 Kyligence Enterprise

   ```sh
   $KYLIN_HOME/bin/kylin.sh start
   ```



### 补充：清理过期数据

在升级之前清理过期数据是个好习惯，这有可能大大减少后面备份数据所需的时间和空间。步骤如下。

- 检查元数据一致性

  ```sh
  $KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker check
  ```

  如果检查发现了元数据存在不一致的情况，继续执行 

  ```sh
  $KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker recovery
  ```

- 清理过期元数据

  ```sh
$KYLIN_HOME/bin/metastore.sh clean
  ```
  
  第一次执行不带 `--delete` 参数，仅会显示出可以清理的元数据，核对后进行实质的清理：
  
  ```sh
  $KYLIN_HOME/bin/metastore.sh clean --delete true
  ```

- 清理过期 Cube 数据

  ```sh
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.storage.KapStorageCleanupCLI
  ```

  第一次执行不带 `--delete` 参数，仅会显示出可以清理的 Cube 数据，核对文件路径和名称后进行实质的清理：
  
  ```sh
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.storage.KapStorageCleanupCLI
  --delete true
  ```

> **注意**：以上的过期数据清理方法仅试用于 KAP 2.x。在 Kyligence Enterprise 3.x 中，有[新的日常运维工具](../routine_ops/routine_tool.cn.md)提供更易用的清理功能。
