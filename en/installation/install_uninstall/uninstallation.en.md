## Uninstall
In this section, we will show you the steps to uninstall Kyligence Enterprise.

The complete steps to uninstall Kyligence Enterprise and remove all relevant data are as follows:

1. Run the following command on all Kyligence Enterprise nodes to stop the Kyligence Enterprise instance:

   ```shell
   $KYLIN_HOME/bin/kylin.sh stop
   ```

2. Data cleaning and backup (optional):

   - To ensure that some temporary data in Kyligence Enterprise are deleted in the external system, it is recommended that [storage cleanup](..\operation\storage_cleanup.en.md) operations should be performed before the formal unloading.

   - Backup metadata before full unloading so that it can be restored when needed.

     ```shell
     $KYLIN_HOME/bin/metastore.sh backup
     ```

     > Notice: We recommend that you copy metadata to more reliable storage devices later.

3. Please check the configuration file `$KYLIN_HOME/conf/kylin.properties`  to determine the name of the working directory. Suppose that your item is:

   ```properties
   kylin.hdfs.working.dir=/kylin
   ```

   Please run the following command to delete the working directory:

   ```shell
   hdfs dfs -rm -r /kylin
   ```

4. Please check the configuration file  `$KYLIN_HOME/conf/kylin.properties` to determine the name of the metadata table. Suppose that your item is:

   ```properties
   kylin.metadata.url=kylin_metadata@hbase
   ```

   Run the following command to delete the source data table:

   ```shell
   hbase shell
   disable_all "kylin_metadata.*"
   drop_all "kylin_metadata.*"
   ```

5. Run the following commands on all Kyligence Enterprise nodes to delete the Kyligence Enterprise installation:

   ```shell
   rm -rf $KYLIN_HOME
   ```

At this point, the Kyligence Enterprise uninstall is completed.