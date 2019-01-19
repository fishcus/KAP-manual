## CDH 环境下与 Kerberos + Sentry 安全集成

CDH 自带了 Sentry、Kerberos 等安全组件，用于配置一站式数据安全管控与权限管理。本章节将介绍如何在启用了安全配置的 CDH 集群环境中部署 Kyligence，并实现与 Sentry、Kerberos 安全配置的集成。

###环境准备

本小节介绍如何部署一个启用安全配置的CDH环境（以下所有链接内容都是在CDH5.15版本进行，如需其他版本请自行查找）：

- 安装CDH基本环境，请参考<https://www.cloudera.com/documentation/enterprise/5-15-x/topics/installation.html>


- 启用Kerbores认证，请参考<https://www.cloudera.com/documentation/enterprise/5-15-x/topics/cm_sg_authentication.html>

- 启用Sentry相关的组件

  - 启用HDFS Access Control Lists访问控制列表： <https://www.cloudera.com/documentation/enterprise/5-15-x/topics/cdh_sg_hdfs_ext_acls.html>

  - 启用Hive相关的Sentry服务：

    <https://www.cloudera.com/documentation/enterprise/5-15-x/topics/sg_sentry_service_config.html#concept_z5b_42s_p4__section_n4d_4g4_rp>

  - 启用HDFS-Sentry plugin（用于HDFS同步Sentry权限信息）：

    https://www.cloudera.com/documentation/enterprise/5-15-x/topics/sg_hdfs_sentry_sync.html#xd_583c10bfdbd326ba--69adf108-1492ec0ce48--7f3a>

  - Setting Hive Warehouse Directory Permissions

  - Disable impersonation for HiveServer2 in the Cloudera ManagerAdmin Console.

  - If you are using YARN, enable the Hive user to submit YARN jobs.

  - Block the Hive CLI user from accessing the Hive metastore.

- Add the Hive, Impala and Hue Groups to Sentry's Admin Groups



###Hive权限配置

本小节介绍通过Hive创建新库方式介绍所需的安全配置(对于Hive中已有的数据表，也可按照同样的方式进行安全配置)。

**前提：**

1. 确保hive中有一些数据库和表来做测试。在本例中，在hive中创建数据库db_test，在数据库db_test中创建一些表。

2. 系统中没有ke_user用户和ke_group用户组，需手动创建：

   ```shell
   $groupadd ke_group     ##新建用户组ke_group

   $useradd -G ke_group ke_user     ##新建用户ke_user并添加到ke_group用户组中
   ```

   > **注意：**确保在集群中所有host都创建ke_user和ke_group，否则权限无法生效。



####登陆Beeline

安全环境中需要使用Beeline方式访问Hive，并需要以kerberos用户hive操作beeline，创建角色，授予权限。参考命令如下：

> 注意：只有属于 `sentry->配置->sentry.service.admin.group` 中添加的用户组的用户才有权限在beeline中执行sentry权限管理命令，请确保 hive 这个 group 被加入进去。

```shell
$kinit [hive](mailto:hive@EXAMPLE.COM)

$beeline -u “jdbc:hive2://localhost:10000/;principal=hive/xxx@EXAMPLE.COM”
```

> **注意：**上面的 Principal 信息在 ClouderaManager 的 hive 中配置，搜索 *hive.metastore.kerberos.principal* 即可找到。

1. 在 Beeline 创建一个角色 *ke_role*，并赋予给组

   ```shell
   $create role ke_role;

   $grant role ke_role to group ke_group;
   ```

   > **注意：**只能将角色授予给特定的组，不能将角色授予给特定的用户。

   ​

2. 创建一个数据库，专门用于 KyligenceEnterprice 存放构建 cube 时打的平表，赋予 *ke_role* 角色对这个数据库所有操作权限，并给测试库也赋予权限。

   ```shell
   $create database db_flat;

   $grant all on database db_flat to role ke_role; 

   $grant all on database db_test to roleke_role;        
   ```

3. Kyligence Enterprice首次执行 `bin/kylin.shstart` 时，首先会 `check-env` 检查环境，在此过程中会在hive中创建临时测试表存放在 hdfs 的 {kylin-working-dir} 目录下。

   所以需要执行下述语句，授予用户 ke_user 对 hdfs 的 {kylin-working-dir} 路径对应 uri 的所有权限，并且对 /tmp 也要有权限。

   ```shell
   $grant all on uri “[hdfs://xxxx:8020/](){kylin-working-dir}”to role ke_role;

   $grant all on uri “hdfs://xxxx:8020/tmp”to role ke_role;
   ```

   > **注意：**如果您的集群是hadoop HA，请把上面的 *hdfs://xxxx:8020/xxx* 替换为您所配置的 nameservice，例如 *hdfs://nameservice1/kylin* 。

Sentry的授权同步到HDFS的ACL可能需要几分钟时间，请耐心等待。

 

####测试ke_role角色

1.    新增 Kerberos 用户 *ke_user*，在 KDC 部署机器 host 上执行 kadmin.local   

      ```Shell
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



###配置Hive Server

请登录Cloudera Manager，并执行下述操作。

1. 转到Hive服务。

2. 单击**配置**选项卡。

3. 搜索 Hive MetastoreAccess Control and Proxy User Groups Override以找到配置项       `hadoop.proxyuser.hive.groups`，点击加号添加 *ke_group*（本文档中实例用户 *ke_user* 的所属组）。

   > **提示： **KyligenceEnterprice执行用户提交的表采样任务时，需要去连接hive metastore。但只有属于 `hive->配置->[hadoop.proxyuser.hive.groups` 中添加的用户组的用户才能够连接hive metastore，所以需要把用户组ke_group添加至其中。这样用户 *ke_user* 就能够连接 hive metastore了。 


4. 对 “hive-site.xml的Hive服务高级配置代码段（安全阀）”点击加号，增加以下配置：

   **名称：**hive.metastore.rawstore.impl，

   **值 ：**org.apache.sentry.binding.metastore.AuthorizingObjectStore。

   **名称：**hive.server2.session.hook

   **值：**org.apache.sentry.binding.hive.HiveAuthzBindingSessionHook

   **名称：**hive.server2.authentication

   **值：**KERBEROS

   **名称：**hive.server2.enable.doAs

   **值：**false。

   > **提示：**此时如果通过 hive CLI 去连接 hive metastore，sentry 的权限控制对属于`hadoop.proxyuser.hive.groups`中添加的用户组的用户不起作用。例如，此时用户 *ke_user* 在 hive CLI 中运行 `use default`， `show tables`， 这时可以看到 default 库中所有的表名。

所以我们通过上述步骤4中的配置来对`hadoop.proxyuser.hive.groups`中添加的用户组做与其对应角色权限的过滤和拦截。此时用户 *ke_user* 在 hiveCLI 中运行 `use default`，` show tables`， 这时只可以看到 default 库中*ke_user* 有权限看到的表了。



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

2.    把上一步生成的 `ke_user.keytab` 文件放到 `KYLIN_HOME/conf` 下

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