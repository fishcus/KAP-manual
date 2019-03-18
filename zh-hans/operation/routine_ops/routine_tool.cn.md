## 日常运维工具

Kyligence Enterprise 提供了日常运维命令行工具，用于系统元数据/数据的检查、清理与恢复，从而保证系统处于良好的运行状态。

日常运维工具主要负责：
- 元数据的检查，清理及修复
- 系统垃圾（HDFS / Hive / HBase）的检查与清理
- 元数据的备份

### 使用方法

Kyligence Enterprise 的日常运维工具通过以下命令行运行：

```shell
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.routine.RoutineTool
```

在不加任何参数执行此命令时，它只会检查系统中的垃圾数据以及不一致的元数据，并不会执行真正的清理动作。

此命令支持标准的短参数和长参数，参数说明如下：

- `-c, --cleanup`：执行数据清理和删除
- `-e, --excludeThreshold <arg>`：指定清理元数据时需要排除的最近元数据时间阈值（天数），`<arg>` 为整数类型值 。默认为 1 天，表示最近 1 天的元数据无需执行清理。
- `-f, --force`: 强制删除 Hive 的**所有**的临时中间表。
- `-h, --help`: 打印帮助信息。
- `-r, --withRecovery`: 指定这个参数来检查并修复损坏的快照。
- `-o, --outdatedThreshold <arg>`: `<arg>` 为整数类型值， 指定清理时保留的构建任务以及历史记录的时间，默认为 30 天。
- `-dl,--dumpLocation <arg>`: `<arg>` 为系统路径, 指定清理时导出的元数据的位置，默认为系统的临时目录。
- `-fm,--fastMode`: 指定这个参数来启用快速模式，忽略元数据垃圾检查以及存储中垃圾检查。
- `-gm,--gcMode`: 指定这个参数来启用垃圾清理模式，只进行元数据垃圾检查以及存储中垃圾检查。
- `-stb,--singleThreadBackup`: 指定这个参数在备份元数据时启用单线程, 默认为多线程。


> **注意**：
> 1. `-f` 参数以及 `-r` 参数只有同时与 `-c` 参数执行时才能生效。
> 2. 请谨慎使用 `-f` 参数，因为它可能会影响正在运行的任务。
> 3. `--fastMode` 以及 `--gcMode` 不能够同时使用

### 元数据的备份

当此命令使用 `-c` 参数执行时， RoutineTool 会自动备份当前系统中除了字典（dictionary），快照（snapshot），以及统计（statistics）之外的所有的元数据。当且仅当备份成功后， 才会执行清理工作。备份最多留存 5 份， 之后当有新的备份时，会将最旧的备份删除。

备份文件存储路径为 `$KYLIN_HOME/meta_backups`，备份文件夹命名规范为 `meta_${timestamp}`。

### 最佳实践

对于日常的系统运维，您可以使用这一个命令行完成，而无需像以前一样单独去运行元数据检查工具命令行和垃圾清理工具命令行。

我们建议您能够定期执行该命令行，来保证 Kyligence Enterprise 集群的稳定性和性能。您可以编写一个定时执行的 shell 脚本，在系统空闲时，比如每天凌晨执行。

```shell
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.routine.RoutineTool -c
```

