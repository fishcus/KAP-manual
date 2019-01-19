## Kyligence Enterprise 跨 Hadoop 集群迁移

Kyligence Enterprise 支持跨 Hadoop 集群迁移，包括：整体的迁移和单个 Cube 的迁移。


### 前置条件

迁移的集群间是连通的，并且集群间的命令 `hadoop distcp` 是可用的。以下用 SHC 简写表示 Source Hadoop Cluster，即源 Hadoop 集群，用 DHC 简写表示 Destination Hadoop Cluster，即目标 Hadoop 集群。



### 整体实例迁移 

1. 将 Kyligence Enterprise 分别部署到两个集群上，并且保证它们拥有相同的 `kylin.metadata.url` 和 `kylin.env.hdfs-working-dir`，同时保证 Kyligence Enterprise 在 SHC 中没有运行。
2. 在 SHC 上，运行 `$KYLIN_HOME/bin/cluster-migration.sh backup`
3. 在 DHC 上，运行 `$KYLIN_HOME/bin/cluster-migration.sh restore hdfs://SHC-namenode/kylin_working_dir`



### 单个 Cube 迁移 

1. 在 SHC 上的 `KYLIN_HOME` 目录下执行 `$KYLIN_HOME/bin/cluster-migration.sh backup-cube —cubeName someCube —onlyMetadata true`，其中 `cubeName` 是要迁移的 Cube 的名字。
2. 在 DHC 上的 `KYLIN_HOME` 目录下执行 `$KYLIN_HOME/bin/cluster-migration.sh restore-cube —cubeName someCube —project someProject —namenode hdfs://someip —overwrite true`，其中 `cubeName` 是要迁移的 Cube 的名字，`project` 是 Cube 要加入的项目，`namenode` 是源集群的 HDFS URI 地址。

> 提示：如果目标项目中存在同名 Cube，脚本会提示已有同名 Cube 存在。如果确认要覆盖这个 Cube，可以设置 `--overwrite true`。