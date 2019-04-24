## Build Cube from Streaming Data

Build cube job from streaming data can be triggered from WEB UI or by REST API. For more information about how to use REST API, please refer to  [Cube Build API - Build a streaming cube](../../rest/cube_api/cube_build_api.en.md#build-a-streaming-cube)

### Frequently Asked Questions

**Q: How to trigger the periodic automatic build of the streaming Cube?**
After the first build is completed, you can trigger the build job at a fixed time, and each time the build job is triggered, Kyligence Enterprise will automatically build from the last time it was last. You can periodically trigger a build task using Linux's `crontab` command:
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
**Q: Because the build job of the streaming cube always starts from the end of the message queue, if a build job is discarded, the cube will genereate a "hole" due to the missing segment. Normal build jobs will not be able to fill these holes. How should this be handled?**
Use REST API to find the "holes" of these segments and trigger the build job to fill them.

- Check for holes

  ```shell
  curl -X GET \
       'http://host:port/kylin/api/cubes/{your_cube_name}/holes' \
       -H 'Accept: application/vnd.apache.kylin-v2+json' \
       -H 'Accept-Language: en' \
       -H 'Authorization: Basic QURNSU46S1lMSU4=' \
       -H 'Content-Type: application/json;charset=utf-8'
  ```

  If the result is an empty array, there is no hole. Otherwise, you need to manually trigger a new build task to fill the "hole."

- Check for holes

  ```shell
    curl -X PUT \
       'http://host:port/kylin/api/cubes/{your_cube_name}/holes' \
       -H 'Accept: application/vnd.apache.kylin-v2+json' \
       -H 'Accept-Language: en' \
       -H 'Authorization: Basic QURNSU46S1lMSU4=' \
       -H 'Content-Type: application/json;charset=utf-8'
  ```

**Q: What if there is already a lot of messages in Kafka Topic?**
You can initiate start of offset for the build via the REST API and select the tail of the Kafka Topic queue as the starting point for the build.

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

**Q: How to solve the failed building job due to empty or other invalid values in Kafka data?**

You can change the properties in  `$KYLIN_HOME/conf/kylin.properties ` :

```properties
kylin.engine.mr.tolerant-with-invalid-data=true
```

The default value is false. After enable this parameter, the row which contains messy data, such as empty data, will be skipped to ensure the job building successfully.