## Upgrade to Kyligence Enterprise 3.x with upgrade script

In order to simplify upgrade operation, upgrade script is provided since Kyligence Enterprise 3.3.1

> **Note:** Starting with 3.x, the Kyligence Analytics Platform (KAP) was officially renamed to Kyligence Enterprise.

> upgrade script is available since Kyligence Enterprise 3.3.1

The upgrade process is different for a *main version* and a *minor version*. The first two in the version number are major version, such as KAP 2.x upgrade to Kyligence Enterprise 3.x and as Kyligence Enterprise 3.1.x upgrade to Kyligence Enterprise 3.2.x. Conversely, the first two in the version number not changing is a minor version upgrade, such as Kyligence Enterprise 3.2.1 upgrade to Kyligence Enterprise 3.2.2.

The metadata is compatible between two minor versions (with the same major version), so the upgrade only needs to run the upgrade script.

You may need to upgrade the metadata between the major versions or upgrade the existing cube data. It is recommended to back up the metadata and cube data to ensure the maximum safty of your data.

If the original version is KAP 2.x and one project contains multiple data sources like Hive and Kafka, you have to specify a default data source (RDBMS option is not available at this point) for this project after upgrade. Once it's set, it cannot be changed in future.

In order to ensure the safety and stability of production, we do not recommend directly upgrade a production environment. Instead we recommend you to prepare a test environment for the upgrade first, then upgrade the production environment when the test environment are upgraded and verified.

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

In order to maximize the safty of data and the availability of services, we recommend backing up metadata before upgrade. For major version upgrades, it is recommended to back up the cube data.

- Backup metadata

  ```sh
  $KYLIN_HOME/bin/metastore.sh backup
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
    hadoop distcp /kylin /kylin_temp
    ```


### Update Installation Directory

Unzip the new version of the Kyligence Enterprise installation package and update the `KYLIN_HOME` environment variable:

```sh
tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
export KYLIN_HOME={your-unpack-folder}
```

### Run upgrade script

example:

```sh
Usage: upgrade.sh <OLD_KYLIN_HOME> [--silent]

<OLD_KYLIN_HOME>   Specify the old version of the Kyligence Enterprise
                   installation directory. If not specified, use KYLIN_HOME by default.

--silent           Optional, don't enter interactive mode, automatically complete the upgrade.
```


- Run upgrade script：

  ```sh
  $NEW_KYLIN_HOME/bin/upgrade.sh $OLD_KYLIN_HOME
  ```
  
- Enter the interactive upgrade mode, Use command (y/n) to finish upgrade according tips and reality.

### Cautions
1. For **main version**, upgrade script cannot upgrade Spark or Tomcat automatically. Please configure it after running of upgrade script. （Reference [Integrate with Kerberos](../../security/kerberos.en.md) 和 [Cluster Deployment and Load Balancing](../../installation/deploy/cluster_lb.en.md)）
2. It is on site upgrade, which means the upgrade script will backup `OLD_KYLIN_HOME` and rename `NEW_KYLIN_HOME` to `OLD_KYLIN_HOME`. Constant installation directory is suggested. It doesn't need extra configuration change, such as `kylin.env.hadoop-conf-dir`, after on site upgrade.
3. Upgrade logs will be generated in directory `$NEW_KYLIN_HOME/logs` which include operation details.
4. Parameter `--silent` allows upgrade script into silent mode. In this mode, confirmation operations are no needed. Please use the parameter in the help of Kyligence Technical Support

### Verify Kyligence Enterprise is Upgraded Successfully

> **Note:**
> - If you encounter any problems during the upgrade, please contact Kyligence Technical Support via [Kyligence Support Portal](https://support.kyligence.io/#/).
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
