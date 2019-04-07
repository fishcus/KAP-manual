## 流式构建

流式构建可以通过在 WEB UI 中点击 Cube-->**操作**-->**构建**来触发，也可以通过 REST API 进行触发，具体 API 调用方法请参考 [Cube 构建 API](../../rest/cube_api/cube_build_api.cn.md#构建Cube流式构建) 中的**构建 Cube - 流式构建**部分内容。

### 常见问题答疑

**Q:如何触发流式 Cube 的定期自动构建？**
在第一次构建完成以后，您可以以一定周期定时触发构建任务，每次触发构建的时候，Kyligence Enterprise 都会自动从上次结束的位置开始构建。您可以使用 Linux 的 `crontab` 指令定期触发构建任务：
   ```sh
   crontab -e　*/5 * * * * curl -X PUT \
   'http://host:port/kylin/api/cubes/{cubeName}/build_streaming' \
   -H 'Accept: application/vnd.apache.kylin-v2+json' \
   -H 'Accept-Language: en' \
   -H 'Authorization: Basic QURNSU46S1lMSU4=' \
   -H 'Content-Type: application/json;charset=utf-8' \
   -d '{ 
       "sourceOffsetStart": 0, 
       "sourceOffsetEnd": 9223372036854775807, 
       "buildType": "BUILD"
   }' 
   ```
**Q:由于流式 Cube 的构建总是从消息队列尾部开始构建，如果某次构建任务被终止，则 Cube 中会由于缺失了此次构建的 Segment 而产生一个“空洞”。正常的构建将无法填补这些空洞，这种情况应该如何处理？**
使用 REST API 找出这些 Segment 的“空洞”，并且重新触发构建将其补全。
   - **检查空洞**
     ```sh
     curl -X GET \
     'http://host:port/kylin/api/cubes/{your_cube_name}/holes' \
     -H 'Accept: application/vnd.apache.kylin-v2+json' \
     -H 'Accept-Language: en' \
     -H 'Authorization: Basic QURNSU46S1lMSU4=' \
     -H 'Content-Type: application/json;charset=utf-8'
     ```
     如果返回结果为空数组，则表示没有任何空洞。否则，您需要手动触发新构建任务来填补“空洞”。

   - **填补空洞**
     ```sh
     curl -X PUT \
     'http://host:port/kylin/api/cubes/{your_cube_name}/holes' \
     -H 'Accept: application/vnd.apache.kylin-v2+json' \
     -H 'Accept-Language: en' \
     -H 'Authorization: Basic QURNSU46S1lMSU4=' \
     -H 'Content-Type: application/json;charset=utf-8'
     ```

**Q:如果 Kafka Topic 中已经有大量的消息怎么办？**
您可以通过 REST API 设置构建的起始偏移量，选择 Kafka Topic 队列的尾部作为构建的起始点。

```sh
curl -X PUT \
'http://host:port/kylin/api/cubes/{your_cube_name}/init_start_offsets' \
-H 'Accept: application/vnd.apache.kylin-v2+json' \
-H 'Accept-Language: en' \
-H 'Authorization: Basic QURNSU46S1lMSU4=' \
-H 'Content-Type: application/json;charset=utf-8'
-d '{ 
     "sourceOffsetStart": 0, 
     "sourceOffsetEnd": 9223372036854775807, 
     "buildType": "BUILD"
    }' 
```



**Q: 当前因为 Kafka 数据中有空值导致构建失败，应该如何解决？**

您可以通过在 `$KYLIN_HOME/conf/kylin.properties ` 中配置如下参数：

```properties
kylin.engine.mr.tolerant-with-invalid-data=true
```

该参数默认关闭，开启该参数后，当构建时遇到异常数据，如空字符串，缺失字段等情况时将会自动跳过该行数据，保证构建的正常进行。

