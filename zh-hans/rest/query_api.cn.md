## 查询 API

> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [查询 Cube 数据](#查询Cube数据)
* [列出可查询的表](#列出可查询的表)
* [导出查询结果](#导出查询结果)



### 查询 Cube 数据   {#查询Cube数据}

- `POST http://host:port/kylin/api/query`

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `sql` - `必选` `string`，查询的 SQL 语句
  - `offset` - `可选` `int`， 设置查询从哪一行开始往后返回数据
  - `limit` - `可选` `int`，设置从 `offset` 开始返回的行数，不足 `limit` 以实际行数为准
  - `project` - `可选` `string`，项目名称，默认为 `DEFAULT`

- Curl 请求示例

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/query' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{ "sql":"select count(*) from KYLIN_SALES", "project":"learn_kylin" }'
  ```

- 响应示例

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
        "queryId":"26f5cbe0-7dbd-4c07-aaf2-831a86016eb5",
        "duration":2403,
        "totalScanCount":0,
        "totalScanBytes":0,
        "hitExceptionCache":false,
        "storageCacheUsed":false,
        "traceUrl":null,
        "server":"sandbox.hortonworks.com:7070",
        "suiteId":null,
        "timeout":false,
        "lateDecodeEnabled":false,
        "pushDown":false,
        "sparderUsed":true
    },
    "msg":""
}
  ```

- 响应信息
  - `columnMetas` - 每个列的元数据信息
  - `results` - 返回的结果集
  - `cube` - 使用的查询引擎
  - `isException` - 这个查询返回是否是异常
  - `exceptionMessage` - 返回异常对应的内容
  - `queryId` - 查询 ID
  - `duration` - 查询耗时
  - `totalScanCount` - 总扫描行数
  - `totalScanBytes` - 总扫描字节数
  - `hitExceptionCache` - 是否来自执行失败的结果缓存
  - `storageCacheUsed` - 是否来自执行成功的结果缓存
  - `server` - 在启用了负载平衡的环境中，执行查询的服务器
  - `timeout` - 查询是否超时
  - `pushDown` - 查询是否下压到其他引擎
  - `sparderUsed` - 是否使用了 Sparder 查询引擎



### 列出可查询的表

- `GET http://host:port/kylin/api/tables_and_columns`

- URL Parameters 	
  
  - `project` - `必选` `string`，项目名称
  
- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/tables_and_columns?project=learn_kylin' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- 响应示例

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



### 导出查询结果

- `POST http://host:port/kylin/api/query/format/{format}`

- URL Parameters

  - `format` - `必选` `string`，导出文件类型，目前仅支持 `csv` 格式文件

- HTTP Header

  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object

  - `sql` - `必选` `string`，查询的 SQL 语句
  - `project` - `必选` `string`，项目名称
  - `offset` - `可选` `int`， 设置查询从哪一行开始往后返回数据
  - `limit` - `可选` `int`，设置从 `offset` 开始返回的行数，实际行数小于该参数时，以实际行数为准

- Curl 请求示例

  ```sh
  curl -X POST \
  	'http://host:port/kylin/api/query/format/csv' \
  	-H 'Accept: application/vnd.apache.kylin-v2+json' \
  	-H 'Accept-Language: en' \
  	-H 'Authorization: Basic QURNSU46S1lMSU4=' \
  	-H 'Content-Type: application/json;charset=utf-8' \
  	-d '{ "sql":"select * from KYLIN_ACCOUNT", "project":"learn_kylin" }' \
  	-O -J
  ```

- 响应示例

  ```sh
  %  Total % Received % Xferd Average Speed  Time  Time   Time   Current
                              Dload  Upload  Total Spent  Left   Speed
  100 277 100  161   100  116  712    513 --:--:-- --:--:-- --:--:--1282
  curl: Saved to filename '20190718102045980.result.csv'
  ```