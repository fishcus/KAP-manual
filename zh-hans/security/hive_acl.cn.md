## 加载表时的 Hive 权限映射

Kyligence Enterprise 在 Hortonworks HDP 和华为 FusionInsight 平台上支持 Hive 数据源的权限映射，当用户如项目管理员、建模人员加载 Hive 数据源中的表时，其仅能看到其在 Hive 中拥有权限的表。

**注意：** 

1. Kyligence Enterprise 的系统管理员不受该权限限制，即管理员能看到 Hive 中所有的表。
2. 一旦将 Hive 数据源中的表成功加载进入 Kyligence Enterprise 后，其权限就不再与 Hive 数据源关联。比如，若用户在 Hive 中失去权限，但已经加载到系统中的表不会自动失去权限。



### 如何配置

* **Hortonworks HDP 平台**

  1. 确认您的 Hive 配置中 Authorization 模式选择的是 `SQLStdAuth`

     ![Hive 设置](images/hive_setting.png)

  2. 确认 Hive 高级设置中 `hive.security.authorization.enabled` 为 `true`

  3. 保证  Hive 高级设置 `hive.security.metastore.authorization.manager` 中去除
     `org.apache.hadoop.hive.ql.security.authorization.MetaStoreAuthzAPIAuthorizerEmbedOnly`

  4. 完成以上步骤后，在 Kyligence Enterprise 的配置文件 `kylin.properties` 中添加以下参数：

     ```java
     kylin.source.hive.sync-table-using-hive-acl=true 
     //[必选]是否开启hive权限映射。该参数指定是否将 Hive 数据源中的权限映射到系统中，默认值为 “false”。开启后，登陆系统的用户只能加载在 Hive 中被授予权限的表。
         
     kylin.source.hive.sync-table-using-hive-acl-exceptions=hive 
     //[可选]配置 Hive 中超级用户，被配置到该项的用户将会跳过 Hive 权限过滤。
     ```


* **华为 FusionInsight 平台**

  如果您使用的是华为 FusionInsight 平台，无需额外配置。因为 FusionInsight 环境默认是安全模式，您需要在 Kyligence Enterprise 的配置文件 `kylin.properties` 中添加以下参数：

  ```java
  kylin.source.hive.sync-table-using-hive-acl=true 
  //[必选]是否开启hive权限映射。该参数指定是否将 Hive数据源中的权限映射到系统中，默认值为 xxx。开启后，登陆系统的用户只能加载在 Hive 中被授予权限的表。
      
  kylin.source.hive.sync-table-using-hive-acl-exceptions=hive 
  //[可选]配置hive中超级用户，被配置到该项的用户将会跳过hive权限过滤。
  ```



同时我们提供了命令行工具来检查用户在特定表上的权限，使用方式如下：

```sh
kylin.sh io.kyligence.kap.tool.storage.KapHiveRemoteClientCheckCLI check -database [yourdatabase] -table [yourtable] -user [username]
```

 

### 已知限制

目前 Kyligence Enterprise 对加载表时的 Hive 权限映射还存在以下限制：

- 目前该功能只支持将 Hive 中 `Authorization` 设置为 `SQLStdAuth`

- 不支持按用户组级别的权限映射

- 不支持 Cloudera CDH 和 MapR 环境的 Hive 权限同步

