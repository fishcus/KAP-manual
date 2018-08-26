## How to Migrate Metadata from HBase to Relational Database

### Migration Steps

1. Backup metadata, please run the following command.

   ```shell
   $KYLIN_HOME/bin/metastore.sh backup
   ```

2. Use JDBC to connect relational database as metastore. For more details, please refer the related chapters.

3. Start Kyligence Enterprise to check the validity of configurations.

   ```shell
   $KYLIN_HOME/bin/kylin.sh start
   ```

4. Run the metadata restore command to migrate metadata.

   ```shell
   $KYLIN_HOME/bin/metastore.sh restore {path_to_backup}
   ```