## 管理 Cube API

> **提示：**
>
> 1. 请确保已阅读前面的[访问及安全认证](../authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [克隆 Cube](#克隆Cube)
* [启用 Cube](#启用Cube)
* [禁用 Cube](#禁用Cube)
* [清理 Cube](#清理Cube)
* [管理 Segment](#管理Segment)
* [列出 Cube 中的空洞](#列出Cube中的空洞)
* [填充 Cube 中的空洞](#填充Cube中的空洞)
* [导出 TDS](#导出TDS)



### 克隆 Cube  {#克隆Cube}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/clone`

- URL Parameters

  - `cubeName` - `必选` `string`， 被克隆的 Cube 名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `cubeName` - `必选` `string`，克隆后的 Cube 名称
  - `project` - `必选` `string`，克隆后的项目名称 

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/clone' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{"cubeName":"kylin_sales_cube_clone",
  "project":"learn_kylin"}'
  ```


- 响应示例

  ```JSON
  {
      "code": "000",
      "data": {
          "uuid": "88670f47-1ce1-48fb-acf5-3aac63b04ccd",
          "last_modified": 1536563756734,
          "version": "3.0.0.1",
          "name": "kylin_sales_cube_clone",
          "owner": "ADMIN",
          "descriptor": "kylin_sales_cube_clone",
          "display_name": null,
          "cost": 786,
          "status": "DISABLED",
          "segments": [],
          "create_time_utc": 1536563756859,
          "cuboid_bytes": null,
          "cuboid_bytes_recommend": null,
          "cuboid_last_optimized": 0,
          "project": "learn_kylin",
          "model": "kylin_sales_model",
          "is_streaming": false,
          "partitionDateColumn": "KYLIN_SALES.PART_DT",
          "partitionDateStart": 1325376000000,
          "isStandardPartitioned": true,
          "size_kb": 0,
          "input_records_count": 0,
          "input_records_size": 0,
          "is_draft": false,
          "multilevel_partition_cols": [],
          "total_storage_size_kb": 0
      },
      "msg": ""
  }
  ```



### 启用 Cube   {#启用Cube}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/enable`

- URL Parameters

  - `cubeName` - `必选` `string`，Cube 名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/enable' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- 响应示例

  ```JSON
  {
      "code":"000",
      "data":{
          "uuid":"f2d467cb-db42-4b53-bb6f-74b35f19b793",
          "last_modified":1535686103823,
          "version":"3.0.0.1",
          "name":"kylin_sales_cube",
          "owner":"ADMIN",
          "descriptor":"kylin_sales_cube",
          "display_name":null,
          "cost":24,
          "status":"READY",
          "segments":[...],
          "create_time_utc":1535685965861,
          "cuboid_bytes":null,
          "cuboid_bytes_recommend":null,
          "cuboid_last_optimized":0,
          "project":"learn_kylin",
          "model":"KYLIN_SALES_MODEL",
          "is_streaming":false,
          "partitionDateColumn":null,
          "partitionDateStart":0,
          "isStandardPartitioned":false,
          "size_kb":5,
          "input_records_count":24,
          "input_records_size":540,
          "is_draft":false,
          "multilevel_partition_cols":[...],
          "total_storage_size_kb":5
      },
      "msg":""
  }
  ```



### 禁用 Cube  {#禁用Cube}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/disable`

- URL Parameters

  - `cubeName` - `必选` `string`，Cube 名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/disable' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- 响应示例

  ```JSON
  {
      "code":"000",
      "data":{
          "uuid":"f2d467cb-db42-4b53-bb6f-74b35f19b793",
          "last_modified":1535686103823,
          "version":"3.0.0.1",
          "name":"kylin_sales_cube",
          "owner":"ADMIN",
          "descriptor":"kylin_sales_cube",
          "display_name":null,
          "cost":24,
          "status":"DISABLED",
          "segments":[...],
          "create_time_utc":1535685965861,
          "cuboid_bytes":null,
          "cuboid_bytes_recommend":null,
          "cuboid_last_optimized":0,
          "project":"learn_kylin",
          "model":"KYLIN_SALES_MODEL",
          "is_streaming":false,
          "partitionDateColumn":null,
          "partitionDateStart":0,
          "isStandardPartitioned":false,
          "size_kb":5,
          "input_records_count":24,
          "input_records_size":540,
          "is_draft":false,
          "multilevel_partition_cols":[...],
          "total_storage_size_kb":5
      },
      "msg":""
  }
  ```



### 清理 Cube   {#清理Cube}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/purge`

- URL Parameters

  - `cubeName` - `必选` `string`， Cube 名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `mpValues` - `可选` `string`，模型多级分区值
  - `project` - `必选` `string`，项目名称

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/{cubeName}/purge' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{"mpValues": "", "project": "learn_kylin"}'
  ```


- 响应示例

  ```JSON
  {
      "code":"000",
      "data":{
          "uuid":"f2d467cb-db42-4b53-bb6f-74b35f19b793",
          "last_modified":1535686103823,
          "version":"3.0.0.1",
          "name":"{cubeName}",
          "owner":"ADMIN",
          "descriptor":"{cubeName}",
          "display_name":null,
          "cost":24,
          "status":"DISABLED",
          "segments":[...],
          "create_time_utc":1535685965861,
          "cuboid_bytes":null,
          "cuboid_bytes_recommend":null,
          "cuboid_last_optimized":0,
          "project":"learn_kylin",
          "model":"{modelName}",
          "is_streaming":false,
          "partitionDateColumn":null,
          "partitionDateStart":0,
          "isStandardPartitioned":false,
          "size_kb":0,
          "input_records_count":0,
          "input_records_size":0,
          "is_draft":false,
          "multilevel_partition_cols":[...],
          "total_storage_size_kb":0
      },
      "msg":""
  }
  ```



### 管理 Segment   {#管理Segment}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments`


- URL Parameters

  - `cubeName` - `必选` `string`，Cube 名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `buildType`  -  `必选` `string`，操作类型，为 "MERGE", "REFRESH" 或 "DROP"
  - `segments`  -  `必选` `string[]`，Segment 名称
  - `mpValues`  -  `可选` `string`， 模型的多级分区值
  - `force`  -  `可选` `boolean`，是否强制进行操作，为 "true" 或 "false"

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
  "mpValues":"",
  "force":true
  }'
  ```


- 响应示例

  ```JSON
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



### 列出 Segment 中的空洞  {#列出Segment中的空洞}

> 提示：健康的 Cube 不应存在 Segment 中的空洞

- `GET http://host:port/kylin/api/cubes/{cubeName}/holes`

- URL Parameters
  - `cubeName` - `必选` `string`, Cube 名称
  - `mpValues` - `可选` `string`, 多级分区值（只对于多级分区的 Cube 有效）

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/holes ' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- 响应示例

  ```JSON
  {
      "data": [{
      "code": "000",
          "uuid": null,
          "name": "20091110000000_20100110000000",
          "storage_location_identifier": null,
          "date_range_start": 1257811200000,
          "date_range_end": 1263081600000,
          "source_offset_start": 0,
          "source_offset_end": 0,
          "status": null,
          "size_kb": 0,
          "input_records": 0,
          "input_records_size": 0,
          "last_build_time": 0,
          "last_build_job_id": null,
          "create_time_utc": 0,
          "cuboid_shard_nums": {},
          "total_shards": 0,
          "blackout_cuboids": [],
          "binary_signature": null,
          "dictionaries": null,
          "global_dictionaries": null,
          "snapshots": null,
          "rowkey_stats": [],
          "project_dictionaries": {},
          "col_length_info": {}
      }],
      "msg": ""
  }
  ```



### 列出 Cube 中的空洞  {#列出Cube中的空洞}

> **提示：** 生产系统上健康的 Cube 不应存在空洞，意味着 Cube 中的 Segment 应该在分区列上是连续的。

- `GET http://host:port/kylin/api/cubes/{cubeName}/holes`

- URL Parameters
  - `cubeName` - `必选` `string`, Cube 名称
  - `mpValues` - `可选` `string`, 多级分区值（只对于多级分区的 Cube 有效）

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/holes ' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- 响应示例

  ```JSON
  {
      "data": [{
      "code": "000",
          "uuid": null,
          "name": "20091110000000_20100110000000",
          "storage_location_identifier": null,
          "date_range_start": 1257811200000,
          "date_range_end": 1263081600000,
          "source_offset_start": 0,
          "source_offset_end": 0,
          "status": null,
          "size_kb": 0,
          "input_records": 0,
          "input_records_size": 0,
          "last_build_time": 0,
          "last_build_job_id": null,
          "create_time_utc": 0,
          "cuboid_shard_nums": {},
          "total_shards": 0,
          "blackout_cuboids": [],
          "binary_signature": null,
          "dictionaries": null,
          "global_dictionaries": null,
          "snapshots": null,
          "rowkey_stats": [],
          "project_dictionaries": {},
          "col_length_info": {}
      }],
      "msg": ""
  }
  ```



### 填充 Cube 中的空洞  {#填充Cube中的空洞}

> **提示:** 对于基于非流式数据源构建的 Cube, 系统将根据空洞的范围正常提交构建任务; 对于基于流式数据源构建的 Cube, 请确保补洞前, 流式数据源中的数据没有过期或删除, 否侧填充空洞构建任务将会失败。

- `PUT http://host:port/kylin/api/cubes/{cubeName}/holes`

- URL Parameters
  - `cubeName` - `必选` `string`, Cube 名称
  - `mpValues` - `可选` `string`, 多级分区值（只对于多级分区的 Cube 有效）

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/holes ' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```



### 导出 TDS   {#导出TDS}

- `GET http://host:port/kylin/api/cubes/{cubeName}/export/tds`

- URL Parameters

  - `cubeName` - `必选` `string`， Cube 名称
  - `windowUrl` - `可选` `string`，使用浏览器打开 Kyligence Enterprise 的 URL 前缀，如 `http://localhost:7070/kylin`，默认值为空
  - `containTableIndex` - `可选` `boolean`，是否包含 table index 的列，默认值为 `false`


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/export/tds' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```



