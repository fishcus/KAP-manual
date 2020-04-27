## Segment 管理 API

> **提示：**
>
> 1. 请确保已阅读前面的[访问及安全认证](./authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [合并/刷新/删除 Segment](#管理Segment)
* [导出 Segment](#导出Segment)
* [导入 Segment](#导入Segment)
* [文件数据源：（按小时）合并所有连续的 Segment](#文件数据源（按小时）合并Segment)
* [文件数据源：自定义区间合并 Segment](#文件数据源自定义区间合并Segment)
* [文件数据源：刷新 Segment](#文件数据源刷新Segment)
* [刷新维度表快照](#刷新维度表快照)




### 合并/刷新/删除 Segment {#管理Segment}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments`


- URL Parameters

  - `cubeName` - `必选` `string`，Cube 名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `buildType`  -  `必选` `string`，操作类型，为 "MERGE", "REFRESH" 或 "DROP"
  - `segments`  -  `必选` `string 数组`，Segment 名称的数组
  - `mpValues`  -  `可选` `string`， 模型的多级分区值
  - `force`  -  `可选` `boolean`，是否强制进行操作，为 "true" 或 "false"
  - `yarnQueue` - `可选` `string`，合并 segment 时可以设置任务的 YARN 队列，在系统级别或项目级别设置参数后使用：kylin.engine-yarn.queue.in.task.enabled（是否允许为任务指定 YARN 队列，默认不开启）、kylin.engine-yarn.queue.in.task.available（可供设置的 YARN 队列，多个队列时用英文逗号分隔）。

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/segments' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{"buildType":"REFRESH",
  "segments":["20180908000000_20180909000000"],
  "mpValues":""
  }'
  ```


- 响应示例

  ```json
  {
    "code":"000",
    "data":[
        {
            "uuid":"90be8cbb-4141-4af7-a57e-0a3b1b5504bd",
            "last_modified":1545912427926,
            "version":"3.2.1.2001",
            "name":"BUILD CUBE - kylin_sales_cube - 20180908000000_20180909000000 - GMT+08:00 2018-12-27 20:07:07",
            "type":"BUILD",
            "duration":0,
            "related_cube":"kylin_sales_cube",
            "display_cube_name":"kylin_sales_cube",
            "related_segment":"76910915-d869-4ed4-9d31-55c419e7a6b2",
            "exec_start_time":0,
            "exec_end_time":0,
            "exec_interrupt_time":0,
            "mr_waiting":0,
            "steps":[...],
            "submitter":"ADMIN",
            "job_status":"PENDING",
            "progress":0
        }
    ],
    "msg":""
  }
  ```



### 导出 Segment   {#导出Segment}

- `POST http://host:port/kylin/api/cubes/segment/export`


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `cube`  -  `必选` `string`，Cube 名称
  - `project`  -  `必选` `string`，项目名称
  - `segmentIds`  -  `必选` `string 数组`， Segment ID 的数组
  - `hdfsPath`  -  `必选` `string`，导出的 HDFS 目录地址
  - `mkdirOnHdfs`  -  `可选` `boolean`，是否强制创建 HDFS 目录，为 "true" 或 "false"

- Curl 请求示例

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/cubes/segment/export' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{"cube": "kylin_sales_cube",
    "project": "learn_kylin",
    "segmentIds": ["79e204f1-af67-47b4-962c-ee85077b3972"],
    "hdfsPath": "hdfs://ip:port/kylin/segment_export"
  }'
  ```


- 响应示例

  ```json
  {
    "code":"000",
    "data": "hdfs://ip:port/kylin/segment_export/79e204f1-af67-47b4-962c-ee85077b3972",
    "msg": "Export cube segment storage to HDFS successfully. Path: hdfs://ip:port/kylin/segment_export/79e204f1-af67-47b4-962c-ee85077b3972"
  }
  ```



### 导入 Segment  {#导入Segment}

- `POST http://host:port/kylin/api/cubes/segment/import`


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `hdfsPath`  -  `必选` `string`，导出的 HDFS 目录地址
  - `cubeName`  -  `可选` `string`，Cube 名称
  - `projectName`  -  `可选` `string`，项目名称
  - `tableMapping`  -  `可选` `map`，导入数据对应表名映射关系

- Curl 请求示例

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/cubes/segment/export' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{"hdfsPath": "hdfs://ip:port/kylin/kylin/segment_export/79e204f1-af67-47b4-962c-ee85077b3972",
    "tableMapping": {"EDW.TEST_CAL_DT_RENAME":"EDW.TEST_CAL_DT","DEFAULT.TEST_KYLIN_FACT_RENAME":"DEFAULT.TEST_KYLIN_FACT"}
  }'
  ```


- 响应示例

  ```json
  {
    "code":"000",
    "data": null,
    "msg": ""
  }
  ```



### 文件数据源：（按小时）合并所有连续的 Segment   {#文件数据源（按小时）合并Segment}

假设使用了 “**年月日+小时+文件序号**” 的 Segment 区间格式，调用这个 API 将合并所有同一小时内的连续 Segment。例如，如果已有下面的 Segment：

- [2018042210000, 2018042210001)         -- 21点的第一个 Segment
- [2018042210001, 2018042210002)         -- 21点的第二个 Segment
- [2018042210002, 2018042210003)         -- 21点的第三个 Segment
- [2018042220000, 2018042220001)         -- 22点的第一个 Segment
- [2018042220001, 2018042220002)         -- 22点的第二个 Segment

则调用 API 后，将把上面所有 Segment 合并为21点和22点两个合并的 Segment：

- [2018042210000, 2018042210003)         -- 21点的合并 Segment
- [2018042220000, 2018042220002)         -- 22点的合并 Segment

**具体调用方法**

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/merge_consecutive_segs_by_files`

- URL Parameters

  - `cubeName` - `必选` `string`， Cube 名称

- HTTP Header

  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en` 

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://localhost:port/kylin/api/cubes/cubeName/segments/merge_consecutive_segs_by_files' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -H 'cache-control: no-cache'
  ```

- 响应示例

  ```json
  {
      "code":"000",
      "data":[
          {
              "uuid":"03fdc009-ae6d-4632-8ebd-9ea9ac42f8e9",
              "last_modified":1533781944054,
              "version":"3.0.0.1",
              "name":"MERGE CUBE - file_test - 2018042210000_2018042210002 - GMT+08:00 2018-08-09 10:32:24",
              "type":"BUILD",
              "duration":0,
              "related_cube":"file_test",
              "display_cube_name":"file_test",
              "related_segment":"d1b06278-1443-4dc9-9e75-1129b39c7552",
              "exec_start_time":0,
              "exec_end_time":0,
              "exec_interrupt_time":0,
              "mr_waiting":0,
              "steps":[...],
              "submitter":"SYSTEM",
              "job_status":"PENDING",
              "progress":0
          }
      ],
      "msg":"1 jobs submitted"
  }
  ```



### 文件数据源：自定义区间合并 Segment   {#文件数据源自定义区间合并Segment}

根据自定义的区间合并 Segment。

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_by_files`
- URL Parameters

  - `cubeName` - `必选` `string`，Cube 名称
- HTTP Header
  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en` 

- HTTP Body: JSON Object
  - `startOffset` - `必选` `long`，合并区间起始值（包含），例如 `2018042210000` 表示2018年4月22日10点。
  - `endOffset` - `必选` `long`，合并区间结束值（不包含），例如 `2018042213000` 表示2018年4月22日13点。
  - `buildType` - `必选` `string`，支持的构建类型为 `MERGE`。

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://localhost:port/kylin/api/cubes/cubeName/segments/build_by_files' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -H 'cache-control: no-cache' \
    -d '{"startOffset":2018042210000, "endOffset": 2018042213000, "buildType":"MERGE"}'
  ```

- 响应示例

  ```json
  {
      "code":"000",
      "data":[
          {
              "uuid":"bf941173-3c81-42f3-b482-b4daf4668cc4",
              "last_modified":1533790550188,
              "version":"3.0.0.1",
              "name":"MERGE CUBE - file_test - 2018042210000_2018042213000 - GMT+08:00 2018-08-09 12:55:50",
              "type":"BUILD",
              "duration":0,
              "related_cube":"file_test",
              "display_cube_name":"file_test",
              "related_segment":"a48e5c84-0917-44d3-a50b-be565806703c",
              "exec_start_time":0,
              "exec_end_time":0,
              "exec_interrupt_time":0,
              "mr_waiting":0,
              "steps":[...],
              "submitter":"SYSTEM",
              "job_status":"PENDING",
              "progress":0
          }
      ],
      "msg":"1 jobs submitted"
  }
  ```



### 文件数据源：刷新 Segment   {#文件数据源刷新Segment}

一般而言，已经导入的数据不应该再有变化。但如果源数据确实发生了变化，也可以刷新（即重新载入）一个已经存在的 Segment。

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_by_files`
- URL Parameters

  - `cubeName` - `必选` `string`，Cube 名称
- HTTP Header
  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en` 

- HTTP Body: JSON Object
  - `startOffset` - `必选` `long`， 要刷新的 Segment 的区间起始值（包含）。
  - `endOffset` - `必选` `long`，要刷新的 Segment 的区间结束值（不包含）。
  - `buildType` - `必选` `string`，支持的构建类型为`BUILD`。
  - `files` - `必选` `string 数组`，刷新数据文件的绝对路径列表。

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://localhost:port/kylin/api/cubes/cubeName/segments/build_by_files' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -H 'cache-control: no-cache' \
    -d '{"startOffset":2018042210000, "endOffset":2018042210001, "buildType":"BUILD", "files":["/sample/path/file1", "/sample/path/file5"]}'
  ```

- 响应示例

  ```json
  {
      "code":"000",
      "data":{
          "uuid":"2624277d-5e34-4022-aa75-25c70a31474f",
          "last_modified":1533790808154,
          "version":"3.0.0.1",
          "name":"BUILD CUBE - file_test - 2018042211000_2018042211001 - GMT+08:00 2018-08-09 13:00:08",
          "type":"BUILD",
          "duration":0,
          "related_cube":"file_test",
          "display_cube_name":"file_test",
          "related_segment":"fa739a23-ee90-4dd1-8055-6bf24c6908e9",
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



### 刷新维度表快照   {#刷新维度表快照}

刷新当前 Cube 下所有 Segment 的维度表快照数据。

> **注意**：仅支持 SCD 1 类型的维表刷新。

- `PUT http://host:port/kylin/api/cubes/{cubeName}/refresh_lookup`
- URL Parameters

  - `cubeName` - `必选` `string`，Cube 名称
- HTTP Header
  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en` 

- HTTP Body: JSON Object
  - `project` - `必选` `string`， 要刷新 Cube 的项目名。
  - `lookupTable` - `必选` `string`，要刷新的维表名称，格式 DATABASE.TABLE。

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://localhost:host/kylin/api/cubes/kylin_sales_cube/refresh_lookup' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -H 'cache-control: no-cache' \
    -d '{"project":"learn_kylin", "lookupTable":"DEFAULT.KYLIN_CAL_DT"}'
  ```

- 响应示例

  ```json
    {
      "code": "000",
      "data": {
          "uuid": "261d09cd-6919-4cd4-a636-7ba43fe3b59c",
          "last_modified": 1558682047156,
          "version": "3.4.0.0",
          "name": "REFRESH SNAPSHOT - {tableName}-GMT+08:00 2019-05-24 15:14:07",
          "type": "BUILD",
          "duration": 0,
          "related_cube": "{cubeName}",
          "display_cube_name": "{cubeName}",
          "project_name": "{projectName}",
          "related_segment": null,
          "exec_start_time": 0,
          "exec_end_time": 0,
          "exec_interrupt_time": 0,
          "mr_waiting": 0,
          "steps": [...],
          "submitter": "ADMIN",
          "job_status": "PENDING",
          "is_broken": false,
          "progress": 0
      },
      "msg": ""
    }
  ```

