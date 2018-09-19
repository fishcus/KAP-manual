## Upgrading from Apache Kylin

Kyligence Enterprise is developed based on Apache Kylin. Users could upgrade the system from Apache Kylin to Kyligence Enterprise conveniently. It needs to be noted that Kyligence Enterprise uses the new storage engine KyStorage. Therefore, the storage engine also needs to upgrade when upgrading from Kylin to Kyligence Enterprise. 

### Perform the Upgrade

1. Stop the running Kylin instance:

   ```shell
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```

2. Backup the metadata: 

   ```shell
   cp -r $KYLIN_HOME ${KYLIN_HOME}.backup
   $KYLIN_HOME/bin/metastore.sh backup
   ```

3. Unzip the Kyligence Enterprise package and update the value of the environment variable `KYLIN_HOME`: 

   ```shell
   tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
   export KYLIN_HOME={your-unpack-folder}
   ```

4. Modify configuration parameters: 

   Kyligence Enterprise provides two sets of parameters: `conf/profile_prod/` and `conf/profile_min/`, in which the former is the default setting. If you are going to run Kyligence Enterprise in environments with shortage of resources, such as sandboxes, run commands below to switch to `conf/profile_min/`: 

   ```shell
   rm $KYLIN_HOME/conf/profile
   ln -s $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
   ```

5. Update the configuration files: 

   * manually re-apply all changes in old version's `$KYLIN_HOME/conf` to new version's `$KYLIN_HOME/conf`.
   * manually re-apply all changes in old version's `$KYLIN_HOME/bin/setenv.sh` to new version's `$KYLIN_HOME/conf/setenv.sh`. 

   > Notice:
   >
   > * the folder for `setenv.sh` has changed, which located at `$KYLIN_HOME/conf`.
   >
   > * Direct file copy-and-replace is not allowed.
   >
   > * If you want to use the exsiting metadata, please do the following changes in `$KYLIN_HOME/conf/kylin.properties`
   >
   >   ```shell
   >   kylin.metadata.url = {your_kylin_metadata_url}
   >   ```

6. Update the information of cubes to adapt some advanced settings: 

   ```shell
   $KYLIN_HOME/bin/metastore.sh refresh-cube-signature
   ```

7. User data also needs to be upgraded because Kyligence Enterprise uses a new concept named user group to manage users.

   ```shell
   $KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.metadata.UserAuthorityUpgraderCLI
   ```
   After the upgrade, please reset the ADMIN password by the following commands.

   ```shell
   $KYLIN_HOME/bin/kylin.sh admin-password-reset
   ```

8. Start the Kyligence Enterprise instance: 

   ```shell
   $KYLIN_HOME/bin/kylin.sh start
   ```

9. Upgrade cube storage engine:

  Cubes built after upgrading use KyStorage as their storage engine, while old cubes use HBase. If it was not necessary for you to reserve data of built cubes, just follow steps below to **rebuild** old cubes: 

  - Save the current metadata into `$KYLIN_HOME/meta_backups/<path_of_BACKUP_FOLDER>`: 

    ```shell
    $KYLIN_HOME/bin/metastore.sh backup
    ```

  - Upgrade metadata in `meta_backups/` to adjust it to KyStorage: 

    ```shell
    $KYLIN_HOME/bin/metastore.sh promote $KYLIN_HOME/meta_backups/<path_of_BACKUP_FOLDER>
    ```

  - Restore metadata in `meta_backups/` to overwrite the old metadata: 

    ```shell
    $KYLIN_HOME/bin/metastore.sh restore $KYLIN_HOME/meta_backups/<path_of_BACKUP_FOLDER>
    ```

  - Reload metadata on Kyligence Enterprise GUI, purge all cubes manually, and rebuild them. 
