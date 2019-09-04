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

  ```json
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

  ```json
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

  ```json
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
  - `project` - `必选` `string`，项目名称
  - `mpValues` - `可选` `string`，模型多级分区值，用于指定单个待清理的分区
  - `mpValuesSet` - `可选` `数组`, 模型多级分区值的数组，用于指定多个待清理的分区

> 注意：`mpValues`和`mpValuesSet`两个参数只需设置一个。如果两个参数同时设置，生效的待清理分区是两个参数值的全集。

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/{cubeName}/purge' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{"mpValues": "", "project": "learn_kylin", "mpValuesSet": ["value1", "value2"...]}'
  ```


- 响应示例

  ```json
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

  ```json
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
  - `windowUrl` - `必选` `string`，使用浏览器打开 Kyligence Enterprise 的 URL 前缀，如 `http://localhost:7070/kylin`
  - `containTableIndex` - `可选` `boolean`，是否包含 table index 的列，默认值为 `false`


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X GET \
    'http://localhost:7070/kylin/api/cubes/kylin_sales_cube/export/tds?windowUrl=http%3a%2f%2flocalhost%3a7070%2fkylin' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```



