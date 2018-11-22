## Data Source API

> Reminder:
>
> 1. Please read [Access and Authentication REST API](authentication.en.md) and understand how authentication works.
>
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Load Hive Table](#Load-Hive-Table)
* [Get Multiple Hive Table](#Get-Multiple-Hive-Table)
* [Get Hive Table Information](#Get-Hive-Table-Information)



### Load Hive Table {#Load-Hive-Table}

- `POST http://host:port/kylin/api/tables/load`


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `project` - `required` `string`, specify which project will the Hive table be loaded to
  - `tables` - `required` `string[]`, specify the names of Hive tables which will be loaded


- Curl Request Example

  ```shell
  curl -X POST \
    'http://host:port/kylin/api/tables/load' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
  	"project":"learn_kylin",
  	"tables":["KYLIN_SALES","KYLIN_CAL_DT"]
  }'
  ```

- Response Example

  ```JSON
  {
      "code": "000",
      "data": {
          "result.loaded": [
              "DEFAULT.KYLIN_SALES",
              "DEFAULT.KYLIN_CAL_DT"
          ],
          "result.running": [],
          "result.unloaded": []
      },
      "msg": ""
  }
  ```



### Get Multiple Hive Table {#Get-Multiple-Hive-Table}

- `GET http://host:port/kylin/api/tables`


- URL Parameters
  - `project` - `required` `string`, project name
  - `ext` - `optional` `boolean`, specify whether the  table's extension information is returned


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```shell
  curl -X GET \
    'http://host:port/kylin/api/tables?project=learn_kylin' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```JSON
  {
      "code":"000",
      "data":[
          {
              "uuid":"57df01cd-bdad-45ee-85da-7996e8632ab8",
              "last_modified":1535362645000,
              "version":"2.3.0.20505",
              "name":"{tableName},
              "columns":[...],
              "source_type":0,
              "table_type":"MANAGED_TABLE",
              "database":"{databaseName}"
          },{...}
      ],
      "msg":""
  }
  ```




### Get Hive Table Information {#Get-Hive-Table-Information}

- `GET http://host:port/kylin/api/tables/{project}/{tableName}`


- URL Parameters
  - `project` - `optional` `string`, project name
  - `tableName` - `optional` `string`, table name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```shell
  curl -X GET \
    'http://host:port/kylin/api/tables/learn_kylin/kylin_sales' \
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
          "uuid":"e286e39e-40d7-44c2-8fa2-41b365522771",
          "last_modified":1533896217000,
          "version":"3.0.0.1",
          "name":"KYLIN_SALES",
          "columns":[...],
          "source_type":0,
          "table_type":"MANAGED_TABLE",
          "database":"DEFAULT"
      },
      "msg":""
  }
  ```
