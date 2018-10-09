## 数据源 API


> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [加载 Hive 表](#加载 Hive 表)
* [返回多个 Hive 表](#返回多个 Hive 表)
* [返回 Hive 表信息](#返回 Hive 表信息)



### 加载 Hive 表

- `POST http://host:port/kylin/api/tables/load`


- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`


- HTTP Body
    * `project` - `必选` `string` ，指定 Hive 表将要加载到哪个项目
    * `tables` - `必选` `string[]` ，指定想要加载的 Hive 表

**Curl 请求示例**

```shell
curl -X POST \
  'http://host:port/kylin/api/tables/load' \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8' \
  -d '{
	"project":"learn_kylin",
	"tables":["KYLIN_SALES","KYLIN_CAL_DT"]
}'
```

**响应示例**

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



### 返回多个 Hive 表

- `GET http://host:port/kylin/api/tables`

- URL Parameters
    * `project` - `必选` `string` ， 项目名
    * `ext` - `可选` `boolean` ，是否返回表的扩展信息

- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`

**Curl 请求示例**

```shell
curl -X GET \
  'http://host:port/kylin/api/tables?project=learn_kylin' \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8'
```

**响应示例**

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




### 返回 Hive 表信息

- `GET http://host:port/kylin/api/tables/{project}/{tableName}`

- URL Parameters
    * `project` - `可选` `string` ， 项目名称
    * `tableName` - `可选` `string` ， 表名称

- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`

**Curl 请求示例**

```shell
curl -X GET \
  'http://host:port/kylin/api/tables/learn_kylin/kylin_sales' \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8'
```

**响应示例**

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
