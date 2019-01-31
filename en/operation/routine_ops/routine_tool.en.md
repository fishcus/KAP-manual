## Routine Operation Tool

Kyligence Enterprise provides a routine operation command tool to ensure that Kyligence Enterprise cluster has a good running status.

Routine Operation Tool in charge of:
- Metadata check, cleanup and recovery
- System Garbage(HDFS/Hive/HBase etc) check, cleanup
- Metadata backups

### Usage

```shell
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.routine.RoutineTool
```

When executing this command by default, it only checks the `system garbage` and `inconsistent metadata`, it won't take any cleanup actions.

This command supports the standard short options and the standard long options, details lists below:

```shell
usage: io.kyligence.kap.tool.routine.RoutineTool
 -c,--cleanup                   Check and cleanup metadata and also unused
                                storage.
 -e,--excludeThreshold <arg>    Specify how many days of recent metadata
                                to be excluded from cleanup and recovery,
                                default is 1 day. Only natural number
                                accepted.
 -f,--force                     Warning: Check or cleanup all hive
                                intermediate tables.
 -h,--help                      Print usage of RoutineTool.
 -o,--outdatedThreshold <arg>   Specify how many days of job record and
                                history to keep, default is 30 days. Only
                                natural number accepted.
 -r,--withRecovery              Check or cleanup with recover table
                                snapshot.
```

- `-c, --cleanup`: Specify this option for cleanup with deleting action
- `-f, --force`: Specify this option for check and clean `ALL` intermediate tables in Hive
- `-r, --withRecovery`: Specify this option for check and recover table snapshots
- `-e, --excludeThreshold <arg>`: `<arg>` is a value of int type, to specify how many days of recent metadata to be excluded from check and cleanup, default is 1 day, the minimum value is 0. When set as 0, the tool will check or cleanup all metadata in system.
- `-o, --outdatedThreshold <arg>`: `<arg>` is a value of int type, to specify how many days of job record and history to keep, default is 30 days, the minimum value is 0. When set as 0, the tool will clean all job records and all histories in the system.

### Metadata Backup

When execute the command with `-c` option, RoutineTool will backup metadata excluding `Dictionary` annd `Snapshot` automatically. Only when the backup has been succeeded, the cleanup action will be taken.

The `maximum quantity of backup is 5`, when there is a new backup, the tool will delete the oldest backup.

The name of backup follows the pattern `meta_${timestamp}`, the path is `$KYLIN_HOME/meta_backups`.

### Best Practice

In general case, we suggest that user should execute the command below in daily time to ensure the performance of Kyligence Enterprise cluster.

```shell
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.routine.RoutineTool -c
```

User does not need to execute `MetadataChecker` or `Gargbage Clean` when this command has been executed.

For best practice, we suggest that users write a scheduler shell script to invoke this command in the early morning
