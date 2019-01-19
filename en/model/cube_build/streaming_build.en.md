## Streaming Build

You can trigger the build job from web GUI, by clicking **Actions** -> **Build**, or sending a request via Kyligence Enterprise REST API. For more details, please refer to REST API chapter.

After the build job is submitted, you can see this new job in the **Monitor** page.

Enter the **Insight** page, type in a SQL statement to test, e.g.:

```sql
SELECT MINUTE_START, COUNT(*), SUM(AMOUNT), SUM(QTY) FROM KAFKA_TABLE_1 GROUP BY MINUTE_START ORDER BY MINUTE_START
```



### Trouble Shooting

You may encounter the following error when you run “kylin.sh”:

```sh
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
```

The reason is Kyligence Enterprise isn’t able to find the proper Kafka client jars. Make sure you have properly set “KAFKA_HOME” environment variable.

Get “killed by admin” error in the “Build Cube” step

Within a Sandbox VM, YARN may not allocate the requested memory resource to MR job, as the “in-mem” cubing algorithm requests more memory resource. You can bypass this by requesting less memory: edit “conf/kylin_job_conf_inmem.xml”, change the following two parameters like this:

```xml
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
```

If there already exists bunch of history messages in Kafka and you'd better not to build from the very beginning, you can trigger a call to set the current end position as the start for the cube:

```sh
curl -X PUT --user ADMIN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" -d '{ "sourceOffsetStart": 0, "sourceOffsetEnd": 9223372036854775807, "buildType": "BUILD"}' http://localhost:7070/kylin/api/cubes/{your_cube_name}/init_start_offsets
```

If some build jobs got errors and you discard them, there will be a hole (or say gap) left in the Cube. Since each time Kyligence Enterprise will build from the last position, you couldn't expect the hole be filled by normal builds. Kyligence Enterprise provides API to check and fill the holes.

Check holes:

```sh
curl -X GET --user ADMINN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" http://localhost:7070/kylin/api/cubes/{your_cube_name}/holes
```

If the result is an empty array, it means there are no holes. Otherwise, trigger Kyligence Enterprise to fill them:

```sh
curl -X PUT --user ADMINN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" http://localhost:7070/kylin/api/cubes/{your_cube_name}/holes
```
