## Metadata REST API
> **Tip**
>
> Before using API, make sure that you read the previous chapter of [Access and Authentication](authentication.en.md), and know how to add authentication information in API.
>
> If there exists `&` in your request path, please enclose the URL in quotation marks `""` or add a backslash ahead  `\&`  to avoid being escaped.


* [Get multiple Hive tables](#get-multiple-hive-tables)
* [Get Hive table information](#get-hive-table-information)
* [Load Hive tables](#load-hive-tables)

### Get multiple Hive tables
`Request Mode：GET`

`Access Path：http://host:port/kylin/api/tables`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`


#### Request Parameter
* project - `required` `string`, project name.
* ext - `optional` `boolean`, specify if table's extension information is returned.

#### Request Example
`Request Path: "http://host:port/kylin/api/tables?project=learn_kylin&ext=true"`

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json"  -H "Content-Type:application/vnd.apache.kylin-v2+json" "http://host:port/kylin/api/tables?project=learn_kylin&ext=true"
```

#### Response Example
```sh
{
    "code": "000",
    "data": [
        {
            "uuid": "e286e39e-40d7-44c2-8fa2-41b365632882",
            "last_modified": 1507690958000,
            "version": "3.0.0.1",
            "name": "TEST_COUNTRY",
            "columns": [
                {
                    "id": "1",
                    "name": "COUNTRY",
                    "datatype": "varchar(256)",
                    "index": "T"
                },
                {
                    "id": "2",
                    "name": "LATITUDE",
                    "datatype": "double"
                },
                {
                    "id": "3",
                    "name": "LONGITUDE",
                    "datatype": "double"
                },
                {
                    "id": "4",
                    "name": "NAME",
                    "datatype": "varchar(256)",
                    "index": "T"
                }
            ],
            "source_type": 0,
            "table_type": null,
            "database": "DEFAULT",
            "exd": {},
            "cardinality": {
                "CRE_DATE": 31,
                "SITE_ID": 270,
                "SITES_UPD_DATE": 3,
                "SITE_DOMAIN_CODE": 2,
                "EOA_EMAIL_CSTMZBL_SITE_YN_ID": 2,
                "SITE_CNTRY_ID": 225,
                "DFAULT_LSTG_CURNCY": 31,
                "CRE_USER": 8,
                "SITE_NAME": 271,
                "SITES_UPD_USER": 2
            }
        }
    ],
    "msg": ""
}
```

### Get Hive table information
`Request Mode: GET`

`Access Path: http://host:port/kylin/api/tables/{project}/{tableName}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`


#### Request Parameter
* project - `optional` `string`, project name.
* tableName - `optional` `string`, table name.

#### Request Example
`Request Path:http://host:port/kylin/api/tables/learn_kylin/kylin_cal_dt`

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/tables/learn_kylin/kylin_cal_dt
```

#### Response Example
```
{
    "code": "000",
    "data": {
        "uuid": "e286e39e-40d7-44c2-8fa2-41b365522771",
        "last_modified": 1508819599000,
        "version": "3.0.0.1",
        "name": "TEST_KYLIN_FACT",
        "columns": [
            {
                "id": "1",
                "name": "TRANS_ID",
                "datatype": "bigint",
                "data_gen": "ID"
            },
            {
                "id": "2",
                "name": "ORDER_ID",
                "datatype": "bigint",
                "index": "T"
            },
            {
                "id": "3",
                "name": "CAL_DT",
                "datatype": "date",
                "data_gen": "FK,order",
                "index": "T"
            },
            {
                "id": "4",
                "name": "LSTG_FORMAT_NAME",
                "datatype": "varchar(256)",
                "data_gen": "FP-GTC|FP-non GTC|ABIN|Auction|Others",
                "index": "T"
            },
            {
                "id": "5",
                "name": "LEAF_CATEG_ID",
                "datatype": "bigint",
                "data_gen": "FK,null,nullstr=0",
                "index": "T"
            },
            {
                "id": "6",
                "name": "LSTG_SITE_ID",
                "datatype": "integer",
                "index": "T"
            },
            {
                "id": "7",
                "name": "SLR_SEGMENT_CD",
                "datatype": "smallint",
                "data_gen": "FK,pk=EDW.TEST_SELLER_TYPE_DIM_TABLE.SELLER_TYPE_CD",
                "index": "T"
            },
            {
                "id": "8",
                "name": "SELLER_ID",
                "datatype": "integer",
                "data_gen": "RAND||10000000|10001000",
                "index": "T"
            },
            {
                "id": "9",
                "name": "PRICE",
                "datatype": "decimal(19,4)",
                "data_gen": "RAND|.##|-100|1000"
            },
            {
                "id": "10",
                "name": "ITEM_COUNT",
                "datatype": "integer",
                "data_gen": "RAND"
            },
            {
                "id": "11",
                "name": "TEST_COUNT_DISTINCT_BITMAP",
                "datatype": "varchar(256)",
                "data_gen": "RAND"
            }
        ],
        "source_type": 0,
        "table_type": null,
        "data_gen": "1",
        "database": "DEFAULT"
    },
    "msg": ""
}
```

### Load Hive tables
`Request Mode: POST`

`Access Path: http://host:port/kylin/api/tables/load`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`


#### Request Parameter
* project - `required` `string`, specify which project the hive table will be loaded to.
* tables - `required` `string[]`, the hive table name list to be loaded.

#### Request Example
`Request Path: http://host:port/kylin/api/tables/load`

#### Curl Request Example
```
curl -X POST -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "project":"000", "tables":["KYLIN_CAL_DT"] }' http://host:port/kylin/api/tables/load
```

#### Response Example
```sh
{
    "code": "000",
    "data": {
        "result.loaded": [
            "DEFAULT.TEST_KYLIN_FACT"
        ],
        "result.unloaded": []
    },
    "msg": ""
}
```
