## 元数据检查 (Deprecated)

我们建议用户经常备份元数据，以便损坏时可以快速恢复。仍然有一些无法预见的情况可能造成元数据出现不一致，此时可以使用元数据检查工具进行元数据检查及恢复。

### 使用方法

检查工具参数说明:

```sh
usage: io.kyligence.kap.tool.metadata.MetadataChecker
-c,--check                     Check metadata. 
-d,--withDict                  Check metadata including dictionaries
-e,--excludeThreshold <arg>    Specify how many days of metadata to be
excluded from cleanup. Default 2 days
-g,--copyGroupSize <arg>       Specify parallel copy group size when
checking metadata. Default is 200
-o,--outdatedThreshold <arg>   Specify how many days of job metadata
keeping. Default 30 days
-r,--recovery                  Check and Cleanup metadata
-s,--withSnapshot              Check metadata including snapshots
```

> 注意: 
> 1. 工具参数支持标准的短参数或者长参数
> 2. 工具参数向前兼容旧版本工具中的 check 和 recovery 参数
> 3. 工具默认检查时不包含 dictionary 和 snapshot 元数据的检查, 需要检查请在执行命令时添加相应的参数
> 4. 如果选择检查 snapshot 元数据, 请确保数据原表能够通过 Kyligence Enterprise 访问
> 5. 如果选择修复 snapshot 元数据, 要求 Kyligence Enterprise 构建节点在线
> 6. 工具只检查 dictionary 元数据, 不会对 dictionary 进行修复

检查元数据是否存在某些不一致问题：

```sh
bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker -c
```

或

```sh
bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker check
```

如果检查发现了元数据存在不一致的情况，执行恢复操作：

> 注意：
> 1. 这一步骤将修复系统中检测出来的不一致的元数据。
> 2. 执行恢复操作会将需要修复的元数据备份至 $KYLIN_HOME/meta_backups/ 文件夹中, 备份文件夹命名规范为 cleaned_meta_\${timestamp}

```sh
bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker -r
```

或

```sh
bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker recovery
```

后台执行检查工具示例:

```sh
nohup bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker recovery >> /path/to/check.log 2>&1 &
```

