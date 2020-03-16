## Integrate with Kerberos and Sentry

The CDH platform contains security components such as Sentry and Kerberos. This chapter describes how to deploy Kyligence in a CDH cluster enabled with Sentry and Kerberos.
Some configurations are slightly different from those in [Prerequisite](../installation/prerequisite.en.md). This chapter shall prevail.

### Prerequisite

Please contact your Hadoop Administrator to ensure that your CDH cluster has enabled with Kerberos authentication and plugin related with Sentry. And you also need to ensure HDFS ACLs and Permissions synchronization between HDFS ACLs and Sentry have been enabled.

### Create a system user

Please make sure a system user, like `ke_user`, has been created to run Kyligence Enterprise and its corresponding user group, like `ke_group` has also been created.
```sh
 $ groupadd ke_group     # Create a new user group ke_group
 $ useradd -G ke_group ke_user     # Create a user named ke_user and add it to a user group named ke_group
 $ usermod -a -G ke_group hive   # Add user hive to user group ke_group 
```
> *Caution*: Please make sure to execute the above steps in all hosts of a cluster.

### Create a Kerberos user

1. Create a Kerberos user, like `ke_user`, and execute the following steps in the KDC host.
   ```sh
    $ kadmin.local
    kadmin.local > addprinc ke_user
   ```
2. Verify `ke_user`
   ```sh
    $ kinit ke_user
   ```

### Configure Hive

- Configure Hive Server
  1. Go to the *Hive*--> *Configuration* tab.
  2. Search for `Hive MetastoreAccess Control and Proxy User Groups Override` and locate the `hadoop.proxyuser.hive.groups` property, add `ke_group`.
  3. Update the following configuration under `Hive Service Advanced Configuration Snippet (Safety Valve) for hive-site.xml`
     - name: `hive.metastore.rawstore.impl`     
       value: `org.apache.sentry.binding.metastore.AuthorizingObjectStore`

     - name: `hive.server2.session.hook`    
       value: `org.apache.sentry.binding.hive.HiveAuthzBindingSessionHook`

     - name: `hive.server2.authentication`  
       value: `KERBEROS`

     - name: `hive.server2.enable.doAs`     
       value: `false`

- Configure Beeline

  1. In the security environment, it's necessary to access Hive with Beeline and configure Beeline with Kerberos user `hive` to create roles and grant permissions.
     ```sh
      $ kinit hive
      $ beeline -u "jdbc:hive2://<HiveServer2>:10000/;principal=hive/{HOST_NAME}@EXAMPLE.COM"
     ```

  2. Create a role, like `ke_role`, and grant it to user group `ke_group`.
     ```sh
      $ create role ke_role;
      $ grant role ke_role to group ke_group;
     ```
     
  3. Create a Hive database for storing intermediate table created by Kyligence Enterprise, and grant all permission on this database to role `ke_role` .
     ```sh
      $ create database db_flat;
      $ grant all on database db_flat to role ke_role; 
     ```
     
  4. Grant privilege `select` on the hive databases or tables which will be synchronized as Kyligence Enterprise dataSource to role `ke_role`.
     ```sh
      $ grant select on database default to role ke_role;  
      or
      $ grant select on table kylin_sales to role ke_role; 
     ```


### Configure HDFS

The following steps are needed to make sure Kyligence Enterprise can write and read file in HDFS smoothly.
1. Use Kerberos user `hdfs` to create corresponding working directory and modify the permission.
   ```sh
    $ kinit hdfs
    $ hdfs dfs -mkdir /{working_dir}
    $ hdfs dfs -chown ke_user:ke_group /{working_dir}
    $ hdfs dfs -mkdir /user/ke_user
    $ hdfs dfs -chown ke_user:ke_group /user/ke_user
    $ hdfs dfs -chmod -R 775 /{working_dir}
   ```
  
2. Grant all permissions to role `ke_role` on the corresponding uri of working directory and `/tmp`.
   ```sh
    $ grant all on uri "hdfs://{namenode}:8020/{working_dir}" to role ke_role;
    $ grant all on uri "hdfs://{namenode}:8020/tmp" to role ke_role;
   
    If HA is enabled in your Hadoop cluster, please config with 'nameservice'
   
    $ grant all on uri "hdfs://{nameservice}/{working_dir}" to role ke_role;
    $ grant all on uri "hdfs://{nameservice}/tmp" to role ke_role;
   ```

### Configure HBase

If HBase is used as metastore, it's necessary to grant user `ke_user` the read/write permission in HBase.
```sh
 $ kinit hbase
 $ hbase shell
 $ grant 'ke_user','RWCA'
```

### Configure Kyligence Enterprise

1. Create keytab file for ke_user and put it to directory `$KYLIN_HOME/conf/`.
   ```sh
    $ kadmin.local 
      kadmin.local > ktadd -k /{path}/ke_user.keytab ke_user
    $ cp /{path}/ke_user.keytab $KYLIN_HOME/conf/
   ```
2. Modify `$KYLIN_HOME/conf/kylin.properties`
   - Specify the Hive database for storing intermediate table
     ```properties
      kylin.source.hive.database-for-flat-table=db_flat
     ```
   - Add or modify the following properties
     ```properties
      kylin.env.hdfs-working-dir={working_dir}
      kylin.source.hive.client=beeline
      kylin.source.hive.beeline-params= -u 'jdbc:hive2://<HiveServer2>:10000/;principal=hive/XXXX@EXAMPLE.COM'
      kap.kerberos.enabled=true
      kap.kerberos.platform=Standard
      kap.kerberos.principal=ke_user
      kap.kerberos.keytab=ke_user.keytab
     ```
 3. Use kerberos user ke_user to start Kyligence Enterprise
    ```sh
     $ kinit ke_user
     $ ${KYLIN_HOME}/bin/kylin.sh start
    ```
