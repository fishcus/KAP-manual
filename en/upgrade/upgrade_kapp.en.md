## Upgrading from KAP Plus##

### Upgrading from KAP Plus 2.X to KAP Plus of higher versions###

KAP Plus 2.X shares compatible metadata with other KAP Plus 2.X versions. Thus you could upgrade the system from KAP Plus 2.X to KAP Plus of higher versions by overwriting the software package, updating configuration files, and upgrading HBase coprocessors without upgrading the metadata unnecessarily. 

> Before upgrading from the older version, please ensure that all automated **metadata clean** and **storage cleanup CLI** tools are turned off to avoid the impact of the upgrade.

Please follow the steps below: 

1. Backup the metadata: 

   ```shell
   $KYLIN_HOME/bin/metastore.sh backup
   ```

2. Stop the running Kylin instance:

   ```shell
   $KYLIN_HOME/bin/kylin.sh stop
   ```

3. Unzip the KAP Plus package of new version. Update the value of the environment variable KYLIN_HOME: 

   ```shell
   tar -zxvf kap-{version-env}.tar.gz
   export KYLIN_HOME=...
   ```

4. Update the configuration files: 

   If you're upgrading from >=2.4.0 to a newer version, simply replace new versions' `$KYLIN_HOME/conf` with old version's `$KYLIN_HOME/conf`.

   > kylin.server.init-tasks needs to be deleted or annotated

   Otherwise if you're upgrading from <2.4.0, you need to: 1. manually re-apply all changes in old version's `$KYLIN_HOME/conf` to new version's `$KYLIN_HOME/conf`. 2. manually re-apply all changes in old version's `$KYLIN_HOME/bin/setenv.sh` to new version's `$KYLIN_HOME/conf/setenv.sh`. 3. manually delete kylin.server.init-tasks in `$KYLIN_HOME/conf/kylin.properties`.

   > Watch out: 1. the folder for setenv.sh has changed. 2. Direct file copy-and-replace is not allowed.

5. Upgrade and redeploy coprocessors: 

   ```shell
   $KYLIN_HOME/bin/kylin.sh org.apache.kylin.storage.hbase.util.DeployCoprocessorCLI default all
   ```

6. If you are upgrading from KAP Plus <2.4.0, you are required to migrate ACL data. Run commands below: 

   ```shell
   $KYLIN_HOME/bin/kylin.sh org.apache.kylin.tool.AclTableMigrationCLI MIGRATE
   ```

7. Confirm the License:

   Confirm the license file in the new directory of KAP.
8. Please ensure the JDK version is *1.8*.

9. Start the KAP Plus instance:

   If you are upgrading from KAP Plus <3.0, the project dictionary will be upgraded and metadata will backup automatically in the upgrade process.

   > Please ensured that there is no running segment before you upgrade.

   The upgrade will be automatically started when you start KAP. Meanwhile, all the cube json files will backup. If the upgrade succeeded, it would notice that “Migrate project dictionary successfully”. Otherwise, it would notice “Run Project Dictionary Migration failed. Please run cmd `bin/kylin.sh io.kyligence.kap.tool.migration.ProjectDictionaryMigrationCLI FIX` to fix it”.

   If there is something wrong in the upgrade process, please run the following command line to fix `bin/kylin.sh io.kyligence.kap.tool.migration.ProjectDictionaryMigrationCLI FIX` . If the fix command did not work, please contact Kyligence Support.

   ```shell
   $KYLIN_HOME/bin/kylin.sh start
   ```

   

