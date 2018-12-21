## 在华为 FusionInsight 集群上安装



在安装前，请确认您已阅读[**安装前置条件**](../installation_conditions.cn.md)。

Kyligence Enterprise 可以在 FusionInsight 环境中运行。在本节中，我们将引导您在 FusionInsight 环境中快速安装 Kyligence Enterprise。

### 准备运行环境

如果您需要在 FusionInsight 的环境下运行 Kyligence Enterprise，请选择 **Huawei FI** 安装包。

执行下述命令以初始化所需的环境变量：

```shell
source /opt/hadoopclient/bigdata_env
kinit <user_name>
```

### 下载安装 Kyligence Enterprise

1. 获取 Kyligence Enterprise 软件包。您可以访问 [Kyligence Enterprise 发布声明](../../release/README.md)，选择适合您的版本；

2. 将 Kyligence Enterprise 软件包拷贝至您需要安装 Kyligence Enterprise 的服务器或虚拟机，并解压至安装路径下。我们假设您的安装路径为`/usr/local/`。运行下述命令：

   ```shell
   cd /usr/local
   tar -zxvf Kyligence-Enterprise-{version}.tar.gz
   ```

3. 将环境变量 `KYLIN_HOME` 的值设为 Kyligence Enterprise 解压后的路径：

   ```shell
   export KYLIN_HOME=/usr/local/Kyligence-Enterprise-{version}
   ```

4. 在 HDFS 上创建 Kyligence Enterprise 的工作目录，并将对应的读写权限赋予启动 Kyligence Enterprise 的账户。默认的工作目录为`/kylin`。同时，Kyligence Enterprise 需要向`/user/{current_user}`目录下写入临时数据，因此也需要创建对应目录的权限。请您运行下述命令，进行相应权限配置：

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

5. 请您将 FusionInsight 客户端中 Hive 目录的`hivemetastore-site.xml`文件中的所有配置项拷贝至`hive-site.xml`文件中，并将`hive-site.xml`文件拷贝到KE目录下spark的conf目录中。

6. 在 FI Manager 页面中，依次点击 **Hive** - **配置（全部配置）**- **安全** - **白名单**，

   该白名单的配置项名称为：`hive.security.authorization.sqlstd.confwhitelist`，再将`$KYLIN_HOME/conf/kylin_hive_conf.xml`文件中的所有 Hive 配置项的 key（如`dfs.replication`）添加至 FI Hive 配置的白名单中。此外，还需要额外将`mapreduce.job.reduces,fs.defaultFS`配置项添加至白名单中。

   以下是一个我们实际使用的例子，供您参考。请根据您的 **Hadoop** 环境替换一些参数值。

   ```properties
   hive.security.authorization.sqlstd.confwhitelist = mapreduce.job.reduces,dfs.replication,hive.exec.compress.output,hive.auto.convert.join,hive.auto.convert.join.noconditionaltask,hive.auto.convert.join.noconditionaltask.size,mapreduce.map.output.compress.codec,mapreduce.output.fileoutputformat.compress.codec,mapreduce.output.fileoutputformat.compress.type,mapreduce.job.split.metainfo.maxsize,hive.stats.autogather,hive.merge.mapfiles,hive.merge.mapredfiles,mapreduce.job.reduces,fs.defaultFS
   ```

7. 请您在 FI 客户端中输入 **beeline**，并复制 `Connect to` 后面的内容，然后在`$KYLIN_HOME/conf/kylin.properties`中进行如下配置：

   ```properties
   kylin.source.hive.client=beeline
   kylin.source.hive.beeline-params=-n root -u 'jdbc:hive2://…HADOOP.COM'
   ```

   > kylin.source.hive.beeline-params 参数中需要配置的 `user.keytab`项应为具体的路径名，如 `user.keytab= ${KYLIN_HOME}/conf/user.keytab`。

### 检查运行环境

首次启动 Kyligence Enterprise 之前，Kyligence Enterprise 会对所依赖的环境进行检查。如果在检查过程中发现问题，您将在控制台中看到警告或错误信息。

> 提示：您可以在任何时候手动检查运行环境。运行下述命令：
>
> ```shell
> $KYLIN_HOME/bin/check-env.sh
> ```

如果检查运行环境时提示缺少 HBase 权限，请您在 FI Manager 页面上创建一个新用户，并将该用户添加至`supergroup`用户组下，分配权限`System_administrator`。然后，请您运行下述命令，将 Kyligence Enterprise 工作目录的所有者更改为该用户：

```shell
hdfs dfs -chown -R <user_name> <working_directory>
```

如果检查运行环境时提示未安装 Snappy，您可以自行安装 Snappy，也可以在`$KYLIN_HOME/conf/kylin.properties`配置文件中修改下述与 Snappy 相关的配置项：

```properties
kylin.storage.hbase.compression-codec=none
# Kyligence Enterprise.storage.columnar.page-compression=SNAPPY //注释掉该项
```
> **注意**：对于华为FI C70，如果运行环境有启用kerberos安全认证，并且集群的`hive-site.xml`的配置`hive.server2.enable.doAs`为false，则需要添加相关的配置项：

```properties
kylin.source.hive.table-dir-create-first=true
```

如果您需要集成 Kerberos，请参看[集成Kerberos](../../security/kerberos.cn.md)章节。

### 启动 Kyligence Enterprise

运行下述命令以启动 Kyligence Enterprise：

```shell
$KYLIN_HOME/bin/kylin.sh start
```

> 提示：您可以执行下述命令以观察启动的详细进度：
>
> ```shell
> tail $KYLIN_HOME/logs/kylin.log
> ```

启动成功后，您将在控制台中看到提示信息。此时可以运行下述命令以查看 Kyligence Enterprise 进程是否正在运行：

```shell
ps -ef | grep kylin
```

### 访问 Kyligence Enterprise

当 Kyligence Enterprise 顺利启动后，您可以打开 web 浏览器，访问`http://<host_name>:7070/kylin/`。请将其中`<host_name>`替换为具体的 Host 名、IP 地址或域名。默认端口值为`7070`。默认用户名和密码分别为`ADMIN`和`KYLIN`。

当您成功从 Kyligence Enterprise GUI 登录后，可以通过构建 Sample Cube 以验证 Kyligence Enterprise 的功能。请参阅[安装验证](../installation_validation.cn.md)。

### 停止 Kyligence Enterprise

运行下述命令以停止运行 Kyligence Enterprise：

```shell
$KYLIN_HOME/bin/kylin.sh stop
```

您可以运行下述下述命令以查看 Kyligence Enterprise 进程是否已停止：

```shell
ps -ef | grep kylin
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
```
