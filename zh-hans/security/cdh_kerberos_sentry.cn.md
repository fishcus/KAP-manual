## 与 Kerberos + Sentry 集成

CDH 自带了 Sentry、Kerberos 等安全组件，用于配置一站式数据安全管控与权限管理。本章节将介绍如何在启用了安全配置的 CDH 集群环境中部署 Kyligence，并实现与 Sentry、Kerberos 安全配置的集成。

本章节内容结构如下：

- [环境准备](#cdh-prep)
  - 


- 配置验证

### 环境准备 {#cdh-prep}

1. 请联系您的 Hadoop 管理员来确保您的 CDH 环境中已经启用了 Kerberos 认证和 Sentry 有关的组件。
2. 请确保 Hive 中有一些数据库（如：`db_test`）和表用于测试。
3. 请确保用于运行 Kyligence Enterprise 的用户（如：`ke_user` ）及对应用户组（如：`ke_group` ）已经被创建。
   ```sh
   $ groupadd ke_group     # 新建用户组 ke_group
   $ useradd -G ke_group ke_user     # 新建用户 ke_user 并添加到 ke_group 用户组中
   ```

   > **注意：**请确保在集群中的所有节点上都创建 `ke_user` 和 `ke_group` 以保证权限的成功生效。


### 配置 Hive

1. 登录 Cloudera Manager，转到 **Hive** 服务，单击**配置**选项卡。
2. 搜索 **Hive MetastoreAccess Control and Proxy User Groups Override**，找到配置项 `hadoop.proxyuser.hive.groups`，点击**加号**添加 `ke_group`。
3. 在环境中的 `hive-site.xml` 中增加如下配置：
   ```xml
   <property>
      <name>hive.metastore.rawstore.impl</name>
      <value>org.apache.sentry.binding.metastore.AuthorizingObjectStore</value>
   </property>

   <property>
      <name>hive.server2.session.hook</name>
      <value>org.apache.sentry.binding.hive.HiveAuthzBindingSessionHook</value>
   </property>

   <property>
      <name>hive.server2.authentication</name>
      <value>kerberos</value>
   </property>

   <property>
      <name>hive.server2.enable.doAs</name>
      <value>false</value>
   </property>
   ```

   > 提示：通过 Hive CLI 去连接 Hive Metastore，Sentry 的权限控制对 `hadoop.proxyuser.hive.groups` 中添加的用户组的用户不起作用；通过添加上述步骤 3 中的配置对 `hadoop.proxyuser.hive.groups` 中添加的用户组中对应角色进行权限的过滤和拦截。



### 配置 Beeline 连接

安全环境中需要使用 Beeline 连接访问 Hive，并需要以 Kerberos 用户 hive 操作 Beeline，创建角色，授予权限。参考命令如下：

> **注意**：只有在 Sentry 配置项 `sentry.service.admin.group` 中添加的用户组的用户才有权限在 Beeline 中执行 Sentry 权限管理命令，请确保 hive 所在的用户组被加入进去。

​```sh
$ kinit hive@EXAMPLE.COM
$ beeline -u "jdbc:hive2://localhost:10000/;principal=hive/xxx@EXAMPLE.COM"
```

> **注意：** Principal 信息在环境的 `hive-site.xml` 中搜索 `hive.metastore.kerberos.principal` 即可找到。

1. 在 Beeline 创建一个角色 `ke_role`，并赋予给组 `ke_group`

   ```sh
   $ create role ke_role;
   $ grant role ke_role to group ke_group;
   ```
2. 创建一个数据库，用于存放Hive 中间表，赋予 *ke_role* 角色对这个数据库所有操作权限，并给测试库也赋予权限。
   ```sh
   $create database db_flat;

   $grant all on database db_flat to role ke_role; 

   $grant all on database db_test to role ke_role;        
   ```

3. Kyligence Enterprice首次执行 `bin/kylin.sh start` 时，首先会 `check-env` 检查环境，在此过程中会在hive中创建临时测试表存放在 hdfs 的 {kylin-working-dir} 目录下。

   所以需要执行下述语句，授予用户 ke_user 对 hdfs 的 {kylin-working-dir} 路径对应 uri 的所有权限，并且对 /tmp 也要有权限。

   ```shell
   $grant all on uri "hdfs://xxxx:8020/{kylin-working-dir}" to role ke_role;

   $grant all on uri "hdfs://xxxx:8020/tmp" to role ke_role;
   ```

   > **注意：**上述的XXXX代表你的NameNode的地址。如果您的集群是hadoop HA，请把上面的 *hdfs://xxxx:8020/xxx* 替换为您所配置的 nameservice，例如 *hdfs://nameservice1/kylin* 。

Sentry的授权同步到HDFS的ACL可能需要几分钟时间，请耐心等待。

 

####测试ke_role角色

1.    新增 Kerberos 用户 *ke_user*，在 KDC 部署机器 host 上执行 kadmin.local   

      ```sh
      $kadmin.local: addprinc ke_user
      ```


2.    测试ke_role的权限

      - Kerbores 切换成 *ke_user*:  

        ```Shell
        $kinit ke_user
        ```

      - 通过beeline连接hiveserver2:

        ```shell
        $beeline -u“jdbc:hive2://localhost:10000/;principal=hive/xxx@EXAMPLE.COM;”
        ```

      - 查看所有的数据库

        ```Shell
        $show databases;       
        ```

      - 显示数据库表

        ```shell
        $show tables;  
        ```

        此时还没有指定使用哪一个数据库，所以 showtables 默认显示的是数据库 default 中的表，但 *ke_user* 用户没有对数据库 default 的权限，此时不会显示任何表。

      - 使用数据库db_test。

        ```shell
        $use db_test; 
        ```

        *ke_user* 用户有权限使用数据库db_test。其他除db_flat的数据库是无权访问的

      - 显示数据库表

        ```shell
        $show tables;  
        ```

        查看数据库 db_test 中有哪些表，由于 *ke_user* 用户有数据库 *db_test* 的所有权限，故可以看到 *db_test* 中的所有表。 

更多sentry权限管理命令请参照cdh官方文档：<https://www.cloudera.com/documentation/enterprise/5-15-x/topics/sg_hive_sql.html>





###配置HBase

如果使用HBase作为Metastore，还需要给用户ke_user在hbase中读写的权限。

```shell
$kinit hbase
$hbase shell
$grant 'ke_user' ,'RWCA'
```

由于首次执行`bin/kylin.sh start`时，我们会先 `check-env` 来检查用户是否有对hbase写入的权限，故执行此步骤。



###配置HDFS

为了保证Kyligence可以顺利在HDFS读写文件，需要在HDFS中创建Kyligence Enterprice的工作目录并修改目录权限。

以 kerberos 用户 hdfs 做以下操作：

```Shell
$ kinit hdfs
$ hdfs dfs -mkdir /{kylin-working-dir}
$ hdfs dfs -chown ke_user:ke_user /{kylin-working-dir}
$ hdfs dfs -mkkdir /user/ke_user
$ hdfs dfs -chown ke_user:ke_user /user/ke_user
```

 

###配置Kyligence Enterprise

**前提：**

1.    在 KyligenceEnterprise 中对某个表进行采样前，或对使用到这个表的 cube 进行构建前，请确保与 Kyligence Enterprise 集成 Kerberos 的用户角色对这个表具有所有权限。

2.    由于涉及到 hive 权限管理，不同 hive 角色的用户对 hive 中的库和表具有不同的权限，所以对于每一个项目，请确保只使用 hive 中的同一个的角色对这个项目进行操作，即对这个项目进行操作的 kerberos 用户，请确保他们都是 hive 中的同一个角色。

####Check-env时需要的权限

Check-env运行时需要访问 HDFS，请确保 HDFS 权限正常赋予。参考如下命令：

```shell
$ kinit ke_user
$ hadoop fs -setfacl -m “user:hive:rwx” /{kylin-working-dir}
```

####把 *ke_user* 用户的 keytab 文件放到 conf 目录下

1.    在根目录下生成ke_user.keytab文件

      ```shell
      $kadmin.local 
      kadmin.local > xst -norandkey-k /ke_user.keytab ke_user
      ```

2.    把上一步生成的 `ke_user.keytab` 文件放到 `$KYLIN_HOME/conf` 下

####在 `kylin.properties` 中新增配置：

```
kylin.source.hive.database-for-flat-table=db_flat
```

> **注意：**这里的db_flat是用于存放构建 cube 时打出来的平表。数据库 *db_flat* 已经在登录 Beeline 步骤中创建，并赋予了用户 *ke_user* 对 *db_flat* 的所有权限。

```
kylin.source.hive.table-dir-create-first=true

kylin.source.hive.client=beeline

kylin.source.hive.beeline-params= -u 'jdbc:hive2://<hiveSever2 IP>:10000/;principal=hive/XXXX@EXAMPLE.COM' --hiveconfhive.exec.compress.output=true --hiveconf dfs.replication=2 --hiveconfhive.security.authorization.sqlstd.confwhitelist.append='mapreduce.job.*|dfs.* kap.kerberos.enabled=true

kap.kerberos.platform=Standard

kap.kerberos.principal=ke_user@EXAMPLE.COM

kap.kerberos.keytab=ke_user.keytab

kap.storage.columnar.spark-conf.spark.yarn.principal= ke_user@EXAMPLE.COM

kap.storage.columnar.spark-conf.spark.yarn.keytab= ke_user.keytab
```

####启动 KyligenceEnterprise

```shell
$bin/kylin.sh start
```

####在 KyligenceEnterprise 中新建项目，点击导入 Hive 数据源。

此时会显示hive中所有的数据库名，但只有db_test中的表能够显示，并被我们操作。点击其他的数据库（数据库db_flat除外），界面上不会显示这个库的任何表。因为ke_user用户在hive中的角色ke_role只对db_test数据库及db_flat数据库中的所有表具有操作权限。

####构建 cube 或模型检测前需要的权限

```shell
$ kinit ke_user

$ hadoop fs -setfacl -m user:hive:rwx /{kylin-working-dir}/kylin_default_instance/{project_name}
```

> **注意：**必须对每一个project的路径做此步操作。

####新建模型和cube，启动表采样任务，启动模型检测任务，启动构建任务。

如果构建失败，请检查上一步是否配置正确。