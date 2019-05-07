## 升级至 Kyligence Enterprise 3.x 最新版本

> **提示：** 从 3.0 开始，Kyligence Analytics Platform (KAP) 正式改名为 Kyligence Enterprise。

**如果您要升级到 Kyligence Enterprise 3.3.0 或之前的版本，由于没有自动升级脚本，请查看这里[如何做手工升级](upgrade_ke.cn.md)。**

升级分为**主要版本**的升级和**次要版本**的升级。版本号前两位发生变化的是主要版本的升级，如 Kyligence Enterprise 3.1.x 升级到 Kyligence Enterprise 3.2.x。反之，版本号前两位不发生变化则是次要版本升级，如 Kyligence Enterprise 3.2.1 升级到 Kyligence Enterprise 3.2.2。

次要版本之间兼容元数据，因此升级只需要运行升级脚本即可.

主要版本之间可能需要升级元数据、或者对已有的 Cube 数据进行升级，建议备份元数据和 Cube 数据以保证数据的最大安全性。

**注意**：为了保障生产的安全稳定，我们不建议直接在生产环境升级 Kyligence Enterprise。我们推荐您准备一个测试环境进行升级的测试，直到在测试环境可以稳定使用 Kyligence Enterprise 后，才在生产环境升级。

### 升级前准备工作

1. 确保**没有**正在进行（即等待、运行、错误和暂停）的构建任务，即**所有任务都是完成状态**（即成功或者终止）。

   - 您可以等待所有任务完成，或者终止它们。

2. Kyligence Enterprise 3.x 所在节点及其运行的 Hadoop 集群中的所有节点，需要的 Java 环境是 JDK 8 (64 bit) 及以上，您可以通过以下命令查看 JDK 版本：

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

为了最大程度保障数据的安全性，我们推荐在升级前备份元数据。另对于主要版本升级，如果资源允许，还建议额外备份 Cube 数据。

- 备份元数据

  您可以通过以下命令执行元数据的备份：

  ```sh
  $KYLIN_HOME/bin/metastore.sh backup
  ```

- 备份 Cube 数据（仅对主要版本升级）

  因为主要版本的升级可能会影响已有 Cube 数据，为了保证数据的最大安全性，我们推荐您对存储在 HDFS 上的 Cube 数据进行备份。

  - 请先确认您 HDFS 上空间足够，您可以通过以下命令查询 HDFS 上磁盘空间使用情况：
    ```sh
    hdfs dfs -df -h /
    ```
  - 通过以下命令确认 Kyligence Enterprise 工作目录的大小：
    > 提示：工作目录由配置文件 `$KYLIN_HOME/conf/kylin.properties` 中的 `kylin.env.hdfs-working-dir` 参数指定，默认值为 `/kylin`
    ```sh
    hdfs dfs -du -h /kylin
    ```
  - 确认 HDFS 有足够的磁盘空间支持拷贝 Kyligence Enterprise 工作目录，执行 Cube 数据备份
    ```sh
    hadoop distcp /kylin /kylin_temp
    ```

### 解压并运行升级脚本

解压缩新版的 Kyligence Enterprise 安装包:

```sh
tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
```
在解压目录中，运行升级脚本：

```sh
Usage: upgrade.sh <OLD_KYLIN_HOME> [--silent]

<OLD_KYLIN_HOME>   Specify the old version of the Kyligence Enterprise
                   installation directory. If not specified, use KYLIN_HOME by default.

--silent           Optional, don't enter interactive mode, automatically complete the upgrade.
```

- 解压新版本安装包。假设新版本解压路径为 `UNPACK_HOME`，旧版本安装目录为 `OLD_KYLIN_HOME`

- 执行升级脚本：
  ```sh
  $UNPACK_HOME/bin/upgrade.sh $OLD_KYLIN_HOME
  ```
  
- 进入 “交互升级模式”，根据提示和实际情况确认指令（y/n）来完成升级。

- 成功后，`OLD_KYLIN_HOME` 即为升级后的 Kyligence Enterprise。

**注意事项**：

1. 当跨**主要版本**升级时，升级脚本无法自动完成 Spark 或 Tomcat 的升级。请在升级脚本执行结束后，根据实际场景重新配置（参考 [与 Kerberos 集成](../../security/kerberos.cn.md) 和 [集群部署与负载均衡](../../installation/deploy/cluster_lb.cn.md)）
2. 升级模式为 “原地升级” ，即升级程序结束后会自动对 `OLD_KYLIN_HOME` 进行备份并将 `UNPACK_HOME` 重命名为 `OLD_KYLIN_HOME`。建议始终使用统一的安装目录，在完成 “原地升级” 后不需要做额外的配置修改，例如：`kylin.env.hadoop-conf-dir` 等。
3. 升级完成后，在 `$UNPACK_HOME/logs` 下会生成升级日志，其中包含升级过程中的操作细节。
4. 参数 `--silent` 允许升级脚本进入 “无声升级模式”，无需客户确认操作指令。该参数请在 Kyligence 技术支持的确认下进行设置。

### 测试升级后 Kyligence Enterprise 是否正常工作

> **提示：**
>
> - 如果升级后有任何问题，请及时通过 [Support Portal](https://support.kyligence.io/#/) 联系 Kyligence 技术支持以寻求帮助。
> - 在测试期间，请**不要**执行垃圾清理操作以保证最大程度的数据安全性。

1. 确认 Kyligence Enterprise Web UI 能够正常显示、登录。
2. 进行构建、查询等基本操作，观察是否能正常工作及耗时是否正常。
   如果您升级前存在一些需要新版本修复的问题，请升级后及时测试新版本是否解决了您的问题。
3. 检验集成 Kyligence Enterprise 的第三方系统是否能够成功工作，如使用 JDBC 进行查询的客户端、如调用 REST API 进行查询的客户端、如 BI 工具等。

### 升级成功，清除备份文件与数据

经过测试确认过功能全部可用后，您可以删除在升级前备份的元数据、安装目录和 Cube 数据，以节省空间。

### 升级失败，回滚到之前版本

**在您决定回滚之前**，请确保您在升级后遇到的问题已经咨询过 Kyligence 技术支持。 Kyligence 技术支持通常能帮您解决升级过程遇到的常见问题。

1. 停止并确认没有正在运行的 Kyligence Enterprise 进程：

   ```sh
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```

2. 恢复原 Kyligence Enterprise 安装目录，更新 `KYLIN_HOME` 环境变量：

   ```sh
   rm -rf $KYLIN_HOME
   tar -zxf $OLD_KYLIN_HOME.backup.tar.gz
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
   hadoop distcp /kylin_temp /kylin
   ```

5. 启动 Kyligence Enterprise

   ```sh
   $KYLIN_HOME/bin/kylin.sh start
   ```

