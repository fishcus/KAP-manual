## Upgrading from KAP Plus 2.x to Kyligence Enterprise 3.x ##

From 3.x, Kyligence Analytics Platform (KAP) renamed to Kyligence Enterprise.

KAP 2.x shares compatible metadata with higher versions. Therefore, you can upgrade from KAP 2.x to higher versions by just overwriting the software package and updating configuration files.

### Preparation

1. In order to improve the query performance, cube and segment will be upgraded during the upgrade process. As a precondition, *please ensure that there is no active build job before upgrade, which includes running, pending, error and stopped jobs*.

2. Please stop all KAP service and confirm that there is no running KAP process.

3. This product requires JDK 8 or above. Run the following command to check your JDK version. If your JDK version is 7 or below, you will find addition steps required in the following document. Please pay attention.

   ```bash
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

3. Unpack the Kyligence Enterprise package. Update the environment variable KYLIN_HOME: 

   ```shell
   tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
   export KYLIN_HOME={your-unpack-folder}
   ```

4. Update the configuration files

   Upgrading from version 2.4 or above: 

   * Overwrite the `$KYLIN_HOME/conf` by copying from your existing configuration files.
   * `kylin.server.init-tasks` needs to be deleted or commented out in `conf/kylin.properties`.

   Upgrading from version 2.3 or below:

   > Notice: For KAP version 2.3 or below
   >
   > * The location of ` setenv.sh` has changed. The file moved to `$KYLIN_HOME/conf` since 2.4 version.
   > * Configuration file is not fully compatible, please don't copy and overwrite. 

   * Manually re-apply all changes in old version's `$KYLIN_HOME/conf` on new version's `$KYLIN_HOME/conf`.

   * Manually re-apply all changes in old version's `$KYLIN_HOME/bin/setenv.sh` on new version's `$KYLIN_HOME/conf/setenv.sh`. 

   * Manually delete `kylin.server.init-tasks` in `conf/kylin.properties` if any.

   * Manually migrate ACL data. Please run: 

     ```shell
     $KYLIN_HOME/bin/kylin.sh org.apache.kylin.tool.AclTableMigrationCLI MIGRATE
     ```

5. If the Redis cluster is used to share sessions in your [cluster deployment](../install/adv_install_lb.en.md),  please do the following steps:

   - Copy the Redis jar packages to `$KYLIN_HOME/tomcat/lib` from your exisiting files.
   - Overwrite the  `$KYLIN_HOME/tomcat/content.xml` by copying from your existing configuration files.

6. If your cluster is based on JDK 7

   Please follow the steps in "[How to Run Kyligence Enterprise on Lower Version JDK](../install/about_low_version_jdk.en.md)".

7. Start Kyligence Enterprise

   During the first start, cube and segment will be upgraded automatically. The upgrade time depends on your data size, which could last for 1 hour or longer.

   ```shell
   $KYLIN_HOME/bin/kylin.sh start
   ```

   If the upgrade succeeded, you will see console prompt:

   ```
   Segments have been upgraded successfully.
   ```

8. Till now, the uprade is done.

   The backup data including old installation files and metadata can be safely deleted. 

### Upgrade FAQ

**Q: If my Hadoop cluster is JDK 7, can I upgrade to Kyligence Enterprise 3.x?.**

Sure, please refer to "[How to Run Kyligence Enterprise on Lower Version JDK](../install/about_low_version_jdk.en.md)".

**Q: Do I need to manually upgrade cube and segment?**

No, the upgrade will happen automatically when you start Kyligence Enterprise for the first time.

**Q: How could I determine if the upgrade has succeeded or not?**

During the first start of Kyligence Enterprise, you may see:

* Prompt in case of success:

  ```
  Segments have been upgraded successfully.
  ```

* Prompt in case of failure:

  ```
  Upgrade failed. Please try to run
  bin/kylin.sh io.kyligence.kap.tool.migration.ProjectDictionaryMigrationCLI FIX
  to fix.
  ```

**Q: If the upgrade failed, what could I do?**

If there is something went wrong in the upgrade process, please run the following command to fix.

```bash
bin/kylin.sh io.kyligence.kap.tool.migration.ProjectDictionaryMigrationCLI FIX
```

If the fix succeeded, you will see “Segments have been upgraded successfully”. If the fix failed again, please contact Kyligence Support for help.

**Q: How could I roll back if the upgrade failed?**

If you have backup of the KAP installation directory and metadata, you could roll back like below:

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

- Now rollback is finished and you can start the original KAP

  ```shell
  $KYLIN_HOME/bin/kylin.sh start
  ```
