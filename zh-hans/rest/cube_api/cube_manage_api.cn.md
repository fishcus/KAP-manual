## 管理 Cube API

> **提示：**
>
> 1. 请确保已阅读前面的[访问及安全认证](../authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。


* [创建 Cube](#创建Cube)
* [删除 Cube](#删除Cube)
* [克隆 Cube](#克隆Cube)
* [启用 Cube](#启用Cube)
* [禁用 Cube](#禁用Cube)
* [清理 Cube](#清理Cube)
* [列出 Cube 中的空洞](#列出Cube中的空洞)
* [填充 Cube 中的空洞](#填充Cube中的空洞)
* [导出 TDS](#导出TDS)



### 创建 Cube {#创建Cube}

- `PUT http://host:port/kylin/api/cubes`

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`
  
- HTTP Body: JSON Object
  - `project` - `必选` `string`，项目名称
  - `cubeDescData` - `必选` `string`，cube描述数据（JSON Object String）
    - `uuid` - `非必选` `string`，唯一识别码，默认随机生成
    - `last_modified` - `非必选` `long`，最后修改时间（创建 Cube 时需要设为 0，修改 Cube 时需要设为上次修改时间）
    - `name` - `必选` `string`，Cube 名称
    - `model_name` - `必选` `string`，模型名称
    - `is_draft` - `非必选` `boolean`，是否为草稿
    - `description` - `非必选` `string`，Cube 额外描述信息
    - `null_string` - `非必选` `string[]`，将 Cuboid 和 RawTable 中特定字符串值置为空值（如`null`字符串）
    - `dimensions` - `必选` `JSON Object[]`，维度信息
      - `name` - `非必选` `string`，维度名
      - `table` - `必选` `string`，表名
      - `column` - `必选` `string`，字段名
      - `derived` - `非必选` `string`，衍生维度
    - `measures` - `必选` `JSON Object[]`，度量信息
      - `name` - `必选` `string`，度量名
      - `description` - `非必选` `string`，描述信息
      - `function` - `必选` `JSON Object`，函数信息
        - `expression` - `必选` `string`，表达式
        - `parameter` - `必选` `JSON Object`，参数信息
          - `type` - `必选` `string`，参数类型（column,constant）无默认值
          - `value` - `必选` `string`，参数值
        - `returntype` - `必选` `string`，返回值类型（varchar,int,long...standard sql types）无默认值
        - `semi_additive_info` - `非必选` `JSON Object`，半累加度量信息
          - `aggregation_func` - `必选` `string`，聚合函数 (LastChild)
          - `order_by_column` - `必选` `string` 时间维度
    - `rowkey` - `必选` `JSON Object`，行键信息
      - `rowkey_columns` - `必选` `JSON Object[]`，行键中，列的相关信息
        - `column` - `必选` `string`，列名
        - `encoding` - `必选` `string`，编码名及参数，使用`:`分割第一位为编码名，其后为参数，如`integer:8`表示编码为 Integer 长度为 8 的编码（dict,boolean,date,double,int,fixed_length,fixed_length_hex,integer,one_more_byte_vlong,time）无默认值
        - `encoding_version` - `非必选` `int`，编码版本，默认为：1
        - `isShardBy` - `非必选` `boolean`，是否为分片列，默认为：False
    - `global_dim_cap` - `非必选` `int`，Cube 级别最大维度组合数，默认为：0
    - `aggregation_groups` - `必选` `JSON Object`，维度聚合组相关信息
      - `includes` - `必选` `string`，所有维度
      - `select_rule` - `必选` `string`，聚合组选择规则
        - `hierarchy_dims` - `非必选` `string[]`，层级维度
        - `mandatory_dims` - `必选` `string[]`，必要维度
        - `joint_dims` - `非必选` `string[]`，联合维度
        - `dim_cap` - `非必选` `int`，聚合组级别最大维度组合数
    - `signature` - `非必选` `string[]`，Cube 的标记与 UUID 不同由 CubeDescData 中的 Dimensions，Measures 等信息计算出
    - `notify_list` - `非必选` `string[]`，邮件通知列表
    - `status_need_notify` - `非必选` `string`，需要通知的事件
    - `partition_date_start` - `非必选` `long`，开始时间分区，默认为：0
    - `partition_date_end` - `非必选` `long`，结束时间分区，默认为：3153600000000
    - `auto_merge_time_ranges` - `非必选` `long[]`，自动合并时间范围
    - `volatile_range` - `非必选` `long`，为 0 时将自动合并所有可以合并的 Segment，或 `auto_merge` 将不会合并最新的 Volatile 范围内的 Segment，默认为：0
    - `retention_range` - `非必选` `long`，为 0 时将会保留所有历史 Segment，或只保留一定时间范围内的 Segment，默认为：0
    - `engine_type` - `必选` `int`，计算引擎类型（0 :MR1, 2 :MR2, 4 :spark ... 可配）默认为：2
    - `storage_type` - `必选` `int`，存储类型（0 :HBASE, 1 :HYBRID, 2 :SHARDED_HBASE）默认为：0
    - `override_kylin_properties` - `Map<string,string>` `非必选`，覆盖 Kylin 配置
    - `cuboid_black_list` - `非必选` `long[]`，Cuboid 黑名单
    - `parent_forward` - `非必选` `int`，需要保留的父级 Cuboid 最低层数，默认为：3
    - `mandatory_dimension_set_list` - `非必选` `string[]`，必要维度集合列表
  - `rawTableDescData` - `非必选` `string`，索引列表（JSON Object String）
    - `uuid` - `非必选` `string`，唯一识别码，默认随机生成
    - `last_modified` - `非必选` `long`，最后修改时间（创建 Cube 中的索引时需要设为 0，修改 Cube 中的索引时需要设为上次修改时间）
    - `name` - `必选` `string`，Cube 名称
    - `model_name` - `必选` `string`，模型名称
    - `is_draft` - `非必选` `boolean`，是否为草稿
    - `columns` - `必选` `JSON Object[]`，字段的信息
      - `table` - `必选` `string`，表名
      - `column` - `必选` `string`，字段名
      - `index` - `非必选` `string`，索引类型（discrete,fuzzy），无默认值
      - `encoding` - `非必选` `string`，编码名及参数，使用`:`分割第一位为编码名，其后为参数，如`integer:8`表示编码为 Integer 长度为 8 的编码（boolean,date,double,int,fixed_length,fixed_length_hex,integer,one_more_byte_vlong,time）
      - `encoding_version` - `非必选` `int`，编码版本，默认为：1
      - `is_shardby` - `非必选` `boolean`，是否为分片字段
      - `is_sortby` - `非必选` `boolean` ，是否排序
    - `engine_type` - `非必选` `int`，计算引擎类型（0 :MR1, 2 :MR2, 4 :spark ... 可配）
    - `storage_type` - `非必选` `int`，存储类型（0 :HBASE, 1 :HYBRID, 2 :SHARDED_HBASE）默认为：0
    - `auto_merge_time_ranges` - `非必选` `long`，自动合并时间范围
  - `schedulerJobData` - `非必选` `string`，调度任务信息（JSON Object String）
    - `partition_interval` - `非必选` `long`，分区间隔
    - `repeat_count` - `非必选` `long`，重复执行次数
    - `repeat_interval` - `非必选` `long`，重复执行间隔
    - `startTime` - `非必选` `long`，开始时间
    - `scheduled_run_time` - `非必选` `long`，调动任务启动时间
    - `enabled` - `非必选` `boolean`，是否启用
  - `userDefinedColumnDescData` - `非必选` `string`，列的描述数据（JSON Object String）
    - `name` - `必选` `string`，Cube 名称
    - `dimensions` - `非必选` `JSON Object`，维度信息
      - `name` - `非必选` `string`，维度名
      - `table` - `非必选` `string`，表名
      - `column` - `非必选` `string`，字段名
      - `derived` - `非必选` `string`，衍生维度 
      

- Curl 请求示例
```sh
curl -X PUT \
'http://host:port/kylin/api/cubes' \
 -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8' \
//该示例为了展示直观，将 JSON Object String 展开，使用时需要进行压缩并转义
  -d '{"cubeDescData":"{
            "uuid":"e9863edd-f999-4ebc-8c89-bbf79a139e77", 
            "last_modified":1597826731416,
            "version":"3.4.0.0",
            "name":"test_cube",
            "is_draft":false,
            "model_name":"test_model",
            "description":"",
            "null_string":null,
            "dimensions":[
                {
                    "name":"SELLER_ID",
                    "table":"KYLIN_SALES",
                    "column":"SELLER_ID",
                    "derived":null
                },
                {
                    "name":"BUYER_ID",
                    "table":"KYLIN_SALES",
                    "column":"BUYER_ID",
                    "derived":null
                },
                {
                    "name":"ACCOUNT_COUNTRY",
                    "table":"KYLIN_ACCOUNT",
                    "column":null,
                    "derived":[
                        "ACCOUNT_COUNTRY"
                    ]
                },
                {
                    "name":"COUNTRY",
                    "table":"KYLIN_COUNTRY",
                    "column":null,
                    "derived":[
                        "COUNTRY"
                    ]
                },
                {
                    "name":"NAME",
                    "table":"KYLIN_COUNTRY",
                    "column":null,
                    "derived":[
                        "NAME"
                    ]
                }
            ],
            "measures":[
                {
                    "name":"_COUNT_",
                    "description":"",
                    "function":{
                        "expression":"COUNT",
                        "parameter":{
                            "type":"constant",
                            "value":"1"
                        },
                        "returntype":"bigint",
                        "semi_additive_info":null
                    }
                },
                {
                    "name":"PRICE_PLUS",
                    "description":"价格",
                    "function":{
                        "expression":"SUM",
                        "parameter":{
                            "type":"column",
                            "value":"KYLIN_SALES.REAL_PRICE"
                        },
                        "returntype":"bigint",
                        "semi_additive_info":{
                            "aggregation_func":"LastChild",
                            "order_by_column":"KYLIN_SALES.PART_DT"
                        }
                    }
                }
            ],
            "dictionaries":[
            
            ],
            "rowkey":{
                "rowkey_columns":[
                    {
                        "column":"KYLIN_SALES.SELLER_ID",
                        "encoding":"integer:8",
                        "encoding_version":1,
                        "isShardBy":false
                    },
                    {
                        "column":"KYLIN_SALES.BUYER_ID",
                        "encoding":"integer:8",
                        "encoding_version":1,
                        "isShardBy":false
                    },
                    {
                        "column":"KYLIN_ACCOUNT.ACCOUNT_COUNTRY",
                        "encoding":"dict",
                        "encoding_version":1,
                        "isShardBy":false
                    }
                ]
            },
            "global_dim_cap":2,
            "aggregation_groups":[
                {
                    "includes":[
                        "KYLIN_SALES.SELLER_ID",
                        "KYLIN_SALES.BUYER_ID",
                        "KYLIN_ACCOUNT.ACCOUNT_COUNTRY"
                    ],
                    "select_rule":{
                        "hierarchy_dims":[
            
                        ],
                        "mandatory_dims":[
                            "KYLIN_ACCOUNT.ACCOUNT_COUNTRY"
                        ],
                        "joint_dims":[
            
                        ],
                        "dim_cap":2
                    }
                }
            ],
            "signature":"r2YwZ3YSMLWFUwygYnxIuA==",
            "notify_list":[
            
            ],
            "status_need_notify":[
                "ERROR",
                "DISCARDED",
                "SUCCEED"
            ],
            "partition_date_start":0,
            "partition_date_end":3153600000000,
            "auto_merge_time_ranges":[
                604800000,
                2419200000
            ],
            "volatile_range":0,
            "retention_range":0,
            "engine_type":100,
            "storage_type":100,
            "override_kylin_properties":{
                "kap.smart.conf.aggGroup.strategy":"auto",
                "kylin.engine.mr.max-reducer-number":"5"
            },
            "cuboid_black_list":[
            
            ],
            "parent_forward":3,
            "mandatory_dimension_set_list":[
            
            ],
            "status":"DISABLED"
            }",
        "project":"zhimim_test",
        "rawTableDescData":"{
            "uuid":"300ef7b8-fbdd-4ad6-bae2-cd89414d5dcb",
            "last_modified":1597826731483,
            "version":"3.4.0.0",
            "name":"test_cube",
            "is_draft":false,
            "model_name":"test_model",
            "columns":[
                {
                    "table":"KYLIN_SALES",
                    "column":"REAL_PRICE",
                    "index":"discrete",
                    "encoding":"integer:4",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":true
                },
                {
                    "table":"KYLIN_SALES",
                    "column":"PART_DT",
                    "index":"discrete",
                    "encoding":"date",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":true
                },
                {
                    "table":"KYLIN_SALES",
                    "column":"SELLER_ID",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":false
                },
                {
                    "table":"KYLIN_SALES",
                    "column":"BUYER_ID",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":true,
                    "is_sortby":false
                },
                {
                    "table":"KYLIN_ACCOUNT",
                    "column":"ACCOUNT_ID",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":false
                },
                {
                    "table":"KYLIN_ACCOUNT",
                    "column":"ACCOUNT_COUNTRY",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":false
                },
                {
                    "table":"KYLIN_COUNTRY",
                    "column":"COUNTRY",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":false
                },
                {
                    "table":"KYLIN_COUNTRY",
                    "column":"NAME",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":false
                },
                {
                    "table":"KYLIN_SALES",
                    "column":"PRICE",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":false
                },
                {
                    "table":"KYLIN_SALES",
                    "column":"ITEM_COUNT",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":false
                }
            ],
            "engine_type":100,
            "storage_type":100,
            "auto_merge_time_ranges":null,
            "raw_table_mapping":{
                "column_family":[
                    {
                        "name":"F1",
                        "column_refs":[
                            "KYLIN_SALES.REAL_PRICE"
                        ]
                    },
                    {
                        "name":"F2",
                        "column_refs":[
                            "KYLIN_SALES.PART_DT"
                        ]
                    },
                    {
                        "name":"F3",
                        "column_refs":[
                            "KYLIN_SALES.SELLER_ID"
                        ]
                    },
                    {
                        "name":"F4",
                        "column_refs":[
                            "KYLIN_SALES.BUYER_ID"
                        ]
                    },
                    {
                        "name":"F5",
                        "column_refs":[
                            "KYLIN_ACCOUNT.ACCOUNT_ID"
                        ]
                    },
                    {
                        "name":"F6",
                        "column_refs":[
                            "KYLIN_ACCOUNT.ACCOUNT_COUNTRY"
                        ]
                    },
                    {
                        "name":"F7",
                        "column_refs":[
                            "KYLIN_COUNTRY.COUNTRY"
                        ]
                    },
                    {
                        "name":"F8",
                        "column_refs":[
                            "KYLIN_COUNTRY.NAME"
                        ]
                    },
                    {
                        "name":"F9",
                        "column_refs":[
                            "KYLIN_SALES.PRICE"
                        ]
                    },
                    {
                        "name":"F10",
                        "column_refs":[
                            "KYLIN_SALES.ITEM_COUNT"
                        ]
                    }
                ]
            }
        }",
        "schedulerJobData":"{
            "partition_interval":0,
            "repeat_count":65535,
            "repeat_interval":0,
            "startTime":0,
            "scheduled_run_time":1597855531593,
            "name":"test_cube",
            "project":"zhimim_test",
            "enabled":false
        }",
        "userDefinedColumnDescData":"{
            "uuid":"5cb41e74-a2ea-41fb-b64e-f2f3498c0424",
            "last_modified":1597826731615,
            "version":"3.4.0.0",
            "name":"test_cube",
            "dimensions":[
                {
                    "name":"PART_DT",
                    "table":"KYLIN_SALES",
                    "column":"PART_DT",
                    "derived":null
                },
                {
                    "name":"SELLER_ID",
                    "table":"KYLIN_SALES",
                    "column":"SELLER_ID",
                    "derived":null
                },
                {
                    "name":"BUYER_ID",
                    "table":"KYLIN_SALES",
                    "column":"BUYER_ID",
                    "derived":null
                },
                {
                    "name":"ACCOUNT_ID",
                    "table":"KYLIN_ACCOUNT",
                    "column":"ACCOUNT_ID",
                    "derived":null
                },
                {
                    "name":"ACCOUNT_COUNTRY",
                    "table":"KYLIN_ACCOUNT",
                    "column":"ACCOUNT_COUNTRY",
                    "derived":null
                },
                {
                    "name":"COUNTRY",
                    "table":"KYLIN_COUNTRY",
                    "column":"COUNTRY",
                    "derived":null
                },
                {
                    "name":"NAME",
                    "table":"KYLIN_COUNTRY",
                    "column":"NAME",
                    "derived":null
                }
            ]
        }"
}'
```

- 响应示例
```
{
    "code": "000",
    "data": {
        "schedulerJobData": "{
            "uuid":"902ceb9f-ada4-40a5-8d0c-3a1666fe2d61",
            "last_modified":1597827357796,
            "version":"3.4.0.0",
            "name":"test_cube",
            "project":"zhimim_test",
            "realization_type":"cube",
            "related_realization":"test_cube",
            "related_realization_uuid":"e9863edd-f999-4ebc-8c89-bbf79a139e77",
            "enabled":false,
            "partition_start_time":0,
            "scheduled_run_time":1597856157777,
            "repeat_count":65535,
            "cur_repeat_count":0,
            "repeat_interval":0,
            "partition_interval":0
        }",
        "cubeDescData": "{
            "uuid":"e9863edd-f999-4ebc-8c89-bbf79a139e77",
            "last_modified":1597827357595,
            "version":"3.4.0.0",
            "name":"test_cube",
            "is_draft":false,
            "model_name":"test_model",
            "description":"",
            "null_string":null,
            "dimensions":[
                {
                    "name":"SELLER_ID",
                    "table":"KYLIN_SALES",
                    "column":"SELLER_ID",
                    "derived":null
                },
                {
                    "name":"BUYER_ID",
                    "table":"KYLIN_SALES",
                    "column":"BUYER_ID",
                    "derived":null
                },
                {
                    "name":"ACCOUNT_COUNTRY",
                    "table":"KYLIN_ACCOUNT",
                    "column":null,
                    "derived":[
                        "ACCOUNT_COUNTRY"
                    ]
                },
                {
                    "name":"COUNTRY",
                    "table":"KYLIN_COUNTRY",
                    "column":null,
                    "derived":[
                        "COUNTRY"
                    ]
                },
                {
                    "name":"NAME",
                    "table":"KYLIN_COUNTRY",
                    "column":null,
                    "derived":[
                        "NAME"
                    ]
                }
            ],
            "measures":[
                {
                    "name":"_COUNT_",
                    "description":"",
                    "function":{
                        "expression":"COUNT",
                        "parameter":{
                            "type":"constant",
                            "value":"1"
                        },
                        "returntype":"bigint",
                        "semi_additive_info":null
                    }
                },
                {
                    "name":"PRICE_PLUS",
                    "description":"价格",
                    "function":{
                        "expression":"SUM",
                        "parameter":{
                            "type":"column",
                            "value":"KYLIN_SALES.REAL_PRICE"
                        },
                        "returntype":"bigint",
                        "semi_additive_info":{
                            "aggregation_func":"LastChild",
                            "order_by_column":"KYLIN_SALES.PART_DT",
                            "group_by_column":null
                        }
                    }
                }
            ],
            "dictionaries":[
        
            ],
            "rowkey":{
                "rowkey_columns":[
                    {
                        "column":"KYLIN_SALES.SELLER_ID",
                        "encoding":"integer:8",
                        "encoding_version":1,
                        "isShardBy":false
                    },
                    {
                        "column":"KYLIN_SALES.BUYER_ID",
                        "encoding":"integer:8",
                        "encoding_version":1,
                        "isShardBy":false
                    },
                    {
                        "column":"KYLIN_ACCOUNT.ACCOUNT_COUNTRY",
                        "encoding":"dict",
                        "encoding_version":1,
                        "isShardBy":false
                    }
                ]
            },
            "hbase_mapping":{
                "column_family":[
                    {
                        "name":"F1",
                        "columns":[
                            {
                                "qualifier":"M",
                                "measure_refs":[
                                    "_COUNT_"
                                ]
                            }
                        ]
                    },
                    {
                        "name":"F2",
                        "columns":[
                            {
                                "qualifier":"M",
                                "measure_refs":[
                                    "PRICE_PLUS"
                                ]
                            }
                        ]
                    }
                ]
            },
            "global_dim_cap":2,
            "aggregation_groups":[
                {
                    "includes":[
                        "KYLIN_SALES.SELLER_ID",
                        "KYLIN_SALES.BUYER_ID",
                        "KYLIN_ACCOUNT.ACCOUNT_COUNTRY"
                    ],
                    "select_rule":{
                        "hierarchy_dims":[
        
                        ],
                        "mandatory_dims":[
                            "KYLIN_ACCOUNT.ACCOUNT_COUNTRY"
                        ],
                        "joint_dims":[
        
                        ],
                        "dim_cap":2
                    }
                }
            ],
            "signature":"r2YwZ3YSMLWFUwygYnxIuA==",
            "notify_list":[
        
            ],
            "status_need_notify":[
                "ERROR",
                "DISCARDED",
                "SUCCEED"
            ],
            "partition_date_start":0,
            "partition_date_end":3153600000000,
            "auto_merge_time_ranges":[
                604800000,
                2419200000
            ],
            "volatile_range":0,
            "retention_range":0,
            "engine_type":100,
            "storage_type":100,
            "override_kylin_properties":{
                "kap.smart.conf.aggGroup.strategy":"auto",
                "kylin.engine.mr.max-reducer-number":"5"
            },
            "cuboid_black_list":[
        
            ],
            "parent_forward":3,
            "mandatory_dimension_set_list":[
        
            ]
        }",
        "cubeUuid": "e9863edd-f999-4ebc-8c89-bbf79a139e77",
        "userDefinedColumnDescData": "{
            "uuid":"5cb41e74-a2ea-41fb-b64e-f2f3498c0424",
            "last_modified":1597827357819,
            "version":"3.4.0.0",
            "name":"test_cube",
            "dimensions":[
                {
                    "name":"PART_DT",
                    "table":"KYLIN_SALES",
                    "column":"PART_DT",
                    "derived":null
                },
                {
                    "name":"SELLER_ID",
                    "table":"KYLIN_SALES",
                    "column":"SELLER_ID",
                    "derived":null
                },
                {
                    "name":"BUYER_ID",
                    "table":"KYLIN_SALES",
                    "column":"BUYER_ID",
                    "derived":null
                },
                {
                    "name":"ACCOUNT_ID",
                    "table":"KYLIN_ACCOUNT",
                    "column":"ACCOUNT_ID",
                    "derived":null
                },
                {
                    "name":"ACCOUNT_COUNTRY",
                    "table":"KYLIN_ACCOUNT",
                    "column":"ACCOUNT_COUNTRY",
                    "derived":null
                },
                {
                    "name":"COUNTRY",
                    "table":"KYLIN_COUNTRY",
                    "column":"COUNTRY",
                    "derived":null
                },
                {
                    "name":"NAME",
                    "table":"KYLIN_COUNTRY",
                    "column":"NAME",
                    "derived":null
                }
            ]
        }",
        "rawTableDescData": "{
            "uuid":"300ef7b8-fbdd-4ad6-bae2-cd89414d5dcb",
            "last_modified":1597827357677,
            "version":"3.4.0.0",
            "name":"test_cube",
            "is_draft":false,
            "model_name":"test_model",
            "columns":[
                {
                    "table":"KYLIN_SALES",
                    "column":"REAL_PRICE",
                    "index":"discrete",
                    "encoding":"integer:4",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":true
                },
                {
                    "table":"KYLIN_SALES",
                    "column":"PART_DT",
                    "index":"discrete",
                    "encoding":"date",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":true
                },
                {
                    "table":"KYLIN_SALES",
                    "column":"SELLER_ID",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":false
                },
                {
                    "table":"KYLIN_SALES",
                    "column":"BUYER_ID",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":true,
                    "is_sortby":false
                },
                {
                    "table":"KYLIN_ACCOUNT",
                    "column":"ACCOUNT_ID",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":false
                },
                {
                    "table":"KYLIN_ACCOUNT",
                    "column":"ACCOUNT_COUNTRY",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":false
                },
                {
                    "table":"KYLIN_COUNTRY",
                    "column":"COUNTRY",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":false
                },
                {
                    "table":"KYLIN_COUNTRY",
                    "column":"NAME",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":false
                },
                {
                    "table":"KYLIN_SALES",
                    "column":"PRICE",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":false
                },
                {
                    "table":"KYLIN_SALES",
                    "column":"ITEM_COUNT",
                    "index":"discrete",
                    "encoding":"orderedbytes",
                    "encoding_version":1,
                    "is_shardby":false,
                    "is_sortby":false
                }
            ],
            "engine_type":100,
            "storage_type":100,
            "auto_merge_time_ranges":null,
            "raw_table_mapping":{
                "column_family":[
                    {
                        "name":"F1",
                        "column_refs":[
                            "KYLIN_SALES.REAL_PRICE"
                        ]
                    },
                    {
                        "name":"F2",
                        "column_refs":[
                            "KYLIN_SALES.PART_DT"
                        ]
                    },
                    {
                        "name":"F3",
                        "column_refs":[
                            "KYLIN_SALES.SELLER_ID"
                        ]
                    },
                    {
                        "name":"F4",
                        "column_refs":[
                            "KYLIN_SALES.BUYER_ID"
                        ]
                    },
                    {
                        "name":"F5",
                        "column_refs":[
                            "KYLIN_ACCOUNT.ACCOUNT_ID"
                        ]
                    },
                    {
                        "name":"F6",
                        "column_refs":[
                            "KYLIN_ACCOUNT.ACCOUNT_COUNTRY"
                        ]
                    },
                    {
                        "name":"F7",
                        "column_refs":[
                            "KYLIN_COUNTRY.COUNTRY"
                        ]
                    },
                    {
                        "name":"F8",
                        "column_refs":[
                            "KYLIN_COUNTRY.NAME"
                        ]
                    },
                    {
                        "name":"F9",
                        "column_refs":[
                            "KYLIN_SALES.PRICE"
                        ]
                    },
                    {
                        "name":"F10",
                        "column_refs":[
                            "KYLIN_SALES.ITEM_COUNT"
                        ]
                    }
                ]
            }
        }"
    },
    "msg": ""
}
```

### 删除 Cube  {#删除Cube}

- `DELETE http://host:port/kylin/api/cubes/{projectName}/{cubeName}`

- URL Parameters

  - `projectName` - `必选` `string`，需要删除的 Cube 所属的项目名称
  - `cubeName` - `必选` `string`，需要删除的 Cube 名称
  
- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```
  curl -X DELETE \
    'http://host:port/kylin/api/cubes/test_kylin/test_cube' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
  ```  

### 克隆 Cube  {#克隆Cube}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/clone`

- URL Parameters

  - `cubeName` - `必选` `string`， 被克隆的 Cube 名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `cubeName` - `必选` `string`，克隆后的 Cube 名称
  - `project` - `必选` `string`，克隆后的项目名称 

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/clone' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{"cubeName":"kylin_sales_cube_clone",
  "project":"learn_kylin"}'
  ```


- 响应示例

  ```json
  {
      "code": "000",
      "data": {
          "uuid": "88670f47-1ce1-48fb-acf5-3aac63b04ccd",
          "last_modified": 1536563756734,
          "version": "3.0.0.1",
          "name": "kylin_sales_cube_clone",
          "owner": "ADMIN",
          "descriptor": "kylin_sales_cube_clone",
          "display_name": null,
          "cost": 786,
          "status": "DISABLED",
          "segments": [],
          "create_time_utc": 1536563756859,
          "cuboid_bytes": null,
          "cuboid_bytes_recommend": null,
          "cuboid_last_optimized": 0,
          "project": "learn_kylin",
          "model": "kylin_sales_model",
          "is_streaming": false,
          "partitionDateColumn": "KYLIN_SALES.PART_DT",
          "partitionDateStart": 1325376000000,
          "isStandardPartitioned": true,
          "size_kb": 0,
          "input_records_count": 0,
          "input_records_size": 0,
          "is_draft": false,
          "multilevel_partition_cols": [],
          "total_storage_size_kb": 0
      },
      "msg": ""
  }
  ```



### 启用 Cube   {#启用Cube}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/enable`

- URL Parameters

  - `cubeName` - `必选` `string`，Cube 名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/enable' \
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
          "uuid":"f2d467cb-db42-4b53-bb6f-74b35f19b793",
          "last_modified":1535686103823,
          "version":"3.0.0.1",
          "name":"kylin_sales_cube",
          "owner":"ADMIN",
          "descriptor":"kylin_sales_cube",
          "display_name":null,
          "cost":24,
          "status":"READY",
          "segments":[...],
          "create_time_utc":1535685965861,
          "cuboid_bytes":null,
          "cuboid_bytes_recommend":null,
          "cuboid_last_optimized":0,
          "project":"learn_kylin",
          "model":"KYLIN_SALES_MODEL",
          "is_streaming":false,
          "partitionDateColumn":null,
          "partitionDateStart":0,
          "isStandardPartitioned":false,
          "size_kb":5,
          "input_records_count":24,
          "input_records_size":540,
          "is_draft":false,
          "multilevel_partition_cols":[...],
          "total_storage_size_kb":5
      },
      "msg":""
  }
  ```



### 禁用 Cube  {#禁用Cube}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/disable`

- URL Parameters

  - `cubeName` - `必选` `string`，Cube 名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/disable' \
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
          "uuid":"f2d467cb-db42-4b53-bb6f-74b35f19b793",
          "last_modified":1535686103823,
          "version":"3.0.0.1",
          "name":"kylin_sales_cube",
          "owner":"ADMIN",
          "descriptor":"kylin_sales_cube",
          "display_name":null,
          "cost":24,
          "status":"DISABLED",
          "segments":[...],
          "create_time_utc":1535685965861,
          "cuboid_bytes":null,
          "cuboid_bytes_recommend":null,
          "cuboid_last_optimized":0,
          "project":"learn_kylin",
          "model":"KYLIN_SALES_MODEL",
          "is_streaming":false,
          "partitionDateColumn":null,
          "partitionDateStart":0,
          "isStandardPartitioned":false,
          "size_kb":5,
          "input_records_count":24,
          "input_records_size":540,
          "is_draft":false,
          "multilevel_partition_cols":[...],
          "total_storage_size_kb":5
      },
      "msg":""
  }
  ```



### 清理 Cube   {#清理Cube}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/purge`

- URL Parameters

  - `cubeName` - `必选` `string`， Cube 名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `project` - `必选` `string`，项目名称
  - `mpValues` - `可选` `string`，模型多级分区值，用于指定单个待清理的分区
  - `mpValuesSet` - `可选` `数组`, 模型多级分区值的数组，用于指定多个待清理的分区

> 注意：`mpValues`和`mpValuesSet`两个参数只需设置一个。如果两个参数同时设置，生效的待清理分区是两个参数值的全集。

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/{cubeName}/purge' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{"mpValues": "", "project": "learn_kylin", "mpValuesSet": ["value1", "value2"...]}'
  ```


- 响应示例

  ```json
  {
      "code":"000",
      "data":{
          "uuid":"f2d467cb-db42-4b53-bb6f-74b35f19b793",
          "last_modified":1535686103823,
          "version":"3.0.0.1",
          "name":"{cubeName}",
          "owner":"ADMIN",
          "descriptor":"{cubeName}",
          "display_name":null,
          "cost":24,
          "status":"DISABLED",
          "segments":[...],
          "create_time_utc":1535685965861,
          "cuboid_bytes":null,
          "cuboid_bytes_recommend":null,
          "cuboid_last_optimized":0,
          "project":"learn_kylin",
          "model":"{modelName}",
          "is_streaming":false,
          "partitionDateColumn":null,
          "partitionDateStart":0,
          "isStandardPartitioned":false,
          "size_kb":0,
          "input_records_count":0,
          "input_records_size":0,
          "is_draft":false,
          "multilevel_partition_cols":[...],
          "total_storage_size_kb":0
      },
      "msg":""
  }
  ```



### 列出 Cube 中的空洞  {#列出Cube中的空洞}

> **提示：** 生产系统上健康的 Cube 不应存在空洞，意味着 Cube 中的 Segment 应该在分区列上是连续的。

- `GET http://host:port/kylin/api/cubes/{cubeName}/holes`

- URL Parameters
  - `cubeName` - `必选` `string`, Cube 名称
  - `mpValues` - `可选` `string`, 多级分区值（只对于多级分区的 Cube 有效）

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/holes ' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- 响应示例

  ```json
  {
      "data": [{
      "code": "000",
          "uuid": null,
          "name": "20091110000000_20100110000000",
          "storage_location_identifier": null,
          "date_range_start": 1257811200000,
          "date_range_end": 1263081600000,
          "source_offset_start": 0,
          "source_offset_end": 0,
          "status": null,
          "size_kb": 0,
          "input_records": 0,
          "input_records_size": 0,
          "last_build_time": 0,
          "last_build_job_id": null,
          "create_time_utc": 0,
          "cuboid_shard_nums": {},
          "total_shards": 0,
          "blackout_cuboids": [],
          "binary_signature": null,
          "dictionaries": null,
          "global_dictionaries": null,
          "snapshots": null,
          "rowkey_stats": [],
          "project_dictionaries": {},
          "col_length_info": {}
      }],
      "msg": ""
  }
  ```



### 填充 Cube 中的空洞  {#填充Cube中的空洞}

> **提示:** 对于基于非流式数据源构建的 Cube, 系统将根据空洞的范围正常提交构建任务; 对于基于流式数据源构建的 Cube, 请确保补洞前, 流式数据源中的数据没有过期或删除, 否侧填充空洞构建任务将会失败。

- `PUT http://host:port/kylin/api/cubes/{cubeName}/holes`

- URL Parameters
  - `cubeName` - `必选` `string`, Cube 名称
  - `mpValues` - `可选` `string`, 多级分区值（只对于多级分区的 Cube 有效）

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/holes ' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```



### 导出 TDS   {#导出TDS}

- `GET http://host:port/kylin/api/cubes/{cubeName}/export/tds`

- URL Parameters

  - `cubeName` - `必选` `string`， Cube 名称
  - `windowUrl` - `必选` `string`，使用浏览器打开 Kyligence Enterprise 的 URL 前缀，如 `http://localhost:7070/kylin`
  - `containsTableIndex` - `可选` `boolean`，是否包含 table index 的列，默认值为 `false`
  - `connection` - `可选` `string`，选择导出 tds 的类型，可选值为 `odbc` 和 `connector`，分别表示通用 ODBC 格式和 tableau connector 格式，默认值为 `odbc`

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X GET \
    'http://localhost:7070/kylin/api/cubes/kylin_sales_cube/export/tds?windowUrl=http%3a%2f%2flocalhost%3a7070%2fkylin' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```



