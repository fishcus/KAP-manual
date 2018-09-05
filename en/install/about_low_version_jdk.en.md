## How to Run Kyligence Enterprise on Lower Version JDK

Kyligence Enterprise requires JDK 8 or above. This applies to not only the node that installs Kyligence Enterprise, but also the nodes in Hadoop cluster that run Spark / MapReduce jobs for Kyligence Enterprise.

If user's current Hadoop cluster is based on JDK 7 or below, we can still install and run Kyligence Enterprise. However the following steps must be taken before the first start of Kyligence Enterprise.

1. On *all nodes in the cluster*, download and install JDK 8 64 bit to the same location. For example `/usr/java/jdk1.8`

2. Add following lines to `$KYLIN_HOME/conf/kylin.properties`

   ```properties
   kap.storage.columnar.spark-conf.spark.executorEnv.JAVA_HOME=/usr/java/jdk1.8
   kap.storage.columnar.spark-conf.spark.yarn.appMasterEnv.JAVA_HOME=/usr/java/jdk1.8
   # below is for spark cubing engine
   kylin.engine.spark-conf.spark.executorEnv.JAVA_HOME=/usr/java/jdk1.8
   kylin.engine.spark-conf.spark.yarn.appMasterEnv.JAVA_HOME=/usr/java/jdk1.8
   ```

3. In`$KYLIN_HOME/conf`, find `kylin_job_conf.xml` and `kylin_job_conf_inmem.xml`, then insert the following properties.

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

Till now, JDK 1.8 has been configured for, and only for, Kyligence Enterprise related processes.

Please continue to start Kyligence Enterprise.

```shell
 $KYLIN_HOME/bin/kylin.sh start
```