## 升级至 Kyligence Enterprise 3.x 最新版本

> **提示：**
>
> - 如果您现有的版本是 KAP 2.x，请看如何[从 KAP 2.x 升级](upgrade_from_2x.cn.md)。
> - 从 3.0 开始，Kyligence Analytics Platform (KAP) 正式改名为 Kyligence Enterprise。

升级分为**主要版本**的升级和**次要版本**的升级。版本号前两位发生变化的是主要版本的升级，比如从 3.2.x 升级到 3.3.x。版本号前两位不发生变化则是次要版本升级，比如从 3.3.0 升级到 3.3.3。

次要版本升级风险较小，升级前只需备份元数据即可。主要版本升级由于变化较大，推荐在升级前除了备份元数据之外，条件允许的话，也备份 Cube 数据，以最大程度地保证数据安全。

**注意**：为了保障生产的安全稳定，我们不建议直接在生产环境升级 Kyligence Enterprise。我们推荐您准备一个测试环境进行升级的测试，直到在测试环境可以稳定使用 Kyligence Enterprise 后，才在生产环境升级。

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

### 数据备份

为了最大程度保障数据的安全性，在升级前必需备份元数据。另对于主要版本升级，还建议额外备份 Cube 数据。

- 备份元数据

  您可以通过以下命令备份元数据：

  ```sh
  $KYLIN_HOME/bin/metastore.sh backup
  ```

- 备份 Cube 数据（仅对主要版本升级）

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

### 解压并运行升级脚本

解压缩新版的 Kyligence Enterprise 安装包:

```sh
tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
```
在解压目录中，运行升级脚本：

```
Usage: upgrade.sh <old-kylin-home> [--silent]

<old-kylin-home>   Specify the old version of the Kyligence Enterprise
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

1. 当跨**主要版本**升级时，**新版本中可能携带了更高版本的 Spark 或 Tomcat，且它们的配置文件与旧版本并不兼容**。这时，请在升级脚本执行结束后，根据需要重新手工配置 Spark 或 Tomcat（参考 [与 Kerberos 集成](../../security/kerberos.cn.md) 和 [集群部署与负载均衡](../../installation/deploy/cluster_lb.cn.md)）。配置目录为 `$KYLIN_HOME/spark/conf` 和 `$KYLIN_HOME/tomcat/conf`。
2. 升级模式为 “原地升级” ，即升级程序会先自动备份 `OLD_KYLIN_HOME`，然后原地进行升级。升级后的 `KYLIN_HOME` 不变。
3. 升级完成后，在 `$UNPACK_HOME/logs` 下会生成升级日志，其中包含升级过程中的操作细节。
4. 参数 `--silent` 允许升级脚本进入 “无声升级模式”，无需客户确认操作指令。建议在 Kyligence 技术支持的确认下使用。

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

5. 重新启动 Kyligence Enterprise

   ```sh
   $KYLIN_HOME/bin/kylin.sh start
   ```

