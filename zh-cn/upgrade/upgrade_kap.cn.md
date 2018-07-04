## 从Kyligence Enterprise升级 ##

### 从Kyligence Enterprise 2.X升级至Kyligence Enterprise更高版本 ###

Kyligence Enterprise 2.X各版本之间兼容元数据。因此在从Kyligence Enterprise 2.X升级至更高版本时，无需对元数据进行升级，只需要覆盖软件包、更新配置文件并升级HBase协处理器即可。

> 从旧版本升级前，请您务必确认已关闭所有自动执行的metadata clean和Storage cleanup CLI工具，以避免影响升级。

具体升级步骤如下：

1. 备份元数据：

   ```shell
   $KYLIN_HOME/bin/metastore.sh backup
   ```

2. 停止正在运行的Kyligence Enterprise实例：

   ```shell
   $KYLIN_HOME/bin/kylin.sh stop
   ```

3. 解压缩新版本的Kyligence Enterprise安装包。更新KYLIN_HOME环境变量值：

   ```shell
   tar -zxvf kap-{version-env}.tar.gz
   export KYLIN_HOME=...
   ```

4. 更新配置文件：

   如果是从>=2.4.0的版本升级到更新的版本，只需要简单地用老版本中的的`$KYLIN_HOME/conf`替换新版本中的`$KYLIN_HOME/conf`

   如果是从<2.4.0的版本升级到更新的版本，需要： 1. 手动地把在老版本`$KYLIN_HOME/conf`中的改动重新在新版本的`$KYLIN_HOME/conf`重做一遍 2. 手动地把在老版本中`$KYLIN_HOME/bin/setenv.sh`中的改动再新版本中的`$KYLIN_HOME/conf/setenv.sh`重新做一遍。 注意：1. setenv.sh的目录发生了改变 2. 不允许直接拷贝-替换配置文件

5. 升级并重新部署HBase协处理器：

   ```shell
   $KYLIN_HOME/bin/kylin.sh org.apache.kylin.storage.hbase.util.DeployCoprocessorCLI default all
   ```

6. 如果是从<2.4 的Kyligence Enterprise版本升级，需要对ACL数据进行迁移，执行下述命令：

   ```shell
   $KYLIN_HOME/bin/kylin.sh org.apache.kylin.tool.AclTableMigrationCLI MIGRATE
   ```

7. 确认License：

   在新版本的Kyligence Enterprise安装目录下确认License。

8. 启动Kyligence Enterprise实例：

   ```shell
   $KYLIN_HOME/bin/kylin.sh start
   ```


### 从Kyligence Enterprise升级至Kyligence Enterprise Plus ###

Kyligence Enterprise Plus与Kyligence Enterprise的主要区别在于引入了全新的存储引擎KyStorage。因此在从Kyligence Enterprise 2.X升级至Kyligence Enterprise Plus时，只需要按照从Kyligence Enterprise升级至更高版本的方法执行，最后进行存储引擎相关的升级操作即可。具体升级步骤如下：

1. 执行上一节“从Kyligence Enterprise 2.X升级至Kyligence Enterprise更高版本”中的步骤1至7。其中新版本的Kyligence Enterprise安装包用Kyligence Enterprise Plus安装包替换。

2. 由于Kyligence Enterprise Plus中新引入的Kyligence Enterprise Query Driver会占用一定系统资源，如果是在沙箱等资源较为紧张的环境下运行Kyligence Enterprise Plus，请调整相关配置以确保Kyligence Enterprise Plus能够获取足够的资源。

3. 启动Kyligence Enterprise Plus实例：

   ```shell
   $KYLIN_HOME/bin/kylin.sh start
   ```

4. 升级之后新建的Cube默认使用KyStorage作为存储引擎，原先的Cube则使用HBase作为存储引擎。如果不需要保留原先构建好的Cube数据，可以按照如下步骤重新构建原先的Cube：

   - 保存当前元数据至`meta_backups/`路径下：

     ```shell
     $KYLIN_HOME/bin/metastore.sh backup --noSeg
     ```

   - 对`meta_backups/`路径下的元数据进行升级以使其适应KyStorage：

     ```shell
     $KYLIN_HOME/bin/metastore.sh promote $KYLIN_HOME/meta_backups
     ```

   - 将`meta_backups/`路径下的元数据恢复以覆盖原先的元数据：

     ```shell
     $KYLIN_HOME/bin/metastore.sh restore $KYLIN_HOME/meta_backups
     ```

   - 在Kyligence Enterprise Plus GUI上重载元数据后，手动清理所有Cube中的数据并重新构建。

5. 如果需要升级原有的Cube的存储引擎为KyStorage并保留原先构建好的Cube数据，需要使用混合(Hybrid)升级。假设需要混合升级的Cube为*kylin_sales_cube*，所在项目为*learn_kylin*，Model为*kylin_sales_model*，需要执行的操作如下：

   - 在Kyligence Enterprise Plus GUI中，克隆*kylin_sales_cube*，假设克隆得到的Cube为*kylin_sales_cube_plus*。

   - 保存*kylin_sales_cube_plus*的Cube元数据至指定路径，假设将元数据保存至`cube_backups/`:

     ```shell
     $KYLIN_HOME/bin/metastore.sh backup-cube kylin_sales_cube_plus $KYLIN_HOME/cube_backups
     ```

   - 对该Cube的元数据进行升级以使其适应KyStorage：

     ```shell
     $KYLIN_HOME/bin/metastore.sh promote $KYLIN_HOME/cube_backups
     ```

   - 将升级后的元数据恢复以覆盖原先的元数据：

     ```shell
     $KYLIN_HOME/bin/metastore.sh restore-cube learn_kylin $KYLIN_HOME/cube_backups
     ```

   - 在Kyligence Enterprise Plus GUI上重载元数据后，执行如下命令创建Hybrid Cube：

     ```shell
     $KYLIN_HOME/bin/kylin.sh org.apache.kylin.tool.HybridCubeCLI -action create -name kylin_sales_hybrid -project learn_kylin -model kylin_sales_model -cubes kylin_sales_cube,kylin_sales_cube_plus
     ```

     如果日志中提示`HybridInstance was created at: /hybrid/kylin_sales_hybrid.json`，则表明创建成功。

   - 重载元数据。

   - 注意：后续构建请使用新建的Cube，即*kylin_sales_cube_plus*，请勿使用原先的Cube。
