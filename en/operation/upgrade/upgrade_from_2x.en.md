## Upgrade from KAP 2.x to Kyligence Enterprise 3.x

> **Note:** Starting from 3.x, Kyligence Analytics Platform (KAP) was officially renamed to Kyligence Enterprise.

This chapter introduces how to upgrade from KAP 2.x to Kyligence Enterprise 3.x.

Since this is major version upgrade, we recommend backup of both metadata and cube data before upgrade. Please make sure HDFS has enough free space.

If the original version is KAP 2.x and one project contains multiple data sources like Hive and Kafka, you have to specify a default data source (RDBMS option is not available at this point) for this project after upgrading. Once it's set, it cannot be changed in future.

**Note**: In order to ensure the stability of production, directly upgrade in a production environment is not recommended. Instead, always test the upgrade in a test environment first.



### Before Upgrade

1. Make sure all jobs are fully completed, in either Successful or Discard state.

   For the unfinished jobs (Pending, Running, or Stopped), you can wait for them to complete or simply discard them if you plan to re-launch them later.

   > **Tips**: You can look for the bellow message in `kylin.log` to ensure the states of all jobs.
   >
   > ```
   > [JobFetcher-xxx] ... 0 running, 0 scheduled, 0 actual running, 0 stopped, 0 ready, 0 waiting, x succeed, 0 error, x discarded
   > ```

2. Kyligence Enterprise, and the Hadoop nodes that it runs on, require **JDK 8 (64 bit)** or above.

   If your Hadoop cluster is based on JDK 7, please refer to [Run Kyligence Enterprise on JDK 7](../../appendix/run_on_jdk7.en.md).

3. Stop all Kyligence Enterprise instances and ensure no Kyligence Enterprise process is still running.

   ```sh
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```

4. Clean up outdated data

   If there was not clean up job running regularly for KAP, we recommend clean up the outdated data before continuing. It can save time for later data backup. For details, please refer to the [Clean up Outdated Data](#Supplement: Clean up Outdated Data) at the end of this document.



### Data Backup

For maximal data safety, backup of metadata, cube data, and original installation is required before upgrade.

- Backup metadata

  ```sh
  $KYLIN_HOME/bin/metastore.sh backup
  ```

- Backup original installation

  ```sh
  cp -r $KYLIN_HOME ${KYLIN_HOME}.backup
  ```

- Backup cube data

  - Check that there is enough space on HDFS. 
    ```sh
    hdfs dfs -df -h /
    ```
  - Confirm the size of the Kyligence Enterprise working directory.
    ```sh
    hdfs dfs -du -h /kylin
    ```
    > **Tips:** The working directory is specified by the `kylin.env.hdfs-working-dir` property in `$KYLIN_HOME/conf/kylin.properties`. The default value is `/kylin`.

  - Backup the cube data if space allows.
    ```sh
    hadoop distcp /kylin /kylin_temp
    ```
    Double check the backup folder `/kylin_temp` is the same size as its origin.



### Update Installation Directory

Unzip the new version of the Kyligence Enterprise installation package and update the `KYLIN_HOME` environment variable:

```sh
tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
export KYLIN_HOME={your-unpack-folder}
```



### Update Configuration File

> **Note:**
> 1. Here we use `$OLD_KYLIN_HOME` for the pre-upgrade installation directory, and `KYLIN_HOME` for the upgraded installation directory.
> 2. In order for the new features of the new version to work properly, please do *not* directly overwrite the new configuration folder with the old configuration folder.

- Apply the configuration changes in `setenv.sh` in the previous version of the `conf/` directory manually to the corresponding files in the new version.

  For KAP 2.3 or later, the path to the `setenv.sh` file has changed. In Kyligence Enterprise the file is located in the `$KYLIN_HOME/conf/` directory.

- The configuration file related to the jobs can be overwritten.
  ```sh
  cp $OLD_KYLIN_HOME/conf/kylin_*.xml $KYLIN_HOME/conf/
  ```

- In the new version of the `conf/` directory, back up `kylin.properties` and copy the previous version of `kylin.properties` to the current directory.
  ```sh
  mv $KYLIN_HOME/conf/kylin.properties $KYLIN_HOME/conf/kylin.properties.template
  cp $OLD_KYLIN_HOME/conf/kylin.properties $KYLIN_HOME/conf/
  # if kylin.properties.override is also used
cp $OLD_KYLIN_HOME/conf/kylin.properties.override $KYLIN_HOME/conf/
  ```
  
  > **Note:** If you need to use existing metadata, you can modify it in `$KYLIN_HOME/conf/kylin.properties` according to the previous configuration file, as follows:
  >
  > ```properties
  > kylin.metadata.url = {your_kylin_metadata_url}
  > ```

- The new Kyligence Enterprise ships higher versions of Spark and Tomcat, and their configuration files may not be backward compatible. Please manually configure Spark and/or Tomcat again after running the upgrade script according to your needs. The configuration folders are `$KYLIN_HOME/spark/conf` and `$KYLIN_HOME/tomcat/conf`.

- If Redis cluster is enabled to share sessions in multiple Kyligence Enterprise instance in your cluster, please refer to [Cluster Deployment and Load Balancing](../../installation/deploy/cluster_lb.en.md).

- If Kerberos is enabled, please refer to [Integrate with Kerberos](../../security/kerberos.en.md).

- Apply new license file[Apply License](../../appendix/apply_license.en.md).

  


### Launching Kyligence Enterprise

Run the following command to start Kyligence Enterprise:
```sh
$KYLIN_HOME/bin/kylin.sh start
```

> **Note:** When upgrading Kyligence Enterprise 3.x from KAP 2.x, the metadata will be upgraded on the first launch of, depending on the size of your metadata, which may take an hour or longer. It is recommended to use `$KYLIN_HOME/bin/metastore.sh clean [--delete true]` for metadata cleanup before upgrading to remove the useless metadata and make the upgrade metadata time shorter.
>
> The following message will be shown after successful upgrade
> ```
> Segments have been upgraded successfully.
> ```
> The following message will be prompted if upgrade failed 
> ```
> Upgrade failed. Please try to run
> bin/kylin.sh io.kyligence.kap.tool.migration.ProjectDictionaryMigrationCLI FIX
> to fix.
> ```



### Verify Kyligence Enterprise is Upgraded Successfully

> **Note:**
> - If you encounter any problems during the upgrade, please contact [Kyligence Technical Support](https://support.kyligence.io/).
> - To ensure data safety, please *DO NOT* perform garbage cleanup operation during verification.

1. Confirm that Kyligence Enterprise Web UI can show up and log in normally.

2. Confirm basic functions work normally such as building a segment and running a query.

3. Verify that the integrated third-party systems of Kyligence Enterprise work successfully, such as clients that use JDBC for queries, clients that query the REST API, such as BI tools.



### Delete Backup Files

After verifying the Kyligence Enterprise is successfully upgraded to the new version, you can safely delete all backups of metadata, installation directory, and cube data that were created before the upgrade.



### Rollback in case of Upgrade Failure

**Recommend to consult Kyligence Technical Support before deciding to rollback.** More often than not, Kyligence support can help you solve the upgrade issues.

1. Stop and confirm that there are no Kyligence Enterprise processes running:
   ```sh
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```
2. Restore the original KAP installation directory and update the `KYLIN_HOME` environment variable:
   ```sh
   rm -rf $KYLIN_HOME
   cp -r ${KYLIN_HOME}.backup $KYLIN_HOME
   ```
3. Restore metadata
   ```sh
   $KYLIN_HOME/bin/metastore.sh restore {your_backup_metadata_folder}
   ```
4. Restore cube data
   ```sh
   hdfs dfs -rmr /kylin
   hadoop distcp /kylin_temp /kylin
   ```
5. Start Kyligence Enterprise again
   ```sh
   $KYLIN_HOME/bin/kylin.sh start
   ```



### Supplement: Clean up Outdated Data

Clean up the outdated data before upgrade is always a good idea, as it can save time for later data backup. Detailed steps below:

- Check metadata consistency

  ```sh
  $KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker check
  ```

  If inconsistency is detected, continue to recover

  ```sh
  $KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker recovery
  ```

- Clean up outdated metadata

  ```sh
  $KYLIN_HOME/bin/metastore.sh clean
  ```

  The first run without `--delete` option, only reports the items that can be cleaned. Check them and then do the real deletion.

  ```sh
  $KYLIN_HOME/bin/metastore.sh clean --delete true
  ```

- Clean up outdated cube data

  ```sh
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.storage.KapStorageCleanupCLI
  ```

  The first run without `--delete` option, only reports the items that can be cleaned. Check them and then do the real deletion.
  
  ```sh
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.storage.KapStorageCleanupCLI
  --delete true
  ```

> **Note**: The cleanup commands above work only for KAP 2.x. In Kyligence Enterprise 3.x, the [new routine tool](../routine_ops/routine_tool.en.md) provides the same cleanup function in a more friendly command line.
