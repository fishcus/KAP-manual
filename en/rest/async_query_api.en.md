## Asyn Query Result Export REST API

> **Tip**
>
> Before using API, make sure that you read the previous chapter of access and security authentication, and know how to add authentication information in API.
>
* [Asyn Query](#Asyn Query)
* [Query Status](#Query Status)
* [Query Metadata Info](#Query Metadata Info)
* [Query Result File Status](#Query Result File Status)
* [Download Query Result](#Download Query Result)
* [Query hdfs Path](#Query hdfs Path)
* [Delete All Query Result Files](#Delete All Query Result Files)


### Asyn Query

`Request Mode POST`

`Access Path http://host:port/kylin/api/async_query`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Request Body
- sql - ```required``` ```string``` The text of sql statement.
- separator - `可选` `string` The spearator of export result. Default value is ",".
- limit - ```optional``` ```int``` Query limit. If limit is set in sql, limit will be ignored.
- project - ```optional``` ```string``` Project to perform query. Default value is ‘DEFAULT’.

#### Request Example
```json
[
   {
      "sql":"select count(*),L_RECEIPTDELAYED,L_RETURNFLAG,L_SUPPKEY,L_RECEIPTDATE,L_SHIPYEAR,L_SHIPINSTRUCT,L_QUANTITY,L_SHIPDELAYED,L_ORDERKEY,L_SHIPMODE,L_DISCOUNT,L_SHIPDATE,L_LINESTATUS,L_PARTKEY,V_ORDERS.O_SHIPPRIORITY,V_ORDERS.O_ORDERDATE,V_ORDERS.O_ORDERPRIORITY,V_ORDERS.O_CUSTKEY,PART.P_SIZE,PART.P_CONTAINER,PART.P_TYPE,PART.P_BRAND ,CUSTOMER.C_ADDRESS ,C_PHONE from v_lineitem inner join V_ORDERS on L_ORDERKEY = O_ORDERKEY  inner join PART on L_PARTKEY = P_PARTKEY inner join CUSTOMER on O_CUSTKEY = C_CUSTKEY group by L_RECEIPTDELAYED,L_RETURNFLAG,L_SUPPKEY,L_RECEIPTDATE,L_SHIPYEAR,L_SHIPINSTRUCT,L_QUANTITY,L_SHIPDELAYED,L_ORDERKEY,L_SHIPMODE,L_DISCOUNT,L_SHIPDATE,L_LINESTATUS,L_PARTKEY,V_ORDERS.O_SHIPPRIORITY,V_ORDERS.O_ORDERDATE,V_ORDERS.O_ORDERPRIORITY,V_ORDERS.O_CUSTKEY,PART.P_SIZE,PART.P_CONTAINER,PART.P_TYPE,PART.P_BRAND, C_ADDRESS,C_PHONE",
      "separator":",",
      "project":"tpch_kap_24"
   }
]
```

#### Curl Request Example
```
curl -X POST -H "Authorization: Basic XXXXXX" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "sql":"select * from kylin_sales", "separator":","，"project":"tpch_kap_24" }' http://host:port/kylin/api/async_query
```

#### Response Info
* queryID - async query的queryID.
* status - sync query status. Includes:FAILED and RUNNING
* info - sync query detail info.

### Request Example
```json
[
   {
       "code": "000",
       "data": {
           "queryID": "86dbf3e7-361d-44c0-bd34-607de9a423a4",
           "status": "RUNNING",
           "info": "still running"
       },
       "msg": ""
   }
]
```

### Query Status

`Request Mode GET`

`Access Path http://host:port/kylin/api/async_query/{queryID}/status`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Request Example
`Access Path: http://host:port/kylin/api/async_query/yourQueryId/status`

#### Request Body
* queryID - `required` `string`  async query的queryID.

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic XXXXXX" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/async_query/your_query_id/status
```

#### Response Info
* queryID - async query的queryID.
* status - sync query submit status. The status includes FAILED, MISS, SUCCESS and RUNNING
* info - sync query submit status detail info.

### Response Example
```json
[
    {
        "code": "000",
        "data": {
            "queryID": "36b0ef17-f097-4c29-a4db-aad27e06486e",
            "status": "SUCCESSFUL",
            "info": "await fetching results"
        },
        "msg": ""
    }
]
```

### Query Metadata Info

`Request Mode GET`

`Access Path http://host:port/kylin/api/async_query/{queryID}/metadata`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Request Body
* queryID - `required` `string`  async query的queryID.

#### Request Example
`Access Path: http://host:port/kylin/api/async_query/yourQueryId/metadata`

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic XXXXXX" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/async_query/your_query_id/metadata
```

#### Response Info
* data - data with two lists, The first list is fulled with column Names, The second list is fulled with data type names of columns

### Response Example
```json
[
    {
        "code": "000",
        "data": [
            [
                "LSTG_FORMAT_NAME",
                "SLR_SEGMENT_CD",
                "GMV",
                "TRANS_CNT"
            ],
            [
                "VARCHAR",
                "SMALLINT",
                "DECIMAL",
                "BIGINT"
            ]
        ],
        "msg": ""
    }
]
```

### Query Result File Status

`Request Mode GET`

`Access Path http://host:port/kylin/api/async_query/{queryID}/filestatus`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Request Body
* queryID - `required` `string`  async query的queryID.

#### Request Example
`Access Path: http://host:port/kylin/api/async_query/yourQueryId/filestatus`

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic XXXXXX" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/async_query/your_query_id/filestatus
```

#### Response Info
* data - data is the total size of save result

### Response Example
```json
[
    {
        "code": "000",
        "data": 21345912,
        "msg": ""
    }
]
```


### Download Query Result

`Request Mode GET`

`Access Path http://host:port/kylin/api/async_query/{queryID}/result_download`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Request Body
* queryID - `required` `string`  async query的queryID.

#### Request Example
`Access Path: http://host:port/kylin/api/async_query/yourQueryId/result_download`

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic XXXXXX" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/async_query/your_query_id/result_download
```

#### Response Info
* Return a file to download at this time

### Query hdfs Path

`Request Mode GET`

`Access Path http://host:port/kylin/api/async_query/{queryID}/result_path`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Request Body
* queryID - `required` `string`  async query的queryID.

#### Request Example
`Request Path: http://host:port/kylin/api/async_query/yourQueryId/result_path`

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic XXXXXX" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/async_query/your_query_id/result_path
```

#### Response Info
* data - data is the HDFS save path for this query

### Response Example
```json
[
    {
        "code": "000",
        "data": "hdfs://cluster:8020/kylin/ci_cube/async_query_result/d4803444-4efc-46f6-845d-d20cbc3f4e06",
        "msg": ""
    }
]
```

### Delete All Query Result Files

`Request Mode DELETE`

`Access Path http://host:port/kylin/api/async_query`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Request Example
`Access Path: http://host:port/kylin/api/async_query`

#### Curl Request Example
```
curl -X DELETE -H "Authorization: Basic XXXXXX" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/async_query
```

#### Response Info
* data - data is the result of query

### Response Example
```json
[
    {
        "code": "000",
        "data": true,
        "msg": ""
    }
]
```