## Upgrade to Kyligence Enterprise 3.x

This chapter introduces how to upgrade from an earlier version of Kyligence Enterprise to the latest version of Kyligence Enterprise 3.x software.

> **Note:** Starting with 3.x, the Kyligence Analytics Platform (KAP) was officially renamed to Kyligence Enterprise.

The upgrade process is different for a *main version* and a *minor version*. The first two in the version number are major version, such as KAP 2.x upgrade to Kyligence Enterprise 3.x and as Kyligence Enterprise 3.1.x upgrade to Kyligence Enterprise 3.2.x. Conversely, the first two in the version number not changing is a minor version upgrade, such as Kyligence Enterprise 3.2.1 upgrade to Kyligence Enterprise 3.2.2.

The metadata is compatible between two minor versions (with the same major version), so the upgrade only needs to overwrite the software package and update the configuration file. You may need to upgrade the metadata between the major versions or upgrade the existing cube data. It is recommended to back up the metadata and cube data to ensure the maximum safty of your data.

If the original version is KAP 2.x and one project contains multiple data sources like Hive and Kafka, you have to specify a default data source (RDBMS option is not available at this point) for this project after upgrading. Once it's set, it cannot be changed in future.

In order to ensure the safety and stability of production, we do not recommend directly upgrading a production environment. Instead we recommend you to prepare a test environment for the upgrade first, then upgrade the production environment when the test environment are upgraded and verified.

### Stop Kyligence Enterprise service

1. Make sure that there are no running jobs.

2. Kyligence Enterprise, and the Hadoop nodes that it runs on, require:

   - JDK 8 (64 bit) or above

   If your Hadoop cluster is based on JDK 7, please refer to [Run Kyligence Enterprise on JDK 7](../../appendix/run_on_jdk7.en.md).

3. Stop all Kyligence Enterprise service and ensure that no active Kyligence Enterprise instance will affect the upgrade.

   ```sh
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```

### Data Backup

In order to maximize the safty of data and the availability of services, we recommend backing up metadata and installation directories before upgrading. For major version upgrades, it is recommended to back up the cube data.

- Backup metadata

  ```sh
  $KYLIN_HOME/bin/metastore.sh backup
  ```

- Backup installation directory

  ```sh
  cp -r $KYLIN_HOME ${KYLIN_HOME}.backup
  ```

- Backup cube data (only for major version)

  Because the update of major version may affect existing cube data, we recommend you to back up the Cube data stored on HDFS for maximum data safty.

  - Make sure that there is enough space on your HDFS. 
    ```sh
    hdfs dfs -df -h /
    ```
  - Confirm the size of the Kyligence Enterprise working directory with the following command:
    ```sh
    hdfs dfs -du -h /kylin
    ```
   > **Note:** The working directory is specified by  `kylin.env.hdfs-working-dir` property in `$KYLIN_HOME/conf/kylin.properties`. The default value is `/kylin`
  - Verify that HDFS has enough space to copy the Kyligence Enterprise working directory and perform cube data backup
    ```sh
    hdfs dfs -cp /kylin /kylin_temp
    ```


### Update Installation Directory

Unzip the new version of the Kyligence Enterprise installation package and update the `KYLIN_HOME` environment variable:

```sh
tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
export KYLIN_HOME={your-unpack-folder}
```

### Update Configuration File

> **Note:**
> 1. Here we use `$OLD_KYLIN_HOME` for the pre-upgrade installation directory, and `KYLIN_HOME` for the upgraded installation directory.
> 2. In order to ensure that you enjoy the new features of the new version, please do *not* directly overwrite the new configuration folder with the old configuration folder.

- Quick configuration

  Two sets of configuration parameters are available in Kyligence Enterprise: `$KYLIN_HOME/conf/profile_prod` and `$KYLIN_HOME/conf/profile_min`. The former is the default solution for the actual production environment; the latter uses less resources and is suitable for environments with limited resources such as sandboxes. If your environment has limited resources, you can switch to the `profile_min` configuration.

  ```sh
  rm $KYLIN_HOME/conf/profile
  ln -s $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
  ```

- Modify the configuration changes in `setenv.sh` in the previous version of the `conf/` directory manually in the corresponding files in the new version.

  > **Note:** For KAP 2.3 or later, the path to the `setenv.sh` file has changed. In Kyligence Enterprise the file is located in the `$KYLIN_HOME/conf/` directory.

  - The configuration file related to the jobs can be overwritten, you can use the following command to use the previous version of the configuration file:
    ```sh
    cp $OLD_KYLIN_HOME/conf/kylin_*.xml $KYLIN_HOME/conf/
    ```

  - In the new version of the `conf/` directory, back up `kylin.properties` and copy the previous version of `kylin.properties` to the current directory.
    ```sh
    mv $KYLIN_HOME/conf/kylin.properties $KYLIN_HOME/conf/kylin.properties.template
    cp $OLD_KYLIN_HOME/conf/kylin.properties $KYLIN_HOME/conf/
    ```

    > **Note:** If you need to use existing metadata, you can modify it in `$KYLIN_HOME/conf/kylin.properties` according to the previous configuration file, as follows:
    >
    > ```properties
    > kylin.metadata.url = {your_kylin_metadata_url}
    > ```

- If Redis cluster is enabled to share sessions in multiple Kyligence Enterprise instance in your cluster, please refer to [Cluster Deployment and Load Balancing](../../installation/deploy/cluster_lb.en.md)
- If Kerberos is enabled, please refer to [Integrate with Kerberos](../../security/kerberos.en.md)
- If you modified running port of Kyligence Enterprise, please copy and replace the `$OLD_KYLIN_HOME/tomcat/conf/server.xml` to the new installation path.


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
> - If you encounter any problems during the upgrade, please contact Kyligence Technical Support via [Kyligence Support Portal] (https://support.kyligence.io/#/).
> - During the verification, please *DO NOT* perform a garbage cleanup operation to ensure data safty.

1. Confirm that Kyligence Enterprise Web UI can show up and log in normally.

2. Confirm basic functions work normally such as building a segment and running a query.

3. Verify that the integrated third-party systems of Kyligence Enterprise work successfully, such as clients that use JDBC for queries, clients that query the REST API, such as BI tools.

### Deleting Backup Files
After verify and confirm your Kyligence Enterpries is successfully upgraded to the new version, you can safely delete all metadata, installation directories, and cube data that were backed up before the upgrade.


### Roll Back After Upgrade Failed

> **Note:** Before the roll back, it's highly recommended to contacted Kyligence Support to check whether there is a solution for your issue first.

1. Stop and confirm that there are no Kyligence Enterprise processes running:
   ```sh
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```
2. Restore the original Kyligence Enterprise installation directory and update the `KYLIN_HOME` environment variable:
   ```sh
   rm -rf $KYLIN_HOME
   cp -r $OLD_KYLIN_HOME.backup $OLD_KYLIN_HOME
   cd $OLD_KYLIN_HOME
   export KYLIN_HOME=`pwd`
   ```
3. Restore metadata
   ```sh
   $KYLIN_HOME/bin/metastore.sh restore {your_backup_metadata_folder}
   ```
4. (Optional) Restore cube data
   ```sh
   hdfs dfs -rmr /kylin
   hdfs dfs -cp /kylin_temp /kylin
   ```
5. Start Kyligence Enterprise
   ```sh
   $KYLIN_HOME/bin/kylin.sh start
   ```
