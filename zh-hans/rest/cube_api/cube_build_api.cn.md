## Cube 构建 API

> **提示：**
>
> 1. 请确保已阅读前面的[访问及安全认证](../authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [构建 Cube - 全量构建](#构建Cube全量构建)
* [构建 Cube - 按日期/时间构建](#构建Cube按日期/时间构建)
* [构建 Cube - 按文件增量构建](#构建Cube按文件增量构建)
* [构建 Cube - 流式构建](#构建Cube流式构建)
* [构建 Cube - 自定义增量构建](#构建Cube自定义增量构建)
* [构建 Cube - 批量构建](#构建Cube批量构建)




### 构建 Cube - 全量构建  {#构建Cube全量构建}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build`

- URL Parameters
  - `cubeName` - `必选` `string`，Cube 名称

- HTTP Header
  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`

- HTTP Body: JSON Object
  - `startTime` - `必选` `long`，开始时间，为 0
  - `endTime` - `必选` `long`，结束时间，为 0
  - `buildType` - `必选` `string`，支持的计算类型："BUILD"


- Curl 请求示例

```sh
curl -X PUT \
'http://host:port/kylin/api/cubes/{cubeName}/segments/build' \
-H 'Accept: application/vnd.apache.kylin-v2+json' \
-H 'Accept-Language: en' \
-H 'Authorization: Basic QURNSU46S1lMSU4=' \
-H 'Content-Type: application/json;charset=utf-8' \
-d '{
"startTime": 0,
"endTime": 0,
"buildType": "BUILD"
}'
```

- 响应示例

```JSON
{
"code":"000",
"data":{
"uuid":"f055ceaa-4fa0-45ca-b862-ed52b1531ca6",
"last_modified":1536302880808,
"version":"3.0.0.1",
"name":"BUILD CUBE - {cubeName}- FULL_BUILD - GMT+08:00 2018-09-07 14:48:00",
"type":"BUILD",
"duration":0,
"related_cube":"{cubeName}",
"display_cube_name":"{cubeName}",
"related_segment":"5eda2c50-270c-4913-bf00-d8f006890a34",
"exec_start_time":0,
"exec_end_time":0,
"exec_interrupt_time":0,
"mr_waiting":0,
"steps":[...],
"submitter":"ADMIN",
"job_status":"PENDING",
"progress":0
},
"msg":""
}
```



### 构建 Cube - 按日期/时间构建  {#构建Cube按日期/时间构建}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build`

- URL Parameters

  - `cubeName` - `必选` `string`，Cube 名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `startTime` - `必选` `long`，开始时间，对应 GMT 格式的时间戳，如 `1388534400000` 对应 `2014-01-01 00:00:00` ，推荐使用[在线时间戳转换](https://www.epochconverter.com/)对时间进行处理。
  - `endTime` - `必选` `long`，结束时间，对应 GMT 格式的时间戳
  - `buildType` - `必选` `string`，支持的计算类型，为："BUILD"
  - `mpValues` - `可选` `string`，对应模型的分区字段值
  - `force` - `可选` `boolean`，强制提交任务选项，默认值false

  > **提示：** 如果您的源数据随时可能发生更新，并且需要同步刷新 Cube 数据，可以使用**强制提交任务**选项，一步完成刷新 Cube 数据工作，系统将自动对现有的 Cube Segment 或任务进行相应处理：
  >
  > - 如果 Cube 中不存在时间区间相同的 Segment，系统中也没有相应的正在运行或在队列中等待的任务，那么该任务会正常提交。
  > - 如果 Cube 中存在已经构建成功的时间区间相同的 Segment，任务提交后会变成相应的 Cube 刷新任务。
  > - 如果 Cube 中存在构建失败的时间区间相同的 Segment，系统将会终止该任务，并提交新的任务。
  > - 如果系统中存在正在运行或在队列中等待的构建任务，系统将自动终止当前任务，并提交新任务。


- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/{cubeName}/segments/build' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
  	"startTime": 0,
  	"endTime": 1388534400000,
  	"buildType": "BUILD",
  	"force": false
  }'
  ```

- 响应示例

  ```JSON
  {
      "code":"000",
      "data":{
          "uuid":"83c6cd7a-61ce-4d66-9bd3-fea35487dcf7",
          "last_modified":1536289966183,
          "version":"3.0.0.1",
          "name":"BUILD CUBE - {cubeName} - 20120415114212_20140101000000 - GMT+08:00 2018-09-07 11:12:45",
          "type":"BUILD",
          "duration":0,
          "related_cube":"{cubeName}",
          "display_cube_name":"{cubeName}",
          "related_segment":"739453a4-d59d-4a27-af37-d06d16ca17b1",
          "exec_start_time":0,
          "exec_end_time":0,
          "exec_interrupt_time":0,
          "mr_waiting":0,
          "steps":[...],
          "submitter":"ADMIN",
          "job_status":"PENDING",
          "progress":0
      },
      "msg":""
  }
  ```



### 构建 Cube - 按文件增量构建  {#构建Cube按文件增量构建}

根据指定的新增数据文件，构建一个新的 Cube Segment。

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_by_files`

- URL Parameters

  - `cubeName` - `必选` `string`, Cube 名称

- HTTP Header

  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en` 

- HTTP Body: JSON Object

  - `startOffset` - `必选` `long`, Segment 区间的起始值（包含）。目前支持 “**年月日+小时+文件序号**” 格式的 13 位数字。例如，2018042210000表示2018年4月22日10点， 最后三位表示同一个小时内增量的构建序数，最大值为100。

  - `endOffset` - `可选` `long`, Segment 区间的结束值（不包含）。如果省略该值，系统将根据 Cube 中已有的 Segment 和给定的 `startOffset` 自动调整 Segment 区间。典型的用法是，用户可以用相同的小时 `startOffset` 多次请求构建。例如，假设以 `startOffset=2018042210000` 连续请求三次构建，`endOffset` 省略，系统将依次生产这个小时内的三个连续的 Segment：[2018042210000, 2018042210001), [2018042210001, 2018042210002), [2018042210002, 2018042210003)。

  - `buildType` - `必选` `string`, 支持的构建类型为 `BUILD`。

  - `files` - `必选` `string[]`, 新增数据文件在 HDFS 中的绝对路径列表。

  - > 注意：为了防止意外的重复数据，系统不允许在同一个 Cube 中重复加载同一个数据文件。

- Curl 请求示例

  ```bash
  curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/json;charset=utf-8" -H "Accept: application/vnd.apache.kylin-v2+json"  -d '{"startOffset":2018042210000, "buildType":"BUILD", "files":["/sample/path/file1"]}' http://localhost:port/kylin/api/cubes/{cubeName}/segments/build_by_files
  ```

- 响应示例

  ```json
  {
      "code":"000",
      "data":{
          "uuid":"44c2a986-7535-4579-b84a-72c9c802318d",
          "last_modified":1533731858358,
          "version":"3.0.0.1",
          "name":"BUILD CUBE - {cubeName} - 2018042210000_2018042210001 - GMT+08:00 2018-08-08 20:37:38",
          "type":"BUILD",
          "duration":0,
          "related_cube":"{cubeName}",
          "display_cube_name":"{cubeName}",
          "related_segment":"42598177-c5a2-4b3a-ab84-4a9f99639e6b",
          "exec_start_time":0,
          "exec_end_time":0,
          "exec_interrupt_time":0,
          "mr_waiting":0,
          "steps":[...],
          "submitter":"ADMIN",
          "job_status":"PENDING",
          "progress":0
      },
      "msg":""
  }
  ```



### 构建 Cube - 流式构建  {#构建Cube流式构建}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_streaming`

- URL Parameters

  - `cubeName` - `必选` `string`，Cube 名称

- HTTP Header

  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object

  - `sourceOffsetStart` - `必选` `long`，构建开始偏移量。０指的是Cube开始构建的偏移量
  - `sourceOffsetEnd` - `必选` `long`，构建结束偏移量。9223372036854775807指的是Long.MAX_VALUE的值，指的是Kyligence Enterprise的构建会用到Topic中目前为止拥有的所有消息。
  - `buildType` - `必选` `string`，支持的计算类型，为："BUILD"
  - `mpValues` - `可选` `string`，对应模型的分区字段值

  > 注意：API是以"_streaming"结尾的，这跟常规构建中以"build"结尾不同。

* Curl 请求示例

  ```sh
  curl -X PUT --user ADMIN:KYLIN 
    -H "Accept: application/vnd.apache.kylin-v2+json" 
    -H "Content-Type:application/json" 
    -H "Accept-Language: en" 
    -d '{ 
      "sourceOffsetStart": 0, 
      "sourceOffsetEnd": 9223372036854775807, 
      "buildType": "BUILD"}' http://localhost:7070/kylin/api/cubes/{cubeName}/build_streaming
  ```

* 响应示例

  ```json
  {
    "code": "000",
    "data": {
        "uuid": "3adcdb03-0104-4d25-b252-1e0200fd695a",
        "last_modified": 1547026048215,
        "version": "3.2.2.2020",
        "name": "BUILD CUBE - {cubeName} - 19232_19684 - GMT+08:00 2019-01-09 17:27:28",
        "type": "BUILD",
        "duration": 0,
        "related_cube": "{cubeName}",
        "display_cube_name": "{cubeName}",
        "project_name": "{projectName}",
        "related_segment": "aea8e646-74ab-4263-a8bb-35b9dd8b73a4",
        "exec_start_time": 0,
        "exec_end_time": 0,
        "exec_interrupt_time": 0,
        "mr_waiting": 0,
        "steps": [...],
        "submitter": "ADMIN",
        "job_status": "PENDING",
        "progress": 0
    },
    "msg": ""
}
  ```



### 构建 Cube - 自定义增量构建  {#构建Cube自定义增量构建}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_customized`

- URL Parameters

  - `cubeName` - `必选` `string`, Cube 名称

- HTTP Header

  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en` 

- HTTP Body: JSON Object

  - `sourceOffsetStart` - `必选` `long`, Segment 区间的起始值。
  - `sourceOffsetEnd` - `可选` `long`, Segment 区间的结束值。
  - `buildType` - `必选` `string`, 支持的构建类型为 `BUILD`。

- Curl 请求示例

  ```sh
  curl -X PUT \
    http://host:port/kylin/api/cubes/{your_cube_name}/segments/build_customized \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: cn/en' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
   "sourceOffsetStart":201201010001,
   "sourceOffsetEnd":201201010002,
   "buildType":"BUILD",
   "force":true
  }'
  ```

- 响应示例

  ```json
  {
    "code": "000",
    "data": {
        "uuid": "3f214b0b-84ab-46aa-a166-b7ab217ca8f4",
        "last_modified": 1547026478069,
        "version": "3.2.2.2020",
        "name": "BUILD CUBE - {cubeName} - 201812010001_201812010002 - GMT+08:00 2019-01-09 17:34:38",
        "type": "BUILD",
        "duration": 0,
        "related_cube": "{cubeName}",
        "display_cube_name": "{cubeName}",
        "project_name": "{projectName}",
        "related_segment": "5c6bfba9-c709-436d-853e-f7a9fb462530",
        "exec_start_time": 0,
        "exec_end_time": 0,
        "exec_interrupt_time": 0,
        "mr_waiting": 0,
        "steps": [...],
        "submitter": "ADMIN",
        "job_status": "PENDING",
        "progress": 0
    },
    "msg": ""
}
  ```



### 构建 Cube - 批量构建  {#构建Cube批量构建}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/batch_sync`

- URL Parameters

  - `cubeName` - `必选` `string`，Cube 名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `pointList` - `可选` `string`，对应模型的分区的字段值
  - `rangeList` - `可选` `string`，对应模型的分区的字段值
  - `mpValues` - `可选` `string`， 对应模型的分区的字段值

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/{cubeName}/batch_sync' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '[{"mpValues": "300","pointList": ["1","2","3","4","5","6","7","8","9","10"],"rangeList": [["50","70"],["90","110"]]},{"mpValues": "301","pointList": ["1","2","3","4","5","6","7","8","9","10"],"rangeList": [["20","30"],["30","40"]]}]'
  ```

- 响应示例

  ```JSON
  {
      "code":"000",
      "data":[
          {
          "code":"000",
          "data":{
              "uuid":"a09442bb-300f-4851-8bd2-2ec0d811dcb6",
              "last_modified":1529400276349,
              "version":"3.0.0.1",
              "name":"BUILD CUBE - {cubeName} - 1_2 - GMT+08:00 2018-06-19 17:24:36",
              "type":"BUILD",
              "duration":0,
              "related_cube":"{cubeName}",
              "display_cube_name":"{cubeName}",
              "related_segment":"5ef8d42b-5ed6-4489-b95c-07fe4cf5a2e6",
              "exec_start_time":0,
              "exec_end_time":0,
              "exec_interrupt_time":0,
              "mr_waiting":0,
              "steps":[...],
              "submitter":"ADMIN",
              "job_status":"PENDING",
              "progress":0.0
          },
          "msg":""
          }
      ],
      "msg":""
  }
  ```
