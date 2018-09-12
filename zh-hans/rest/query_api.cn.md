## 查询 API

> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 如果您的访问路径中含有 `&` 符号时，请在访问路径两端加上引号`""` 或者添加反斜杠 `\` 对 `&` 进行转义。

* [查询 Cube 数据](#查询 Cube 数据)
* [列出可查询的表](#列出可查询的表)




### 查询 Cube 数据
- `POST http://host:port/kylin/api/query`

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: cn|en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body
  * `sql` - `必选` `string` 查询的 SQL 语句
  * `offset` - `可选` `int` 查询默认从第一行返回结果，可以通过该参数设置查询从哪一行开始往后返回数据
  * `limit` - `可选` `int` 加上 `limit` 参数后会从 `offset` 开始返回对应的行数，不足 `limit` 以实际行数为准
  * `project` - `可选` `string` 默认为 `DEFAULT`

#### cURL 请求示例

```
curl -X POST \
  http://host:port/kylin/api/query \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8' \
  -d '{ "sql":"select count(*) from KYLIN_SALES", "project":"learn_kylin" }'
	
```

#### 响应示例

```JSON
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

- 响应信息
	* `columnMetas` - 每个列的元数据信息
	* `results` - 返回的结果集
	* `cube` - 这个查询使用的 CUBE
	* `affectedRowCount` - 这个查询关系到的总行数
	* `isException` - 这个查询返回是否是异常
	* `exceptionMessage` - 返回异常对应的内容
	* `totalScanCount` - 总记录数
	* `totalScanBytes` - 总字节数
	* `hitExceptionCache` - 是否来自执行失败的结果缓存
	* `storageCacheUsed` - 是否来自执行成功的结果缓存
	* `duration` - 查询消耗时间
	* `partial` - 查询结果是否为部分返回，这个取决于请求参数中的 `acceptPartial`
	* `pushDown` - 是否启用查询下压




### 列出可查询的表

- `GET http://host:port/kylin/api/tables_and_columns`

- URL Parameter 	
	* `project` - `必选` `string` 项目名

- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`

#### cURL 请求示例

```
curl -X GET \
  'http://host:port/kylin/api/tables_and_columns?project=learn_kylin' \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8'
```

#### 响应示例

```JSON
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
