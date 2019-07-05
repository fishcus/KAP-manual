## Upgrade to Latest Kyligence Enterprise 3.x

> **Note:**
>
> - If your current version is KAP 2.x, please refer to [Upgrade from KAP 2.x](upgrade_from_2x.en.md).
> - Starting from 3.x, Kyligence Analytics Platform (KAP) was officially renamed to Kyligence Enterprise.

There is difference between *main version upgrade* and *minor version upgrade*. Having change in the first or second number in version is called *major version upgrade*, such as from 3.2.x to 3.3.x. Having change in the last number in version is called *minor version upgrade*, such as from 3.3.0 to 3.3.3.

Minor version upgrade is of low risk and only metadata backup is required. However, for major version upgrade, we recommend to backup cube data as well for maximal data safety whenever resource allows.

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

### Data Backup

For maximal data safety, backup of metadata is required before upgrade. In addition, for major version upgrade, backup of cube data is also recommended whenever resource allows.

- Backup metadata

  ```sh
  $KYLIN_HOME/bin/metastore.sh backup
  ```

- Backup cube data (for major version upgrade)

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

### Unpack and Run the Upgrade Script

Unzip the new version of the Kyligence Enterprise installation package.

```sh
tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
```

Run the upgrade script in the unpack directory:

```
Usage: upgrade.sh <old-kylin-home> [--silent]

<old-kylin-home>   Specify the old version of the Kyligence Enterprise
                   installation directory. If not specified, use KYLIN_HOME by default.

--silent           Optional, don't enter interactive mode, automatically complete the upgrade.
```


- Unpack the new installation package. Call the unpacked folder `UNPACK_HOME`.

- Run the upgrade script：

  ```sh
  $UNPACK_HOME/bin/upgrade.sh $OLD_KYLIN_HOME
  ```
  
- Answer questions (y/n) in command line to finish the upgrade.

- Once done, the `OLD_KYLIN_HOME` will become the upgraded Kyligence Enterprise.

**Note**:

1. **For main version upgrade, the new version could ship higher versions of Spark and/or Tomcat, and their configuration files are not backward compatible.** In this case, please manually configure Spark and/or Tomcat again after running the upgrade script according to your needs. Please refer to [Integrate with Kerberos](../../security/kerberos.en.md) and [Cluster Deployment and Load Balancing](../../installation/deploy/cluster_lb.en.md). The configuration folders are `$KYLIN_HOME/spark/conf` and `$KYLIN_HOME/tomcat/conf`.
2. The script does in-place upgrade, which means the script will first backup `OLD_KYLIN_HOME`, and then upgrade in the same directory. `KYLIN_HOME` will not change after the upgrade.
3. Upgrade logs will be generated in directory `$UNPACK_HOME/logs` which include operation details.
4. Using `--silent` can upgrade without interaction. Please use the silent mode with the guidance from Kyligence Technical Support.

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
5. Start Kyligence Enterprise again
   ```sh
   $KYLIN_HOME/bin/kylin.sh start
   ```
