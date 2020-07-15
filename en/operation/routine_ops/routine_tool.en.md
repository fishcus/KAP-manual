## Routine Operation Tool

Kyligence Enterprise provides a routine tool to maintain the system, including metadata/outdated data check, cleanup and recovery. **Please make sure this tool is scheduled to run regularly during system free hours.**

This tool provides the following functionalities:

- Metadata check, cleanup and recovery
- Outdated data check and cleanup
- Metadata backup

### How to Use

You can run the below command line to use

```shell
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.routine.RoutineTool
```

Without options, this command does **checking only** and no change to data or metadata will be made. 

This command supports short and long options:

- `-c, --cleanup`: cleanup metadata and outdated data after check; without this option, no change to data or metadata will be made.
- `-e, --excludeThreshold <arg>`: specify how many days of recent metadata to be excluded from cleanup and recovery operation. `<arg>` is an integer value and default value is 1.
- ` -h, --help`: print help message.

> **Note**: A few additional advanced options:
>
> - `-f, --force`:  force delete **ALL** intermediate tables in Hive, only works together with the `-c` option. Don't use this unless necessary as it can impact running jobs.
> - `-r, --withRecovery`: recover table snapshots after check operation, only works together with the `-c` option.
> - `-o, --outdatedThreshold <arg>`: specify how many days of job history that will be ignored during cleaning. `<arg>` is an integer value and default value is 30 (But at least one capacity historical data will be saved).
> - `-dl, --dumpLocation <arg>`: specify the location for dumped metadata. `<arg>` indicates the file system path and default is the temporary folder of system.
> - `-fm, --fastMode`: specify running as Fast-Mode, which only does the checking of inconsistent metadata. Checking of outdated data and metadata is ignored.
> - `-stb, --singleThreadBackup`: run metadata backup in single thread, default is multi-thread.
> - Further, in `$KYLIN_HOME/conf/kylin.properties`, set `kap.tool.routine-tool.delete-task-thread-num` to enable multi-thread on data deletion. In case of deleting a large number of outdated data files, multi-thread can improve performance to some extent.

### Metadata Backup

When execute the command with `-c` option, this tool will backup metadata excluding dictionary and snapshot before making any changes. Only when backup process succeeds, the cleanup action will be taken.

By default, only 5 backups will be kept. If there is a new backup, the tool will delete the oldest one. All backup files are stored under folder `$KYLIN_HOME/meta_backups` and file name pattern is `meta_${timestamp}`.

### Best Practice

We recommend running this tool regularly to ensure the stability and performance of Kyligence Enterprise. Schedule to run bellow command periodically during system is free hours, such as every midnight.

```shell
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.routine.RoutineTool -c
```

As outdated metadata is cleaned, you may go to Kyligence Enterprise Web UI to reload metadata after cleanup is finished.

**Note**:

1. For Multi-Tenancy deployment mode, please run this tool **in each tenant** separately because of the resource isolation.
2. For Read/Write deployment mode, it is only supported to run this tool in **Write Cluster**.