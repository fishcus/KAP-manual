## Async Query API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Submit Async Query](#Submit-Async-Query)
* [Request Query Status](#Request-Query-Status)
* [Request Query Metadata Info](#Request-Query-Metadata-Info)
* [Request Query Result File Status](#Request-Query-Result-File-Status)
* [Download Query Result](#Download-Query-Result)
* [Request Query HDFS Path](#Request-Query-HDFS-Path)
* [Delete All Query Result Files](#Delete-All-Query-Result-Files)



### Submit Async Query   {#Submit-Async-Query}

- `POST http://host:port/kylin/api/async_query`

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `sql` - `required` `string`, SQL statement
  - `separator` - `optional` `string`, separator of the exported result, which is  "," by default
  - `offset` - `optional` `int`, offset of query result
  - `limit` - `optional` `int `, limit on the quantity of query result
  - `project` - `required` `string`, project name, "DEFAULT" by default


- Curl Request Example

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/async_query' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{ "sql":"select * from KYLIN_SALES limit 100", "project":"learn_kylin" }'
  ```


- Response Example

  ```JSON
  {
      "code": "000",
      "data": {
          "queryID": "eb3e837f-d826-4670-aac7-2b92fcd0c8fe",
          "status": "RUNNING",
          "info": "still running"
      },
      "msg": ""
  }
  ```

- Response Information

  - `queryID` -  Query ID of the Async Query
  - `status` - Status, ie.,  "FAILED", "RUNNING"
  - `info` - Detailed information about the status 



### Request Query Status   {#Request-Query-Status}

- `GET http://host:port/kylin/api/async_query/{queryID}/status`

- URL Parameters

  - `queryID` - `required` `string`, Query ID of the Async Query

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/async_query/{queryID}/status' \
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
          "queryID": "eb3e837f-d826-4670-aac7-2b92fcd0c8fe",
          "status": "SUCCESSFUL",
          "info": "await fetching results"
      },
      "msg": ""
  }
  ```

- Response Information
  - `queryID` - Query ID of the Async Query
  - `status` - Status, ie., "SUCCESSFUL" , "RUNNING", "FAILED" and "MISSING" 
  - `info` - Detailed information about the status



### Request Query Metadata Info {#Request-Query-Metadata-Info}

- `GET http://host:port/kylin/api/async_query/{queryID}/metadata`

- URL Parameters

  - `queryID` - `required` `string`,  Query ID of the Async Query

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/async_query/{queryID}/metadata' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- Response Example

  ```JSON
  {
      "code": "000",
      "data": [
          [
              "TRANS_ID",
              "PART_DT"
          ],
          [
              "BIGINT",
              "DATE"
          ]
      ],
      "msg": ""
  }
  ```

- Response Information

  - `data` - data includes two  list, the first list is the column name, and the second list is the corresponding data type of the column



### Request Query Result File Status {#Request-Query-Result-File-Status}

- `GET http://host:port/kylin/api/async_query/{queryID}/filestatus`


- URL Parameters
  - `queryID` - `required` `string`,  Query ID of the Async Query


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/async_query/{queryID}/filestatus' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```JSON
  {
      "code": "000",
      "data": 7611,
      "msg": ""
  }
  ```

- Response Information

  - `data` - total size of the result



### Download Query Result {#Download-Query-Result}

> Note: Please make sure the query status is "SUCCESSFUL" before calling this API.

- `GET http://host:port/kylin/api/async_query/{queryID}/result_download`


- URL Parameters
  - `queryID` - `required` `string`,  Query ID of the Async Query

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example


  ```sh
  curl -X GET \
    'http://host:port/kylin/api/async_query/{queryID}/result_download' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```
  
- Response Example
  - returns a document named `result.csv`.




### Request Query HDFS Path  {#Request-Query-HDFS-Path}

- `GET http://host:port/kylin/api/async_query/{queryID}/result_path`


- URL Parameters
  - `queryID` - `required` `string`,  Query ID of the Async Query


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/async_query/{queryID}/result_path' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- Response Example

  ```JSON
  {
      "code": "000",
      "data": "hdfs://host:8020/{kylin_working_dir}/{kylin_metadata_url}/learn_kylin/async_query_result/eb3e837f-d826-4670-aac7-2b92fcd0c8fe",
      "msg": ""
  }
  ```

- Response Information

  - `data` -  the HDFS Path in which stores the result file



### Delete All Query Result Files  {#Delete-All-Query-Result-Files}

- `DELETE http://host:port/kylin/api/async_query`


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X DELETE \
    'http://host:port/kylin/api/async_query' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```JSON
  {
      "code": "000",
      "data": true,
      "msg": ""
  }
  ```
