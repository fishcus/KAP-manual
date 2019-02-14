## Query API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Query the Cube](#Query-the-Cube)
* [List all tables that can be queried](#List-all-tables-that-can-be-queried)



### Query the Cube {#Query-the-Cube}

- `POST http://host:port/kylin/api/query`

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `sql` - `required` `string`, SQL statement
  - `offset` - `optional` `int`, offset of query result
  - `limit` - `optional` `int`, limit on the quantity of returned query result
  - `project` - `optional` `string`, project name, `DEFAULT` by default

- Curl Request Example

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/query' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{ "sql":"select count(*) from KYLIN_SALES", "project":"learn_kylin" }'
  ```

- Response Example

  ```json
  {
      "code":"000",
      "data":{
          "columnMetas":[...],
          "results":[...],
          "cube":"CUBE[name=kylin_sales_cube]",
          "affectedRowCount":0,
          "isException":false,
          "exceptionMessage":null,
          "queryId":"1ba7490f-8344-41ee-beb7-35e772a0630b",
          "duration":467,
          "totalScanCount":731,
          "totalScanBytes":731,
          "hitExceptionCache":false,
          "storageCacheUsed":false,
          "traceUrl":null,
          "server":"sandbox.hortonworks.com:7070",
          "suiteId":null,
          "lateDecodeEnabled":false,
          "partial":false,
          "sparderUsed":false,
          "timeout":false,
          "pushDown":false
      },
      "msg":""
  }
  ```

- Response Information
  - `columnMetas` - metadata information of the columns
  - `results` - query results
  - `cube` - query realization name
  - `isException` - whether the query returns exception
  - `exceptionMessage` - exception message
  - `queryId` - Query ID
  - `duration` - query duration
  - `totalScanCount` - total scan count
  - `totalScanBytes` - total scan bytes
  - `hitExceptionCache` - whether hit the result cache of an exception query
  - `storageCacheUsed` - whether hit the result cache of a success query
  - `server` - which server executed this query
  - `sparderUsed` - whether Sparder engine is used
  - `timeout` - whether query is timeout
  - `pushDown` - whether query push down to other engine



### List all tables that can be queried {#List-all-tables-that-can-be-queried}

- `GET http://host:port/kylin/api/tables_and_columns`

- URL Parameters 	

  - `project` - `required` `string`, project name

- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: en`
	- `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/tables_and_columns?project=learn_kylin' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```json
  {
      "code":"000",
      "data":[
          {
              "columns":[...],
              "type":[...],
              "type_NAME":null,
              "self_REFERENCING_COL_NAME":null,
              "ref_GENERATION":null,
              "table_SCHEM":"DEFAULT",
              "table_NAME":"KYLIN_ACCOUNT",
              "table_CAT":"defaultCatalog",
              "table_TYPE":"TABLE",
              "remarks":null,
              "type_CAT":null,
              "type_SCHEM":null
          },{...},
      ],
      "msg":""
  }
  ```
