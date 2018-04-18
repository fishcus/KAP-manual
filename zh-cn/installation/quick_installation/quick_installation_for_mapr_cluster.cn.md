## 在 MapR Cluster 中快速安装 KAP

MapR cluster相比于MapR sandbox环境提供了更多的计算存储资源,但是同时环境上也存在一些差异。

### 准备运行环境

1. 准备MapR cluster环境，本文使用的是AWS marketplace中的 MapR Converged Community Edition 6.0a1，可以点击如下[链接](https://aws.amazon.com/marketplace/pp/B010GJS5WO?qid=1522845995210&sr=0-4&ref_=srh_res_product_title)获取相关信息。

2. 在安装MapR cluster时，推荐给每个节点分配公网ip。安装完成后，需要在安全组开放一些常用的端口，如7070（kylin）、8090(RM)等。

3. MapR cluster Node不能直接通过ssh访问，需要以MapR installer节点当做跳板机，再通过ssh连接访问，ssh秘钥保存在installer节点的 `/opt/mapr/installer/data`目录中。

4. 在Mapr Cluster Node中访问MapR cluster资源，需要生成mapr_ticket。生成指令为`maprlogin password`，如果不清楚当前账户密码，请用 `passwd {user}`设置密码。

### 下载安装 KAP

1. 获取 KAP 软件包。您可以访问 [KAP release notes](../../release/README.md)，选择适合您的版本；

2. 将 KAP 软件包拷贝至您需要安装 KAP 的服务器或虚拟机，并解压至安装路径下。我们假设您的安装路径为`/usr/local/`，安装 KAP 所使用的 Linux 账户为`root`。运行下述命令：

   ```shell
   cd /usr/local
   tar -zxvf kap-{version}.tar.gz
   ```

3. 将环境变量`KYLIN_HOME`的值设为 KAP 解压后的路径：

   ```shell
   export KYLIN_HOME=/usr/local/kap-{version}
   ```

4. 在 MapR-FS 上创建 KAP 的工作目录，并授予启动 KAP 的账户读写该工作目录的权限。默认的工作目录为`/kylin`。KAP需要向`/user/{current_user}`目录下写入临时数据，需要创建对应目录。运行下述命令：

   ```shell
   hadoop fs -mkdir /kylin
   hadoop fs -chown root /kylin
   ```

   > 提示：您可以在`$KYLIN_HOME/conf/kylin.properties`配置文件中修改 KAP 工作目录的位置。如果

### 快速配置 KAP

为了使用MapR文件系统，需要将KAP的默认工作目录指向MapR-FS(maprfs:///)。更新kylin.properties文件

```
kylin.env.hdfs-working-dir=maprfs:///kylin
```

### 检查运行环境

首次启动 KAP 之前，KAP 会对所依赖的环境进行检查。如果在检查过程中发现问题，您将在控制台中看到警告或错误信息。

检查中遇到的一部分问题可能是由于无法有效获取环境依赖信息导致的。如果遇到这类问题，您可以尝试通过环境变量显示指定 KAP 获取这些信息的途径。示例如下：

```shell
export HIVE_CONF=/opt/mapr/hive/hive-2.1/conf
export SPARK_HOME=/opt/mapr/spark/spark-2.1.0
```

**注意：在MapR中文件操作命令为`hadoop fs`，而非`hdfs`，这会导致KAP检查运行环境时无法通过，这时候只需将`$KYLIN_HOME/bin/check-os-command.sh`脚本中的`hdfs`命令检查注释即可。示例如下：**

```shell
#command -v hdfs                         || quit "ERROR: Command 'hdfs' is not accessible. Please check Hadoop client setup."
```

* 如果 HBase 不可用或者出现 HBase shell 可以用，但是启动 KAP 会发生无法找到 metadata 的情况，则改用 MySQL 作为 metadata 源，详情参考：[基于关系型数据库的 Metastore 配置](http://docs.kyligence.io/v2.5/zh-cn/config/metadata_jdbc.cn.html)。
* 如果出现 Hadoop 报 ArrayIndexOutOfBounds 的错误，可以考虑将 `/opt/mapr/hadoop/hadoop-2.7.0/etc/hadoop/yarn-site.xml` 中的 true 改为 false。

> 提示：您可以在任何时候手动检查运行环境。运行下述命令：
>
> ```shell
> $KYLIN_HOME/bin/check-env.sh
> ```

* 如果启动时yarn上提交的spark-context任务执行失败，出现 `requestedVirtualCores > maxVirtualCores`，可以考虑修改`yarn-site.xml`的`yarn.scheduler.maximum-allocation-vcores`配置

``` shell
vi {hadoop_conf_dir}/yarn-site.xml
```
```
<property>
	<name>yarn.scheduler.maximum-allocation-vcores</name>
	<value>24</value>
</property>
```
​	或者将`kap profile`设置成`min_profile`

```shell
rm -f $KYLIN_HOME/conf/profile
ln -sfn $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
```
* 如果使用了kafka，请检查环境中的zookeeper端口，一般来说mapr开放的zk端口为5181，而kafka中默认连接zk的端口为2181。

```shell
netstat -ntl | grep 5181(2181)
```

### 启动 KAP

运行下述命令以启动 KAP：

```shell
$KYLIN_HOME/bin/kylin.sh start
```

> 您可以执行下述命令以观察启动的详细进度：
>
> ```shell
> tail $KYLIN_HOME/logs/kylin.log
> ```

启动成功后，您将在控制台中看到提示信息。此时可以运行下述命令以查看 KAP 进程是否正在运行：

```shell
ps -ef | grep kylin
```

### 访问 KAP GUI

当 KAP 顺利启动后，您可以打开 web 浏览器，访问`http://<host_name>:7070/kylin/`。请将其中`<host_name>`替换为具体的 host 名、IP 地址或域名。默认端口值为`7070`。默认用户名和密码分别为`ADMIN`和`KYLIN`。

当您成功从 KAP GUI 登录后，可以通过构建 Sample Cube 以验证 KAP 的功能。请参阅[安装验证](install_validate.cn.md)。

### 停止 KAP

运行下述命令以停止运行 KAP：

```shell
$KYLIN_HOME/bin/kylin.sh stop
```

您可以运行下述下述命令以查看 KAP 进程是否已停止：

```shell
ps -ef | grep kylin
```

