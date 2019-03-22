## Routine Operation Tool

Kyligence Enterprise provides a routine operation tool to keep the system clean and in a healthy state, and hence ensure the system stability and performance. This tool provides following functionalities:

- Metadata check, cleanup, and recovery
- System garbage check, cleanup in HDFS / Hive / HBase etc.
- Metadata backup

> **Note:** We highly recommend you to run this tool on a regular basis during system idle time.

### How to Use

You can run this tool via command line:

```shell
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.routine.RoutineTool
```

Without any options or arguments, running this command only checks system metadata and garbage. No other actions like cleanup are taken. This command supports following options:

- `-c, --cleanup`: cleanup metadata and system garbage after check.
- `-e, --excludeThreshold <arg>`: specify how many days of recent metadata to be excluded from cleanup and recovery. `<arg>` is a number of days and default is 1 day.
- `-f, --force`: force to clean **ALL** intermediate tables in Hive.
- ` -h, --help`: print help message.
- `-r, --withRecovery`: recover table snapshots after check.
- `-o, --outdatedThreshold <arg>`: specify how many days of job history to keep during cleanup, default is 30 days.
- `-dl, --dumpLocation <arg>`: `<arg>` is the path of file system, specify the location for dumped metadata, default is the temporary folder of system.
- `-fm, --fastMode`: specify running as Fast-Mode, ignore metadata garbage checking and storage garbage checking
- `-gm, --gcMode`: specify running as GC-Mode, only collecting metadata garbage and storage garbage
- `-stb, --singleThreadBackup`: specify backup metadata by using single thread, default is multi-thread 

> **Caution:** 
> 1. `-f` and `-r` option applies only when `-c` is used in command line.
> 2. Please use `-f` option only when it's necessary, as it might affect running jobs.
> 3. The option `--fastMode` and `--gcMode` can not be used at the same time.

### Metadata Backup

When execute the command with `-c` option, RoutineTool will backup metadata excluding dictionary and snapshot automatically. Only when the backup process succeeds, the cleanup action will be taken.

By default, only 5 backups are kept in system. If there is a new backup, the tool will delete the oldest one. All backups files are stored under folder `$KYLIN_HOME/meta_backups` and file name pattern is `meta_${timestamp}`.

### Best Practice

For system daily operations, you can run this single command line without exectuing previous commands like  `MetadataChecker` or `Gargbage Clean` separately.

In general case, we suggest that you run the following command line on a daily basis. You can write a scheduler shell script to run it during system idle time, like at midnight when there is no jobs or queries in the system.

```shell
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.routine.RoutineTool -c
```

#### Enable Multi-Thread Execution

RoutineTool supports multi-thread mode to improve the performance of cleanup process.

Set the parameter `kap-tool.routine-tool.delete-task-thread-num` in `kylin.properties` configuration file:

- The value is `1` by default, means using single-thread mode to cleanup
- When setting the value to be greater than `1`, then multi-thread mode will be enabled and the value is number of threads.
