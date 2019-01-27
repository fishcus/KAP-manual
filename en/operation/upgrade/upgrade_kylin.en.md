## Upgrade From Apache Kylin

Kyligence Enterprise is an enterprise software based on Apache Kylin. This chapter describes how to easily upgrade from Apache Kylin v2.3+ to the latest version of Kyligence Enterprise 3.x software.


### Ready to work

- Stop the Apache Kylin instance:
  ```shell
  $KYLIN_HOME/bin/kylin.sh stop
  ```

  Confirm no running Kylin instance

  ```shell
  ps -ef | grep kylin
  ```

- Back up the Kylin installation directory and metadata:

  ```shell
  cp -r $KYLIN_HOME ${KYLIN_HOME}.backup
  $KYLIN_HOME/bin/metastore.sh backup
  ```

- Unzip the Kyligence Enterprise installation package. Update the `KYLIN_HOME` environment variable value:

  ```shell
  tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
  export KYLIN_HOME={your-unpack-folder}
  ```


### Update configuration

- Quick configuration Kyligence Enterprise

  Two sets of configuration parameters are available in Kyligence Enterprise: `$KYLIN_HOME/conf/profile_prod` and `$KYLIN_HOME/conf/profile_min`. The former is the default solution for the actual production environment; the latter uses less resources and is suitable for environments with limited resources such as sandboxes. If your environment has limited resources, you can switch to the `profile_min` configuration.

  ```shell
  rm $KYLIN_HOME/conf/profile
  ln -s $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
  ```

- Manually modify configuration changes in Kylin in Kyligence Enterprise

  > **Note**: The configuration file is not fully compatible, please do *not* direct copy and replace the configuration file.

  - Redo the changes in `$KYLIN_HOME/conf/` in Kyligence Enterprise's `$KYLIN_HOME/conf/`;
  - Redo the changes in `$KYLIN_HOME/bin/setenv.sh` in Kyligence Enterprise's `$KYLIN_HOME/conf/setenv.sh`.

    > Note: The path to `setenv.sh` has been changed. The file is located in the `$KYLIN_HOME/conf/` directory in Kyligence Enterprise.


- If you need to use existing metadata, you need to modify the following configuration in `$KYLIN_HOME/conf/kylin.properties`,

  ```properties
  kylin.metadata.url={your_kylin_metadata_url}
  ```

- Since the Cube allows you to set some advanced settings in Kyligence Enterprise, you need to manually refresh the Cube information:

  ```shell
  $KYLIN_HOME/bin/metastore.sh refresh-cube-signature
  ```

- Due to the introduction of user groups in Kyligence Enterprise, users in Apache Kylin need to be upgraded:

  ```shell
  $KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.metadata.UserAuthorityUpgraderCLI
  ```

  After the upgrade is complete, you also need to reset the password for the ADMIN user:

  ```shell
  $KYLIN_HOME/bin/kylin.sh admin-password-reset
  ```


### Launch Kyligence Enterprise

```shell
$KYLIN_HOME/bin/kylin.sh start
```


### Upgrading the storage engine

Apache Kylin uses HBase as the storage engine, and Kyligence Enterprise uses KyStorage as the storage engine by default. The steps to upgrade the storage engine are as follows:

- Back up current metadata

  ```shell
  $KYLIN_HOME/bin/metastore.sh backup
  ```

- Upgrade the backed up metadata to fit the KyStorage storage engine

  ```shell
  $KYLIN_HOME/bin/metastore.sh promote $KYLIN_HOME/meta_backups/<metadata-backup-folder>
  ```

- Restore upgraded metadata

  ```shell
  $KYLIN_HOME/bin/metastore.sh restore $KYLIN_HOME/meta_backups/<metadata-backup-folder>
  ```

- After clicking *Reload Metadata* on the *System* page of the Kyligence Enterprise web UI, please purge all Cube Segments and rebuild all cubes.