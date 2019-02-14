## 查看 Cube 信息 API

> **提示：**
>
> 1. 请确保已阅读前面的[访问及安全认证](../authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [返回多个 Cube](#返回多个Cube)
* [返回指定 Cube](#返回指定Cube)
* [返回 Cube 描述信息](#返回Cube描述信息)



### 返回多个 Cube     {#返回多个Cube}

- `GET http://host:port/kylin/api/cubes`

- URL Parameters
  - `pageOffset` - `可选` `int`，返回数据起始下标，默认为 0
  - `pageSize` - `可选` `int `，分页返回对应每页返回多少，默认为10
  - `cubeName` - `可选` `string`， Cube 名称
  - `exactMatch` - `可选` `boolean`，是否根据 Cube 名称完全匹配，默认为 `true`
  - `modelName` - `可选` `string`，返回对应模型名称等于该关键字的 Cube
  - `projectName` - `可选` `string`，项目名称
  - `sortBy` - `可选` `string`，指定排序字段，默认为 `update_time`
  - `reverse` - `可选` `boolean`，是否倒序，默认为 `true`

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/cubes?pageSize=10&modelName=kylin_sales_model' \
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
          "size":3,
          "cubes":[...]
      },
      "msg":""
  }
  
  ```



### 返回指定 Cube    {#返回指定Cube}

- `GET http://host:port/kylin/api/cubes`

- URL Parameters

  - `cubeName` - `必选` `string`，Cube 名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/cubes?cubeName=kylin_sales_cube' \
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
          "size":1,
          "cubes":[...]
      },
      "msg":""
  }
  ```



### 返回 Cube 描述信息   {#返回Cube描述信息}

- `GET http://host:port/kylin/api/cube_desc/{projectName}/{cubeName}`

- URL Parameters
  - `projectName` - `必选` `string`，项目名称
  - `cubeName` - `必选` `string `， Cube 名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/cube_desc/learn_kylin/kylin_sales_cube' \
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
