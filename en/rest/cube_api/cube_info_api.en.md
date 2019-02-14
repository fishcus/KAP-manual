## Cube Information API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](../authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Get Cube List](#get-cube-list)
* [Get Specific Cube](#get-specific-cube)
* [Get Cube Description](#get-cube-description)



### Get Cube List    {#get-cube-list}

- `GET http://host:port/kylin/api/cubes`

- URL Parameters
  - `pageOffset` - `optional` `int`, offset of returned result, 0 by default
  - `pageSize` - `optional` `int`, quantity of returned result per page, 10 by default
  - `cubeName` - `optional` `string`,  cube name
  - `exactMatch` - `optional` `boolean`, whether matchs cube name exactly, `true` by default
  - `modelName` - `optional` `string`, corresponding model name
  - `projectName` - `optional` `string`, project name
  - `sortBy` - `optional` `string`, sort field,  `update_time` by default
  - `reverse` - `optional` `boolean`, whether sort reversely,  `true` by default

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/cubes?pageSize=10&modelName=kylin_sales_model' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

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



### Get Specific Cube   {#get-specific-cube}

- `GET http://host:port/kylin/api/cubes`

- URL Parameters
  - `cubeName` - `required` `string`, cube name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/cubes?cubeName=kylin_sales_cube' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

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



### Get Cube Description  {#get-cube-description}

- `GET http://host:port/kylin/api/cube_desc/{projectName}/{cubeName}`

- URL Parameters
  - `projectName` - `required` `string`, project name
  - `cubeName` - `required` `string `,  cube name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/cube_desc/learn_kylin/kylin_sales_cube' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

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


