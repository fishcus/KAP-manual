## Kyligence Enterprise 跨 Hadoop 集群迁移

Kyligence Enterprise 跨 Hadoop 集群迁移包括 Kyligence Enterprise 整体的迁移及针对单个 Cube 的迁移。

### Kyligence Enterprise 整体跨集群迁移

Kyligence Enterprise 整体跨集群迁移包括两个子任务

- 从源 Hadoop 集群（SHC）备份 Kyligence Enterprise 的元数据到本地，然后上传到 Kyligence Enterprise 在 HDFS 上的工作目录
- 利用 HDFS 的```distcp```命令将 Kyligence Enterprise 在 SHC 的 HDFS 工作目录拷贝到目标 Hadoop 集群（DHC）的 HDFS 上

 整个任务是通过脚本 `cluster-migration.sh` 来实现的。

**前置条件：**

迁移的集群间是连通的，并且集群间的命令 `hadoop distcp` 是可用的。

**使用步骤:**

1. 将 Kyligence Enterprise 分别部署到两个集群上，并且保证它们拥有相同的 `kylin.metadata.url` 和 `kylin.env.hdfs-working-dir`，同时保证 Kyligence Enterprise 在 SHC 没有运行。
2. 在 SHC 上，运行 `bin/cluster-migration.sh backup`
3. 在 DHC 上，运行 `bin/cluster-migration.sh restore hdfs://SHC-namenode/kylin_working_dir`

### **单个Cube跨集群迁移**

单个 Cube 跨集群迁移也包括两个子任务

- 从 SHC 备份 Cube 的元数据及其构建数据并上传到 HDFS 上的 `/tmp` 目录下
- 利用 HDFS 的 `distcp` 命令将 Kyligence Enterprise 在 SHC 的 HDFS 工作目录拷贝到 DHC 的 HDFS 上

 整个任务同样是通过脚本 `bin/cluster-migration.sh` 来实现的。

**前置条件：**

迁移的集群间是连通的，并且集群间的命令 `hadoop distcp` 是可用的。

**使用步骤:**

1. 在 SHC 上的 `KYLIN_HOME` 目录下执行 `bin/cluster-migration.sh backup-cube —cubeName someCube —onlyMetadata true`，其中 cubeName 是要迁移的 Cube 的名字。

2. 在 DHC 上的 `KYLIN_HOME` 目录下执行 `bin/cluster-migration.sh restore-cube —cubeName someCube —project someProject —namenode hdfs://someip —overwrite true`，其中 cubeName 是要迁移的 Cube 的名字，project 是 Cube 要加入的项目，namenode 是源集群的 HDFS URI 地址。

   如果目标项目中存在同名 Cube，脚本会提示已有同名 Cube 存在。如果确认要覆盖这个 Cube，可以设置 `--overwrite true`。