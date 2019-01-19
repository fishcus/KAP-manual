## 流式构建

您可以直接在 Web GUI 中，点击 Cube 的操作**构建**来触发 Cube 构建，当然，你也可以通过 curl 指令通过 REST API 触发 Cube 构建，详情请参考本用户手册中的 REST API章节。

在触发了 Cube 构建以后，在**监控**页面，我们可以观察到一个新的构建任务。在构建任务完成后，进入**查询**页面, 并执行 SQL 语句，确认流式 Cube 可用。

```sql
SELECT MINUTE_START, COUNT(*), SUM(AMOUNT), SUM(QTY) FROM KAFKA_TABLE_1 GROUP BY MINUTE_START ORDER BY MINUTE_START
```



### 常见问题答疑

- **Q：流式数据构建时，容易出现 Segment 空洞。比如如果某次构建发生了错误，并且您终止（discard）了这次构建，则Cube中会由于缺失了这次构建的segment而产生一个"空洞"。由于本产品的自动构建总是从最后的位置开始，正常的构建将无法填补这些空洞，这种情况应该如何处理：**
   您需要使用Kyligence Enterprise提供的工具找出这些"空洞"并且重新触发构建将其补全。

   **检查空洞**：

   ```sh
   curl -X GET --user ADMINN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" http://localhost:7070/kylin/api/cubes/{your_cube_name}/holes
   ```

   如果curl结果为空数组，则表示没有任何空洞。否则，我们则需要手动触发新构建任务（build job）来**填补空洞**：

   ```sh
   curl -X PUT --user ADMINN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" http://localhost:7070/kylin/api/cubes/{your_cube_name}/holes
   ```

- **Q：如果topic中已经有大量的消息怎么办？**
   您最好不要从头开始构建，建议您选择队列的尾部作为构建的起始点。将`sourceOffsetStart`参数的值设为0，构建时会自动从队列的尾部开始。如下所示：

   ```sh
   curl -X PUT --user ADMIN:KYLIN -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/json" -H "Accept-Language: en" -d '{ "sourceOffsetStart": 0, "sourceOffsetEnd": 9223372036854775807, "buildType": "BUILD"}' http://localhost:7070/kylin/api/cubes/{your_cube_name}/init_start_offsets
   ```

- **Q：在运行`kylin.sh`的时候，如果遇到如下错误**

   ```java
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

   这是由于Kyligence Enterprise无法找到 Kafka客户端的jar包导致的。请确认您是否已经正确设置了 `KAFKA_HOME`。 
