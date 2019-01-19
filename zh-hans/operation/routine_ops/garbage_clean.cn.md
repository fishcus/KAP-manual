## 垃圾清理

在 Kyligence Enterprise 运行一段时间之后，有很多数据因为不再使用而变成了垃圾数据，这些数据占据着系统资源，当积累到一定规模会对集群性能产生影响。

**注意：**

1. **数据一经删除将彻底无法恢复！** 建议使用前，进行元数据备份，并对目标资源进行谨慎核对。
2. **如有可能，请尽量在没有构建任务时清理垃圾**，以最大限度地保障数据安全。


Kyligence Enterprise 提供了如下命令行工具用于清理系统垃圾，这个命令寻找并打印出系统中的垃圾数据：

- 无用的 Cube 数据，如 Purge 之后原 Cube 的数据、Segment 合并之后原 Segment 的数据
- 在 Cube 构建时创建的但未被正常清理的 Hive 中间表、HDFS 临时文件
- 无用的字典、维表快照、Cube 统计信息
- 旧的 Cube 构建任务历史


```sh
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.storage.KapGarbageCleanupCLI [--delete true]
```

第一次执行该工具时建议省去 `--delete true`参数，这样会只列出所有可以被清理的资源供用户核对，而并不实际进行删除操作。页面输出如下：

```
Retrieving Hive dependency...
Retrieving HBase dependency...
Running io.kyligence.kap.tool.storage.KapGarbageCleanupCLI
Kyligence Enterprise garbage report: (delete=false, force=false, jobOutdatedDays=30)
  Hive Table: kylin_intermediate_kylin_sales_cube_7fc67947_96a9_4184_9c26_5ebf362aad46
  Hive Table: kylin_intermediate_kylin_sales_cube_d0c13857_b08c_4ae4_8e9a_89d5c75d075b
  Storage File: hdfs://sandbox.hortonworks.com:8020/kylin/kylin_default_instance/learn_kylin/kylin-250c4553-b282-4920-9b77-ae40cc59ba23
  Storage File: hdfs://sandbox.hortonworks.com:8020/kylin/kylin_default_instance/learn_kylin/
  Storage File(s) Bytes: 5389334
Dry run mode, no data is deleted.
Garbage cleanup finished in 18417 ms.
```

当用户确认无误后，再添加 `--delete true` 参数真正地执行删除。
