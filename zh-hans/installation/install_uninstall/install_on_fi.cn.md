## 在华为 FusionInsight 集群上安装

为使您可以尽快体验到 Kyligence Enterprise 的强大功能，我们推荐您将 Kyligence Enterprise 与 All-in-one Sandbox VM 等沙箱软件一起配合使用。在本节中，我们将引导您在 FusionInsight 环境中快速安装 Kyligence Enterprise。

### 准备运行环境

如果您需要在 FusionInsight 的环境下运行 Kyligence Enterprise，请选择 **Huawei FI** 安装包。

执行下述命令以初始化所需的环境变量：

```shell
source /opt/hadoopclient/bigdata_env
kinit <user_name>
```

### 快速安装 Kyligence Enterprise

准备好了环境之后，请参照[快速开始](../../quickstart/README.md)章节安装 Kyligence Enterprise。

### 华为 FusionInsight 环境下的特别注意事项

1. 在 HDFS 上创建 Kyligence Enterprise 的工作目录，并将对应的读写权限赋予启动 Kyligence Enterprise 的账户。默认的工作目录为`/kylin`。同时，Kyligence Enterprise 需要向`/user/{current_user}`目录下写入临时数据，因此也需要创建对应目录的权限。请您运行下述命令，进行相应权限配置：

   ```shell
   hdfs dfs -mkdir /kylin
   hdfs dfs -chown root /kylin
   hdfs dfs -chmod 755 /tmp/hive-scratch
   hdfs dfs -mkdir /user/root
   hdfs dfs -chown root /user/root
   ```

   > 提示：您可以在 `$KYLIN_HOME/conf/kylin.properties` 配置文件中修改 Kyligence Enterprise 工作目录的位置。

   如果您所使用的账户在 HDFS 上没有读写权限，请先转至`hdfs`账户，然后再创建工作目录并授予权限。执行下述命令：

   ```shell
   su hdfs
   hdfs dfs -mkdir /kylin
   hdfs dfs -chown root /kylin
   hdfs dfs -chmod 755 /tmp/hive-scratch
   hdfs dfs -mkdir /user/root
   hdfs dfs -chown root /user/root
   ```

2. 请您将 FusionInsight 客户端中 Hive 目录的`hivemetastore-site.xml`文件中的所有配置项拷贝至`hive-site.xml`文件中，并将`hive-site.xml`文件拷贝到 `$KYLIN_HOME/spark/conf`。

3. 在 FI Manager 页面中，依次点击 **Hive** - **配置（全部配置）**- **安全** - **白名单**，

   该白名单的配置项名称为：`hive.security.authorization.sqlstd.confwhitelist`，再将`$KYLIN_HOME/conf/kylin_hive_conf.xml`文件中的所有 Hive 配置项的 key（如`dfs.replication`）添加至 FI Hive 配置的白名单中。此外，还需要额外将`mapreduce.job.reduces,fs.defaultFS`配置项添加至白名单中。

   以下是一个我们实际使用的例子，供您参考。请根据您的 **Hadoop** 环境替换一些参数值。

   ```properties
   hive.security.authorization.sqlstd.confwhitelist = mapreduce.job.reduces,dfs.replication,hive.exec.compress.output,hive.auto.convert.join,hive.auto.convert.join.noconditionaltask,hive.auto.convert.join.noconditionaltask.size,mapreduce.map.output.compress.codec,mapreduce.output.fileoutputformat.compress.codec,mapreduce.output.fileoutputformat.compress.type,mapreduce.job.split.metainfo.maxsize,hive.stats.autogather,hive.merge.mapfiles,hive.merge.mapredfiles,mapreduce.job.reduces,fs.defaultFS
   ```

4. 请您在 FI 客户端中输入 **beeline**，并复制 `Connect to` 后面的内容，然后在`$KYLIN_HOME/conf/kylin.properties`中进行如下配置：

   ```properties
   kylin.source.hive.client=beeline
   kylin.source.hive.beeline-params=-n root -u 'jdbc:hive2://…HADOOP.COM'
   ```


### FAQ：
**Q：重启FusionInsight Hive之后，Kyligence Enterprise 提示/tmp/hive-scratch权限不足？**

你可以尝试执行如下命令后，进行重试。

```Shell
hdfs dfs -chmod 755 /tmp/hive-scratch
```

**Q：如果检查运行环境时提示未安装 Snappy，应该如何解决？**

您可以自行安装 Snappy，也可以在`$KYLIN_HOME/conf/kylin.properties`配置文件中修改下述与 Snappy 相关的配置项：

```properties
kylin.storage.hbase.compression-codec=none
# Kyligence Enterprise.storage.columnar.page-compression=SNAPPY
```

**Q：如果报错HBase权限不足，应该如何解决？**

如果检查运行环境时提示缺少 HBase 权限，请您在 FI Manager 页面上创建一个新用户，并将该用户添加至`supergroup`用户组下，分配权限`System_administrator`。然后，请您运行下述命令，将 Kyligence Enterprise 工作目录的所有者更改为该用户：

```shell
hdfs dfs -chown -R <user_name> <working_directory>
```