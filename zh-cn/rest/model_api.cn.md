## 模型 REST API

> **提示**
>
> 使用 API 前请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，知道如何在 API 中添加认证信息。
>
> 当您的访问路径中含有 `&` 符号时，请在 URL 两端加上引号`""` 或者添加反斜杠来避免转义 `\&`。


* [返回模型](#返回模型)
* [返回模型描述信息](#返回模型描述信息)
* [克隆模型](#克隆模型)
* [删除模型](#删除数据模型)

### 返回模型
`请求方式：GET`

`访问路径：http://host:port/kylin/api/models`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### 请求主体
* pageOffset - `可选` `int` 默认0 返回数据起始下标
* pageSize`可选` `int ` 默认10 分页返回对应每页返回多少
* modelName - `可选` `string` 返回名称等于该关键字的Model
* exactMatch - `可选` `boolean` 默认true 是否对modelName完全匹配
* projectName - `可选` `string` 指定返回该项目下

#### 请求示例
`请求路径: "http://host:port/kylin/api/models?projectName=test&pageSize=10&pageOffset=0"`

#### Curl 访问示例
```
curl -X GET -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json"  "http://host:port/kylin/api/models?projectName=test&pageSize=10&pageOffset=0"
```

#### 响应示例
```json
{
    "code": "000",
    "data": {
        "models": [
            {
                "uuid": "63c20e51-c580-49dd-b1dc-7bec621c7b03",
                "last_modified": 1509006427481,
                "version": "3.0.0.1",
                "name": "m1",
                "owner": "ADMIN",
                "is_draft": false,
                "description": "",
                "fact_table": "DEFAULT.TEST_KYLIN_FACT",
                "lookups": [],
                "dimensions": [
                    {
                        "table": "TEST_KYLIN_FACT",
                        "columns": [
                            "TRANS_ID",
                            "ORDER_ID",
                            "CAL_DT",
                            "LSTG_FORMAT_NAME",
                            "LEAF_CATEG_ID",
                            "LSTG_SITE_ID",
                            "SLR_SEGMENT_CD",
                            "SELLER_ID",
                            "TEST_COUNT_DISTINCT_BITMAP"
                        ]
                    }
                ],
                "metrics": [
                    "TEST_KYLIN_FACT.PRICE",
                    "TEST_KYLIN_FACT.ITEM_COUNT"
                ],
                "filter_condition": "",
                "partition_desc": {
                    "partition_date_column": "TEST_KYLIN_FACT.CAL_DT",
                    "partition_time_column": null,
                    "partition_date_start": 0,
                    "partition_date_format": "yyyy-MM-dd",
                    "partition_time_format": "",
                    "partition_type": "APPEND",
                    "partition_condition_builder": "io.kyligence.kap.cube.mp.MPSqlCondBuilder"
                },
                "capacity": "MEDIUM",
                "multilevel_partition_cols": [
                    "TEST_KYLIN_FACT.LSTG_FORMAT_NAME"
                ],
                "computed_columns": [],
                "smart_model": false,
                "smart_model_sqls": [],
                "project": "default"
            }
        ],
        "size": 1
    },
    "msg": ""
}
```

### 返回模型描述信息

 事实表及维度表等信息
`请求方式 GET`

`访问路径 http://host:port/kylin/api/model_desc/{projectName}/{modelName}`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量

- projectName - `必选` `string` 返回该项目下的model. 
- modelName - `必选` `string` 数据模型名称.

#### 请求示例

`请求路径: http://host:port/kylin/api/model_desc/your_project/your_model`

#### 响应示例

```sh
{
    "code": "000",
    "data": {
        "model": {
            "uuid": "72ab4ee2-2cdb-4b07-b39e-4c298563ae27",
            "last_modified": 1507691058000,
            "version": "3.0.0.1",
            "name": "ci_inner_join_model",
            "owner": null,
            "is_draft": false,
            "description": null,
            "fact_table": "DEFAULT.TEST_KYLIN_FACT",
            "lookups": [
                {
                    "table": "DEFAULT.TEST_ORDER",
                    "kind": "FACT",
                    "alias": "TEST_ORDER",
                    "join": {
                        "type": "INNER",
                        "primary_key": [
                            "TEST_ORDER.ORDER_ID"
                        ],
                        "foreign_key": [
                            "TEST_KYLIN_FACT.ORDER_ID"
                        ]
                    }
                }
            ],
            "dimensions": [
                {
                    "table": "TEST_KYLIN_FACT",
                    "columns": [
                        "TRANS_ID",
                        "ORDER_ID",
                        "CAL_DT",
                        "LSTG_FORMAT_NAME",
                        "LSTG_SITE_ID",
                        "LEAF_CATEG_ID",
                        "SLR_SEGMENT_CD",
                        "SELLER_ID",
                        "TEST_COUNT_DISTINCT_BITMAP",
                        "DEAL_YEAR",
                        "SELLER_COUNTRY_ABBR",
                        "BUYER_COUNTRY_ABBR",
                        "SELLER_ID_AND_COUNTRY_NAME",
                        "BUYER_ID_AND_COUNTRY_NAME"
                    ]
                }            
            ],
            "metrics": [
                "TEST_KYLIN_FACT.PRICE",
                "TEST_KYLIN_FACT.ITEM_COUNT",
                "TEST_KYLIN_FACT.DEAL_AMOUNT"
            ],
            "filter_condition": null,
            "partition_desc": {
                "partition_date_column": "TEST_KYLIN_FACT.CAL_DT",
                "partition_time_column": null,
                "partition_date_start": 0,
                "partition_date_format": "yyyy-MM-dd",
                "partition_time_format": "HH:mm:ss",
                "partition_type": "APPEND",
                "partition_condition_builder": "org.apache.kylin.metadata.model.PartitionDesc$DefaultPartitionConditionBuilder"
            },
            "capacity": "MEDIUM",
            "multilevel_partition_cols": [],
            "computed_columns": [
                {
                    "tableIdentity": "DEFAULT.TEST_KYLIN_FACT",
                    "tableAlias": "TEST_KYLIN_FACT",
                    "columnName": "DEAL_AMOUNT",
                    "expression": "TEST_KYLIN_FACT.PRICE * TEST_KYLIN_FACT.ITEM_COUNT",
                    "datatype": "decimal",
                    "comment": "deal amount of inner join model (with legacy expression format)"
                },
                {
                    "tableIdentity": "DEFAULT.TEST_KYLIN_FACT",
                    "tableAlias": "TEST_KYLIN_FACT",
                    "columnName": "DEAL_YEAR",
                    "expression": "year(TEST_KYLIN_FACT.CAL_DT)",
                    "datatype": "integer",
                    "comment": "the year of the deal"
                },
                {
                    "tableIdentity": "DEFAULT.TEST_KYLIN_FACT",
                    "tableAlias": "TEST_KYLIN_FACT",
                    "columnName": "BUYER_ID_AND_COUNTRY_NAME",
                    "expression": "CONCAT(BUYER_ACCOUNT.ACCOUNT_ID, BUYER_COUNTRY.NAME)",
                    "datatype": "string",
                    "comment": "synthetically concat buyer's account id and buyer country"
                },
                {
                    "tableIdentity": "DEFAULT.TEST_KYLIN_FACT",
                    "tableAlias": "TEST_KYLIN_FACT",
                    "columnName": "SELLER_ID_AND_COUNTRY_NAME",
                    "expression": "CONCAT(SELLER_ACCOUNT.ACCOUNT_ID, SELLER_COUNTRY.NAME)",
                    "datatype": "string",
                    "comment": "synthetically concat seller's account id and seller country"
                },
                {
                    "tableIdentity": "DEFAULT.TEST_KYLIN_FACT",
                    "tableAlias": "TEST_KYLIN_FACT",
                    "columnName": "BUYER_COUNTRY_ABBR",
                    "expression": "SUBSTR(BUYER_ACCOUNT.ACCOUNT_COUNTRY,0,1)",
                    "datatype": "string",
                    "comment": "first char of country of buyer account"
                },
                {
                    "tableIdentity": "DEFAULT.TEST_KYLIN_FACT",
                    "tableAlias": "TEST_KYLIN_FACT",
                    "columnName": "SELLER_COUNTRY_ABBR",
                    "expression": "SUBSTR(SELLER_ACCOUNT.ACCOUNT_COUNTRY,0,1)",
                    "datatype": "string",
                    "comment": "first char of country of seller account"
                }
            ],
            "smart_model": false,
            "smart_model_sqls": [],
            "project": "default"
        }
    },
    "msg": ""
}
```

#### Curl 访问示例

```
curl -H "Authorization: Basic XXXXXXXXX" -H "Accept: application/vnd.apache.kylin-v2+json"  -H "Content-Type:application/vnd.apache.kylin-v2+json"  http://host:port/kylin/api/model_desc/your_project/your_model
```



### 克隆模型
`请求方式：PUT`

`访问路径：http://host:port/kylin/api/models/{modelName}/clone`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### 路径变量
* modelName - `必选` `string` 被克隆模型名称.

#### 请求主体
* modelName - `必选` `string` 新模型名称.
* project - `必选` `string` 新项目名称 

#### 请求示例
`请求路径: http://host:port/kylin/api/models/m2/clone`

#### Curl 访问示例
```
curl -X PUT -H "Authorization: Basic xxxxxx" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json"  http://host:port/kylin/api/models/m2/clone
```

#### 响应示例
```json
 {
    "code": "000",
    "data": {
        "modelDescData": "{\n  \"uuid\" : \"60f4e30e-f50f-4abf-8ad2-4f34233aae21\",\n  \"last_modified\" : 1509010496630,\n  \"version\" : \"3.0.0.1\",\n  \"name\" : \"m2\",\n  \"owner\" : \"ADMIN\",\n  \"is_draft\" : false,\n  \"description\" : \"\",\n  \"fact_table\" : \"DEFAULT.TEST_KYLIN_FACT\",\n  \"lookups\" : [ ],\n  \"dimensions\" : [ {\n    \"table\" : \"TEST_KYLIN_FACT\",\n    \"columns\" : [ \"TRANS_ID\", \"ORDER_ID\", \"CAL_DT\", \"LSTG_FORMAT_NAME\", \"LEAF_CATEG_ID\", \"LSTG_SITE_ID\", \"SLR_SEGMENT_CD\", \"SELLER_ID\", \"TEST_COUNT_DISTINCT_BITMAP\" ]\n  } ],\n  \"metrics\" : [ \"TEST_KYLIN_FACT.PRICE\", \"TEST_KYLIN_FACT.ITEM_COUNT\" ],\n  \"filter_condition\" : \"\",\n  \"partition_desc\" : {\n    \"partition_date_column\" : \"TEST_KYLIN_FACT.CAL_DT\",\n    \"partition_time_column\" : null,\n    \"partition_date_start\" : 0,\n    \"partition_date_format\" : \"yyyy-MM-dd\",\n    \"partition_time_format\" : \"\",\n    \"partition_type\" : \"APPEND\",\n    \"partition_condition_builder\" : \"io.kyligence.kap.cube.mp.MPSqlCondBuilder\"\n  },\n  \"capacity\" : \"MEDIUM\",\n  \"multilevel_partition_cols\" : [ \"TEST_KYLIN_FACT.LSTG_FORMAT_NAME\" ],\n  \"computed_columns\" : [ ]\n}",
        "uuid": "60f4e30e-f50f-4abf-8ad2-4f34233aae21"
    },
    "msg": ""
}
```

### 删除数据模型
`请求方式：DELETE`

`访问路径：http://host:port/kylin/api/models/{projectName}/{modelName}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### 路径变量
* projectName - `必选` `string` 项目名称.
* modelName - `必选` `string` 数据模型名称.

#### 请求示例
`请求路径: http://host:port/kylin/api/models/learn_kylin/m2`

#### Curl 访问示例
```
curl -X DELETE -H "Authorization: Basic xxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/models/learn_kylin/m2
```

### 获取项目下所有可计算列
`请求方式：GET`

`访问路径：http://host:port/kylin/api/models/computed_column_usage/{projectName}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### 路径变量
* projectName - `必选` `string` 项目名称.

#### 请求示例
`请求路径: http://host:port/kylin/api/models/computed_column_usage/your_project_name`

#### Curl 访问示例
```
curl -X GET -H "Authorization: Basic xxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/models/computed_column_usage/your_project_name
```
#### 响应示例
```json
 {
    "code": "000",
    "data": {"test_model":["cc_name"]},
    "msg": ""
}
```