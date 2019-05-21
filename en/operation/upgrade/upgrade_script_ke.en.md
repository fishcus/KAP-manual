## Upgrade to Kyligence Enterprise 3.x with Upgrade Script

> **Note:** Starting with 3.x, the Kyligence Analytics Platform (KAP) was officially renamed to Kyligence Enterprise.

**For Kyligence Enterprise 3.3.0 and below, there is no upgrade script. Please refer to [this document for manual upgrade](../../appendix/upgrade_ke.en.md).**

The upgrade process is different for upgrading a *main version* and upgrading a *minor version*. The first two in the version number are major version, such as KAP 2.x upgrade to Kyligence Enterprise 3.x and as Kyligence Enterprise 3.1.x upgrade to Kyligence Enterprise 3.2.x. Conversely, the first two in the version number not changing is a minor version upgrade, such as Kyligence Enterprise 3.2.1 upgrade to Kyligence Enterprise 3.2.2.

The metadata is compatible between two minor versions (with the same major version), so the upgrade only needs to run the upgrade script.

You may need to upgrade the metadata between the major versions or upgrade the existing cube data. It is recommended to back up the metadata and cube data to ensure the security of your data.

If the original version is KAP 2.x and one project contains multiple data sources like Hive and Kafka, you have to specify a default data source (RDBMS option is not available at this point) for this project after upgrade. Once it's set, it cannot be changed in future.

**Note**: In order to ensure the stability of production, we do not recommend directly upgrade in a production environment. Instead, always test the upgrade in a test environment first.

### Stop Kyligence Enterprise Service

1. Make sure all jobs are fully completed, in either Successful or Discard state.

   - You can wait till all running jobs are completed, or simply discard them if you plan to re-launch them later.

2. Kyligence Enterprise, and the Hadoop nodes that it runs on, require:

   - JDK 8 (64 bit) or above

   If your Hadoop cluster is based on JDK 7, please refer to [Run Kyligence Enterprise on JDK 7](../../appendix/run_on_jdk7.en.md).

3. Stop all Kyligence Enterprise service and ensure that no active Kyligence Enterprise instance will affect the upgrade.

   ```sh
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```

### Data Backup

For maximum data security, backing up metadata before upgrade is necessary. For major version upgrades, backing up the cube data is also highly recommended.

- Backup metadata

  ```sh
  $KYLIN_HOME/bin/metastore.sh backup
  ```

- Backup cube data (only for major version)

  Because the update of major version may affect existing cube data, we recommend you to back up the cube data stored on HDFS if resource permits.

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
    hadoop distcp /kylin /kylin_temp
    ```

### Unpack and Run the Upgrade Script

Unzip the new version of the Kyligence Enterprise installation package.

```sh
tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
```

Run the upgrade script in the unpack directory:

```sh
Usage: upgrade.sh <OLD_KYLIN_HOME> [--silent]

<OLD_KYLIN_HOME>   Specify the old version of the Kyligence Enterprise
                   installation directory. If not specified, use KYLIN_HOME by default.

--silent           Optional, don't enter interactive mode, automatically complete the upgrade.
```


- Run the upgrade script：

  ```sh
  $UNPACK_HOME/bin/upgrade.sh $OLD_KYLIN_HOME
  ```
  
- Answer questions (y/n) in command line to finish the upgrade.

- Once done, the `OLD_KYLIN_HOME` will become the upgraded Kyligence Enterprise.

Notes on the upgrade script:

1. For **main version**, upgrade script cannot upgrade Spark or Tomcat automatically. Please configure it after running of upgrade script. Please refer to [Integrate with Kerberos](../../security/kerberos.en.md) and [Cluster Deployment and Load Balancing](../../installation/deploy/cluster_lb.en.md).
2. The script does in-place upgrade, which means the upgrade script will backup `OLD_KYLIN_HOME` and rename `UNPACK_HOME` to `OLD_KYLIN_HOME`. Constant installation directory is suggested. It doesn't need extra configuration change, such as `kylin.env.hadoop-conf-dir`, after on site upgrade.
3. Upgrade logs will be generated in directory `$UNPACK_HOME/logs` which include operation details.
4. Parameter `--silent` allows upgrade script into silent mode. In this mode, confirmation operations are no needed. Please use the parameter in the help of Kyligence Technical Support.

### Verify Kyligence Enterprise is Upgraded Successfully

> **Note:**
> - If you encounter any problems during the upgrade, please contact Kyligence Technical Support via [Kyligence Support Portal](https://support.kyligence.io/#/).
> - During the verification, please *DO NOT* perform a garbage cleanup operation to ensure data safty.

1. Confirm that Kyligence Enterprise Web UI can show up and log in normally.

2. Confirm basic functions work normally such as building a segment and running a query.

3. Verify that the integrated third-party systems of Kyligence Enterprise work successfully, such as clients that use JDBC for queries, clients that query the REST API, such as BI tools.

### Delete Backup Files
After verify and confirm your Kyligence Enterpries is successfully upgraded to the new version, you can safely delete all metadata, installation directories, and cube data that were backed up before the upgrade.


### Roll Back After Upgrade Failed

**Before you decide to roll back**, it's highly recommended to contacted Kyligence Support to check whether there is a solution for your issue first.

1. Stop and confirm that there are no Kyligence Enterprise processes running:
   ```sh
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```
2. Restore the original Kyligence Enterprise installation directory and update the `KYLIN_HOME` environment variable:
   ```sh
   rm -rf $KYLIN_HOME
   tar -zxf $OLD_KYLIN_HOME.backup.tar.gz
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
   hadoop distcp /kylin_temp /kylin
   ```
5. Start Kyligence Enterprise
   ```sh
   $KYLIN_HOME/bin/kylin.sh start
   ```
