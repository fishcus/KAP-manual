## Upgrading from KAP Plus 2.X to Kyligence Enterprise 3.x ##

From 3.x, Kyligence Analytics Platform (KAP) changed the name to Kyligence Enterprise .

KAP 2.X shares compatible metadata with other higher versions. Therefore, you could upgrade from KAP  2.X to higher versions by overwriting the software package and updating configuration files.

### Preparation

1. In order to improve the query performance, cube and segment will be upgraded during the upgrade process. As the precondition, *please ensure that there is no active build job before your upgrade, which includes running, pending, error and stopped*.

2. Please stop all KAP service and confirm that there is no running KAP process.

3. Please ensure the JDK version is 1.8 or above. You can use the following command to check the JDK version. If the version is under 1.8, please refer to "Upgrade FAQ" at the end of the page, which introduce how to upgrade JDK.

   ```
   java -version
   ```

### Perform the Upgrade

1. Stop and confirm that there is no running KAP process:

   ```shell
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```

2. Backup KAP installation directory and metadata:

   ```shell
   cp -r $KYLIN_HOME ${KYLIN_HOME}.backup
   $KYLIN_HOME/bin/metastore.sh backup
   ```

3. Decompress the Kyligence Enterprise package of new version. Update the value of the environment variable KYLIN_HOME: 

   ```shell
   tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
   export KYLIN_HOME={your-unpack-folder}
   ```

4. Update the configuration files

   upgrading from 2.4.0 version or above: 

   * replace new versions' `$KYLIN_HOME/conf` with old version's `$KYLIN_HOME/conf`.
   * `kylin.server.init-tasks` needs to be deleted or annotated in `kylin.server.init-tasks`.

   upgrading from 2.4.0 version below

   > Notice: for KAP 2.4 version below
   >
   > * The directory of ` setenv.sh` has changed, which moved to `$KYLIN_HOME/conf` since 2.4 version.
   > * Configuration file is not fully compatible, please don't copy and replace. 

   * Manually re-apply all changes in old version's `$KYLIN_HOME/conf` to new version's `$KYLIN_HOME/conf`.

   * Manually re-apply all changes in old version's `$KYLIN_HOME/bin/setenv.sh` to new version's `$KYLIN_HOME/conf/setenv.sh`. 

   * Manually delete `kylin.server.init-tasks` in `$KYLIN_HOME/conf/kylin.properties`.

   * Manually migrate ACL data. Please run commands below: 

     ```shell
     $KYLIN_HOME/bin/kylin.sh org.apache.kylin.tool.AclTableMigrationCLI MIGRATE
     ```

5. Start Kyligence Enterprise instance

   In the first time, cube and segment will be upgraded automatically. The upgrade time depends on your data size, which may cost 1 hour or longer.

   ```shell
   $KYLIN_HOME/bin/kylin.sh start
   ```

   If the upgrade succeeded, you may see:

   ```
   Segments have been upgraded successfully.
   ```

6. Upgrade succeed.

   The backup data including installation directory and metadata can be safely deleted. 

### Upgrade FAQ

*Q: If the JDK version of current cluster is less than 1.8, could I only upgrade the JDK which is used by Kyligence Enterprise process.*

Sure, please refer to the following steps:

* After download and decompress the JDK file, please prepare a file to store them in all nodes, such as `/usr/java/jdk1.8`. 
* Please add the following configurations in `$KYLIN_HOME/conf/kylin.properties`.

```shell
kap.storage.columnar.spark-conf.spark.executorEnv.JAVA_HOME=/usr/java/jdk1.8
kap.storage.columnar.spark-conf.spark.yarn.appMasterEnv.JAVA_HOME=/usr/java/jdk1.8
#If you need to use Spark building engine, please add the following properties
kylin.engine.spark-conf.spark.executorEnv.JAVA_HOME=/usr/java/jdk1.8
kylin.engine.spark-conf.spark.yarn.appMasterEnv.JAVA_HOME=/usr/java/jdk1.8
```

* In`$KYLIN_HOME/conf/`, please add the following configurations in `kylin_job_conf.xml` and `kylin_job_conf_inmem.xml`.

```xml
 <property>
        <name>mapred.child.env</name>
        <value>JAVA_HOME=/usr/java/jdk1.8</value>
    </property>
    <property>
        <name>yarn.app.mapreduce.am.env</name>
        <value>JAVA_HOME=/usr/java/jdk1.8</value>
    </property>
```
*Q: Do I need to manually upgrade cube and segment?*

No, the upgrade will be automatically started when you start Kyligence Enterprise in the first time.

*Q: How could I determine if the upgrade succeeded or failed?*

During the first upgrade progress, you may see:

* Successful tips:

  ```
  Segments have been upgraded successfully.
  ```

* Failed tips:

  ```
  Upgrade failed. Please try to run
  bin/kylin.sh io.kyligence.kap.tool.migration.ProjectDictionaryMigrationCLI FIX
  to fix.
  ```

*Q: If the upgrade failed, what could I do?*

If there is something wrong in the upgrade process, please run the following command to fix.

 `bin/kylin.sh io.kyligence.kap.tool.migration.ProjectDictionaryMigrationCLI FIX` . If the upgrade succeeded, you will see “Segments have been upgraded successfully”. If the fix command did not work, please contact Kyligence Support.

*Q: How could I roll back if the upgrade failed?*

If you back up the Kyligence Enterprise installation directory and metadata, you could roll back with the following steps:

- Stop and confirm that there is no running KAP process:

  ```shell
  $KYLIN_HOME/bin/kylin.sh stop
  ps -ef | grep kylin
  ```

- Restore the original installation directory:

  ```shell
  rm -rf $KYLIN_HOME
  cp -r ${KYLIN_HOME}.backup $KYLIN_HOME
  ```

- Restore metadata

  ```shell
  $KYLIN_HOME/bin/metastore.sh restore {your-backup-metadata-folder}
  ```

- Rollback finished and then you can start the original KAP

  ```shell
  $KYLIN_HOME/bin/kylin.sh start
  ```

  