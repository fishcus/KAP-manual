## 模型 REST API

> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 如果您的访问路径中含有 `&` 符号时，请在访问路径两端加上引号`""` 或者添加反斜杠 `\` 对 `&` 进行转义。

* [返回模型](#返回模型)
* [返回模型描述信息](#返回模型描述信息)
* [克隆模型](#克隆模型)
* [删除模型](#删除模型)
* [获取项目下所有可计算列](#获取项目下所有可计算列)

### 返回模型
- `GET http://host:port/kylin/api/models`

- URL Parameter
	* `pageOffset` - `可选` `int` 默认0 返回数据起始下标
	* `pageSize` - `可选` `int ` 默认10 每页返回多少
	* `modelName` - `可选` `string` 模型名
	* `exactMatch` - `可选` `boolean` 是否对 `modelName` 完全匹配，默认`true`
	* `projectName` - `可选` `string` 项目名

- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`

#### cURL 访问示例

```
curl -X GET \
  'http://host:port/kylin/api/models?pageOffset=1' \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8'
```

#### 响应示例

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

### 返回模型描述信息

- `GET http://host:port/kylin/api/model_desc/{projectName}/{modelName}`

- URL Parameter
	- `projectName` - `必选` `string` 项目名
	- `modelName` - `必选` `string` 模型名

- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`

#### cURL 访问示例

```
curl -X GET \
  http://host:port/kylin/api/model_desc/learn_kylin/kylin_sales_model \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8'
```


#### 响应示例

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


### 克隆模型
- `PUT http://host:port/kylin/api/models/{modelName}/clone`

- URL Parameter
	* `modelName` - `必选` `string` 被克隆模型名称

- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`

- HTTP Body
	* `modelName` - `必选` `string` 克隆后的模型名称
	* `project` - `必选` `string` 项目名称 

#### cURL 访问示例

```
curl -X PUT \
  http://host:port/kylin/api/models/kylin_sales_model/clone \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8' \
  -d '{"modelName":"learn_kylin_model_clone2","project":"learn_kylin"}'
```

#### 响应示例

```JSON
{
    "code":"000",
    "data":{
        "modelDescData":"{{
    "uuid":"2a4fe755-5810-4e41-aa9e-ecb3114b1e0b",
    "last_modified":1536546593858,
    "version":"3.0.0.1",
    "name":"learn_kylin_model_clone2",
    "owner":"ADMIN",
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
    "smart_model_sqls":[...]
},
        "uuid":"2a4fe755-5810-4e41-aa9e-ecb3114b1e0b"
    },
    "msg":""
}
```

### 删除模型

- `DELETE http://host:port/kylin/api/models/{projectName}/{modelName}`

- URL Parameter	
	* `projectName` - `必选` `string` 项目名称
	* `modelName` - `必选` `string` 数据模型名称
	
- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`

#### cURL 请求示例

```
curl -X DELETE \
  http://host:port/kylin/api/models/learn_kylin/kylin_sales_model_clone \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/vnd.apache.kylin-v2+json;charset=UTF-8'
```

### 获取项目下所有可计算列

- `GET http://host:port/kylin/api/models/computed_column_usage/{projectName}`

- URL Parameter	
	* `projectName` - `必选` `string` 项目名称

- HTTP Header
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`

#### cURL 访问示例

```
curl -X GET \
  http://host:port/kylin/api/models/computed_column_usage/learn_kylin \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8'
```

#### 响应示例

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