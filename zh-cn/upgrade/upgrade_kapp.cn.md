## 从 KAP Plus 升级##

### 从 KAP Plus 2.X 升级至 Kyligence Enterprise 3.x 最新版本###

KAP Plus 2.X 与更高版本之间兼容元数据。因此在从 KAP Plus 2.X 升级至更高版本时，无需对元数据进行升级，只需要覆盖软件包、更新配置文件即可。

**升级准备工作：**

1. 关闭所有自动执行的 Metadata Clean 和 Storage Cleanup CLI 工具，以避免影响升级。

2. 确保您的 JDK 版本是 **1.8**，您可以通过以下命令查看 JDK 版本。

   ```
   java -version
   ```

3. 对于初次升级到 3.x 的用户，会进行 Cube 和 Segment 升级。**请确保没有处于构建状态的 Segment，构建状态包括等待、运行、错误和暂停**。

   如有任何疑问，请参考本文最后的 **升级 FAQ** 或联系 Kyligence Support。

**具体升级步骤如下：**

1. 备份元数据：

   ```shell
   $KYLIN_HOME/bin/metastore.sh backup
   ```

2. 停止正在运行的KAP Plus 2.X实例：

   ```shell
   $KYLIN_HOME/bin/kylin.sh stop
   ```

3. 解压缩新版本的Kyligence Enterprise 安装包。更新 KYLIN_HOME 环境变量值：

   ```shell
   tar -zxvf Kyligence-Enterprise-{version-env}.tar.gz
   export KYLIN_HOME=...
   ```

4. 更新配置文件

   2.4 版本以下用户：

   * 手动地把在老版本`$KYLIN_HOME/conf`中的改动重新在新版本的`$KYLIN_HOME/conf`重做一遍 

   * 手动地把在老版本中`$KYLIN_HOME/bin/setenv.sh`的改动重新在新版本中的`$KYLIN_HOME/conf/setenv.sh`

   * 在`$KYLIN_HOME/conf/kylin.properties`中删除或注释kylin.server.init-tasks这一行。 

     > 注意：1. setenv.sh的目录发生了改变，2.4 版本后位于``$KYLIN_HOME/conf`下
     >
     > ​	    2.请不要直接拷贝替换配置文件

   * 手动地对ACL数据进行迁移，执行下述命令：

     ```shell
     $KYLIN_HOME/bin/kylin.sh org.apache.kylin.tool.AclTableMigrationCLI MIGRATE
     ```

   2.4 版本及以上用户：

   * 仅需要把老版本中`$KYLIN_HOME/conf`文件拷贝并替换在新版本中的 `$KYLIN_HOME/conf`中。

     > 注意:  在`$KYLIN_HOME/conf/kylin.properties`中，kylin.server.init-tasks这一行需要被删除或注释。

5. 启动 Kyligence Enterprise，执行该操作后，Kyligence Enterprise 会自动进行升级工作。升级时间取决于您的元数据大小。

    ```
    $KYLIN_HOME/bin/kylin.sh start
    ```

### **升级FAQ**

**Q：如果当前集群的 JDK < 1.8 ，我能否仅对部署 KE 的节点进行 JDK 升级？**

A：可以，此时需要将集群中其他所有节点，下载并解压缩 JDK1.8 后放置在一个目录（如`/usr/java/jdk1.8`）同时进行以下操作：

* 在`$KYLIN_HOME/conf/kylin.properties`中添加以下配置	

```
kap.storage.columnar.spark-conf.spark.executorEnv.JAVA_HOME=/usr/java/jdk1.8
kap.storage.columnar.spark-conf.spark.yarn.appMasterEnv.JAVA_HOME=/usr/java/jdk1.8
#如果您需要使用Spark构建引擎，请添加以下配置
kylin.engine.spark-conf.spark.executorEnv.JAVA_HOME=/usr/java/jdk1.8
kylin.engine.spark-conf.spark.yarn.appMasterEnv.JAVA_HOME=/usr/java/jdk1.8
```

* 在`$KYLIN_HOME/conf`目录下`kylin_job_conf.xml`以及`kylin_job_conf_inmem.xml`添加以下配置

```xml
<property>
        <name>mapred.child.env</name>
        <value>JAVA_HOME=/usr/java/jdk1.8</value>
    </property>
    <property>
        <name>yarn.app.mapreduce.am.env</name>
        <value>JAVA_HOME=/usr/java/jdk1.8</value>
    </property>
```

**Q：需要我手动的升级 Cube 和 Segment 吗？**

A：不需要，在您启动 Kyligence Enterprise 时，会自动执行升级操作。

**Q：初次升级 3.x 版本时，如何确定升级成功还是失败？**

A：升级结束后会有以下提示：

* 升级成功后将会提示

  “Segments have been upgraded successfully.” 

* 失败则会提示

  “Upgrade failed. Please try to run bin/kylin.sh io.kyligence.kap.tool.migration.ProjectDictionaryMigrationCLI FIX to fix. ”

**Q：升级失败如何处理？**

A：如果升级过程出错，例如 Segment 升级失败等，请运行`bin/kylin.sh io.kyligence.kap.tool.migration.ProjectDictionaryMigrationCLI FIX` 进行修复。修复成功后，将会看到“Segments have been upgraded successfully”提示。如修复失败，请您联系Kyligence Support。

在 Kyligence Enterprise 启动时，会自动备份cube文件夹下面所有的 Cube JSON文件。如果升级失败，您也可以直接进行回滚操作，本次升级将不会影响您继续使用 2.x 版本。