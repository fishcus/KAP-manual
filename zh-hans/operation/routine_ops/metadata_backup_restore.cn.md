##  数据备份与恢复

Kyligence Enterprise 实例是无状态的服务，所有的状态信息都存储元数据中，因此备份与恢复元数据是运维工作中一个至关重要的环节，可以在由于误操作导致整个实例或某个 Cube 异常时将 Kyligence Enterprise 快速从备份中恢复出来。

元数据分为系统级别、项目级别、Cube 级别，本节的目录结构如下：

- [元数据目录结构](#metadata_structure)
- [元数据备份](#metadata_backup)
- [元数据恢复](#metadata_restore)


### 元数据目录结构		{#metadata_structure}

| 元数据             | 说明                                               | 系统级别 | 项目级别 | Cube 级别 |
| ------------------ | -------------------------------------------------- | -------- | -------- | --------- |
| UUID               | 元数据标识                                         | √        | √        | √         |
| acl                | 数据访问控制信息                                   | √        | √        |           |
| bad_query          | 慢查询信息                                         | √        | √        |           |
| cube               | Cube 实例的基本信息                                | √        | √        | √         |
| cube_desc          | Cube 结构定义信息                                  | √        | √        | √         |
| cube_statistics    | Cube 实例的统计信息                                | √        | √        |           |
| cube_stats_info    | Cube 的一些信息                                    | √        | √        |           |
| dict               | 使用字典编码方式的列的字典                         | √        | √        |           |
| execute            | 构建任务的信息                                     | √        | √        |           |
| execute_output     | 构建任务对应的步骤信息                             | √        | √        |           |
| history            | 集群的一些历史信息                                 | √        | √        |           |
| kafka              | Kafka 数据源表的一些信息                           | √        | √        |           |
| model_desc         | 模型的描述信息                                     | √        | √        | √         |
| model_stats        | 模型的统计信息                                     | √        | √        |           |
| project            | 项目有关信息，如项目中包含的表名、模型名和 Cube 名 | √        | √        | √         |
| query              | 保存的查询                                         | √        |          |           |
| raw_table_desc     | 表索引的描述信息                                   | √        | √        |           |
| raw_table_instance | 表索引实例                                         | √        | √        |           |
| scheduler          | 自动调度                                           | √        | √        |           |
| streaming          | 流式数据有关的表信息                               | √        | √        |           |
| table              | 表有关的信息                                       | √        | √        | √         |
| table_exd          | 表的扩展信息                                       | √        | √        | √         |
| table_snapshot     | 维表快照                                           | √        | √        |           |
| user               | 用户信息                                           | √        | √        |           |
| user_group         | 用户组信息                                         | √        | √        |           |




### 元数据备份	{#metadata_backup}

一般来说，在每次进行故障恢复或者系统升级之前，对元数据进行备份是一个良好的习惯，这可以保证在操作失败后有回滚的可能，在最坏情况下依然保持系统的稳定性。

此外，元数据备份也是故障查找的一个工具，当系统出现故障导致前端频繁报错，通过下载并查看元数据往往能对确定元数据是否存在问题提供帮助。

元数据可以通过命令行或者用户界面进行备份，具体操作如下：

- 通过**命令行**进行元数据备份

  Kyligence Enterprise 提供了一个命令行工具用于备份元数据，使用方法如下：

  * 备份**系统级别**的元数据

    ```sh
    $KYLIN_HOME/bin/metastore.sh backup
    ```

  * 备份**项目级别**的元数据

    ```sh
    $KYLIN_HOME/bin/metastore.sh backup-project PROJECT_NAME PATH_TO_LOCAL_META_DIR
    ```
    参数说明：

    1. `ROJECT_NAME` - 必选，需要备份的项目名称，如 learn_kylin
    2. `PATH_TO_LOCAL_META_DIR` - 可选，表示备份的元数据保存路径

  * 备份 **Cube 级别**的元数据

    ```sh
    $KYLIN_HOME/bin/metastore.sh backup-cube CUBE_NAME PATH_TO_LOCAL_META_DIR
    ```
    其中，`CUBE_NAME` 为需要备份的 Cube 名称，如 kylin_sales_cube；`PATH_TO_LOCAL_META_DIR` 表示备份的元数据保存路径。

- 通过**用户界面**进行元数据备份
  > 提示：备份成功后，界面会有弹出框提示备份的元数据的存放地址。

  * 备份**系统级别**元数据
    在**系统**页面，点击**备份**按钮。
  * 备份**项目级别**元数据
    选择需要备份的项目点击**操作** --> **备份**按钮。
  * 备份 **Cube 级别**元数据
	在**建模**--> **Cube** 页面，选择需要备份的 Cube，点击**操作**-->**备份**。



### 元数据恢复    {#metadata_restore}

Kyligence Enterprise 中需要用**命令行**进行元数据恢复。

**注意：**恢复操作时，会用本地元数据覆盖远端元数据，所以请确认从备份到恢复期间，Kyligence Enterprise 处于关闭或者无活动（包括构建任务）状态，否则从备份到恢复之间的其它元数据改变会因此而丢失。如果希望 Kyligence Enterprise 服务不受影响，请使用**项目级别**或者 **Cube 级别**的元数据恢复。

- 恢复**系统级别**的元数据

  ```sh
  $KYLIN_HOME/bin/metastore.sh restore /path_to_backup
  ```
- 恢复**项目级别**的元数据--

  ```sh
  $KYLIN_HOME/bin/metastore.sh restore-project project_name /path_to_backup
  ```

- 恢复 **Cube 级别**的元数据

  ```sh
  $KYLIN_HOME/bin/metastore.sh restore-cube project_name /path_to_backup
  ```

  其中，`project_name` 表示项目名称，`/path_to_backup` 表示恢复路径。
