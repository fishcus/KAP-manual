## Read/Write Split Deployment

Kyligence Enterprise read/write split deployment requires two separate Hadoop clusters, called the **Build Cluster** and the **Query Cluster** respectively.

Logically, the two clusters always exist even for normal deployment. They just happen to be the same physical cluster in that case. Kyligence Enterprise uses the build cluster to build cubes, and the query cluster to do parallel computation for online queries. In the build cluster, it has lots of data writes; while in the query cluster, it is mainly about data reads. By splitting the two clusters physically, known as the Build Cluster (*Write Cluster*) and the Query Cluster (*Read Cluster*), the read operations can be well isolated from the write operations, and as a result, the overall storage performance and system stability is improved.

Below is the deployment diagram of read/write split architecture.

![](images/rw_separated.png)

### Precondition Check

The read/write split deployment will deploy Kyligence Enterprise in two separate Hadoop clusters. We call the two groups of nodes that will host Kyligence Enterprise as **Build Servers** and **Query Servers** respectively.

With the interactions between the two Hadoop clusters, the read/write split deployment is much more complicated than normal deployment. *Please read and execute the below checks carefully before proceeding*.

1. Please check the Hadoop versions of the build cluster and the query cluster are identical, and that it satisfies the prerequisite of installation of Kyligence Enterprise.

2. Please check that the **build servers** have the Hadoop client of the **build cluster** installed. Check commands like `hdfs`、`mapred`、`hive` are all working properly and can access the cluster resources.

3. Please check that the **query servers** have the Hadoop client of the **query cluster** installed. Check commands like `hdfs`、`mapred`、`hive` are all working properly and can access the cluster resources.

4. On the **build servers**, please configure and check the `hdfs` command can access HDFS resources in the **query cluster**.

   > Hint: As a test, try run `hadoop fs -ls hdfs://{query-cluster}/` on the build servers.
   >
   > Hint: If Hadoop HA is enabled, you will need to configure the Nameservice for the query cluster.

5. Please check the two clusters can access each other in a password-less style.

   > Hint: As a test, on any build server, try copy some HDFS files from/to the read cluster. The copy must succeed without any extra human interaction.

6. Please make sure the network latency between the two clusters is low enough, as there will be many data movements inbetween during cube build.

7. If  Kerberos is enabled, please check the below as well.

   - The build cluster and the query cluster belong to different realms.
   - The cross-realm trust between the two clusters is configured properly.

### Install and Configure the Read/Write Split Deployment

Follow the below instructions to install Kyligence Enterprise in the build cluster and query cluster, and configure them to work together.

1. First of all, on all the **build servers** and **query servers**, unpack the Kyligence Enterprise software package to the same location. This location is called `$KYLIN_HOME` hereafter.

2. On all the **build servers** and **query servers**, modify `$KYLIN_HOME/conf/kylin.properties` to setup the same metastore and storage location for all of them.

   > Notice: JDBC metastore is required here. Please find more information in [the JDBC metastore configuration document](../config/metastore_jdbc_mysql.en.md).
   >
   > Notice: The storage location must point to the query cluster HDFS.

   ```properties
   # Please find more information in the JDBC metastore configuration document
   kylin.metadata.url=...
   
   # The storage location must point to the the query cluster HDFS
   kylin.storage.columnar.file-system=hdfs://{query-cluster}:8020/
   kylin.storage.columnar.separate-fs-enable=true
   
   # The Zookeeper service address of the query cluster, like "host1:port1,host2:port2,..."
   kylin.env.zookeeper-connect-string=...
   ```

3. On all the **build servers** and **query servers**, modify `$KYLIN_HOME/conf/kylin.properties` to setup the same Hive source for all of them.

   > Notice: The example below assumes Beeline as Hive connectivity. If you use Hive CLI, please adjust accordingly.

   ```properties
   kylin.source.hive.client=beeline
   kylin.source.hive.beeline-shell=beeline
   kylin.source.hive.beeline-params=...
   
   # For Huawei FusionInsight, please uncomment the next line
   #kylin.source.hive.table-dir-create-first=true
   ```

   For better performance, we assume your Hive source resides in the build cluster. In order to let the query servers access the Hive in the build cluster, **please copy the build cluster's `hive-site.xml` into the query servers'`$KYLIN_HOME/conf` folder**.

4. On the **build servers**, modify `$KYLIN_HOME/conf/kylin.properties` to set the server mode.

   ```properties
   kylin.server.mode=job
   ```

5. On the **query servers**, modify `$KYLIN_HOME/conf/kylin.properties` to set the server mode.

   ```properties
   kylin.server.mode=query
   ```

6. If Kerberos is enabled, please do the following steps.

   - Configure [Kerberos intergration](../security/kerberos.en.md) in both clusters, and confirm:

     - The build cluster and the query cluster belong to different realms.
     - The cross-realm trust between the two clusters is configured properly.

   - On the **query servers**, modify `$KYLIN_HOME/conf/kylin.properties`

     ```properties
     kap.storage.columnar.spark-conf.spark.yarn.access.namenodes=hdfs://{query-cluster},hdfs://{build-cluster}
     ```

   - On the **build servers**, modify `$KYLIN_HOME/conf/kylin.properties`

     ```properties
     kylin.engine.spark-conf.spark.yarn.access.namenodes=hdfs://{query-cluster},hdfs://{build-cluster}
     ```

   - On the **build servers**, modify `$KYLIN_HOME/conf/kylin_job_conf.xml`

     ```xml
     <property>
         <name>mapreduce.job.hdfs-servers</name>
         <value>hdfs://{build-cluster}/, hdfs://{query-cluster}/</value>
     </property>
     ```

Now the read/write split deployment is configured. It is ready to start all the Kyligence Enterprise servers.
