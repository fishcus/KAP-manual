## Metadata Restore

### Metadata Detection

In order to avoid possible conflicts before starting recovery, this product will detect the *project and cube level*. The test situation is as follows:

- Detecting the segment of the project

When detecting, when there is a segment in the restored project, the metadata cannot be recovered. At this point, the user needs to clear the segment and then resume.

- Detecting models and cubes in the project

In the metadata recovery process at the project level, there may be cases where the project name is different but the project group model or cube name has a duplicate name with the model and cube in other projects. Therefore, the product will be restored before the metadata is restored. Test.

- Detecting a single cube

When the user restores the cube's metadata, its associated model may be associated with other cubes (not in the metadata), and restoring the metadata will only restore the models and cubes in the original data.

> Note: In this case, the cube in the non-metadata that is currently associated may be affected.

### Metadata Restore

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

> Note: The recover operation will overwrite the whole remote metadata with the local one, so you'd better make sure the KAP service is in a stopped or inactive state (no building task) when doing restore; otherwise some changes in remote metastore might be lost. 
>

