## Model API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Create a Model](#Create-a-Model)
* [Get Model List](#Get-Model-List)
* [Get Model Description](#Get-Model-Description)
* [Clone a Model](#Clone-a-Model)
* [Delete a Model](#Delete-a-Model)
* [Get all Computed Columns in a project](#Get-all-Computed-Columns-in-a-project)



### Get Model Description List {#Get-Model-List}

- `GET http://host:port/kylin/api/models`

- URL Parameters
  - `pageOffset` - `optional` `int`, offset of returned result, 0 by default
  - `pageSize` - `optional` `int`, quantity of returned result per page, 10 by default
  - `modelName` - `optional` `string`, model name
  - `exactMatch` - `optional` `boolean`, whether exactly match the model name,  `true` by default
  - `projectName` - `optional` `string`,  project name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/models?pageOffset=0' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

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



### Get Model Description by Project Name and Model Name {#Get-Model-Description}

- `GET http://host:port/kylin/api/models/{projectName}/{modelName}`

- URL Parameters
  - `projectName` - `required` `string`, project name
  - `modelName` - `required` `string`, model name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/models/learn_kylin/kylin_sales_model' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

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


### Create a Model {#Create-a-Model}

- `PUT http://host:port/kylin/api/models`

- HTTP Header
    - `Accept: application/vnd.apache.kylin-v2+json`
    - `Accept-Language: en`
    - `Content-Type: application/json;charset=utf-8`
    
- HTTP Body: JSON Object
  - `modelDescData` - `required` `string` ,The description information of the model(JSON Object string)
    - `uuid` - `unrequired` `string`,Unique identification code,Default value: random generation
    - `owner` - `unrequired` `string`,Model owner, Default value: current user
    - `name` - `required` `string`,Model name	
    - `description` - `unrequired` `string`,Model description
    - `last_modified` - `unrequired` `long`,Last modify time(When you create the model, you need to set it to 0,If the model already exists, it needs to be set to the last modification time)
    - `capacity` - `unrequired` `string`,Model capacity(SMALL,MEDIUM,LARGE),Default value: MEDIUM 
    - `lookups` - `unrequired` `JSON Object[]`,Dimension table information
      - `table` - `required` `string`,Table name
	  - `kind` - `unrequired` `string`,Table type(FACT,LOOKUP),Default value：LOOKUP
	  - `alias` - `unrequired` `string`,The alias
	  - `scd` - `unrequired` `string`,Slowly Changing Dimension processing method types(SCD_TYPE_1,SCD_TYPE_2)Default value：SCD_TYPE_2
	  - `join` - `required` `JSON Object`,Join information
	    - `type` - `required` `string`,Join type(inner,left),No default value
	    - `primary_key` - `required` `string[]`,Primary key
	    - `foreign_key` - `required` `string[]`,Foreign key
	- `partition_desc` - `unrequired` `JSON Object`,Partition description information
	  - `partition_date_column` - `unrequired` `string`,Date partition field name
	  - `partition_time_column` - `unrequired` `string`,Time partition field name
	  - `partition_date_format` - `unrequired` `string`,Date partition format,Default value: yyyy-MM-dd
	  - `partition_time_format` - `unrequired` `string`,Time partition format,Default value: HH:mm:ss
	  - `partition_type` - `unrequired` `string`,Partition type（FULL_BUILD,TIME, STREAMING,CUSTOMIZED,FILE）,Default value: FULL_BUILD
	  - `partition_condition_builder` - `unrequired` `string`,The full class name of the partition building class,Default value: org.apache.kylin.metadata.model.DefaultPartitionConditionBuilder
	- `dimensions` - `required` `JSON Object[]`,Dimensions information
	  - `table` - `required` `string`,Table name
	  - `columns` - `required` `string[]`,Fields name
	- `metrics` - `required` `string[]`,Metrics field name
	- `multilevel_partition_cols` - `unrequired` `string[]`,Multilevel partition field names
	- `is_draft` - `unrequired` `boolean`,Is it draft or not,Default value: false
	- `filter_condition` - `unrequired` `string`,Filter condition
	- `smart_model` - `unrequired` `boolean`,Whether to model for intelligence,Default value: false
	- `smart_model_sqls` - `unrequired` `string[]`,Intelligent modeling SQLs
	- `computed_columns` - `unrequired` `JSON Object`,Computed Columns information
	  - `tableIdentity` - `required` `string`,Table name
	  - `tableAlias` - `unrequired` `string`,Table alias
	  - `columnName` - `required` `string`,Field name
	  - `expression` - `required` `string`,Expression
	  - `datatype` - `required` `string`,Datatype（varchar,int,long...standard sql types）
	- `fact_table` - `required` `string`,The fact table name
  - `project` - `required` `string`,The project name
    
- Curl Request Example   
```sh
curl -X PUT \
'http://host:port/kylin/api/models' \
 -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8' \
// For the sake of intuition, this example expands the JSON Object String, which needs to be compressed and escaped when used
  -d '"modelDescData": "
  {
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

- Response Example

```json
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


### Clone a Model {#Clone-a-Model}

- `PUT http://host:port/kylin/api/models/{modelName}/clone`

- URL Parameters

  - `modelName` - `required` `string`, model name of being cloned

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `modelName` - `required` `string`, name of the new model
  - `project` - `required` `string`, project name 

- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/models/kylin_sales_model/clone' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{"modelName":"learn_kylin_model_clone2","project":"learn_kylin"}'
  ```

- Response Example

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



### Delete a Model {#Delete-a-Model}

- `DELETE http://host:port/kylin/api/models/{projectName}/{modelName}`

- URL Parameters
  - `projectName` - `required` `string`,  project name
  - `modelName` - `required` `string`, model name
  
- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X DELETE \
    'http://host:port/kylin/api/models/learn_kylin/kylin_sales_model_clone' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```



### Get all Computed Columns in a project {#Get-all-Computed-Columns-in-a-project}

- `GET http://host:port/kylin/api/models/computed_column_usage/{projectName}`

- URL Parameters  

  - `projectName` - `required` `string` project name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/models/computed_column_usage/learn_kylin' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

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
