## Cube REST API

> **提示**
>
> 使用API前请确保已阅读前面的**访问及安全认证**章节，知道如何在API中添加认证信息。
>


* [返回多个Cube](#返回多个cube)
* [返回指定Cube](#返回指定cube)
* [返回Cube描述信息](#返回cube描述信息)
* [构建 Cube-日期分区](#构建cube-日期分区)
* [构建 Cube-非日期分区](#构建cube-非日期分区)
* [构建Cube-无分区](#构建cube-无分区)
* [构建Cube-批量构建](#构建cube-批量构建)
* [克隆 Cube](#克隆cube)
* [启用 Cube](#启用cube)
* [禁用 Cube](#禁用cube)
* [清理 Cube](#清理cube)
* [管理 Segment](#管理segment)
* [删除 Segment](#删除segment)
* [导出 TDS](#导出tds)

### 返回多个Cube

`请求方式 GET`

`访问路径 http://host:port/kylin/api/cubes`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 请求主体
* pageOffset - `可选` `int` 默认0，返回数据起始下标
* pageSize - `可选` `int ` 默认10，分页返回对应每页返回多少
* cubeName - `可选` `string` 返回名称等于该关键字的Cube
* exactMatch - `可选` `boolean` 默认true, 是否根据cubeName完全匹配 
* modelName - `可选` `string` 返回对应模型名称等于该关键字的Cube
* projectName - `可选` `string` 指定返回该项目下Cube
* sortBy - `可选` `string` 指定排序字段，默认"update_time"
* reverse - `可选` `boolean` 是否倒序，默认true

#### 请求示例

`请求路径: http://host:port/kylin/api/cubes?pageOffset=0&pageSize=10&projectName=your_project&cubeName=&sortBy=update_time&reverse=true&exactMatch=false`

#### 响应示例
```json
{
    "code": "000",
    "data":
        "cubes": [  
            {
            "uuid": "8372c3b7-a33e-4b69-83dd-0bb8b1f8117e",
            "last_modified": 1508487909245,
            "version": "3.0.0.1",
            "name": "ci_inner_join_cube",
            "owner": null,
            "descriptor": "ci_inner_join_cube",
            "display_name": null,
            "cost": 50,
            "status": "DISABLED",
            "segments": [],
            "create_time_utc": 0,
            "cuboid_bytes": null,
            "cuboid_bytes_recommend": null,
            "cuboid_last_optimized": 0,
            "project": "default",
            "model": "ci_inner_join_model",
            "is_streaming": false,
            "partitionDateColumn": "TEST_KYLIN_FACT.CAL_DT",
            "partitionDateStart": 0,
            "isStandardPartitioned": true,
            "size_kb": 0,
            "input_records_count": 0,
            "input_records_size": 0,
            "is_draft": false,
            "multilevel_partition_cols": [],
            "total_storage_size_kb": 0
            }
        ],
        size: 1
    },
    msg: ""
}
```

#### Curl 访问示例

```
curl -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' http://host:port/kylin/api/cubes?pageOffset=0&pageSize=10&projectName=your_project&cubeName=&sortBy=update_time&reverse=true&exactMatch=false
```

### 返回指定Cube

`请求方式 GET`

`访问路径 http://host:port/kylin/api/cubes/{cubeName}`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量
* cubeName - `必选` `string` 要获取的Cube 名称.

#### 请求示例

`请求路径: http://host:port/kylin/api/cubes/your_cube`

#### 响应示例

```json
  {
    "code": "000",
    "data":{
      "uuid": "8372c3b7-a33e-4b69-83dd-0bb8b1f8117e",
      "last_modified": 1508487909245,
      "version": "3.0.0.1",
      "name": "ci_inner_join_cube",
      "owner": null,
      "descriptor": "ci_inner_join_cube",
      "display_name": null,
      "cost": 50,
      "status": "DISABLED",
      "segments": [],
      "create_time_utc": 0,
      "cuboid_bytes": null,
      "cuboid_bytes_recommend": null,
      "cuboid_last_optimized": 0,
      "project": "default",
      "model": "ci_inner_join_model",
      "is_streaming": false,
      "partitionDateColumn": "TEST_KYLIN_FACT.CAL_DT",
      "partitionDateStart": 0,
      "isStandardPartitioned": true,
      "size_kb": 0,
      "input_records_count": 0,
      "input_records_size": 0,
      "is_draft": false,
      "multilevel_partition_cols": [],
      "total_storage_size_kb": 0
    },
    msg: ""
}
```

#### Curl 访问示例

```
curl -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' http://host:port/kylin/api/cubes/your_cube
```

### 返回Cube描述信息

 维度, 度量，等
`请求方式 GET`

`访问路径 http://host:port/kylin/api/cube_desc/{projectName}/{cubeName}`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量
* projectName - `必选` `string` 项目名称.
* cubeName - `必选` `string` Cube 名称.

#### 请求示例

`请求路径: http://host:port/kylin/api/cube_desc/your_project/your_cube`

#### 响应示例
```json
 {
    "code": "000",
    "data": {
        "cube": {
            "uuid": "3819ad72-3929-4dff-b59d-cd89a01238af",
            "last_modified": 1508487309851,
            "version": "3.0.0.1",
            "name": "ci_inner_join_cube",
            "is_draft": false,
            "model_name": "ci_inner_join_model",
            "description": null,
            "null_string": null,
            "dimensions": [
                {
                    "name": "CAL_DT",
                    "table": "TEST_CAL_DT",
                    "column": "{FK}",
                    "derived": [
                        "WEEK_BEG_DT"
                    ]
                }            
            ],
            "measures": [
                {
                    "name": "TRANS_CNT",
                    "function": {
                        "expression": "COUNT",
                        "parameter": {
                            "type": "constant",
                            "value": "1"
                        },
                        "returntype": "bigint"
                    }
                },
                {
                    "name": "BUYER_CONTACT",
                    "function": {
                        "expression": "EXTENDED_COLUMN",
                        "parameter": {
                            "type": "column",
                            "value": "TEST_ORDER.BUYER_ID",
                            "next_parameter": {
                                "type": "column",
                                "value": "BUYER_ACCOUNT.ACCOUNT_CONTACT"
                            }
                        },
                        "returntype": "extendedcolumn(100)"
                    }
                },
                {
                    "name": "SELLER_CONTACT",
                    "function": {
                        "expression": "EXTENDED_COLUMN",
                        "parameter": {
                            "type": "column",
                            "value": "TEST_KYLIN_FACT.SELLER_ID",
                            "next_parameter": {
                                "type": "column",
                                "value": "SELLER_ACCOUNT.ACCOUNT_CONTACT"
                            }
                        },
                        "returntype": "extendedcolumn(100)"
                    }
                },
                {
                    "name": "TRANS_ID_RAW",
                    "function": {
                        "expression": "RAW",
                        "parameter": {
                            "type": "column",
                            "value": "TEST_KYLIN_FACT.TRANS_ID"
                        },
                        "returntype": "raw"
                    }
                }
            ],
            "dictionaries": [
                {
                    "column": "TEST_KYLIN_FACT.TEST_COUNT_DISTINCT_BITMAP",
                    "builder": "org.apache.kylin.dict.global.SegmentAppendTrieDictBuilder"
                }
            ],
            "rowkey": {
                "rowkey_columns": [
                    {
                        "column": "TEST_KYLIN_FACT.SELLER_ID",
                        "encoding": "int:4",
                        "isShardBy": false
                    },
                    {
                        "column": "TEST_KYLIN_FACT.ORDER_ID",
                        "encoding": "int:4",
                        "isShardBy": false
                    },
                    {
                        "column": "TEST_KYLIN_FACT.CAL_DT",
                        "encoding": "date",
                        "isShardBy": false
                    }                
                 ]
            },
            "hbase_mapping": {
                "column_family": [
                    {
                        "name": "F1",
                        "columns": [
                            {
                                "qualifier": "M",
                                "measure_refs": [
                                    "TRANS_CNT",
                                    "ITEM_COUNT_SUM",
                                    "GMV_SUM",
                                    "GMV_MIN",
                                    "GMV_MAX",
                                    "COMPUTED_COLUMN_MEASURE"
                                ]
                            }
                        ]
                    },
                    {
                        "name": "F2",
                        "columns": [
                            {
                                "qualifier": "M",
                                "measure_refs": [
                                    "SELLER_HLL",
                                    "SELLER_FORMAT_HLL",
                                    "TOP_SELLER",
                                    "TEST_COUNT_DISTINCT_BITMAP"
                                ]
                            }
                        ]
                    },
                    {
                        "name": "F3",
                        "columns": [
                            {
                                "qualifier": "M",
                                "measure_refs": [
                                    "TEST_EXTENDED_COLUMN",
                                    "BUYER_CONTACT",
                                    "SELLER_CONTACT",
                                    "TRANS_ID_RAW",
                                    "PRICE_RAW",
                                    "CAL_DT_RAW"
                                ]
                            }
                        ]
                    }
                ]
            },
            "aggregation_groups": [
                {
                    "includes": [
                        "TEST_KYLIN_FACT.CAL_DT",
                        "TEST_KYLIN_FACT.LEAF_CATEG_ID",
                        "TEST_KYLIN_FACT.LSTG_FORMAT_NAME",
                        "TEST_KYLIN_FACT.LSTG_SITE_ID",
                        "TEST_KYLIN_FACT.SLR_SEGMENT_CD",
                        "TEST_CATEGORY_GROUPINGS.META_CATEG_NAME",
                        "TEST_CATEGORY_GROUPINGS.CATEG_LVL2_NAME",
                        "TEST_CATEGORY_GROUPINGS.CATEG_LVL3_NAME",
                        "TEST_KYLIN_FACT.DEAL_YEAR"
                    ],
                    "select_rule": {
                        "hierarchy_dims": [
                            [
                                "TEST_CATEGORY_GROUPINGS.META_CATEG_NAME",
                                "TEST_CATEGORY_GROUPINGS.CATEG_LVL2_NAME",
                                "TEST_CATEGORY_GROUPINGS.CATEG_LVL3_NAME",
                                "TEST_KYLIN_FACT.LEAF_CATEG_ID"
                            ]
                        ],
                        "mandatory_dims": [],
                        "joint_dims": [
                            [
                                "TEST_KYLIN_FACT.LSTG_FORMAT_NAME",
                                "TEST_KYLIN_FACT.LSTG_SITE_ID",
                                "TEST_KYLIN_FACT.SLR_SEGMENT_CD",
                                "TEST_KYLIN_FACT.DEAL_YEAR"
                            ]
                        ],
                        "dim_cap": 1
                    }
                },
                {
                    "includes": [
                        "TEST_KYLIN_FACT.CAL_DT",
                        "TEST_KYLIN_FACT.LEAF_CATEG_ID",
                        "TEST_KYLIN_FACT.LSTG_FORMAT_NAME",
                        "TEST_KYLIN_FACT.LSTG_SITE_ID",
                        "TEST_KYLIN_FACT.SLR_SEGMENT_CD",
                        "TEST_CATEGORY_GROUPINGS.META_CATEG_NAME",
                        "TEST_CATEGORY_GROUPINGS.CATEG_LVL2_NAME",
                        "TEST_CATEGORY_GROUPINGS.CATEG_LVL3_NAME",
                        "TEST_KYLIN_FACT.SELLER_ID",
                        "SELLER_ACCOUNT.ACCOUNT_BUYER_LEVEL",
                        "SELLER_ACCOUNT.ACCOUNT_SELLER_LEVEL",
                        "SELLER_ACCOUNT.ACCOUNT_COUNTRY",
                        "SELLER_COUNTRY.NAME",
                        "TEST_KYLIN_FACT.ORDER_ID",
                        "TEST_ORDER.TEST_DATE_ENC",
                        "TEST_ORDER.TEST_TIME_ENC",
                        "TEST_ORDER.BUYER_ID",
                        "BUYER_ACCOUNT.ACCOUNT_BUYER_LEVEL",
                        "BUYER_ACCOUNT.ACCOUNT_SELLER_LEVEL",
                        "BUYER_ACCOUNT.ACCOUNT_COUNTRY",
                        "BUYER_COUNTRY.NAME",
                        "TEST_KYLIN_FACT.SELLER_COUNTRY_ABBR",
                        "TEST_KYLIN_FACT.BUYER_COUNTRY_ABBR",
                        "TEST_KYLIN_FACT.SELLER_ID_AND_COUNTRY_NAME",
                        "TEST_KYLIN_FACT.BUYER_ID_AND_COUNTRY_NAME"
                    ],
                    "select_rule": {
                        "hierarchy_dims": [],
                        "mandatory_dims": [
                            "TEST_KYLIN_FACT.CAL_DT"
                        ],
                        "joint_dims": [
                            [
                                "TEST_CATEGORY_GROUPINGS.META_CATEG_NAME",
                                "TEST_CATEGORY_GROUPINGS.CATEG_LVL2_NAME",
                                "TEST_CATEGORY_GROUPINGS.CATEG_LVL3_NAME",
                                "TEST_KYLIN_FACT.LEAF_CATEG_ID"
                            ]
                        ],
                        "dim_cap": 1
                    }
                }
            ],
            "signature": "kNACGfzr3/ozZvEsWLNNtg==",
            "notify_list": [],
            "status_need_notify": [],
            "partition_date_start": 0,
            "partition_date_end": 3153600000000,
            "auto_merge_time_ranges": [],
            "volatile_range": 0,
            "retention_range": 0,
            "engine_type": 100,
            "storage_type": 99,
            "override_kylin_properties": {
                "kylin.cube.algorithm": "LAYER",
                "kylin.storage.hbase.owner-tag": "kylin@kylin.apache.org"
            },
            "cuboid_black_list": [],
            "parent_forward": 3,
            "mandatory_dimension_set_list": []
        }
    },
    "msg": ""
}
```

#### Curl 访问示例

```
curl -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' http://host:port/kylin/api/cube_desc/your_project/your_cube
```

### 构建Cube-日期分区

`请求方式 PUT`

`访问路径 http://host:port/kylin/api/cubes/{cubeName}/segments/build`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量
* cubeName - `必选` `string` Cube 名称

#### 请求主体
* startTime - `必选` `long` 要计算的数据对应起始时间的时间戳，应为GMT格式的时间戳 , e.g. 1388534400000 for 2014-01-01，可使用 https://www.epochconverter.com/ 网页进行转换。
* endTime - `必选` `long` 要计算的数据对应终止时间的时间戳，应为GMT格式的时间戳
* buildType - `必选` `string` 支持的计算类型: 'BUILD'
* mpValues - `可选` `string` 对应model的more partition 字段值

#### 请求示例

```sh
{  
  "startTime": 0,
  "endTime": 1388534400000,
  "buildType": "BUILD",
  "mpValues": ""
}
```

#### 响应示例
```json
{
    "code": "000",
    "data": {
        "uuid": "3e38d217-0c31-4d9b-9e52-57d10b1e7190",
        "last_modified": 1508837365452,
        "version": "3.0.0.1",
        "name": "BUILD CUBE - ci_inner_join_cube - 0_1388534400000 - GMT+08:00 2017-10-24 17:29:25",
        "type": "BUILD",
        "duration": 0,
        "related_cube": "ci_inner_join_cube",
        "display_cube_name": "ci_inner_join_cube",
        "related_segment": "889049e8-5a57-41d8-abcd-3a356d57eea0",
        "exec_start_time": 0,
        "exec_end_time": 0,
        "exec_interrupt_time": 0,
        "mr_waiting": 0,
        "steps": [
            {
                "interruptCmd": null,
                "id": "3e38d217-0c31-4d9b-9e52-57d10b1e7190-00",
                "name": "Create Intermediate Flat Hive Table",
                "sequence_id": 0,
                "exec_cmd": null,
                "interrupt_cmd": null,
                "exec_start_time": 0,
                "exec_end_time": 0,
                "exec_wait_time": 0,
                "step_status": "PENDING",
                "cmd_type": "SHELL_CMD_HADOOP",
                "info": {},
                "run_async": false
            }
        ],
        "submitter": "ADMIN",
        "job_status": "PENDING",
        "progress": 0
    },
    "msg": ""
}
```

#### Curl 访问示例

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' -d '{ "startTime": 0,"endTime": 1388534400000,"buildType": "BUILD","mpValues": "" }' http://host:port/kylin/api/cubes/your_cube/segments/build
```

### 构建Cube-非日期分区

`请求方式 PUT`

`访问路径 http://host:port/kylin/api/cubes/{cubeName}/segments/build_by_offset`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量
* cubeName - `必选` `string` Cube 名称

#### 请求主体
* sourceOffsetStart - `必选` `long` 开始值
* sourceOffsetEnd - `必选` `long` 结束值
* buildType - `必选` `string` 支持的计算类型: 'BUILD'
* mpValues - `可选` `string` 对应model的more partition 字段值


#### 请求示例

```sh
{  
  "startTime": 0,
  "endTime": 138800,
  "buildType": "BUILD",
  "mpValues": ""
}
```

#### 响应示例

(同 "构建Cube-日期分区")

#### Curl 访问示例

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' -d '{ "startTime": 0,"endTime": 138800,"buildType": "BUILD","mpValues": "" }' http://host:port/kylin/api/cubes/your_cube/segments/build_by_offset
```

### 构建Cube-无分区

`请求方式 PUT`

`访问路径 http://host:port/kylin/api/cubes/{cubeName}/segments/build`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量

* cubeName - `必选` `string` Cube 名称

#### 请求主体

* startTime - `必选` `long` , 0
* endTime - `必选` `long`, 0
* buildType - `必选` `string`, 支持的计算类型: 'BUILD'

#### 请求示例

```sh
{  
  "startTime": 0,
  "endTime": 0,
  "buildType": "BUILD"
}
```

#### 响应示例

(同 "构建Cube-日期分区")

#### Curl 访问示例

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' -d '{ "startTime": 0,"endTime": 0,"buildType": "BUILD" }' http://host:port/kylin/api/cubes/your_cube/segments/build
```

### 构建Cube-批量构建

`请求方式 PUT`

`访问路径 http://host:port/kylin/api/cubes/{cubeName}/batch_sync`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量

* cubeName - `必选` `string` Cube 名称

#### 请求主体
* pointList - `可选` `string` 对应model的partition 字段值 结构：List<Long>
* rangeList - `可选` `string` 对应model的partition 字段值 结构：List<Long[]>
* mpValues - `可选` `string` 对应model的more partition 字段值

#### 请求示例
```json
[	{
        "mpValues": "300",
        "pointList": [
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10"
        ],
        "rangeList": [["50","70"],["90","110"]]
    },
    {
        "mpValues": "301",
        "pointList": [
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10"
        ],
        "rangeList": [["20","30"],["30","40"]]
    }
]
```

#### 响应示例

```json
{
    "code":"000",
    "data":[
        {
        "code":"000",
        "data":{
            "uuid":"a09442bb-300f-4851-8bd2-2ec0d811dcb6",
            "last_modified":1529400276349,
            "version":"3.0.0.1",
            "name":"BUILD CUBE - TYRRE - 1_2 - GMT+08:00 2018-06-19 17:24:36",
            "type":"BUILD",
            "duration":0,
            "related_cube":"TYRRE",
            "display_cube_name":"TYRRE",
            "related_segment":"5ef8d42b-5ed6-4489-b95c-07fe4cf5a2e6",
            "exec_start_time":0,
            "exec_end_time":0,
            "exec_interrupt_time":0,
            "mr_waiting":0,
            "steps":[
              {
                "interruptCmd": null,
                "id": "3e38d217-0c31-4d9b-9e52-7e4d3b1e7190-00",
                "name": "Create Intermediate Flat Hive Table",
                "sequence_id": 0,
                "exec_cmd": null,
                "interrupt_cmd": null,
                "exec_start_time": 0,
                "exec_end_time": 0,
                "exec_wait_time": 0,
                "step_status": "PENDING",
                "cmd_type": "SHELL_CMD_HADOOP",
                "info": {},
                "run_async": false
              }
            ],
            "submitter":"ADMIN",
            "job_status":"PENDING",
            "progress":0.0
        },
        "msg":""}
    ],
    "msg":""
}
```

#### Curl 访问示例

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' -d '[{"mpValues": "300","pointList": ["1","2","3","4","5","6","7","8","9","10"],"rangeList": [["50","70"],["90","110"]]},{"mpValues": "301","pointList": ["1","2","3","4","5","6","7","8","9","10"],"rangeList": [["20","30"],["30","40"]]}]' http://host:port/kylin/api/cubes/your_cube/batch_sync
```

### 克隆Cube

`请求方式 PUT`

`访问路径 http://host:port/kylin/api/cubes/{cubeName}/clone`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量
* cubeName - `必选` `string` 被克隆Cube名称.

#### 请求主体
* cubeName - `必选` `string` 新Cube名称.
* project - `必选` `string` 新项目名称 


#### 请求示例

```Json
{  
  "cubeName": "cube_clone",
  "project": "your_project"
}
```

#### 响应示例
(同 "返回指定 Cube")

#### Curl 访问示例

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' -d '{ "cubeName": "cube_clone","project": "your_project" }' http://host:port/kylin/api/cubes/cube_name/clone
```

### 启用Cube
`请求方式 PUT`

`访问路径 http://host:port/kylin/api/cubes/{cubeName}/enable`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量
* cubeName - `必选` `string` Cube 名称.

#### 请求示例

`请求路径: http://host:port/kylin/api/cubes/your_cube/enable`

#### 响应示例
```json
{  
   "uuid":"1eaca32a-a33e-4b69-83dd-0bb8b1f8c53b",
   "last_modified":1407909046305,
   "name":"test_kylin_cube_with_slr_ready",
   "owner":null,
   "version":null,
   "descriptor":"test_kylin_cube_with_slr_desc",
   "display_name":null,
   "cost":50,
   "status":"ACTIVE",
   "segments":[  
      {
         "uuid":"4d0200ed-6858-49e3-ae98-bb401387b23f",
         "name":"19700101000000_20140531160000",
         "storage_location_identifier":"KYLIN-CUBE-TEST_KYLIN_CUBE_WITH_SLR_READY-19700101000000_20140531160000_BF043D2D-9A4A-45E9-AA59-5A17D3F34A50",
         "date_range_start":0,
         "date_range_end":1401552000000,
         "source_offset_start":0,
         "source_offset_end":0,
         "status":"READY",
         "size_kb":4758,
         "input_records":6000,
         "input_records_size":620356,
         "last_build_time":1407832663227,
         "last_build_job_id":"2c7a2b63-b052-4a51-8b09-0c24b5792cda",
         "create_time_utc":1528713225709,
         "cuboid_shard_nums":{},
         "total_shards":0,
         "blackout_cuboids":[],
         "binary_signature":null,
         "dictionaries":{  
            "TEST_CATEGORY_GROUPINGS/CATEG_LVL2_NAME":"/dict/TEST_CATEGORY_GROUPINGS/CATEG_LVL2_NAME/16d8185c-ee6b-4f8c-a919-756d9809f937.dict",
            "TEST_KYLIN_FACT/LSTG_SITE_ID":"/dict/TEST_SITES/SITE_ID/0bec6bb3-1b0d-469c-8289-b8c4ca5d5001.dict",
            "TEST_KYLIN_FACT/SLR_SEGMENT_CD":"/dict/TEST_SELLER_TYPE_DIM/SELLER_TYPE_CD/0c5d77ec-316b-47e0-ba9a-0616be890ad6.dict",
            "TEST_KYLIN_FACT/CAL_DT":"/dict/PREDEFINED/date(yyyy-mm-dd)/64ac4f82-f2af-476e-85b9-f0805001014e.dict",
            "TEST_CATEGORY_GROUPINGS/CATEG_LVL3_NAME":"/dict/TEST_CATEGORY_GROUPINGS/CATEG_LVL3_NAME/270fbfb0-281c-4602-8413-2970a7439c47.dict",
            "TEST_KYLIN_FACT/LEAF_CATEG_ID":"/dict/TEST_CATEGORY_GROUPINGS/LEAF_CATEG_ID/2602386c-debb-4968-8d2f-b52b8215e385.dict",
            "TEST_CATEGORY_GROUPINGS/META_CATEG_NAME":"/dict/TEST_CATEGORY_GROUPINGS/META_CATEG_NAME/0410d2c4-4686-40bc-ba14-170042a2de94.dict"
         },
         "snapshots":{  
            "TEST_CAL_DT":"/table_snapshot/TEST_CAL_DT.csv/8f7cfc8a-020d-4019-b419-3c6deb0ffaa0.snapshot",
            "TEST_SELLER_TYPE_DIM":"/table_snapshot/TEST_SELLER_TYPE_DIM.csv/c60fd05e-ac94-4016-9255-96521b273b81.snapshot",
            "TEST_CATEGORY_GROUPINGS":"/table_snapshot/TEST_CATEGORY_GROUPINGS.csv/363f4a59-b725-4459-826d-3188bde6a971.snapshot",
            "TEST_SITES":"/table_snapshot/TEST_SITES.csv/78e0aecc-3ec6-4406-b86e-bac4b10ea63b.snapshot"
         }
      }
   ],
   "create_time_utc":0,
   "cuboid_bytes":null,
   "cuboid_bytes_recommend":null,
   "cuboid_last_optimized":0,
   "project":"default",
   "model":"ci_left_join_model",
   "is_streaming":false,
   "partitionDateColumn":"TEST_KYLIN_FACT.CAL_DT",
   "partitionDateStart":0,
   "isStandardPartitioned":true,
   "size_kb":0,
   "input_records_count":0,
   "input_records_size":0,
   "is_draft":false,
   "multilevel_partition_cols":[],
   "total_storage_size_kb":0
}
```

#### Curl 访问示例

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' http://host:port/kylin/api/cubes/your_cube/enable
```

### 禁用Cube

`请求方式 PUT`

`访问路径 http://host:port/kylin/api/cubes/{cubeName}/disable`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量
* cubeName - `必选` `string` Cube 名称.

#### 请求示例

`请求路径: http://host:port/kylin/api/cubes/your_cube/disable`

#### 响应示例
(同 "启用 Cube")

#### Curl 访问示例

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' http://host:port/kylin/api/cubes/your_cube/disable
```

### 清理Cube
`请求方式 PUT`

`访问路径 http://host:port/kylin/api/cubes/{cubeName}/purge`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量
* cubeName - `必选` `string` Cube 名称`

#### 请求主体

* mpValues - `可选` `string` Model Primary Partition 值

#### 请求示例

```Json
{  
  "mpValues": ""
}
```

#### 响应示例
(同 "启用 Cube")

#### Curl 访问示例

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' -d '{ "mpValues": "" }' http://host:port/kylin/api/cubes/your_cube/purge
```

### 管理Segment
`请求方式 PUT`

`访问路径 http://host:port/kylin/api/cubes/{cubeName}/segments`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量
* cubeName - `必选` `string` Cube 名称.

#### 请求主体
* buildType - `必选` `string` MERGE, REFRESH, DROP
* segments - `必选` `string` segment name 数组
* mpValues - `可选` `string` Model Primary Partition 值
* force - `可选` `boolean` 是否强制进行操作，值为true 或 false

#### 请求示例

```json
{  
  "buildType": "REFRESH",
  "segments": [0_1000],
  "mpValues": "ABIN",
  "force": false
}
```

#### Curl 示例
```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' -d '{ "buildType": "REFRESH", "mpValues": "ABIN", "segments": ["0_1000"], "force": false }' http://host:port/kylin/api/cubes/your_cube/segments
```

### 导出TDS
`请求方式 GET`

`访问路径 http://host:port/kylin/api/cubes/{cubeName}/export/tds`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量
* cubeName - `必选` `string` Cube 名称

#### 请求示例

`请求路径: http://host:port/kylin/api/cubes/your_cube/export/tds`

#### Curl 访问示例

```
curl -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' http://host:port/kylin/api/cubes/your_cube/export/tds
```

### 