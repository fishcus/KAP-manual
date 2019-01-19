## Model API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Get Model List](#Get-Model-List)
* [Get Model Description](#Get-Model-Description)
* [Clone a Model](#Clone-a-Model)
* [Delete a Model](#Delete-a-Model)
* [Get all Computed Columns in a project](#Get-all-Computed-Columns-in-a-project)



### Get Model Description List {#Get-Model-List}

- `GET http://host:port/kylin/api/models`

- URL Parameters
  - `pageOffset` - `optional` `int`, offset of returned result, 0 by default
  - `pageSize` - `optional` `int`, quantity of returned result per page, 10 by default
  - `modelName` - `optional` `string`, model name
  - `exactMatch` - `optional` `boolean`, whether exactly match the model name,  `true` by default
  - `projectName` - `optional` `string`,  project name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/models?pageOffset=1' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```JSON
  {
      "code":"000",
      "data":{
          "models":[...],
          "size":12
      },
      "msg":""
  }
  ```



### Get Model Description by Project Name and Model Name {#Get-Model-Description}

- `GET http://host:port/kylin/api/models/{projectName}/{modelName}`

- URL Parameters
  - `projectName` - `required` `string`, project name
  - `modelName` - `required` `string`, model name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/models/learn_kylin/kylin_sales_model' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```JSON
  {
      "code":"000",
      "data":{
          "model":{
              "uuid":"0928468a-9fab-4185-9a14-6f2e7c74823f",
              "last_modified":1536287374944,
              "version":"3.0.0.1",
              "name":"kylin_sales_model",
              "owner":null,
              "is_draft":false,
              "description":"",
              "fact_table":"DEFAULT.KYLIN_SALES",
              "lookups":[...],
              "dimensions":[...],
              "metrics":[...],
              "filter_condition":"",
              "partition_desc":{...},
              "capacity":"MEDIUM",
              "multilevel_partition_cols":[...],
              "computed_columns":[...],
              "smart_model":false,
              "smart_model_sqls":[...],
              "project":"learn_kylin"
          }
      },
      "msg":""
  }
  ```



### Clone a Model {#Clone-a-Model}

- `PUT http://host:port/kylin/api/models/{modelName}/clone`

- URL Parameters

  - `modelName` - `required` `string`, model name of being cloned

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `modelName` - `required` `string`, name of the new model
  - `project` - `required` `string`, project name 

- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/models/kylin_sales_model/clone' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{"modelName":"learn_kylin_model_clone2","project":"learn_kylin"}'
  ```

- Response Example

  ```JSON
  {
      "code":"000",
      "data":{
          "modelDescData":"...",
          "uuid":"2a4fe755-5810-4e41-aa9e-ecb3114b1e0b"
      },
      "msg":""
  }
  ```



### Delete a Model {#Delete-a-Model}

- `DELETE http://host:port/kylin/api/models/{projectName}/{modelName}`

- URL Parameters
  - `projectName` - `required` `string`,  project name
  - `modelName` - `required` `string`, model name
  
- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X DELETE \
    'http://host:port/kylin/api/models/learn_kylin/kylin_sales_model_clone' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```



### Get all Computed Columns in a project {#Get-all-Computed-Columns-in-a-project}

- `GET http://host:port/kylin/api/models/computed_column_usage/{projectName}`

- URL Parameters  

  - `projectName` - `required` `string` project name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/models/computed_column_usage/learn_kylin' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```JSON
  {
      "code": "000",
      "data": {
          "THIS_IS_A_COMPUTED_COLUMN": [
              "kylin_sales_model"
          ]
      },
      "msg": ""
  }
  ```
