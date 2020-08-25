## 模型 API

> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。


* [创建模型](#创建模型)
* [返回模型列表](#返回模型列表)
* [返回模型描述信息](#返回模型描述信息)
* [克隆模型](#克隆模型)
* [删除模型](#删除模型)
* [获取项目下所有可计算列](#获取项目下所有可计算列)


### 创建模型
- `PUT http://host:port/kylin/api/models`

- HTTP Header
    - `Accept: application/vnd.apache.kylin-v2+json`
    - `Accept-Language: en`
    - `Content-Type: application/json;charset=utf-8`
    
- HTTP Body: JSON Object
  - `modelDescData` - `必选` `string` ，模型的描述信息（JSON Object string）
    - `uuid` - `非必选` `string` ，唯一识别码，默认随机生成
    - `owner` - `非必选` `string`，模型拥有者，默认为当前用户
    - `name` - `必选` `string`，模型名字	
    - `description` - `非必选` `string`，模型额外描述
    - `last_modified` - `非必选` `long`，最后修改时间（创建 Model 时需要设为 0，Model 已经存在时需要设为上次修改时间）
    - `capacity` - `非必选` `string`，模型容量（SMALL,MEDIUM,LARGE）默认为：MEDIUM 
    - `lookups` - `非必选` `JSON Object[]`，维表相关信息
      - `table` - `必选` `string`，表名
	  - `kind` - `非必选` `string`，表类型（FACT,LOOKUP）默认为：LOOKUP
	  - `alias` - `非必选` `string`，别名
	  - `scd` - `非必选` `string`，缓慢变化维度处理方法类型（SCD_TYPE_1,SCD_TYPE_2）默认为：SCD_TYPE_2
	  - `join` - `必选` `JSON Object`，连接信息
	    - `type` - `必选` `string`，连接类型（inner,left）无默认值
	    - `primary_key` - `必选` `string[]`，主键
	    - `foreign_key` - `必选` `string[]`，外键
	- `partition_desc` - `非必选` `JSON Object`，分区描述信息
	  - `partition_date_column` - `非必选` `string`，日期分区字段名
	  - `partition_time_column` - `非必选` `string`，时间分区字段名
	  - `partition_date_format` - `非必选` `string`，日期分区格式，默认为：yyyy-MM-dd
	  - `partition_time_format` - `非必选` `string`，时间分区格式，默认为：HH:mm:ss
	  - `partition_type` - `非必选` `string`，分区类型（FULL_BUILD,TIME, STREAMING,CUSTOMIZED,FILE），默认为：FULL_BUILD。
	  - `partition_condition_builder` - `非必选` `string`，分区构建类全类名，默认为：org.apache.kylin.metadata.model.DefaultPartitionConditionBuilder
	- `dimensions` - `必选` `JSON Object[]`，维度信息
	  - `table` - `必选` `string`，表名
	  - `columns` - `必选` `string[]`，字段名
	- `metrics` - `必选` `string[]`，度量字段名
	- `multilevel_partition_cols` - `非必选` `string[]`，多分区字段名
	- `is_draft` - `非必选` `boolean`，是否是草稿，默认为：false
	- `filter_condition` - `非必选` `string`，过滤条件
	- `smart_model` - `非必选` `boolean`，是否为智能建模，默认为：false
	- `smart_model_sqls` - `非必选` `string[]`，智能建模 SQL 语句
	- `computed_columns` - `非必选` `JSON Object`，可计算列描述信息
	  - `tableIdentity` - `必选` `string`，表名
	  - `tableAlias` - `非必选` `string`，表别名
	  - `columnName` - `必选` `string`，字段名
	  - `expression` - `必选` `string`，表达式
	  - `datatype` - `必选` `string`，数据类型（varchar,int,long...standard sql types）
	- `fact_table` - `必选` `string`，事实表名
  - `project` - `必选` `string`，项目名称
    
- Curl 请求示例    
```
curl -X PUT \
'http://host:port/kylin/api/models' \
 -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8' \
//该示例为了展示直观，将 JSON Object String 展开，使用时需要进行压缩并转义
  -d '"modelDescData":"{
    "capacity":"MEDIUM",
    "owner":"ADMIN",
    "lookups":[
        {
            "table":"DEFAULT.KYLIN_ACCOUNT",
            "kind":"LOOKUP",
            "alias":"KYLIN_ACCOUNT",
            "scd":"SCD_TYPE_2",
            "join":{
                "type":"inner",
                "primary_key":[
                    "KYLIN_ACCOUNT.ACCOUNT_ID"
                ],
                "foreign_key":[
                    "KYLIN_SALES.BUYER_ID"
                ]
            }
        },
        {
            "table":"DEFAULT.KYLIN_COUNTRY",
            "kind":"LOOKUP",
            "alias":"KYLIN_COUNTRY",
            "scd":"SCD_TYPE_2",
            "join":{
                "type":"inner",
                "primary_key":[
                    "KYLIN_COUNTRY.COUNTRY"
                ],
                "foreign_key":[
                    "KYLIN_ACCOUNT.ACCOUNT_COUNTRY"
                ]
            }
        }
    ],
    "partition_desc":{
        "partition_date_column":"KYLIN_SALES.PART_DT",
        "partition_time_column":"",
        "partition_date_start":0,
        "partition_date_format":"yyyyMMdd",
        "partition_time_format":"",
        "partition_type":"TIME"
    },
    "dimensions":[
        {
            "table":"KYLIN_SALES",
            "columns":[
                "REAL_PRICE",
                "PART_DT",
                "SELLER_ID",
                "BUYER_ID"
            ]
        },
        {
            "table":"KYLIN_ACCOUNT",
            "columns":[
                "ACCOUNT_ID",
                "ACCOUNT_COUNTRY"
            ]
        },
        {
            "table":"KYLIN_COUNTRY",
            "columns":[
                "COUNTRY",
                "NAME"
            ]
        }
    ],
    "metrics":[
        "KYLIN_SALES.PRICE",
        "KYLIN_SALES.ITEM_COUNT"
    ],
    "is_draft":true,
    "last_modified":0,
    "filter_condition":"id>10",
    "name":"test_model",
    "smart_model":false,
    "smart_model_sqls":[

    ],
    "description":"",
    "computed_columns":[
        {
            "tableIdentity":"DEFAULT.KYLIN_SALES",
            "tableAlias":"KYLIN_SALES",
            "columnName":"REAL_PRICE",
            "expression":"KYLIN_SALES.REAL_PRICE=KYLIN_SALES.PRICE+1",
            "datatype":"integer",
            "disabled":true
        }
    ],
    "fact_table":"DEFAULT.KYLIN_SALES"
}",
  "project": "test"'
```

- 响应示例

```
{
    "uuid":"78851a7e-4161-4a41-b634-eb2f917527a1",
    "last_modified":1597822458442,
    "version":"3.4.0.0",
    "name":"test_model",
    "owner":"ADMIN",
    "is_draft":false,
    "status":"",
    "description":"",
    "fact_table":"DEFAULT.KYLIN_SALES",
    "lookups":[
        {
            "table":"DEFAULT.KYLIN_ACCOUNT",
            "kind":"LOOKUP",
            "scd":"SCD_TYPE_2",
            "alias":"KYLIN_ACCOUNT",
            "join":{
                "type":"inner",
                "primary_key":[
                    "KYLIN_ACCOUNT.ACCOUNT_ID"
                ],
                "foreign_key":[
                    "KYLIN_SALES.BUYER_ID"
                ]
            }
        },
        {
            "table":"DEFAULT.KYLIN_COUNTRY",
            "kind":"LOOKUP",
            "scd":"SCD_TYPE_2",
            "alias":"KYLIN_COUNTRY",
            "join":{
                "type":"inner",
                "primary_key":[
                    "KYLIN_COUNTRY.COUNTRY"
                ],
                "foreign_key":[
                    "KYLIN_ACCOUNT.ACCOUNT_COUNTRY"
                ]
            }
        }
    ],
    "dimensions":[
        {
            "table":"KYLIN_SALES",
            "columns":[
                "REAL_PRICE",
                "PART_DT",
                "SELLER_ID",
                "BUYER_ID"
            ]
        },
        {
            "table":"KYLIN_ACCOUNT",
            "columns":[
                "ACCOUNT_ID",
                "ACCOUNT_COUNTRY"
            ]
        },
        {
            "table":"KYLIN_COUNTRY",
            "columns":[
                "COUNTRY",
                "NAME"
            ]
        }
    ],
    "metrics":[
        "KYLIN_SALES.PRICE",
        "KYLIN_SALES.ITEM_COUNT"
    ],
    "filter_condition":"id&gt;10",
    "partition_desc":{
        "partition_date_column":"KYLIN_SALES.PART_DT",
        "partition_time_column":"",
        "partition_date_start":0,
        "partition_date_format":"yyyyMMdd",
        "partition_time_format":"",
        "partition_type":"TIME",
        "partition_condition_builder":"org.apache.kylin.metadata.model.PartitionDesc$DefaultPartitionConditionBuilder",
        "partition_condition_builder_args":null
    },
    "capacity":"MEDIUM",
    "multilevel_partition_cols":[

    ],
    "computed_columns":[
        {
            "tableIdentity":"DEFAULT.KYLIN_SALES",
            "tableAlias":"KYLIN_SALES",
            "columnName":"REAL_PRICE",
            "expression":"KYLIN_SALES.REAL_PRICE=KYLIN_SALES.PRICE+1",
            "innerExpression":"((((((((((((((((((((KYLIN_SALES.REAL_PRICE=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1)=KYLIN_SALES.PRICE+1 ",
            "datatype":"integer",
            "comment":null
        }
    ],
    "smart_model":false,
    "smart_model_sqls":[

    ]
}
```

### 返回模型列表

- `GET http://host:port/kylin/api/models`

- URL Parameters
  - `pageOffset` - `可选` `int`，返回数据起始下标，默认为 0 
  - `pageSize` - `可选` `int `，每页返回多少，默认为 10 
  - `modelName` - `可选` `string`，模型名称
  - `exactMatch` - `可选` `boolean`，是否对模型名称进行完全匹配，默认为 `true`
  - `projectName` - `可选` `string`， 项目名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/models?pageOffset=0' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- 响应示例

  ```json
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

- `GET http://host:port/kylin/api/models/{projectName}/{modelName}`

- URL Parameters
  - `projectName` - `必选` `string`，项目名称
  - `modelName` - `必选` `string`，模型名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/models/learn_kylin/kylin_sales_model' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- 响应示例

  ```json
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

- URL Parameters
  - `modelName` - `必选` `string`，被克隆模型名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `modelName` - `必选` `string`，克隆后的模型名称
  - `project` - `必选` `string`，项目名称 

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/models/kylin_sales_model/clone' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{"modelName":"learn_kylin_model_clone2","project":"learn_kylin"}'
  ```

- 响应示例

  ```json
  {
      "code":"000",
      "data":{
          "modelDescData":"...",
          "uuid":"2a4fe755-5810-4e41-aa9e-ecb3114b1e0b"
      },
      "msg":""
  }
  ```



### 删除模型

- `DELETE http://host:port/kylin/api/models/{projectName}/{modelName}`

- URL Parameters	
  - `projectName` - `必选` `string`， 项目名称
  - `modelName` - `必选` `string`，模型名称
	
- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X DELETE \
    'http://host:port/kylin/api/models/learn_kylin/kylin_sales_model_clone' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```



### 获取项目下所有可计算列

- `GET http://host:port/kylin/api/models/computed_column_usage/{projectName}`

- URL Parameters	
  - `projectName` - `必选` `string` 项目名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/models/computed_column_usage/learn_kylin' \
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
          "THIS_IS_A_COMPUTED_COLUMN": [
              "kylin_sales_model"
          ]
      },
      "msg": ""
  }
  ```
