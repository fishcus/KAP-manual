## 与 Kerberos + Sentry 集成

CDH 自带了 Sentry、Kerberos 等安全组件，用于配置一站式数据安全管控与权限管理。本章节将介绍如何在启用了安全配置的 CDH 集群环境中部署 Kyligence，并实现与 Sentry、Kerberos 安全配置的集成。
部分配置与 [安装前置条件](../installation/prerequisite.cn.md) 中存在的细微差异，以本章节为准。

### 环境准备 

请联系您的 Hadoop 管理员来确保您的 CDH 环境中已经启用了 Kerberos 认证，并已按照 CDH 操作手册启用 Sentry 有关的组件并完成了相关配置，并且启用了 HDFS ACLs，同时开启了 HDFS ACLs 和 Sentry 权限同步。

### 创建操作系统用户

请确保用于运行 Kyligence Enterprise 的用户（如：`ke_user` ）及对应用户组（如：`ke_group` ）已经被创建，并将 hive 用户加入 ke_group 中。
```sh
 $ groupadd ke_group     # 新建用户组 ke_group
 $ useradd -G ke_group ke_user     # 创建用户 ke_user 并添加到 ke_group 用户组中
 $ usermod -a -G ke_group hive  #把 hive 用户加入到 ke_group
```
>   **注意**：请确保以上操作在集群的所有节点都执行，以保证权限的成功生效。

### 创建 Kerberos 用户

1. 创建 Kerberos 用户 `ke_user`，在 KDC 部署节点上执行如下命令：
   ```sh
    $ kadmin.local
    kadmin.local > addprinc ke_user
   ```
2. 验证用户
   ```sh
    $ kinit ke_user
   ```

### 配置 Hive 

- 配置 Hive Server

  1. 登录 Cloudera Manager，转到 **Hive** 服务，单击**配置**选项卡。
  2. 搜索 **Hive Metastore 访问控制和代理用户组覆盖**，找到配置项 `hadoop.proxyuser.hive.groups`，添加 `ke_group`。
  3. 找到 **hive-site.xml 的 Hive 服务高级配置代码段（安全阀）**，增加如下配置：
     - 名称： `hive.metastore.rawstore.impl`   
       值：`org.apache.sentry.binding.metastore.AuthorizingObjectStore`

     - 名称：`hive.server2.session.hook`   
       值：`org.apache.sentry.binding.hive.HiveAuthzBindingSessionHook`
       
     - 名称：`hive.server2.authentication`     
       值：`KERBEROS`                                             

     - 名称：`hive.server2.enable.doAs`        
       值：`false`

- 配置 Beeline

  1. 安全环境中需要使用 Beeline 方式访问 Hive，并需要以 Kerberos 用户 hive 操作 Beeline，创建角色，授予权限。
     ```sh
      $ kinit hive
      $ beeline -u "jdbc:hive2://<HiveServer2>:10000/;principal=hive/{HOST_NAME}@EXAMPLE.COM"
     ```

  2. 创建一个角色 *ke_role*，并赋予给组 `ke_group`
     ```sh
      $ create role ke_role;
      $ grant role ke_role to group ke_group;
     ```
   
  3. 创建一个用于存放 Kyligence Enterprise 中间表的数据库（如：db_flat），赋予角色 `ke_role` 对这个数据库所有操作权限
     ```sh
      $ create database db_flat;
      $ grant all on database db_flat to role ke_role; 
     ```
     
  4. 赋予角色 `ke_role` 用于构建的 Hive 数据库（如：default）或者表（如：kylin_sales）读权限
     ```sh
      $ grant select on database default to role ke_role;  
      或者
      $ grant select on table kylin_sales to role ke_role; 
     ```


### 配置 HDFS

为了保证 Kyligence Enterprise 可以顺利在 HDFS 中读写文件，需要在 HDFS 中执行如下操作：

1. 使用 Kerberos 用户 `hdfs` 创建对应的工作目录并修改目录权限。
   ```sh
    $ kinit hdfs
    $ hdfs dfs -mkdir /{working_dir}
    $ hdfs dfs -chown ke_user:ke_group /{working_dir}
    $ hdfs dfs -mkdir /user/ke_user
    $ hdfs dfs -chown ke_user:ke_group /user/ke_user
    $ hdfs dfs -chmod -R 775 /{working_dir}
   ```
2. 以 Kerberos 用户 hive 操作 Beeline 授予角色 `ke_role` 工作目录和 `/tmp` 所在路径对应 uri 的所有权限。
   ```sh
    $ grant all on uri "hdfs://{namenode}:8020/{working_dir}" to role ke_role;
    $ grant all on uri "hdfs://{namenode}:8020/tmp" to role ke_role;
   
    如果 Hadoop 集群启用了 HA，则使用下面的命令来赋予 uri 权限：
   
    $ grant all on uri "hdfs://{nameservice}/{working_dir}" to role ke_role;
    $ grant all on uri "hdfs://{nameservice}/tmp" to role ke_role;
   ```

### 配置 HBase

如果使用 HBase 作为 Metastore，需要赋予用户 `ke_user` 在 HBase 中读写的权限。

```sh
 $ kinit hbase
 $ hbase shell
 $ grant 'ke_user','RWCA'
```

### 配置 Kyligence Enterprise

1. 将 Kerberos 用户的 keytab 文件拷贝到 `$KYLIN_HOME/conf/`路径下
   ```sh
    $ kadmin.local 
    kadmin.local > ktadd -k /{path}/ke_user.keytab ke_user
    $ cp /{path}/ke_user.keytab $KYLIN_HOME/conf/
   ```
2. 修改 `$KYLIN_HOME/conf/kylin.properties`
   - 指定存放中间表的 Hive 数据库
     ```properties
      kylin.source.hive.database-for-flat-table=db_flat
     ```
  
   - 添加或修改如下配置
     ```properties
      kylin.env.hdfs-working-dir={working_dir}
      kylin.source.hive.client=beeline
      kylin.source.hive.beeline-params= -u 'jdbc:hive2://<HiveServer2>:10000/;principal=hive/XXXX@EXAMPLE.COM'
      kap.kerberos.enabled=true
      kap.kerberos.platform=Standard
      kap.kerberos.principal=ke_user
      kap.kerberos.keytab=ke_user.keytab
     ```
3. 切换到 Kerberos 用户 ke_user，启动 Kyligence Enterprise
   ```sh
    $ kinit ke_user
    $ ${KYLIN_HOME}/bin/kylin.sh start
   ```