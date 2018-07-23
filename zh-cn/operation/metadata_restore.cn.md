## 元数据恢复

### 元数据检测

在开始恢复前，为了避免出现可能的冲突，本产品会对**项目和cube级别**进行检测。检测情况如下：

- 对项目的segment进行检测

检测时，被恢复的项目里有segment时，元数据无法恢复。此时，需要用户清除掉segment后再进行恢复。

- 对项目里的模型和cube进行检测

在项目级别的元数据恢复过程中，可能会存在项目名不一样但是项目组模型或cube名与其他项目中的模型和cube出现重名的情况，因此，本产品会在元数据恢复前对其进行检测。

- 对单个cube进行检测

当用户恢复cube的元数据时，其关联的模型可能会同时关联其他的cube（不在元数据中），此时恢复元数据只会恢复原数据中有的模型和cube。

> 注意：该情况下可能会影响到现关联的非元数据中的cube。

### 元数据恢复

Kyligence Enterprise 中需要用**命令行**进行元数据恢复。

- 系统级别的元数据恢复

```shell
$KYLIN_HOME/bin/metastore.sh restore /path_to_backup
```
- 项目级别的元数据恢复

```shell
$KYLIN_HOME/bin/metastore.sh restore-project project_name /path_to_backup
```

- cube级别的元数据恢复

```shell
$KYLIN_HOME/bin/metastore.sh restore-cube project_name /path_to_backup
```

> 注意: 
>
> project_name表示项目名称，path_to_backup表示恢复路径；
>
> 恢复操作时，会用本地元数据覆盖远端元数据，所以请确认从备份到恢复期间，Kyligence Enterprise 处于关闭／无活动（包括构建任务）状态，否则从备份到恢复之间的其它元数据改变会因此而丢失。如果希望 Kyligence Enterprise 服务不受影响，请使用project级别或者cube级别的元数据恢复。
