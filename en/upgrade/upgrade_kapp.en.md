## Upgrading from Kyligence Enterprise##

### Upgrading from Kyligence Enterprise 2.X to Kyligence Enterprise of higher versions###

Kyligence Enterprise 2.X shares compatible metadata with other Kyligence Enterprise 2.X versions. Thus you could upgrade the system from Kyligence Enterprise  2.X to Kyligence Enterprise of higher versions by overwriting the software package, updating configuration files, and upgrading HBase coprocessors without upgrading the metadata unnecessarily. 

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

3. Unzip the Kyligence Enterprise package of new version. Update the value of the environment variable KYLIN_HOME: 

   ```shell
   tar -zxvf kap-{version-env}.tar.gz
   export KYLIN_HOME=...
   ```

4. Update the configuration files: 

   If you're upgrading from >=2.4.0 to a newer version, simply replace new versions' `$KYLIN_HOME/conf` with old version's `$KYLIN_HOME/conf`.

   > kylin.server.init-tasks needs to be deleted or annotated

   Otherwise if you're upgrading from <2.4.0, you need to:

   1. manually re-apply all changes in old version's `$KYLIN_HOME/conf` to new version's `$KYLIN_HOME/conf`.
   2. manually re-apply all changes in old version's `$KYLIN_HOME/bin/setenv.sh` to new version's `$KYLIN_HOME/conf/setenv.sh`. 
   3. manually delete kylin.server.init-tasks in `$KYLIN_HOME/conf/kylin.properties`.

   > Watch out: 1. the folder for setenv.sh has changed. 2. Direct file copy-and-replace is not allowed.

5. If you are upgrading from Kyligence Enterprise <2.4.0, you are required to migrate ACL data. Run commands below: 

   ```shell
   $KYLIN_HOME/bin/kylin.sh org.apache.kylin.tool.AclTableMigrationCLI MIGRATE
   ```

6. Confirm the License:

   Confirm the license file in the new directory of Kyligence Enterprise.

7. Please ensure the JDK version is *1.8*.

   If there is only one node upgraded to JDK 1.8, please put the jdk file to the other nodes, such as `/usr/java/jdk1.8`. In addition to this, please add the following configurations.

   * Add the following properties in `$KYLIN_HOME/conf/kylin.properties`.

   ```shell
   kap.storage.columnar.spark-conf.spark.executorEnv.JAVA_HOME=/usr/java/jdk1.8
   kap.storage.columnar.spark-conf.spark.yarn.appMasterEnv.JAVA_HOME=/usr/java/jdk1.8
   #If you need to use Spark building engine, please add the following properties
   kylin.engine.spark-conf.spark.executorEnv.JAVA_HOME=/usr/java/jdk1.8
   kylin.engine.spark-conf.spark.yarn.appMasterEnv.JAVA_HOME=/usr/java/jdk1.8
   ```

   * Add the following configurations in `$KYLIN_HOME/conf/kylin_job_conf.xml` and `kylin_job_conf_inmem.xml`.

   ```xml
    <property>
           <name>mapred.child.env</name>
           <value>JAVA_HOME=/usr/java/jdk1.8</value>
       </property>
       <property>
           <name>yarn.app.mapreduce.am.env</name>
           <value>JAVA_HOME=/usr/java/jdk1.8</value>
       </property>
   ```

8. Start the Kyligence Enterprise instance:

   If you are upgrading from Kyligence Enterprise <3.0, the project dictionary will be upgraded and metadata will backup automatically in the upgrade process.

   *Please ensure that there is no running job before you upgrade, which include running, pending, error, stopped*

   The upgrade will be automatically started when you start Kyligence Enterprise. Meanwhile, all the cube json files will backup. If the upgrade succeeded, it would notice that “Segments have been upgraded successfully." Otherwise, it would notice “Upgrade failed. Please try to run `bin/kylin.sh io.kyligence.kap.tool.migration.ProjectDictionaryMigrationCLI FIX` to fix. ”.

   If there is something wrong in the upgrade process, please run the following command line to fix `bin/kylin.sh io.kyligence.kap.tool.migration.ProjectDictionaryMigrationCLI FIX` . If the fix command did not work, please contact Kyligence Support.

   ```shell
   $KYLIN_HOME/bin/kylin.sh start
   ```

   

