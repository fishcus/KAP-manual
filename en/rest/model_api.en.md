## Model REST API

> **Tip**
>
> Before using API, make sure that you read the previous chapter of [Access and Authentication](authentication.en.md), and know how to add authentication information in API.
>
> If there exists `&` in your request path, please enclose the URL in quotation marks `""` or add a backslash ahead  `\&`  to avoid being escaped.


* [List Model](#list-model)
* [GET ModelDesc](#model desc)
* [Clone Model](#clone-model)
* [Drop Model](#drop-model)
* [Get Computed Columns](#get-computed-columns)

### List Model
`Request Mode: GET`

`Access Path: http://host:port/kylin/api/models`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Request Body
* pageOffset - `optional` `int`, default 0, get data start subscript.
* pageSize - `optional` `int `, default 10, how many lines would be included in each returned page.
* modelName - `optional` `string`, returned name is the keyword related model.
* exactMatch - `optional` `boolean`, default true, specify whether matching exactly with modelName.
* projectName - `optional` `string`, specify the returned project.

#### Request Example
`Request Path: "http://host:port/kylin/api/models?projectName=test&pageSize=10&pageOffset=0"`

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json"  "http://host:port/kylin/api/models?projectName=test&pageSize=10&pageOffset=0"
```

#### Response Example
```sh
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

### Model Desc

 More info about fact table and lookup table desc
`request mode GET`

`Access path http://host:port/kylin/api/model_desc/{projectName}/{modelName}`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### Path Variables

- projectName - `required` `string` project name
- modelName -  `required ` `string`  model name

#### Request Example

`Request Path: http://host:port/kylin/api/model_desc/your_project/your_model`

#### Response Example

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

#### Curl Request Example

```
curl -H "Authorization: Basic XXXXXXXXX" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' http://host:port/kylin/api/model_desc/your_project/your_model
```



### Clone Model
`Request Mode: PUT`

`Access Path: http://host:port/kylin/api/models/{modelName}/clone`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* modelName - `required` `string`, the name of the cloned model.

#### Request Body
* modelName - `required` `string`, new models' name.
* project - `required` `string`, new projects' name. 

#### Request Example
`request path: http://host:port/kylin/api/models/m2/clone`

#### Curl Request Example
```
curl -X PUT -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json"  http://host:port/kylin/api/models/m2/clone
```

#### Response Example
```sh
 {
    "code": "000",
    "data": {
        "modelDescData": "{\n  \"uuid\" : \"60f4e30e-f50f-4abf-8ad2-4f34233aae21\",\n  \"last_modified\" : 1509010496630,\n  \"version\" : \"3.0.0.1\",\n  \"name\" : \"m2\",\n  \"owner\" : \"ADMIN\",\n  \"is_draft\" : false,\n  \"description\" : \"\",\n  \"fact_table\" : \"DEFAULT.TEST_KYLIN_FACT\",\n  \"lookups\" : [ ],\n  \"dimensions\" : [ {\n    \"table\" : \"TEST_KYLIN_FACT\",\n    \"columns\" : [ \"TRANS_ID\", \"ORDER_ID\", \"CAL_DT\", \"LSTG_FORMAT_NAME\", \"LEAF_CATEG_ID\", \"LSTG_SITE_ID\", \"SLR_SEGMENT_CD\", \"SELLER_ID\", \"TEST_COUNT_DISTINCT_BITMAP\" ]\n  } ],\n  \"metrics\" : [ \"TEST_KYLIN_FACT.PRICE\", \"TEST_KYLIN_FACT.ITEM_COUNT\" ],\n  \"filter_condition\" : \"\",\n  \"partition_desc\" : {\n    \"partition_date_column\" : \"TEST_KYLIN_FACT.CAL_DT\",\n    \"partition_time_column\" : null,\n    \"partition_date_start\" : 0,\n    \"partition_date_format\" : \"yyyy-MM-dd\",\n    \"partition_time_format\" : \"\",\n    \"partition_type\" : \"APPEND\",\n    \"partition_condition_builder\" : \"io.kyligence.kap.cube.mp.MPSqlCondBuilder\"\n  },\n  \"capacity\" : \"MEDIUM\",\n  \"multilevel_partition_cols\" : [ \"TEST_KYLIN_FACT.LSTG_FORMAT_NAME\" ],\n  \"computed_columns\" : [ ]\n}",
        "uuid": "60f4e30e-f50f-4abf-8ad2-4f34233aae21"
    },
    "msg": ""
}
```

### Drop Model 
`Request Mode: DELETE`

`Access Path: http://host:port/kylin/api/models/{projectName}/{modelName}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* projectName - `required` `string`, project name.
* modelName - `required` `string`, data models' name.

#### Request Example
`Request path: http://host:port/kylin/api/models/learn_kylin/m2`

#### Curl Request Example
```
curl -X DELETE -H "Authorization: Basic xxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/models/learn_kylin/m2
```

### Get Computed Columns
`Request Mode：GET`

`Access Path：http://host:port/kylin/api/models/computed_column_usage/{projectName}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* projectName - `required` `string` project name.

#### Request Example
`request path: http://host:port/kylin/api/models/computed_column_usage/your_project_name`

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic xxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/models/computed_column_usage/your_project_name
```
#### Response Example
```json
 {
    "code": "000",
    "data": {"test_model":["cc_name"]},
    "msg": ""
}
```