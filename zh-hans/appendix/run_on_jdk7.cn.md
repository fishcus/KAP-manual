## 如何在低版本 JDK 上运行 Kyligence Enterprise

Kyligence Enterprise 要求 JDK 8 或以上。这要求不仅适用于运行 Kyligence Enterprise 的节点，也适用于 Hadoop 集群中，所有运行 Kyligence Enterprise 相关的 MapReduce 任务和 Spark 任务的节点，都必须装有 JDK 8 或以上。

如果用户当前的集群为 JDK 7 或更低，我们仍然可以安装和运行 Kyligence Enterprise。只是在第一次启动 Kyligence Enterprise 之前，必需先执行以下配置：

1. 保证 **Kyligence Enterprise 安装节点**的 JDK 版本为 **JDK 8 及以上**。

2. 在 **集群中其他所有节点上**，下载并安装 JDK 8 64 bit 到同样的路径下，比如`/usr/java/jdk1.8`。

3. 在`$KYLIN_HOME/conf/kylin.properties`中添加以下配置。

   ```properties
   kap.storage.columnar.spark-conf.spark.executorEnv.JAVA_HOME=/usr/java/jdk1.8
   kap.storage.columnar.spark-conf.spark.yarn.appMasterEnv.JAVA_HOME=/usr/java/jdk1.8
   #如果您需要使用Spark构建引擎，请添加以下配置
   kylin.engine.spark-conf.spark.executorEnv.JAVA_HOME=/usr/java/jdk1.8
   kylin.engine.spark-conf.spark.yarn.appMasterEnv.JAVA_HOME=/usr/java/jdk1.8
   ```

4. 在`$KYLIN_HOME/conf`目录下`kylin_job_conf.xml`以及`kylin_job_conf_inmem.xml`添加以下配置。

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

至此 JDK 1.8 配置完毕，且只影响 Kyligence Enterprise 相关的服务、Spark和 MapReduce 进程。

请继续启动 Kyligence Enterprise。

```shell
 $KYLIN_HOME/bin/kylin.sh start
```