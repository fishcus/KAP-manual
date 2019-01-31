## 日常运维工具

Kyligence Enterprise 提供了日常运维命令行工具。 用于对 Kyligence Enterprise 系统的日常运维，从而保证系统处于良好的运行状态。

日常运维工具主要负责：
- 元数据的检查，清理及修复
- 系统垃圾(HDFS/Hive/HBase)的检查，清理
- 元数据的备份

### 使用方法

```shell
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.routine.RoutineTool
```

默认执行此命令时，只检查`系统中的垃圾数据`以及`不一致的元数据`,并不会执行真正的清理动作。

此命令只支持标准的短参数以及标准的长参数，参数说明如下：

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

- `-c, --cleanup`: 指定这个参数来执行真正的数据删除
- `-f, --force`: 注意, 指定这个参数来检查或者删除 Hive 的**所有**的临时中间表
- `-r, --withRecovery`: 指定这个参数来检查并修复损坏的 Snapshot
- `-e, --excludeThreshold <arg>`: `<arg>` 为整数类型值， 指定清理元数据时排除检查元数据的时间，默认为1天， 最小值为 0 天；设置为 0 时， 即检查或清理系统中所有的元数据
- `-o, --outdatedThreshold <arg>`: `<arg>` 为整数类型值， 指定清理时保留的构建任务以及历史记录的时间，默认为 30 天，最小值为 0 天；设置为 0 时， 会清理系统中所有的构建任务以及所有的历史记录

**注意**， `-f` 参数以及 `-r` 参数，只有在 `-c` 参数执行时， 才会真正的执行数据的清理或者修复工作

### 元数据的备份

当此命令执行 `-c` 参数时， RoutineTool 会自动备份当前系统中除了 Dictionary 以及 Snapshot 之外的所有的元数据。当且仅当备份成功后， 才会执行清理工作。备份最多存在 5 份， 当有新的备份时，会将最旧的备份目录删除。

备份文件夹命名规范为 `meta_${timestamp}`，备份路径为 `$KYLIN_HOME/meta_backups`。

### 最佳实践

一般情况下， 我们建议用户每天执行如下命令来保证 Kyligence Enterprise 集群的性能。

```shell
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.routine.RoutineTool -c
```

执行此命令后，用户无需再单独执行`元数据检查工具` 或 `垃圾清理工具`

此工具的最佳实践, 我们建议用户写一个定时执行的 shell script, 在每天凌晨执行这个命令
