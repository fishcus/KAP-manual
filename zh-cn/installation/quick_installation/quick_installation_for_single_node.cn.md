## 在单节点上快速安装 Kyligence Enterprise

在本节中，我们将引导您在单节点上快速安装 Kyligence Enterprise。

### 下载安装 Kyligence Enterprise

1. 获取 Kyligence Enterprise 软件包。您可以访问 [Kyligence Enterprise Release Notes](../../release/README.md)，选择适合您的版本。

2. 决定安装路径和将要运行 Kyligence Enterprise 的 Linux 账户。下文所有示例都做如下假设：
   - 假设安装路径为 `/usr/local/`。
   - 假设运行 Kyligence Enterprise 的 Linux 账户为 `root`，下文简称 “Linux 账户”。
   - 在执行时，请留意将上述假设替换为真实的安装路径和 Linux 账户。比如，CDH 沙箱的默认用户是 `cloudera`。

3. 将 Kyligence Enterprise 软件包拷贝至您需要安装的服务器或虚拟机，并解压至安装路径下。
   ```shell
   cd /usr/local
   tar -zxvf Kyligence-Enterprise-{version}.tar.gz
   ```

4. 将环境变量`KYLIN_HOME`的值设为 Kyligence Enterprise 解压后的路径：
   ```shell
   export KYLIN_HOME=/usr/local/Kyligence-Enterprise-{version}
   ```

5. 在 HDFS 上创建 Kyligence Enterprise 的工作目录，并授予 Linux 账户读写该工作目录的权限。默认的工作目录为`/kylin`。同时确保 Linux 账户在 HDFS 上的用户目录也有正常的读写权限。运行下述命令：

   ```shell
   hdfs dfs -mkdir /kylin
   hdfs dfs -chown root /kylin
   hdfs dfs -mkdir /user/root
   hdfs dfs -chown root /user/root
   ```

   如果需要，您可以在 `$KYLIN_HOME/conf/kylin.properties` 配置文件中修改 Kyligence Enterprise 工作目录的位置。

   **注意：如果您没有权限执行上述命令，可以先转至 `hdfs` 账户，然后再次尝试。 **

   ```shell
   su hdfs
   hdfs dfs -mkdir /kylin
   hdfs dfs -chown root /kylin
   hdfs dfs -mkdir /user/root
   hdfs dfs -chown root /user/root
   ```

### 快速配置 Kyligence Enterprise

由于沙箱等单节点环境能够提供的资源有限，我们推荐您在单节点上安装 Kyligence Enterprise 时，对 Kyligence Enterprise 进行配置以限制其使用的资源。在 `$KYLIN_HOME/conf/` 路径下，我们已经为您准备了两套配置方案：`profile_prod` 和 `profile_min`。前者是默认方案，适用于实际生产环境；后者使用较少的资源，适用于沙箱等环境。运行下述命令，切换为 `profile_min` 配置：

```shell
rm -f $KYLIN_HOME/conf/profile
ln -sfn $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
```

### 如果您使用 Beeline 连接 Hive
如果您使用 Beeline 连接 Hive，需要如下修改 `kylin.properties` 配置，确保 Beeline 使用正确的账户执行命令：

- 请留意替换 `-n root` 为您运行 Kyligence Enterprise 的 Linux 账户
- 请留意替换 `jdbc:hive2://localhost:10000` 为您环境中的 Beeline 服务地址

```properties
kylin.source.hive.beeline-params=-n root --hiveconf
hive.security.authorization.sqlstd.confwhitelist.append='mapreduce.job.*|dfs.*' -u jdbc:hive2://localhost:10000
```
并将如下参数写入 hive-site.xml，给与 Kyligence Enterprise 调整 Hive 执行参数的一定权限：

```properties
hive.security.authorization.sqlstd.confwhitelist=dfs.replication|hive.exec.compress.output|hive.auto.convert.join.noconditionaltask.*|mapred.output.compression.type|mapreduce.job.split.metainfo.maxsize
```
参见更多 [Beeline命令说明](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-BeelineCommandOptions)。

### 如果您使用 Kerberos

如果您的集群启用 Kerberos 安全机制，Kyligence Enterprise 自带的 Spark 需要正确的配置才能安全地访问您的集群资源。

首先，如果您的机器上设有 SPARK_HOME 环境变量，请确保它指向 Kyligence Enterprise 自带的 Spark。
   ```shell
   export SPARK_HOME=$KYLIN_HOME/spark
   ```

然后，在 `kylin.properties` 中做如下配置，使 Kyligence Enterprise 能正确地读取 Kerberos 配置文件：

- 请留意替换 `/opt/spark/cfg/jaas-zk.conf` 为您环境中对应的 `jaas` 配置文件路径
- 请留意替换 `/opt/spark/cfg/kdc.conf` 为您环境中对应的 `kdc` 配置文件路径
   ```properties
   kap.storage.columnar.spark-conf.spark.yarn.am.extraJavaOptions=\
   -Djava.security.auth.login.config=/opt/spark/cfg/jaas-zk.conf \
   -Djava.security.krb5.conf=/opt/spark/cfg/kdc.conf
   kap.storage.columnar.spark-conf.spark.driver.extraJavaOptions=\
   -Djava.security.auth.login.config=/opt/spark/cfg/jaas-zk.conf \
   -Djava.security.krb5.conf=/opt/spark/cfg/kdc.conf
   kap.storage.columnar.spark-conf.spark.executor.extraJavaOptions=\
   -Djava.security.auth.login.config=/opt/spark/cfg/jaas-zk.conf \
   -Djava.security.krb5.conf=/opt/spark/cfg/kdc.conf
   ```

最后，Kyligence Enterprise 需要使用正确的 Kerberos 配置来访问 Hive Metastore。这里有两种配置方法。

- 方法一：进一步修改 `kylin.properties` 中的 `kap.storage.columnar.spark-conf.spark.driver.extraJavaOptions` 参数如下：
   ```properties
   kap.storage.columnar.spark-conf.spark.driver.extraJavaOptions=\
   -Djava.security.auth.login.config=/opt/spark/cfg/jaas-zk.conf \
   -Djava.security.krb5.conf=/opt/spark/cfg/kdc.conf \
   -Dhive.metastore.sasl.enabled=true \
   -Dhive.metastore.kerberos.principal=hive/XXX@XXX.com
   ```
- 方法二：将 `hive-site.xml` 文件拷贝（或软链接）至 `$KYLIN_HOME/spark/conf` 目录下。

> 常见问题：如果 Kyligence Enterprise 启动后，在日志中发现 `/tmp/hive-scratch` 目录（或类似的临时 HDFS 目录）没有写权限，只要授予权限（如 `hadoop fs -chmod -R 777 /tmp/hive-scratch`），再重启 Kyligence Enterprise 即可。

更多 Kerberos 相关的信息，请参看[集成Kerberos](../../security/kerberos.cn.md)章节。

### 检查运行环境

首次启动 Kyligence Enterprise 时，会自动对所依赖的环境进行检查。如果在检查过程中发现问题，您将在控制台中看到警告或错误信息。

检查中遇到的一部分问题可能是由于无法有效获取环境依赖信息导致的。如果遇到这类问题，您可以尝试通过环境变量显示指定 Kyligence Enterprise 获取这些信息的途径。示例如下：

```shell
export HADOOP_CONF_DIR=/etc/hadoop/conf
export HIVE_LIB=/usr/lib/hive
export HIVE_CONF=/etc/hive/conf
export HCAT_HOME=/usr/lib/hive-hcatalog
```

> 提示：您可以在任何时候手动检查运行环境。运行下述命令：
>
> ```shell
> $KYLIN_HOME/bin/check-env.sh
> ```

### 启动 Kyligence Enterprise

运行下述命令以启动 Kyligence Enterprise：

```shell
$KYLIN_HOME/bin/kylin.sh start
```

> 如果想观察启动的详细进度：
>
>
> ```shell
> tail -f $KYLIN_HOME/logs/kylin.log
> ```
>

启动成功后，您将在控制台中看到提示信息。此时可以运行下述命令检查 Kyligence Enterprise 进程：

```shell
ps -ef | grep kylin
```

### 使用 Kyligence Enterprise

当 Kyligence Enterprise 顺利启动后，您可以打开 Web 浏览器，访问 `http://host_name:7070/kylin/`。请将其中的 `host_name` 替换为具体的机器名、IP 地址或域名，默认端口为 `7070`。默认用户名和密码分别为 `ADMIN` 和 `KYLIN`。使用默认用户名／密码初次登陆后，请遵照密码规则重置管理员密码。

> **密码规则：**
>
> - 密码长度至少8位
> - 密码需要包含至少一个数字、字母、及特殊字符（~!@#$%^&*(){}|:"<>?[];',./`）

当您成功登录后，可以通过构建 Sample Cube 来验证 Kyligence Enterprise 的功能。具体请参阅[安装验证](../installation_validation.cn.md)。

### 停止 Kyligence Enterprise

运行下述命令以停止运行 Kyligence Enterprise：

```shell
$KYLIN_HOME/bin/kylin.sh stop
```

您可以运行下述命令查看 Kyligence Enterprise 进程是否已停止：

```shell
ps -ef | grep kylin
```

