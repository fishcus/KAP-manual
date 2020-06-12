## 异步查询 API


> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [提交查询](#提交查询)
* [返回查询状态](#返回查询状态)
* [返回查询的元数据信息](#返回查询的元数据信息)
* [返回查询结果文件大小](#返回查询结果文件大小)
* [下载查询结果](#下载查询结果)
* [返回查询的 HDFS 路径](#返回查询的HDFS路径)
* [删除所有查询结果文件](#删除所有查询结果文件)



### 提交查询

- `POST http://host:port/kylin/api/async_query`

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `sql` - `必选` `string`，查询语句
  - `separator` - `可选` `string`，导出结果的分隔符，默认为 ","
  - `offset` - `可选` `int`，查询结果的偏移量
  - `limit` - `可选` `int `，从偏移量开始返回对应的行数，不足 limit 以实际行数为准
  - `project` - `必选` `string`，项目名，默认为 "DEFAULT"


- Curl 请求示例

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/async_query' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{ "sql":"select * from KYLIN_SALES limit 100", "project":"learn_kylin" }'
  ```


- 响应示例

  ```json
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

- 响应信息

  - `queryID` - 异步查询的 Query ID
  - `status` - 提交的状态，分为："FAILED" 和 "RUNNING"
  - `info` - 提交状态的详细信息



### 返回查询状态

- `GET http://host:port/kylin/api/async_query/{queryID}/status`

- URL Parameters

  - `queryID` - `必选` `string`，异步查询的 Query ID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/async_query/{queryID}/status' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- 响应示例

  ```json
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

- 响应信息
  - `queryID` - 异步查询的 Query ID
  - `status` - 查询状态，该状态分为："SUCCESSFUL" （成功），"RUNNING"（仍在运行中），"FAILED" (失败) 和 "MISSING" (查询不到此查询)， 
  - `info` - 查询状态的详细信息



### 返回查询的元数据信息

- `GET http://host:port/kylin/api/async_query/{queryID}/metadata`

- URL Parameters
  - `queryID` - `必选` `string`，异步查询的 Query ID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/async_query/{queryID}/metadata' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- 响应示例

  ```json
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

- 响应信息

  - `data` - data 中包含两个 list，其中第一个 list 为列名，第二个 list 为列对应的数据类型



### 返回查询结果文件大小

- `GET http://host:port/kylin/api/async_query/{queryID}/filestatus`


- URL Parameters
  - `queryID` - `必选` `string`，异步查询的 Query ID


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/async_query/{queryID}/filestatus' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- 响应示例

  ```json
  {
      "code": "000",
      "data": 7611,
      "msg": ""
  }
  ```

- 响应信息

  - `data` - 保存结果的总大小



### 下载查询结果

> 提示：请确认查询状态为 SUCCESSFUL 之后再调用此接口

- `GET http://host:port/kylin/api/async_query/{queryID}/result_download`?includeHeader=true


- URL Parameters
  - `queryID` - `必选` `string`，异步查询的 Query ID
  - `includeHeader` - `可选` `boolean`，下载结果是否包含表头，默认为 false


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例


  ```sh
  curl -X GET \
    'http://host:port/kylin/api/async_query/{queryID}/result_download?includeHeader=true' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -o result.csv
  ```

- 响应示例
	- 返回一个名为 `result.csv` 的文件



### 返回查询的 HDFS 路径 {#返回查询的HDFS路径}

- `GET http://host:port/kylin/api/async_query/{queryID}/result_path`


- URL Parameters
  - `queryID` - `必选` `string`，异步查询的 Query ID


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/async_query/{queryID}/result_path' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- 响应示例

  ```json
  {
      "code": "000",
      "data": "hdfs://host:8020/{kylin_working_dir}/{kylin_metadata_url}/learn_kylin/async_query_result/eb3e837f-d826-4670-aac7-2b92fcd0c8fe",
      "msg": ""
  }
  ```

- 响应信息

  - `data` -  该查询的 HDFS 保存路径



### 删除所有查询结果文件

> 提示：该接口可能会删除还没有获取到结果的查询。

- `DELETE http://host:port/kylin/api/async_query`

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X DELETE \
    'http://host:port/kylin/api/async_query' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- 响应示例

  ```json
  {
      "code": "000",
      "data": true,
      "msg": ""
  }
  ```
