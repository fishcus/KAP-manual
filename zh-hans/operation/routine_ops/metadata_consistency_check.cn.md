## metadata与metastore一致性校验

我们建议用户经常备份元数据，以便损坏时可以快速恢复。仍然有一些无法预见的情况可能造成元数据出现不一致，此时可以使用元数据一致性检查工具进行元数据检查。

### 使用方法

检查工具参数说明:

```sh
usage: io.kyligence.kap.tool.check.MetastoreIntegrityCheck
-h,--help                     print help message.
-p,--project <arg>            check special project metastore integrity
```

> 注意: 
> 1. 工具参数支持标准的短参数或者长参数
> 2. 工具只检查元数据, 不会对元数据进行修复

展示帮助信息：

```sh
bin/kylin.sh io.kyligence.kap.tool.check.MetastoreIntegrityCheck -h
```

或

```sh
bin/kylin.sh io.kyligence.kap.tool.check.MetastoreIntegrityCheck --help
```

检查指定项目的元数据一致性

```sh
bin/kylin.sh io.kyligence.kap.tool.check.MetastoreIntegrityCheck -p learn_kylin
```

或

```sh
bin/kylin.sh io.kyligence.kap.tool.check.MetastoreIntegrityCheck --project=learn_kylin
```

检查多个项目的元数据一致性

```sh
bin/kylin.sh io.kyligence.kap.tool.check.MetastoreIntegrityCheck -p=learn_kylin,learn_kylin_streaming
```

检查所有项目的元数据一致性

```sh
bin/kylin.sh io.kyligence.kap.tool.check.MetastoreIntegrityCheck
```

提示：
如果丢失的文件过多，可以使用tee命令，将输出展示在控制台并重定向到文件中

```sh
bin/kylin.sh io.kyligence.kap.tool.check.MetastoreIntegrityCheck -p learn_kylin | tee check_result_output.log
```