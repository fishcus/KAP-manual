## Cube REST API

> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 如果您的访问路径中含有 `&` 符号时，请在访问路径两端加上引号`""` 或者添加反斜杠 `\` 对 `&` 进行转义。


* [返回多个 Cube](#返回多个 Cube)
* [返回指定 Cube](#返回指定 Cube)
* [返回 Cube 描述信息](#返回 Cube 描述信息)
* [构建 Cube - 日期分区](#构建 Cube - 日期分区)
* [构建 Cube - 无分区](#构建 Cube - 无分区)
* [构建 Cube - 批量构建](#构建 Cube - 批量构建)
* [克隆 Cube](#克隆 Cube)
* [启用 Cube](#启用 Cube)
* [禁用 Cube](#禁用 Cube)
* [清理 Cube](#清理 Cube)
* [管理 Segment](#管理 Segment)
* [导出 TDS](#导出 TDS)



### 返回多个 Cube

- `GET http://host:port/kylin/api/cubes`

- URL Parameter
  * `pageOffset` - `可选` `int` 返回数据起始下标，默认为0
  * `pageSize` - `可选` `int ` 分页返回对应每页返回多少，默认10
  * `cubeName` - `可选` `string` 返回名称等于该关键字的 Cube
  * `exactMatch` - `可选` `boolean` 是否根据 cubeName 完全匹配，默认 `true`
  * `modelName` - `可选` `string` 返回对应模型名称等于该关键字的 Cube
  * `projectName` - `可选` `string` 指定返回该项目下 Cube
  * `sortBy` - `可选` `string` 指定排序字段，默认为 `update_time`
  * `reverse` - `可选` `boolean` 是否倒序，默认 `true`


- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`


#### cURL 请求示例

```
curl -X GET \
  'http://host:port/kylin/api/cubes?pageSize=10&modelName=kylin_sales_model' \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8'
```

#### 响应示例

```JSON
{
    "code":"000",
    "data":{
        "size":3,
        "cubes":[...]
    },
    "msg":""
}

```



### 返回指定 Cube

- `GET http://host:port/kylin/api/cubes`


- URL Parameter
  - `cubeName` - `必选` `string` 返回名称等于该关键字的 Cube


- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`


#### cURL 请求示例

```
curl -X GET \
  'http://host:port/kylin/api/cubes?cubeName=kylin_sales_cube' \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8'
```

#### 响应示例
```JSON
{
    "code":"000",
    "data":{
        "size":1,
        "cubes":[...]
    },
    "msg":""
}
```



### 返回 Cube 描述信息

- `GET http://host:port/kylin/api/cube_desc/{projectName}/{cubeName}`


- URL Parameter
	* `projectName` - `必选` `string` 项目名称
	* `cubeName` - `必选` `string` Cube 名称


- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`


#### cURL 请求示例

```
curl -X GET \
  http://host:port/kylin/api/cube_desc/learn_kylin/kylin_sales_cube \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8'
```

#### 响应示例

```JSON
{
    "code":"000",
    "data":{
        "cube":{
            "uuid":"0ef9b7a8-3929-4dff-b59d-2100aadc8dbf",
            "last_modified":1534836872000,
            "version":"3.0.0.1",
            "name":"kylin_sales_cube",
            "is_draft":false,
            "model_name":"kylin_sales_model",
            "description":"",
            "null_string":null,
            "dimensions":[...],
            "measures":[...],
            "rowkey":{...},
            "hbase_mapping":{...},
            "aggregation_groups":[...],
            "signature":null,
            "notify_list":[...],
            "status_need_notify":[...],
            "partition_date_start":1325376000000,
            "partition_date_end":3153600000000,
            "auto_merge_time_ranges":[

            ],
            "volatile_range":0,
            "retention_range":0,
            "engine_type":100,
            "storage_type":100,
            "override_kylin_properties":{...},
            "cuboid_black_list":[...],
            "parent_forward":3,
            "mandatory_dimension_set_list":[...]
        }
    },
    "msg":""
}
```



### 构建 Cube - 日期分区

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build`


- URL Parameter
	* `cubeName` - `必选` `string` Cube 名称


- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`


- HTTP Body
	* `startTime` - `必选` `long` 要计算的数据对应起始时间的时间戳，应为 GMT 格式的时间戳，可使用 https://www.epochconverter.com/ 网页进行转换，如`1388534400000`对应`2014-01-01 00:00:00`
	* `endTime` - `必选` `long` 要计算的数据对应终止时间的时间戳，应为 GMT 格式的时间戳
	* `buildType` - `必选` `string` 支持的计算类型: 'BUILD'
	* `mpValues` - `可选` `string` 对应模型的多级分区字段值


#### cURL 请求示例

```
curl -X PUT \
  http://host:port/kylin/api/cubes/kylin_sales_cube/segments/build \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Content-Type: application/json;charset=utf-8' \
  -d '{
	"startTime": 0,
	"endTime": 1388534400000,
	"buildType": "BUILD"
}'
```

#### 响应示例

```JSON
{
    "code":"000",
    "data":{
        "uuid":"83c6cd7a-61ce-4d66-9bd3-fea35487dcf7",
        "last_modified":1536289966183,
        "version":"3.0.0.1",
        "name":"BUILD CUBE - kylin_sales_cube - 20120415114212_20140101000000 - GMT+08:00 2018-09-07 11:12:45",
        "type":"BUILD",
        "duration":0,
        "related_cube":"kylin_sales_cube",
        "display_cube_name":"kylin_sales_cube",
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



### 构建 Cube - 全量构建

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build`


- HTTP Header
	- `Content-Type: application/vnd.apache.kylin-v2+json;charset=UTF-8`
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`


- URL Parameter
	* `cubeName` - `必选` `string` Cube 名称


- HTTP Body
	* `startTime` - `必选` `long` , 0
	* `endTime` - `必选` `long`, 0
	* `buildType` - `必选` `string`, 支持的计算类型: 'BUILD'


#### cURL 请求示例

```
curl -X PUT \
  http://host:port/kylin/api/cubes/{cubeName}/segments/build \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8' \
  -d '{
	"startTime": 0,
	"endTime": 0,
	"buildType": "BUILD"
}'
```

#### 响应示例

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



### 构建 Cube - 批量构建

- `PUT http://host:port/kylin/api/cubes/{cubeName}/batch_sync`


- URL Parameter
	* `cubeName` - `必选` `string` Cube 名称


- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`


- HTTP Body
	* `pointList` - `可选` `string` 对应模型的分区的字段值
	* `rangeList` - `可选` `string` 对应模型的分区的字段值
	* `mpValues` - `可选` `string` 对应模型的分区的字段值


#### cURL 请求示例

```
curl -X PUT \
  http://host:port/kylin/api/cubes/{cubeName}/batch_sync \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8' \
  -d '[{"mpValues": "300","pointList": ["1","2","3","4","5","6","7","8","9","10"],"rangeList": [["50","70"],["90","110"]]},{"mpValues": "301","pointList": ["1","2","3","4","5","6","7","8","9","10"],"rangeList": [["20","30"],["30","40"]]}]'
```

#### 响应示例

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



### 克隆Cube

- `PUT http://host:port/kylin/api/cubes/{cubeName}/clone`


- URL Parameter
	* `cubeName` - `必选` `string` 被克隆Cube名称


- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`


- HTTP Body
    * `cubeName` - `必选` `string` 新Cube名称
    * `project` - `必选` `string` 新项目名称 


#### cURL 请求示例

```
curl -X PUT \
  http://host:port/kylin/api/cubes/kylin_sales_cube/clone \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8' \
  -d '{"cubeName":"kylin_sales_cube_clone",
"project":"learn_kylin"}'
```


#### 响应示例

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



### 启用Cube

- `PUT http://host:port/kylin/api/cubes/{cubeName}/enable`


- URL Parameter
	- `cubeName` - `必选` `string` Cube 名称


- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`


#### cURL 请求示例

```
curl -X PUT \
  http://host:port/kylin/api/cubes/kylin_sales_cube/enable \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8'
```


#### 响应示例

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



### 禁用 Cube

- `PUT http://host:port/kylin/api/cubes/{cubeName}/disable`


- URL Parameter
	- `cubeName` - `必选` `string` Cube 名称


- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`


#### cURL 请求示例

```
curl -X PUT \
  http://host:port/kylin/api/cubes/kylin_sales_cube/disable \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8'
```


#### 响应示例

```
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



### 清理Cube

- `PUT http://host:port/kylin/api/cubes/{cubeName}/purge`


- URL Parameter
	- `cubeName` - `必选` `string` Cube 名称


- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`

- HTTP Body
	* `mpValues` - `可选` `string` 模型多级分区值
	* `project` - `必选`


#### cURL 请求示例

```
curl -X PUT \
  http://host:port/kylin/api/cubes/{cubeName}/purge \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8' \
  -d '{"mpValues": "", "project": "learn_kylin"}'
```


#### 响应示例

```
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



### 管理Segment

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments`


- URL Parameter
	- `cubeName` - `必选` `string` Cube 名称

- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`


- HTTP Body
    * `buildType`  -  `必选` `string` "MERGE", "REFRESH", "DROP"
    * `segments`  -  `必选` `string` Segment 名字 数组
    * `mpValues`  -  `可选` `string` 模型的多级分区值
    * `force`  -  `可选` `boolean` 是否强制进行操作，"true" 或 "false"


#### cURL 请求示例

```
curl -X PUT \
  http://host:port/kylin/api/cubes/kylin_sales_cube/segments \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8' \
  -d '{"buildType":"REFRESH",
"segments":["20180908000000,20180909000000"],
"mpValues":"",
"force":true
}'
```


#### 响应示例

```JSON
{
    "code": "000",
    "data": [],
    "msg": ""
}
```



### 导出TDS

- `GET http://host:port/kylin/api/cubes/{cubeName}/export/tds`


- URL Parameter
	- `cubeName` - `必选` `string` Cube 名称


- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`


#### cURL 请求示例

```
curl -X GET \
  http://10.1.2.99:7070/kylin/api/cubes/kylin_sales_cube/export/tds \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8'
```
