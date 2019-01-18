## Upgrade to Kyligence Enterprise 3.x

## Upgrade to the latest version of Kyligence Enterprise 3.x

This chapter describes how to upgrade from an earlier version of Kyligence Enterprise to the latest version of Kyligence Enterprise 3.x software.

> Tip: Starting with 3.x, the Kyligence Analytics Platform (KAP) was officially renamed Kyligence Enterprise.

The upgrade is divided into an upgrade of the **main version** and a **minor version**. The first two changes in the version number are major version upgrades, such as KAP 2.x upgrade to Kyligence Enterprise 3.x, such as Kyligence Enterprise 3.1.x upgrade to Kyligence Enterprise 3.2.x. Conversely, the first two versions of the version number do not change, which is a minor version upgrade, such as Kyligence Enterprise 3.2.1 upgrade to Kyligence Enterprise 3.2.2.

The metadata is compatible with the minor versions, so the upgrade only needs to overwrite the software package and update the configuration file. You may need to upgrade the metadata between the major versions or upgrade the existing Cube data. It is recommended to back up the metadata and Cube data. To ensure the maximum security of the data.

In order to ensure the safety and stability of production, we do not recommend upgrading Kyligence Enterprise directly in the production environment. We recommend that you prepare a test environment for the upgrade test until the test environment can be used stably with Kyligence Enterprise before upgrading in the production environment.



### Preparing for the upgrade

1. Make sure that ** there are no build tasks for ** in progress (ie wait, run, error, and pause), ie ** all tasks are done status** (ie success or termination).

2. The Kyligence Enterprise 3.x node and all the nodes in the Hadoop cluster running it, the required Java environment is: JDK 8 (64 bit) and above, you can view the JDK version by the following command:

   ```bash
   Java -version
   ```
   If your JDK version does not meet the requirements, please refer to [How to run on a lower version of JDK] (../../appendix/run_on_jdk7.cn.md)

3. Stop all Kyligence Enterprise services and ensure that no active Kyligence Enterprise processes affect the upgrade.

   ```sh
   $KYLIN_HOME/bin/kylin.sh stop
   Ps -ef | grep kylin
   ```



### data backup

In order to maximize the security of data and the availability of services, we recommend backing up metadata and installation directories before upgrading. For the major version upgrades, it is recommended to back up the Cube data.

- Backup metadata

  You can perform a backup of the metadata with the following command:

  ```sh
  $KYLIN_HOME/bin/metastore.sh backup
  ```

- Backup installation directory

  You can perform a backup of the installation directory with the following command:

  ```sh
  Cp -r $KYLIN_HOME ${KYLIN_HOME}.backup
  ```

- Backup Cube data (upgrade only for major versions)

  Because the major version of the upgrade may affect existing Cube data, we recommend that you back up the Cube data stored on HDFS for maximum data security and availability.

  - Please make sure that there is enough space on your HDFS. You can query the memory usage on HDFS by the following command:
    ```sh
    Hdfs dfs -df -h /
    ```
  - Confirm the size of the Kyligence Enterprise working directory with the following command:
    > Tip: The working directory is specified by the `kylin.env.hdfs-working-dir` parameter of `$KYLIN_HOME/conf/kylin.properties` in the configuration file. The default value is `/kylin`
    ```sh
    Hdfs dfs -du -h /kylin
    ```
  - Verify that HDFS has enough memory to copy the Kyligence Enterprise working directory and perform Cube data backup
    ```sh
    Hdfs dfs -cp /kylin /kylin_temp
    ```




### Update installation directory

Unzip the new version of the Kyligence Enterprise installation package and update the `KYLIN_HOME` environment variable:

```sh
Tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
Export KYLIN_HOME={your-unpack-folder}
```



### Update configuration file

> Tip:
>
> 1. The following uses `$OLD_KYLIN_HOME` for the pre-upgrade installation directory, and `KYLIN_HOME` for the upgraded installation directory.
>
> 2. In order to ensure that you enjoy the new features of the new version, please do not ** directly overwrite the new configuration folder with the old configuration folder.

- Quick configuration

  Two sets of configuration parameters are available in Kyligence Enterprise: `$KYLIN_HOME/conf/profile_prod/` and `$KYLIN_HOME/conf/profile_min/`. The former is the default solution for the actual production environment; the latter uses less resources and is suitable for environments with limited resources such as sandboxes. If your single point environment has limited resources, you can switch to the `profile_min` configuration.

  ```sh
  Rm $KYLIN_HOME/conf/profile
  Ln -s $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
  ```

- Modify the configuration changes in `setenv.sh` in the previous version of the `conf/` directory manually in the corresponding files in the new version.

  > Tip: For KAP 2.3 and below, the path to the `setenv.sh` file has changed. In Kyligence Enterprise the file is located in the `$KYLIN_HOME/conf/` directory.

  - The configuration file related to the build task can be overwritten, you can use the following command to use the previous version of the configuration file:
    ```sh
    Cp $OLD_KYLIN_HOME/conf/kylin_*.xml $KYLIN_HOME/conf/
    ```

  - In the new version of the `conf/` directory, back up `kylin.properties` and copy the previous version of `kylin.properties` to the current directory.
    ```sh
    Mv $KYLIN_HOME/conf/kylin.properties $KYLIN_HOME/conf/kylin.properties.template
    Cp $OLD_KYLIN_HOME/conf/kylin.properties $KYLIN_HOME/conf/
    ```

    > Tip: If you need to use existing metadata, you can modify it in `$KYLIN_HOME/conf/kylin.properties` according to the previous configuration file, as follows:
    >
    > ```properties
    > kylin.metadata.url = {your_kylin_metadata_url}
    > ```

- If your current cluster deployment is a Session share of multiple Kyligence Enterprise instances via Redis, you will also need to modify the Tomcat configuration file as follows:

  - Place the Redis related jar package in the `$KYLIN_HOME/tomcat/lib/` directory as follows:
    ```sh
    Cp $OLD_KYLIN_HOME/tomcat/lib/{jedis-2.0.0.jar,commons-pool2-2.2.jar,tomcat-redis-session-manager-1.2-tomcat-7-java-7.jar} $KYLIN_HOME/tomcat/ Lib/
    ```

  - Overwrite the Tomcat configuration file as follows:
    ```sh
    Cp $OLD_KYLIN_HOME/tomcat/conf/context.xml $KYLIN_HOME/tomcat/context.xml
    ```



### Launching Kyligence Enterprise

Run the following command to start:
```sh
$KYLIN_HOME/bin/kylin.sh start
```

> Tip: When upgrading Kyligence Enterprise 3.x from KAP 2.x, the metadata will be upgraded on the first launch of **, depending on the size of your data, which may be an hour or more. We recommend that you use `$KYLIN_HOME/bin/metastore.sh clean [--delete true]` for metadata cleanup before the upgrade to reduce useless metadata and make the upgrade metadata time shorter.
>
> Metadata will be prompted after successful upgrade
> ```
> Segments have been upgraded successfully.
> ```
> Failure will prompt
> ```
> Upgrade failed. Please try to run
> bin/kylin.sh io.kyligence.kap.tool.migration.ProjectDictionaryMigrationCLI FIX
> to fix.
> ```



### Is Kyligence Enterprise working properly after the upgrade?

> Tip:
> - If you have any problems after the upgrade, please contact Kyligence Technical Support for assistance in [Support Portal] (https://support.kyligence.io/#/).
> - During the test, please do not ** perform a garbage cleanup operation to ensure maximum data security.

1. Confirm that the Kyligence Enterprise Web UI can display and log in normally.

2. Perform basic operations such as building and querying to see if it works properly and if it takes time.
   If there are some issues that need to be fixed before the upgrade, please check if the new version solves your problem after upgrading.

3. Verify that the integrated third-party systems of Kyligence Enterprise work successfully, such as clients that use JDBC for queries, clients that query the REST API, such as BI tools.



### update successed

After testing to confirm that all features are available, you can save metadata by deleting metadata, installation directories, and cube data that were backed up before the upgrade.


### Upgrade failed, need to roll back to the previous version

> **Note: ** Please make sure that the problem you have encountered after the upgrade has been contacted by Kyligence Technical Support, Kyligence Technical Support cannot provide an effective solution to your problem and this issue affects your core usage, then choose to roll back .

1. Stop and confirm that there are no Kyligence Enterprise processes running:
   ```sh
   $KYLIN_HOME/bin/kylin.sh stop
   Ps -ef | grep kylin
```

2. Restore the original Kyligence Enterprise installation directory and update the `KYLIN_HOME` environment variable:
   ```sh
   Rm -rf $KYLIN_HOME
   Cp -r $OLD_KYLIN_HOME.backup $OLD_KYLIN_HOME
   Cd $OLD_KYLIN_HOME
   Export KYLIN_HOME=`pwd`
```

3. Restore metadata
   ```sh
   $KYLIN_HOME/bin/metastore.sh restore {your_backup_metadata_folder}
```

4. (Optional) Restore Cube Data
   ```sh
   Hdfs dfs -rmr /kylin
   Hdfs dfs -cp /kylin_temp /kylin
```

5. Start Kyligence Enterprise
   ```sh
   $KYLIN_HOME/bin/kylin.sh start
```