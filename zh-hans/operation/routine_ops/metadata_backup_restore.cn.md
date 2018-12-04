## 系统元数据备份与恢复

Kyligence Enterprise 实例是无状态的服务，所有的状态信息都存储元数据中，因此备份与恢复元数据是运维工作中一个至关重要的环节，可以在由于误操作导致整个实例或某个 Cube 异常时将 Kyligence Enterprise 快速从备份中恢复出来。



### 元数据备份

一般来说，在每次进行故障恢复或者系统升级之前，对元数据进行备份是一个良好的习惯，这可以保证在操作失败后有回滚的可能，在最坏情况下依然保持系统的稳定性。

此外，元数据备份也是故障查找的一个工具，当系统出现故障导致前端频繁报错，通过下载并查看元数据往往能对确定元数据是否存在问题提供帮助。

元数据可以通过命令行或者用户界面进行备份，具体操作如下：

1. 通过命令行进行元数据备份

Kyligence Enterprise 提供了一个命令行工具用于备份元数据，使用方法如下：

* 备份**系统级别**的元数据

```shell
$KYLIN_HOME/bin/metastore.sh backup
```

* 备份**项目级别**的元数据

```shell
$KYLIN_HOME/bin/metastore.sh backup-project PROJECT_NAME PATH_TO_LOCAL_META_DIR
```

其中，`PROJECT_NAME` 为需要备份的项目名称，如 learn_kylin；`PATH_TO_LOCAL_META_DIR` 表示备份的元数据保存路径


* 备份 **Cube级别**的元数据

```shell
$KYLIN_HOME/bin/metastore.sh backup-cube CUBE_NAME PATH_TO_LOCAL_META_DIR
```

其中，`CUBE_NAME` 为需要备份的 Cube 名称，如 kylin_sales_cube；`PATH_TO_LOCAL_META_DIR` 表示备份的元数据保存路径



2. 通过用户界面进行元数据备份

除了使用命令行进行元数据备份，Kyligence Enterprise 还支持在用户界面下进行元数据备份。


* 备份**系统级别**元数据

在**系统**页面，点击**备份**按钮，备份成功后，会有弹出框提示存放路径。

![系统元数据备份](images/instance_meta_backup_cn.png)


* 备份**项目级别**元数据

选择需要备份的项目点击**操作** --> **备份**按钮，

![项目页面](images/project_page_1_cn.png)

![项目元数据备份](images/project_backup_1_cn.png)

* 备份 **Cube 级别**元数据

点击页面左侧建模按键后，选择 Cube 界面，选择需要备份的 Cube 点击操作按键后进行备份，Cube 元数据文件会备份在 Kyligence Enterprise 安装目录下的 meta\_backups 文件夹中。文件命名为 `cube_备份Cube名_当前时间`（如cube_corr_2018_01_11_19_04_47）。

![建模页面](images/studio_page_1_cn.png)

![Cube元数据备份](images/Cube_backup_1_cn.png)

### 元数据目录结构

系统级别的元数据主要包括的目录如下表所示：

| 目录名             | 介绍                                                 |
| :----------------- | :--------------------------------------------------- |
| project            | 包含了项目的基本信息，项目所包含其它元数据类型的声明 |
| bad_query          | 慢查询信息                                           |
| column_acl         | 列级acl权限信息                                      |
| history            | 包含垃圾清理，元数据检测，数据使用的历史信息         |
| hybrid             | hybrid数据                                           |
| info               | 文件包时间，类型                                     |
| kafka              | Kafka表数据                                          |
| kylin_env          | 环境信息                                             |
| kylin.properties   | 配置项文件                                           |
| model_opt_log      | 模型操作信息（sql建议结果等）                        |
| model_stats        | 模型检测信息                                         |
| project_dict       | 项目级别字典信息                                     |
| row_acl            | 行级acl权限                                          |
| streaming          | streaming表数据                                      |
| user_group         | 用户组信息                                           |
| UUID               | 是每个metadata instance的标识                        |
| model_desc         | 包含了描述数据模型基本信息与结构的定义               |
| cube_desc          | 包含了描述 Cube 模型基本信息与结构的定义             |
| cube               | 包含了 Cube 实例的基本信息                           |
| cube_statistics    | 包含了 Cube 实例的统计信息                           |
| table              | 包含了表的基本信息                                   |
| table_exd          | 包含了表的扩展信息，如维度                           |
| table_snapshot     | 包含了 Lookup 表的镜像                               |
| dict               | 包含了使用字典列的字典                               |
| execute            | 包含了 Cube 构建任务的步骤信息                       |
| execute_output     | 包含了 Cube 构建任务的步骤输出                       |
| raw_table_desc     | 包含了表索引的基本信息与结构的定义                   |
| raw_table_instance | 包含了表索引实例的基本信息                           |
| user               | 包含了用户信息                                       |
| acl                | 包含了数据访问控制信息                               |
| query              | 包含了保存的历史查询                                 |
| draft              | 包含了 Model 与 Cube 的草稿                          |

> 提示：
>
> **系统级别**元数据目录包含表中全部目录；
>
> **项目级别**的元数据目录包括 commit_SHA1, cube, cube_desc, model_desc, streaming, UUID, info, kylin_env, project, table；
>
> **cube级别**包括  commit_SHA1, cube, cube_desc, info, kylin_env, model_desc, table, table_exd, UUID。



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
