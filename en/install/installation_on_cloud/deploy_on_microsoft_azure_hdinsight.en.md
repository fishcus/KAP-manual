## Deployment on Microsoft Azure HDInsight

### **Azure HDInsight**

Backed by a 99.9% SLA, Microsoft Azure HDInsight is the only fully-managed cloud Apache Hadoop offering that gives you optimized open-source analytic clusters for Spark, Hive, MapReduce, HBase, Storm, Kafka, and Microsoft R Server. 

This architecture separates computing and storage, and since the data is persisted in Azure Blob Storage or Azure Data Lake, customers can easily start/stop and scale/shrink the cluster on demand without worrying about data loss.

### **Kyligence Enterprise on HDInsight**

With Azure HDInsight, you can easily deploy Kyligence Enterprise in a few minutes. Kyligence Enterprise can run on any node of the cluster, communicating with Hadoop services (Hive/YARN/HBase, etc.) via standard protocols. Kyligence Enterprise automatically finds the services with the client configurations and then starts working. No additional installation/configuration is needed, just a “kylin.sh start” will start Kyligence Enterprise. If you want to uninstall, a “kylin.sh stop” command will shut down Kyligence Enterprise.

HDInsight application platform is an easy way to distribute, discover, and install applications that you have built for the Hadoop ecosystem. HDInsight application platform automatically provisions an “Edge Node” for the application, and installs/configures the Hadoop clients on it. Developers only need to provide a shell script and a ARM (Azure Resource Manager) template for their application to install the application, and other processes are handled by Azure. This is a fancy feature that makes deploying Kyligence Enterprise on HDInsight much easier and more efficient. Figure 1 shows the architecture of Kyligence Enterprise with HDInsight.

![Figure 1. Kyligence Enterprise with Azure HDInsight Architecture](images/kap_with_hdinsight.png)

By referring to the samples in Azure [Iaas-Applications](https://github.com/hdinsight/Iaas-Applications) project, we developed the first version of the Azure Resource Manager (ARM) template for Kyligence Enterprise, and successfully deployed Kyligence Enterprise on a cluster. After that, we continuously enhance the template and scripts to enable more features. Now, both Kyligence Enterprise and KyAnalyzer, our agile BI tool, can be installed as HDInsight applications. Users can quickly get a Hadoop-based Data Warehouse + Business Intelligence tool in a couple of minutes.

Advanced users expect to optimize Hadoop and Kyligence Enterprise to have better performance. With Apache Ambari as the centralized configuration management and monitoring platform, users can configure the parameters of Hadoop services by Ambari's web interface or API, and Ambari will automatically update the configuration to each node, including the nodes that Kyligence Enterprise runs. For Kyligence Enterprise configuration, you can login to the node through SSH and configure it, which is easy to do.

### **How to Install Kyligence Enterprise**

Kyligence Enterprise is now available on Microsoft Azure (including Azure overseas and Azure China operated by VNET). Our customers have already started to use HDInsight + Kyligence Enterprise for their business. We, Kyligence Inc., are also using it in development, testing, training, live demo, prof of concept and other scenarios. To enable it, you just need a couple of steps:

1) You need to prepare a HDInsight cluster with the type of “Hadoop”. It can be an existing cluster or a new cluster.

![Figure 2. Select HBase as cluster type](images/hadoop_cluster.png)

2) If it is a new cluster, you need to switch to the “Custom” wizard, select “Kyligence Enterprise Plus” in the third step, as below:

![Figure 3. Select Kyligence Enterprise to install](images/kap_install.png)

If it is an existing Hadoop cluster, you need to click the “Applications” icon, and then click “Add” button. In the application list, select “Kyligence Enterprise Plus” to install. Clicking “Purchase” button means you agree with the terms to install. It won’t cause additional charge for Kyligence Enterprise. YAfter installation, you can apply for 2 months' trial license on the Kyligence Enterprise interface. It is free in the probation period. After the trial, please contact Kyligence company to purchase the official license.

![Figure 4. Kyligence Enterprise in HDInsight Applications](images/kap_in_hdinsight.png)

3) After the cluster is created, you will get the Kyligence Enterprise and KyAnalyzer URL from Azure Portal. Clicking them will lead you to the Kyligence Enterprise web portal and KyAnalyzer web portal. You can also get the SSH endpoint of the Edge Node that running Kyligence Enterprise.

![Figure 5. Kyligence Enterprise and KyAnalyzer URL](images/kap_kyanalyzerurl.png)

### **Request Trial License and Login**

On the first time visiting, Kyligence Enterprise will ask for a license. If you don’t have a license, you can easily request a free trial license here. Click ”Apply Evaluation License“, fill in your email address, organization name and person name, and then click ”Submit“. It will download a trial license immediately and then you can go ahead. After the trial expires (two months), you can contact Kyligence to purchase a formal license.

![Figure 6. Apply Trial License](images/trial_license.png)

The initial administrator username is ”ADMIN“ and the password is ”KYLIN“. Enter it and then click ”Submit“ to login. At the first login, Kyligence Enterprise will ask you to update the password to a stronger one. Please remember the new password for future login.

KyAnalyzer integrates with Kyligence Enterprise for user authentication, so you just need to update the user in Kyligence Enterprise once, and then use the same in KyAnalyzer.

### Switch Metastore (Optional)

If you've installed Kyligence Enterprise Plus from HDInsight Applications, the metadata of Kyligence Enterprise will be stored in the MySQL database installed on the edge node. But this MySQL has not tuned for production use. So recommand to switch Kyligence Enterprise metastore to MySQL on Azure or SQL Server on Azure for better optimization and maintanence. About how to configure metastore, please refer to: [Use jdbc to connect other database as metastore](../../config/metadata_jdbc_mysql.en.md)

### **Play with Sample Cube**

The installation will create a sample “kylin_sales_cube” (as well as sample tables in Apache Hive) in the “learn_kylin” project. In the left navigation, click ”Studio“ -> ”Cube“ then you will see the sample cube. It is in “DISABLED” status, you need to build it before query. Click ”Actions“ -> ”Build“, and then pick an end date like ‘2014-01-01’, Kyligence Enterprise will start a build job.

![Figure 7. Sample Cube](images/sample_cube.png)

You can monitor the build progress on Kyligence Enterprise’s  ”Monitor“ tab; After the build is finished (progress 100%), the Cube status is changed to “Ready”, that means you can query it with ANSI-SQL in the “Insight” page, e.g.:

```sql
select part_dt, sum(price) as total_selled, count(distinct seller_id) as sellers from kylin_sales group by part_dt order by part_dt;
```

Kyligence Enterprise will return results quickly. You can run the same query to compare the performance.

![Figure 8. Run Query in Kyligence Enterprise](images/query_in_kap.png)

Now you know how to use Kyligence Enterprise to accelerate your data analysis. But writing SQL is still troublesome for most users. You can use KyAnalyzer to analyze the data by drag-and-drop.

### **Import Data to Kyligence Enterprise**

Kyligence Enterprise supports Apache Hive and Apache Kafka as the data source. Hive is for batch processing; Kafka is for streaming processing.

To use your batch data in Kyligence Enterprise, you need to describe your files as a Hive tables as the first step.  HDInsight supports using Azure Blob Store and Azure Data Lake as the storage for Hadoop, so you can easily manage and process the data on Cloud with high availability, long durability, and low-cost. Here is an example of uploading files to Azure Blob Store with command line:

```properties
export AZURE_STORAGE_ACCOUNT=<your storage account>
export AZURE_STORAGE_ACCESS_KEY=<your storage account access key>
```

```properties
#list all files in container
azure storage blob list <container>
#upload a file to container
azure storage blob upload <path of a local file> <container> <name in container>
```

Although Azure Blob Store is not a real file system, it can use “/” as the separator in the file name to simulate the folder structures. The following command will upload the local file “airline_2015_01.csv” to container “mycontainer”, and use “airline/2015/airline_2015_01.csv” as the remote path:

```properties
azure storage blob upload airline_2015_01.csv mycontainer airline/2015/airline_2015_01.csv
```

Once the files be uploaded to Azure Blob Store, you can use HiveQL to create the table. You can do this in the “Hive view” of HDInsight Ambari, or use SSH to a node and use the Hive command line to execute the HiveQL statement. Below is an example of creating a partitioned Hive table:

```properties
hive> CREATE EXTERNAL TABLE airline_data (
   Year int,  
   Quarter int, 
   Month int,  
   DayofMonth int, 
   DayOfWeek int, 
   FlightDate date, 
   ...
 ) 
 PARTITIONED BY (Part_year STRING)
 ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
 WITH SERDEPROPERTIES ("separatorChar" = ",") 
 LOCATION 'wasb://<container>@<storage-account>.blob.core.windows.net/airline' 
 TBLPROPERTIES('serialization.null.format'='','skip.header.line.count'='1');
```

Please replace container and storage-account with your store account information. Then you can add partitions like this:

```properties
hive> ALTER TABLE airline_data ADD PARTITION (Part_year = '2015') location 'wasb://<container>@<storage-account>.blob.core.windows.net/airline/2015';
```

When the table created and has at least 1 partition, you can query it in Hive:

```properties
hive> select * from airline_data limit 100;
```

Now you have successfully created a Hive table with your data files on Azure cloud storage. You can login Kyligence Enterprise web GUI, in the "Studio" -> "Data source" page, click the "Load Hive Table" button to import table metadata into Kyligence Enterprise; The import only synchronizes the table metadata, like column name. The source data is still in origin place, so this operation will be fast:

![Figure 9. Import Hive Table](images/hive_table.png)

### Create Model and Cube

With all necessary tables being imported, you can start to define your data model. The model is a basis for Cube, and it can be reused by multiple Cubes. In the ”Studio“ tab, click ”+Model“, enter the name, and then drag and drop the tables to the model designer canvas.

On each table, click the ”setting“ icon and then mark it as “Fact table” or “Lookup table”. The fact table will be highlighted in blue. You can link two tables by draging one column from fact table to another to setup the FK/PK relationship.

Kyligence Enterprise will automatically detect columns’ type and then determine it is a dimension, measure or none, with “D”, “M” or “-” as the prefix. If it is not accurate, you can click on the prefix to modify.

![Figure 10. Create Data Model](images/data_model.png)

Once finished, click “Save” to save the data model. Kylience Enterprise will automatically run a job to check and collect statistics of the model. You can track the job progress in the “Monitor” tab. The statistic will help Kyligence Enterprise to understand the model and give you advices when creating Cube.

Now you can create a Cube. Cube is a data structure which has dimensions and measures. Kyligence Enterprise supports tens of dimensions in a Cube, and you can define the most common measures like SUM, COUNT, MAX, MIN, DISTINCT COUNT and also supports advanced metrics, such as Top- N, Percentile, and precise weight counter based on Bitmap. Click the “+Cube”, a wizard will guide you to finish these step by step.

![Figure 11. Create Cube](images/cube_create.png)

### **Build Cube**

After the Cube is created, you need to build data into it. In the Cube list, click “Action” -> “Build”. If your data model is partitioned, you need to specify a date range for the source data; If it is not partitioned, all data will be loaded into Cube.

![Figure 12. Build Cube](images/build_cube.png)

When trigger a Cube build, a job is created and you can monitor the progress in the “Monitor” page. The build can take a couple of minutes to several hours, which depends on your data size and cluster capacity. You can expand the job to see each steps. If a step is a MR job, it shows the link to job on Hadoop resource manager, where you can track the detail progress. Once the build is finished, the Cube status will be changed to “Ready” automatically, which means it can serve your queries.

### **Run Queries**

Click the “Insight” tab, you can compose a SQL query and then click “Submit”. The query will be served with Cube; and you can preview the result in the web page.

### **Use KyAnalyzer for Agile BI**

Log in KyAnalyzer with the same user as Kyligence Enterprise, in the ” Console” page, click “Sync Cubes from Kylin”, select the “kylin_sales_cube” to sync. The Cube will be imported to KyAnalyzer.

![Figure 13. Sync Cube to KyAnalyzer](images/sync_to_kyanalyzer.png)

Click the “New query” to open a new page, click the refresh button beside “Cubes” to see the new loaded model, select “kylin_sales” in the dropdown list. Now you see the measures and dimensions. Click one measure and one dimension, it will query the data and generate a data table.

![Figure 14. Select dimension and measure in KyAnalyzer](images/dimension_and_measure.png)

By clicking the “Chart Mode” icon in the upper right corner, KyAnalyzer will generate diagram based on the table, as below shows. Isn’t it easy?

![Figure 15. Generate chart in KyAnalyzer](images/chart_in_kyanalyzer.png)

Congratulations! You have built your first Cube and created the first chart by drag-and-drop. You can also integrate Kyligence Enterprise with more visualization tools like Tableau, PowerBI/Excel. For detailed information, please refer to related pages in the chapter of **Integrate with the 3rd party**.

### **Kafka on HDInsight Integration**

Apache Kafka is a popular open-source stream-ingestion broker. It can handle large numbers of reads and writes per second from thousands of clients. Kyligence Enterprise supports using Apache Kafka (v0.10+) as the data source. You can flow your data to Kafka topics continuously, and then build data into Cube with incremental build jobs. With this integration, it can decrease the data latency from days/hours to minutes level.

Kafka on HDInsight provides you with a managed, highly scalable, and highly available service in the Azure cloud. You can create a Kafka cluster from Azure portal quickly. To ensure the Kafka version in Kyligence Enterprise node is compatible with the Kafka cluster, we recommend you use the same HDInsight version. Otherwise, you need to manually download and install the matched version of Kafka in Kyligence Enterprise instance.

HDInsight does not allow to directly connect to Kafka over the public internet. In order to connect with Kafka from Kyligence Enterprise, you need to make these two clusters share the same V-Net, or use VPN solution. 

By default, Kyligence Enterprise doesn’t have Kafka client shipped; so you will get a “ClassNotFoundException” error when connecting to a Kafka cluster. To fix this, you need to SSH into the Kyligence Enterprise node, manually specify KAFKA_HOME environment variable in KYLIN_HOME/bin/find-kafka-dependency.sh:

```
ssh sshuser@KAP.CLUSTERNAME-ssh.azurehdinsight.net

sudo vi /usr/local/kap/bin/setenv.sh
```

In the beginning position, add (Please use the Kafka installation path that exists in the specific environment.):

```
export KAFKA_HOME=/usr/hdp/2.5.5.3-2/kafka
```

Then you can verify whether it can find the dependent jar successfully, such as:

```
sshuser@ed10-kapdem:~$ /usr/local/kap/bin/find-kafka-dependency.sh -v

Turn on verbose mode.

Retrieving kafka dependency...

KAFKA_HOME is set to: /usr/hdp/2.5.5.3-2/kafka, use it to locate kafka dependencies.

kafka dependency: /usr/hdp/2.5.5.3-2/kafka/libs/kafka-clients-0.10.0.2.5.5.3-2.jar
```

If OK, then restart Kyligence Enterprise service to take effective:

```
sudo systemctl restart Kyligence Enterprise
```

When Kyligence Enterprise is restarted, go back to the “Studio” -> “Datasource” page, click “Kafka” button, input the Kafka broker host and port info. Then Kyligence Enterprise will connect to Kafka, list the topics and then show sample messages, as shown in Figure 16.

![Figure 16. Kafka Integration](images/kafka_integration.png)

The next step is to continue with the section "Streaming Cube" in the Kyligence Enterprise manual.

### Practices of Kyligence Enterprise on HDInsight

Here are some practices that can help you in using this solution better.

*1. Use dedicated virtual network for HDInsight*

When creating HDInsight clusters, a specific virtual network can be specified to manage the node network configuration of the cluster. If not specified, Azure will use a default virtual network for each HDInsight cluster. The default virtual network is invisible in Azure portal; so once the cluster being created, you couldn’t add other instances to it nor customize its network firewall. In order to keep the flexibility for future, we recommend you create a dedicated virtual network and then use it for the new HDInsight. The virtual network needs to be associated with a network security group, which needs to allow the connections for HDInsight required hosts and ports. You can check HDInsight documentation for the details.

*2. Optimize Hadoop settings*

The default Hadoop settings of HDInsight might not be the best for Kyligence Enterprise. They may allocate much resources to HBase but leave less for YARN. Besides, as the Cubes are immutable in HBase, we can allocate more resource to block cache to gain better read performance. You can optimize these settings in the HDInsight dashboard (Ambari Web UI). Here are some recommended settings:

![Table 1. Recommended settings](images/recommended_settings.en.png)

After update these parameters, remember to sync the changes to cluster nodes and then restart the services to take effective. Kyligence Enterprise service also needs to be restarted to ensure that the latest settings are used.

*3. Use multiple storage accounts*

Using multiple storage accounts will better leverage the network bandwidth, improve the performance of concurrent IO, so as to improve the performance. You can use separated storage accounts for the source Hive tables.

*4. Scale and shrink on demand*

With data in Azure Blob Store or Azure Data Lake, you can easily scale and shrink the cluster without worrying about data loss. For example, when you build a big Cube, you can scale out it to get more concurrencies. After the build is finished, you can shrink it back to save the cost.

*5. Shutdown and bring back*

Kyligence Enterprise uses HBase to store the Cube metadata and Cube data. With the Hadoop/HBase data persisted in Azure Blob Store or Azure Data Lake at a very low cost, you can safely delete the cluster when you don’t need it, and someday when you need, bring it back by re-creating the cluster with the same storage account and container. The Cubes that you built previously will be working for you as before. This will be great if it is a low frequent usage scenario.

While there are still some other data you may need to take a manual backup:

- Kyligience Enterprise/KyAnalyzer configurations and logs

Kyligence Enterprise configurations (as well as shell scripts) are local files on the edge node. If you have made some local changes and want to keep after re-creation, a backup is needed. You can use “Hadoop fs -put” command to easily upload the files to distributed file system, which is the Azure Blob Store or Azure Data Lake.

- Hive metadata

Hive metadata is persisted in a SQL database, not Azure Blob Store or Azure Data Lake. So if you select to use an external SQL service, that would be good. Otherwise when re-creating Cluster, you may lose the Hive metadata. So you’d better backup the Hive scripts or select to use an Azure SQL service as Hive metadata store when creating HDInsight.

*6. Start/stop Kyligence Enterprise and KyAnalyzer*

- Kyligence Enterprise and KyAnalyzer are installed in the HDInsight edge node. You need SSH into it with the SSH user and credential that configured for the cluster:

```
ssh sshuser@KAP.CLUSTERNAME-ssh.azurehdinsight.net
```

Replace the “CLUSTERNAME” with your cluster name.

- Kyligence Enterprise and KyAnalyzer are installed in “/usr/local/kap” (KYLIN_HOME) and “/usr/local/kyanalyzer” (KYANALYZER_HOME). You can check the scripts, configurations and log files there. For example:

```
tail -200f /usr/local/kap/logs/kylin.log

tail -200f /usr/local/kyanalyzer/tomcat/logs/kyanalyzer.log
```

- Kyligence Enterprise and KyAnalyzer are registered as system services. You can manually start, stop them with systemctl command. For example:

```
sudo systemctl status kap

sudo systemctl stop kap 

sudo systemctl start kap
```

To operate KyAnalyzer, you only need to replace the "Kyligence Enterprise" in the above command with "kyanalyzer".

