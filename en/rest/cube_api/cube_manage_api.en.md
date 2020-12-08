## Cube Manage API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](../authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Create a Cube](#Create-a-cube)
* [Delete a Cube](#Delete-a-cube)
* [Clone a Cube](#clone-a-cube)
* [Enable a Cube](#enable-a-cube)
* [Disable a Cube](#disable-a-cube)
* [Purge a Cube](#purge-a-cube)
* [Get Holes in Cube](#get-holes-in-cube)
* [Fill Holes in Cube](#fill-holes-in-cube)
* [Export TDS File](#export-tds-file)


### Create a Cube {#Create-a-cube}

- `PUT http://host:port/kylin/api/cubes`

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`
  
- HTTP Body: JSON Object
  - `project` - `required` `string`,Project name
  - `cubeDescData` - `required` `string`,Cube description information(JSON Object string)
    - `uuid` - `unrequired` `string`,Unique identification code,Default value: random generation
    - `last_modified` - `unrequired` `long`,Last modify time(When you create the cube, you need to set it to 0,If the cube already exists, it needs to be set to the last modification time)
    - `name` - `required` `string`,Cube name
    - `model_name` - `required` `string`,Model name
    - `is_draft` - `unrequired` `boolean`,Is it draft or not,Default value: false
    - `description` - `unrequired` `string`,Cube additional description
    - `null_string` - `unrequired` `string[]`,Null values for specific string values in Cuboid and rawTable(Like a 'null' string)
    - `dimensions` - `required` `JSON Object[]`,Dimensions information
      - `name` - `unrequired` `string`,Dimension name
      - `table` - `required` `string`,Table name
      - `column` - `required` `string`,Field name
      - `derived` - `unrequired` `string`,Derived dimension
    - `measures` - `required` `JSON Object[]`,Measures information
      - `name` - `required` `string`,Measures name
      - `description` - `unrequired` `string`,Measures description
      - `function` - `required` `JSON Object`,Function information
        - `expression` - `required` `string`,Expression
        - `parameter` - `required` `JSON Object`,Parameter information
          - `type` - `required` `string`,Parameter type(column,constant) no default value
          - `value` - `required` `string`,Parameter value
        - `returntype` - `required` `string`,Return value type(varchar,int,long...standard sql types) no default value
        - `semi_additive_info` - `unrequired` `JSON Object`,Semi-additive measures information
          - `aggregation_func` - `required` `string`,Aggregation function
          - `order_by_column` - `required` `string`,Order by field name
    - `rowkey` - `required` `JSON Object`,Row key information
      - `rowkey_columns` - `required` `JSON Object[]`,Row key columns information
        - `column` - `required` `string`,Columns name
        - `encoding` - `required` `string`,Encoding name and parameters,Use ':' to split the first digit as the code name, followed by a parameter,For example, 'Integer :8' represents an encoding of integer length 8(dict,boolean,date,double,int,fixed_length,fixed_length_hex,integer,one_more_byte_vlong,time) no default value
        - `encoding_version` - `unrequired` `int`,Encoding version,Default value:1
        - `isShardBy` - `unrequired` `boolean`,Is it shard by or not,Default value:false
    - `global_dim_cap` - `unrequired` `int`,Cube-level max dimension combination,Default value:0
    - `aggregation_groups` - `required` `JSON Object`,Aggregation groups information
      - `includes` - `required` `string`,All included dimensions
      - `select_rule` - `required` `string`,Aggregation group selection rules
        - `hierarchy_dims` - `unrequired` `string[]`,Hierarchy dimension
        - `mandatory_dims` - `required` `string[]`,Mandatory dimension
        - `joint_dims` - `unrequired` `string[]`,Joint dimension
        - `dim_cap` - `unrequired` `int`,Aggregation group-level max dimension combination
    - `signature` - `unrequired` `string[]`,A Different marker of Cube calculated from cubeDescData dimensions,measures and other information
    - `notify_list` - `unrequired` `string[]`,Mailing list
    - `status_need_notify` - `unrequired` `string`,Events that require notification
    - `partition_date_start` - `unrequired` `long`,Partition date start,Default value:0
    - `partition_date_end` - `unrequired` `long`,Partition date end,Default value:3153600000000
    - `auto_merge_time_ranges` - `unrequired` `long[]`,Auto merge time ranges
    - `volatile_range` - `unrequired` `long`,By default it's '0', which will auto merge all possible cube segments , or 'Auto Merge' will not merge latest [Volatile Range] time cube segments,Default value:0
    - `retention_range` - `unrequired` `long`,By default it's '0',which will keep all historic cube segments ,or will keep latest [Retention Threshold] time cube segments,Default value:0
    - `engine_type` - `required` `int`,Compute engine type(0 :MR1, 2 :MR2, 4 :spark ... configurable)Default value:2
    - `storage_type` - `required` `int`,Storage type(0 :HBASE, 1 :HYBRID, 2 :SHARDED_HBASE)Default value:0
    - `override_kylin_properties` - `Map<string,string>` `unrequired`,Override kylin properties
    - `cuboid_black_list` - `unrequired` `long[]`,Cuboid black list
    - `parent_forward` - `unrequired` `int`,The lowest level of parent cuboid needs to be preserved,Default value:3
    - `mandatory_dimension_set_list` - `unrequired` `string[]`,Mandatory dimension set list
  - `rawTableDescData` - `unrequired` `string`,The Raw Table description information(JSON Object string)
    - `uuid` - `unrequired` `string`,Unique identification code,Default value: random generation
    - `last_modified` - `unrequired` `long`,Last modify time(When you create the cube, you need to set it to 0,If the cube already exists, it needs to be set to the last modification time)
    - `name` - `required` `string`,Cube name
    - `model_name` - `required` `string`,Model name
    - `is_draft` - `unrequired` `boolean`,Is it draft or not
    - `columns` - `required` `JSON Object[]`,Field information
      - `table` - `required` `string`,Table name
      - `column` - `required` `string`,Field name
      - `index` - `unrequired` `string`,Index type(discrete,fuzzy),no default value
      - `encoding` - `unrequired` `string`,Encoding name and parameters,Use ':' to split the first digit as the code name, followed by a parameter,For example, 'Integer :8' represents an encoding of integer length 8(boolean,date,double,int,fixed_length,fixed_length_hex,integer,one_more_byte_vlong,time) no default value
      - `encoding_version` - `unrequired` `int`,Encoding version,Default value:1
      - `is_shardby` - `unrequired` `boolean`,Is it shard by or not,No default value
      - `is_sortby` - `unrequired` `boolean` `required`,Is it sort by or not,No default value
    - `engine_type` - `unrequired` `int`,Compute engine type(0 :MR1, 2 :MR2, 4 :spark ... configurable)
    - `storage_type` - `unrequired` `int`,Storage type(0 :HBASE, 1 :HYBRID, 2 :SHARDED_HBASE)Default value: 0
    - `auto_merge_time_ranges` - `unrequired` `long`,Auto merge time ranges
  - `schedulerJobData` - `unrequired` `string`,Scheduler job description information(JSON Object string)
    - `partition_interval` - `unrequired` `long`,Partition interval
    - `repeat_count` - `unrequired` `long`,Repeat times
    - `repeat_interval` - `unrequired` `long`,Repeat interval
    - `startTime` - `unrequired` `long`,Start time
    - `scheduled_run_time` - `unrequired` `long`,Scheduled run time
    - `enabled` - `unrequired` `boolean`,Is it enabled or not
  - `userDefinedColumnDescData` - `unrequired` `string`,Column description information(JSON Object string)
    - `name` - `required` `string`,Cube name
    - `dimensions` - `unrequired` `JSON Object`,Dimensions information
      - `name` - `unrequired` `string`,Dimension name
      - `table` - `unrequired` `string`,Table name
      - `column` - `unrequired` `string`,Field name
      - `derived` - `unrequired` `string`,Derived dimension name
      

- Curl Request Example
```sh
curl -X PUT \
'http://host:port/kylin/api/cubes' \
 -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: en' \
  -H 'Authorization: JSESSIONID=B660917F51343328B517595714A2F5D4' \
  -H 'Content-Type: application/json;charset=utf-8' \
// For the sake of intuition, this example expands the JSON Object String, which needs to be compressed and escaped when used
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

- Example
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

### Delete a Cube  {#Delete-a-cube}

- `DELETE http://host:port/kylin/api/cubes/{projectName}/{cubeName}`

- URL Parameters

  - `projectName` - `required` `string`,The name of the project to which the Cube belongs that needs to be deleted
  - `cubeName` - `required` `string`,The name of the Cube that needs to be deleted
  
- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```
  curl -X DELETE \
    'http://host:port/kylin/api/cubes/test_kylin/test_cube' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
  ```



### Clone a Cube  {#clone-a-cube}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/clone`


- URL Parameters
  - `cubeName` - `required` `string`,  cube name of being cloned


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `cubeName` - `required` `string`,  cube name to be cloned to
  - `project` - `required` `string`, project name 


- Curl Request Example

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

- Response Example
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



### Enable a Cube {#enable-a-cube}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/enable`


- URL Parameters
  - `cubeName` - `required` `string`, cube name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/enable' \
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



### Disable a Cube  {#disable-a-cube}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/disable`


- URL Parameters
  - `cubeName` - `required` `string`, cube name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/disable' \
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



### Purge a Cube  {#purge-a-cube}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/purge`

- URL Parameters

  - `cubeName` - `required` `string`,  cube name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `project` - `required` `string`, project name
  - `mpValues` - `optional` `string`, multiple partition value of corresponding model, used to specify one partition to clean up its data
  - `mpValuesSet` - `optional` `array`, several multiple partition values of corresponding model, used to specify multiple partitions to clean up its data

> Hint: Please choose one between `mpValues` and `mpValuesSet` according to your requirement. The union will take effect if you used both of them in the request. 

- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/{cubeName}/purge' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{"mpValues": "", "project": "learn_kylin", "mpValuesSet": ["value1", "value2"...]}'
  ```


- Response Example

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



### Get Holes in Cube   {#get-holes-in-cube}

> **Note:** A healthy cube in production should not have holes in the meaning of inconsecutive segments.

- `GET http://host:port/kylin/api/cubes/{cubeName}/holes`

- URL Parameters
  - `cubeName` - `required` `string`, cube name
  - `mpValues` - `optional` `string`, multiple partition values (only applies to multi-partitioned cube)

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/holes' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

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

### Fill Holes in Cube {#fill-holes-in-cube}

> **Note:** For non-streaming data based Cube, Kyligence Enterprise will submit normal build cube job(s) with corresponding time partition value range(s); For streaming data based Cube, please make sure that corresponding data is not expired or deleted in source before filling holes, otherwise the build job will fail.

- `PUT http://host:port/kylin/api/cubes/{cubeName}/holes`

- URL Parameters
  - `cubeName` - `required` `string`, cube name
  - `mpValues` - `optional` `string`, multiple partition values (only applies to multi-partitioned cube)

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/holes' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


### Export TDS File   {#export-tds-file}

- `GET http://host:port/kylin/api/cubes/{cubeName}/export/tds`

- URL Parameters

  - `cubeName` - `required` `string`,  cube name
  - `windowUrl` - `required` `string`, url of Kyligence Enterprise windows, for example, `http://localhost:7070/kylin`
  - `containsTableIndex` - `optional` `boolean`, whether includes the columns set to table index, the default value is `false`
  - `connection` - `optional` `string`, Select how to connect data source, the optional values are `odbc` ( generic odbc ) and `connector` ( tableau connector ), the default value is `odbc` 

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://localhost:7070/kylin/api/cubes/kylin_sales_cube/export/tds?windowUrl=http%3a%2f%2flocalhost%3a7070%2fkylin' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```



