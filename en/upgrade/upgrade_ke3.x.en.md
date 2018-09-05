## Upgrading from Kyligence Enterprise 3.x to Latest Version ##

Kyligence Enterprise shares compatible metadata with higher versions. Therefore, you can upgrade from Kyligence Enterprise 3.x to higher versions by just overwriting the software package and updating configuration files.

### Preparation

1. Please stop all Kyligence Enterprise service and confirm that there is no running Kyligence Enterprise process.


### Perform the Upgrade

1. Stop and confirm that there is no running Kyligence Enterprise process:

   ```shell
   $KYLIN_HOME/bin/kylin.sh stop
   ps -ef | grep kylin
   ```

2. Backup Kyligence Enterprise installation directory and metadata:

   ```shell
   cp -r $KYLIN_HOME ${KYLIN_HOME}.backup
   $KYLIN_HOME/bin/metastore.sh backup
   ```

3. Unpack the Kyligence Enterprise package. Update the environment variable KYLIN_HOME: 

   ```shell
   tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
   export KYLIN_HOME={path_to_unpack_folder}
   ```

4. Update the configuration files

   * Overwrite the `$KYLIN_HOME/conf` by copying from your existing configuration files.
   * `kylin.server.init-tasks` needs to be deleted or commented out in `conf/kylin.properties`.

5. If the Redis cluster is used to share sessions in your [cluster deployment](../install/adv_install_lb.en.md),  please do the following steps:

   * Copy the Redis jar packages to `$KYLIN_HOME/tomcat/lib` from your exisiting files.
   * Overwrite the  `$KYLIN_HOME/tomcat/content.xml` by copying from your existing configuration files.

6. Start Kyligence Enterprise

   ```shell
   $KYLIN_HOME/bin/kylin.sh start
   ```

7. Till now, the uprade is done.

   The backup data including old installation files and metadata can be safely deleted. 

### Upgrade FAQ

**Q: How could I roll back if the upgrade failed?**

If you have backup of the Kyligence Enterprise installation directory and metadata, you could roll back like below:

- Stop and confirm that there is no running Kyligence Enterprise process:

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
  $KYLIN_HOME/bin/metastore.sh restore {path_to_your_backup_metadata_folder}
  ```

- Now rollback is finished and you can start the original Kyligence Enterprise

  ```shell
  $KYLIN_HOME/bin/kylin.sh start
  ```
