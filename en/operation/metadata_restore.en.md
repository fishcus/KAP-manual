## Metadata Restore

With the metadata backups, users can restore the metadata. Similar to the backup, KAP provides a  recovery tool, the usage is as follows:

```shell
$KYLIN_HOME/bin/metastore.sh restore /path_to_backup
```
If you recover from the previous example backup, run command:
```shell
cd $KYLIN_HOME
bin/metastore.sh restore meta_backups/meta_2016_06_10_20_24_50
```
When the restore operation is finished, you may click the `Reload Metadata` button on the right of System Config page to refresh the cache, and then you can see the latest metadata.

Note that the recover operation will overwrite the whole remote metadata with the local one, so you'd better make sure the KAP service is in a stopped or inactive state (no building task) when doing restore; otherwise some changes in remote metastore might be lost. If you want to minimize the impact, please use the "Selective Metadata Recover" method.

## Selective Metadata Recover (Recommended)

If only a couple of metadata files needs to be changed, the administrator can just pick these files to restore, without having to restore all the metadata. Compared to the full recovery, this approach is recommended because it is more efficient and causes less impact to users.

* Create a new empty directory, and then create subdirectories in it according to the structure of the metadata files to restore; for example, to restore a Cube instance, you should create a "cube" subdirectory:

```shell
mkdir /path_to_restore_new
mkdir /path_to_restore_new/cube
```

* Copy the metadata file to be restored to this new directory

```shell
cp meta_backups/meta_2016_06_10_20_24_50/cube/kylin_sales_cube.json /path_to_restore_new/cube/
```

At this point you can modify the metadata manually.

* Restore from this directory

```shell
cd $KYLIN_HOME
bin/metastore.sh restore /path_to_restore_new
```

Similarly, after the recovery is finished, click `Reload Metadata` button on the Web UI to flush cache.