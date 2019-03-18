## 垃圾清理 (Deprecated)

> **注意：** 从 Kyligence Enterprise 3.2.2 开始，此垃圾清理命令行工具将不再维护。建议您使用新的日常运维工具，完成系统的垃圾检查与清理。具体使用方法，请参考[日常维护工具](./routine_tool.cn.md)。

在 Kyligence Enterprise 运行一段时间之后，有很多数据因为不再使用而变成了垃圾数据，这些数据占据着系统资源，当积累到一定规模会对集群性能产生影响。

这些垃圾数据主要包括：

- Purge 之后原 Cube 的数据
- Segment 合并之后原 Segment 的数据
- 任务中未被正常清理的临时文件
- 旧的 Cube 构建任务历史

> **注意：**
>
> 1. 数据一经删除将彻底无法恢复！ 建议使用前，进行元数据备份，并对目标资源进行谨慎核对。
> 2. 请尽量在没有（或少有）构建任务时清理垃圾，以最大限度地保障数据安全。

### 垃圾清理工具
Kyligence Enterprise 提供了一个命令行工具清理系统垃圾。

```sh
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.storage.KapGarbageCleanupCLI [--delete true]
```

这个命令寻找并打印出系统中的垃圾数据

- 无用的 Cube 数据
- 在 Cube 构建时创建的但未被正常清理的的 Hive 中间表、HDFS 临时文件
- 无用的字典、Lookup 表镜像、Cube 统计信息
- 旧的 Cube 构建任务历史

参数：

- `--delete true`：指定这个参数来执行真正的数据删除


第一次执行该工具时建议省去 `--delete true` 参数，这样会只列出所有可以被清理的资源供用户核对，而并不实际进行删除操作。当用户确认无误后，再添加 `--delete true` 参数执行删除。另外建议总是在清理垃圾前备份元数据，以备不时之需。
