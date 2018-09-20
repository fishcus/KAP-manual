##  Streaming Cube

Kyligence Enterprise 2.3.x releases the scalable streaming cubing function, it leverages Hadoop to consume the data from Kafka to build the cube. This doc is a step-by-step tutorial, illustrating how to create and build a streaming cube.

For the information on Kafka data source import and the definition of a fact table from streaming data, please refer to [Import Kafka Data Source](data_import/kafka_import.en.md) under the section of Data Import.

### Create Data Model
With the table defined in the previous step, let's create the data model. This step is pretty same as creating a normal data model, but please notice:

* For a streaming cube, it doesn't support joining with lookup tables. So when you define the data model, only select "DEFAULT.KAFKA_TABLE_1 " as the fact table, no lookup tables.
* Select "MINUTE_START" as the cube's partition date column, as we will do incremental build at the minute level.

Here we pick 8 dimension columns and 2 measure columns:

![](images/g.png)
 	
![](images/h.png)

![](images/i.png)

Select 'MINUTE_START' as partition column. Save the data model.

![](images/j.png)


### Create Cube

The streaming cube is almost the same as a normal cube. A couple of points need your attention here:

* Don't use "order\_time" as dimension as that is pretty fine-grained, here we suggest to use "minute\_start", "hour\_start" or other, depending on how you inspect the data.
* In the "refresh setting" step, you should create more merge ranges, like 0.5 hour, 4 hours, 1 day, and 7 days. This helps to control the cube segment amount.
* "minute_start" is the partition column of model and shall be defined as `Dimension`.
* In the "rowkeys" section, drag the "minute\_start" to the head position. For streaming queries, the time condition is used frequently. So putting it to the head will help narrow down the scan range.

 ![](images/k.png)

 ![](images/l.png)
 ​	
 ![](images/m.png)

 ![](images/n.png)

Save the cube.


### Run a Build

You can trigger the build job from web GUI, by clicking “Actions” -> “Build”, or sending a request to Kyligence Enterprise RESTful API with ‘curl’ command:

	curl -X PUT --user ADMIN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" -d '{ "sourceOffsetStart": 0, "sourceOffsetEnd": 9223372036854775807, "buildType": "BUILD"}' http://localhost:7070/kylin/api/cubes/{your_cube_name}/build_streaming

Please notice that the API endpoint is different from a normal cube (this URL ends with “build_streaming”).

Here 0 means it is from the last position, and 9223372036854775807 (Long.MAX_VALUE) means to the end position on Kafka topic. If it is the first time to build (no previous segment), Kyligence Enterprise will seek the beginning of the topics as the start position.

In the “Monitor” page, a new job is generated; Wait it 100% finished.

Enter the “Insight” page, compose a SQL to run, e.g.:

	SELECT MINUTE_START, COUNT(*), SUM(AMOUNT), SUM(QTY) FROM KAFKA_TABLE_1 GROUP BY MINUTE_START ORDER BY MINUTE_START

### Automate the Build


Once the first build and query run successfully, you can schedule incremental builds at a certain frequency. Kyligence Enterprise records the offsets of each build; when receives a build request, it will start from the last end position, and then seeks the latest offsets from Kafka. You can invoke RESTful API with any scheduler tools like Linux crontab to build periodically:

    crontab -e　*/5 * * * * curl -X PUT --user ADMIN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" -d '{ "sourceOffsetStart": 0, "sourceOffsetEnd": 9223372036854775807, "buildType": "BUILD"}' http://localhost:7070/kylin/api/cubes/{your_cube_name}/build_streaming

Now you can find the cube is automatically built from streaming. And when the cube segments accumulate to a longer time range, Kyligence Enterprise will automatically merge them into a larger segment.

### Trouble Shooting

You may encounter the following error when you run “kylin.sh”:

    Exception in thread "main" java.lang.NoClassDefFoundError: org/apache/kafka/clients/producer/Producer
    at java.lang.Class.getDeclaredMethods0(Native Method)
    at java.lang.Class.privateGetDeclaredMethods(Class.java:2615)
    at java.lang.Class.getMethod0(Class.java:2856)
    at java.lang.Class.getMethod(Class.java:1668)
    at sun.launcher.LauncherHelper.getMainMethod(LauncherHelper.java:494)
    at sun.launcher.LauncherHelper.checkAndLoadMain(LauncherHelper.java:486)
    Caused by: java.lang.ClassNotFoundException: org.apache.kafka.clients.producer.Producer
    at java.net.URLClassLoader$1.run(URLClassLoader.java:366)
    at java.net.URLClassLoader$1.run(URLClassLoader.java:355)
    at java.security.AccessController.doPrivileged(Native Method)
    at java.net.URLClassLoader.findClass(URLClassLoader.java:354)
    at java.lang.ClassLoader.loadClass(ClassLoader.java:425)
    at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:308)
    at java.lang.ClassLoader.loadClass(ClassLoader.java:358)
    ... 6 more


The reason is Kyligence Enterprise isn’t able to find the proper Kafka client jars. Make sure you have properly set “KAFKA_HOME” environment variable.

    Get “killed by admin” error in the “Build Cube” step

Within a Sandbox VM, YARN may not allocate the requested memory resource to MR job, as the “in-mem” cubing algorithm requests more memory resource. You can bypass this by requesting less memory: edit “conf/kylin_job_conf_inmem.xml”, change the following two parameters like this:

	<property>
	    <name>mapreduce.map.memory.mb</name>
	    <value>1072</value>
	    <description></description>
	</property>
	
	<property>
	    <name>mapreduce.map.java.opts</name>
	    <value>-Xmx800m</value>
	    <description></description>
	</property>

If there already exists bunch of history messages in Kafka and you'd better not to build from the very beginning, you can trigger a call to set the current end position as the start for the cube:

	curl -X PUT --user ADMIN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" -d '{ "sourceOffsetStart": 0, "sourceOffsetEnd": 9223372036854775807, "buildType": "BUILD"}' http://localhost:7070/kylin/api/cubes/{your_cube_name}/init_start_offsets

If some build jobs got errors and you discard them, there will be a hole (or say gap) left in the Cube. Since each time Kyligence Enterprise will build from the last position, you couldn't expect the hole be filled by normal builds. Kyligence Enterprise provides API to check and fill the holes.

Check holes:

	curl -X GET --user ADMINN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" http://localhost:7070/kylin/api/cubes/{your_cube_name}/holes

If the result is an empty array, it means there are no holes. Otherwise, trigger Kyligence Enterprise to fill them:

	curl -X PUT --user ADMINN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" http://localhost:7070/kylin/api/cubes/{your_cube_name}/holes


### Create Streaming Cube by Sample Scripts

Kyligence Enterprise has bundled sample streaming cube and script which generates sample records constantly.

Under `KYLIN_HOME` , run`bin/sample.sh`, it creates source table `kylin_streaming_table`, model `kylin_streaming`, and cube `kylin_streaming_cube`. The table `kylin_streaming_table` has referred to the Kafka topic `kylin_streaming_topic` under localhost:9092 Kafka broker node.

Suppose the Kafka broker is running on localhost:9092, and `KAFKA_HOME` is set properly when Kyligence Enterprise starts, the script`sample-streaming.sh` will create new Kafka topic `kylin_streaming_topic`. The script will send 100 random messages per second to that topic.

In the cube listing page, `BUILD` could be triggered manually. Multiple build jobs could be triggered one by one to check the streaming cube.
