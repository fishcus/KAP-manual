## 异步结果导出 REST API

> **提示**
>
> 使用API前请确保已阅读前面的**访问及安全认证**章节，知道如何在API中添加认证信息。
>
* [提交查询](#提交查询)
* [查询query状态](#查询query状态)
* [查询query的metadata信息](#查询query的metadata信息)
* [查询query的结果文件大小](#查询query的结果文件大小)
* [下载query查询结果](#下载query查询结果)
* [查询query的hdfs路径](#查询query的hdfs路径)
* [删除所有查询结果文件](#删除所有查询结果文件)


### 提交查询

`请求方式 POST`

`访问路径 http://host:port/kylin/api/async_query`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 请求主体
* sql - `必选` `string` 查询的sql.
* separator - `可选` `string` 默认",",指定导出结果的分隔符
* limit - `可选` `int ` 加上limit参数后会从offset开始返回对应的行数，不足limt以实际行数为准
* project - `必选` `string`  默认为 ‘DEFAULT’，在实际使用时，如果对应查询的项目不是“DEFAULT”，需要设置为自己的项目

#### 请求示例
```json
[
   {
      "sql":"select count(*),L_RECEIPTDELAYED,L_RETURNFLAG,L_SUPPKEY,L_RECEIPTDATE,L_SHIPYEAR,L_SHIPINSTRUCT,L_QUANTITY,L_SHIPDELAYED,L_ORDERKEY,L_SHIPMODE,L_DISCOUNT,L_SHIPDATE,L_LINESTATUS,L_PARTKEY,V_ORDERS.O_SHIPPRIORITY,V_ORDERS.O_ORDERDATE,V_ORDERS.O_ORDERPRIORITY,V_ORDERS.O_CUSTKEY,PART.P_SIZE,PART.P_CONTAINER,PART.P_TYPE,PART.P_BRAND ,CUSTOMER.C_ADDRESS ,C_PHONE from v_lineitem inner join V_ORDERS on L_ORDERKEY = O_ORDERKEY  inner join PART on L_PARTKEY = P_PARTKEY inner join CUSTOMER on O_CUSTKEY = C_CUSTKEY group by L_RECEIPTDELAYED,L_RETURNFLAG,L_SUPPKEY,L_RECEIPTDATE,L_SHIPYEAR,L_SHIPINSTRUCT,L_QUANTITY,L_SHIPDELAYED,L_ORDERKEY,L_SHIPMODE,L_DISCOUNT,L_SHIPDATE,L_LINESTATUS,L_PARTKEY,V_ORDERS.O_SHIPPRIORITY,V_ORDERS.O_ORDERDATE,V_ORDERS.O_ORDERPRIORITY,V_ORDERS.O_CUSTKEY,PART.P_SIZE,PART.P_CONTAINER,PART.P_TYPE,PART.P_BRAND, C_ADDRESS,C_PHONE",
      "separator":",",
      "project":"tpch_kap_24"
   }
]
```

#### 响应信息
* queryID - async query的queryID.
* status - sync query提交的状态.该状态分为:FAILED 和 RUNNING
* info - sync query提交状态的详细信息.

### 响应示例
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

### 查询query状态

`请求方式 GET`

`访问路径 http://host:port/kylin/api/async_query/{queryID}/status`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 请求主体
* queryID - `必选` `string`  async query的queryID.


#### 响应信息
* queryID - async query的queryID.
* status - sync query提交的状态.该状态分为:FAILED, MISS(查询不到此查询), SUCCESS 和 RUNNING
* info - sync query提交状态的详细信息.

### 响应示例
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

### 查询query的metadata信息

`请求方式 GET`

`访问路径 http://host:port/kylin/api/async_query/{queryID}/metadata`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 请求主体
* queryID - `必选` `string`  async query的queryID.


#### 响应信息
* data - data为一个两个list,第一个list为列名,第二个list为对应列的数据类型

### 响应示例
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

### 查询query的结果文件大小

`请求方式 GET`

`访问路径 http://host:port/kylin/api/async_query/{queryID}/filestatus`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 请求主体
* queryID - `必选` `string`  async query的queryID.


#### 响应信息
* data - data为保存结果的总大小

### 响应示例
```json
[
    {
        "code": "000",
        "data": 21345912,
        "msg": ""
    }
]
```


### 下载query查询结果

`请求方式 GET`

`访问路径 http://host:port/kylin/api/async_query/{queryID}/result_download`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 请求主体
* queryID - `必选` `string`  async query的queryID.


#### 响应信息
* 此时返回一个文件下载

### 查询query的hdfs路径

`请求方式 GET`

`访问路径 http://host:port/kylin/api/async_query/{queryID}/result_path`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 请求主体
* queryID - `必选` `string`  async query的queryID.


#### 响应信息
* data - data为该查询的hdfs保存路径

### 响应示例
```json
[
    {
        "code": "000",
        "data": "hdfs://cluster:8020/kylin/ci_cube/async_query_result/d4803444-4efc-46f6-845d-d20cbc3f4e06",
        "msg": ""
    }
]
```

### 删除所有查询结果文件

`请求方式 DELETE`

`访问路径 http://host:port/kylin/api/async_query`

`Content-Type: application/vnd.apache.kylin-v2+json`


#### 响应信息
* data - data为执行结果

### 响应示例
```json
[
    {
        "code": "000",
        "data": true,
        "msg": ""
    }
]
```