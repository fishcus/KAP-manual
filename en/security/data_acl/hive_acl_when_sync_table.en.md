## Enable Hive ACL on Table Sync

Kyligence Enterprise supports Hive ACL mapping on Hortonworks HDP and HUAWEI FusionInsight platform, which means project admin or modeler can see and sync only these tables according to ACL defined in Hive.

**Note:** 

1. System admin in Kyligence Enterprise is not subject to Hive ACL, that is, system admin can view and load all tables in Hive data source. 
2. Once Hive tables are loaded into Kyligence Enterprise, these table access are no longer sync with Hive. For example, if *Table_A* is loaded by *User_A*, *User_A* can always access *Table_A* in Kyligence Enterprise even *User_A* lost his/her authorization in Hive.



### How to Enable Hive ACL on Table Sync

* **Hortonworks HDP platform**

  1. Set **Authorization** in Hive to `SQLStdAuth`

     ![Hive setting](images/hive_setting.png)

  2. Set `hive.security.authorization.enabled` to `true`

  3. Remove `org.apache.hadoop.hive.ql.security.authorization.MetaStoreAuthzAPIAuthorizerEmbedOnly ` in `hive.security.metastore.authorization.manager` 

  4. After modifying above configurations in Hive, please add the following configurations in  `kylin.properties` in Kyligence Enterprise:

     ```java
     kylin.source.hive.sync-table-using-hive-acl=true 
     //[Required] Specify whether to sync Hive ACL with Kyligence Enterprise. The default value is "false". User can only view and load Hive tables which he/she had permission on while this configuration is set to true.
     
     kylin.source.hive.sync-table-using-hive-acl-exceptions=hive 
     //[Optional] Specify whether to ignore the Hive ACL. User in Kyligence Enterprise can view and load all Hive tables.
     ```


* **HUAWEI FusionInsight platform**

  If Kyligence Enterprise is installed in HUAWEI FusionInsight platform, you don't need to modify Hive configurations to enable ACL mapping, since FusionInsight is in security mode by default. You only need to add the following configurations in  `kylin.properties` in Kyligence Enterprise:

  ```java
  kylin.source.hive.sync-table-using-hive-acl=true 
  //[Required] Specify whether to sync Hive ACL with Kyligence Enterprise. The default value is xxx. User can only view and load Hive tables which he/she had permission on while this configuration is set to true.
      
  kylin.source.hive.sync-table-using-hive-acl-exceptions=hive 
  //[Optional] Specifiy whether to ignore the Hive ACL. User in Kyligence Enterprise can view and load all Hive tables.
  ```



You can check user permissions on a specific table via following command:

```sh
kylin.sh io.kyligence.kap.tool.storage.KapHiveRemoteClientCheckCLI check -database [yourdatabase] -table [yourtable] -user [username]
```

After all setting is done, restart Kyligence Enterprise to take effect.



### Hive User Mapping

With the above Hive ACL is enabled, the system works by mapping Kyligence Enterprise users to Hive users directly. For example, for Kyligence Enterprise user `test_user`, the system requires Hive user `test_user` exists, and only Hive tables that are accessible to `test_user` will show when syncing Hive table.

If there is no one-to-one user mapping between Kyligence Enterprise and Hive, then you may implement the UserMappingProvider extension point to create a mapping between the users of the two systems.

For maximum flexibility, the mapping requires a little coding, as shown below.

- Setup development environment

  Unzip `$KYLIN_HOME/samples/static-user-mapping.tar.gz`. This is the sample project with `pom.xml` and maven project defined. Import it into your Java IDE.

  Add Kyligence Enterprise library `$KYLIN_HOME/tool/kylin-tool-kap-[version].jar` to your project lib directory and to your classpath.

  

- Implement the UserMappingProvider interface

  The code is simple. The key is to implement `getRealUsers(String user)` method. Given the input Kyligence Enterprise user, return the corresponding Hive user.
  
  The sample below maps user `kylin` to Hive user `kylin_in_hive`.
  
  ```java
  public class StaticUserMapping implements UserMappingProvider {
  
      Map<String, Set<String>> mapping = new ConcurrentHashMap<>();
  
      public StaticUserMapping() {
          Set<String> users = new HashSet<>();
          users.add("kylin_in_hive");
          mapping.put("kylin", users);
      }
  
      public Set<String> getRealUsers(String user) {
          if (mapping == null) {
              return new HashSet<>();
          }
          Set<String> realUsers = mapping.get(user);
          if (realUsers == null) {
              return new HashSet<>();
          }
          return realUsers;
      }
  }
  ```
  
  Note `getRealUsers(String user)` can return a set of users, allows mapping one Kyligence Enterprise user to multiple Hive users. In this case, the user can load any Hive table that any of the returned Hive users can access.
  
  


- Package and deploy
  1. Pack you code into a jar file using maven

     ```shell
     mvn package -DskipTests
     ```
  
     The built jar file should be found under the `target` folder.

  2. Deploy the jar file

     Put the jar file to folder `$KYLIN_HOME/ext`.

  3. Configure and restart the system

     Add the following configuration in `conf/kylin.properties` and restart to take effect.

     ```properties
     # Set the user name mapping provider in full class name
     kylin.security.user-mapping-provider-clz=StaticUserMapping
     ```

  4. Log in to Kyligence Enterprise and verify

     After Kyligence Enterprise is restarted, the user mapping should take effect when syncing Hive tables.




### Known Limitations

There are some known limitations of enabling Hive ACL on table sync in Kyligence Enterprise:

- Only `SQLStdAuth` of Hive Authorization is supported

- User group mapping of Hive ACL is not supported

- Cloudera CDH platform and MapR platform are not supported
