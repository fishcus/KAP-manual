## Job REST API

> **提示**
>
> 使用API前请确保已阅读前面的**访问及安全认证**章节，知道如何在API中添加认证信息。
>


* [恢复 Job](#恢复job)
* [终止 Job](#终止job)
* [暂停 Job](#暂停job)
* [删除 Job](#删除job)
* [返回 Job 信息](#返回job信息)
* [返回 Job 每步输出](#返回job每步输出)
* [返回 Job 列表](#返回job列表)

### 恢复Job
`请求方式 PUT`

`访问路径 http://host:port/kylin/api/jobs/{jobId}/resume`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量
* jobId - `必选` `string` Job id.

#### 请求示例

`请求路径: http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/resume`

#### 响应信息

- uuid - Job id.
- last_modified - Job最后修改时间.
- name - Job名称.
- type - Job执行的任务类型，如（BUILD，MERGE，REFRESH）.
- duration - Job耗时.
- related_cube - Job相关联的Cube.
- related_segment - Job相关联的Segment.
- exec_start_time - 执行开始时间.
- exec_end_time - 执行结束时间.
- steps - 步骤.
- job_status - Job状态，如（RUNNING，PENDING，STOPPED，ERROR，DISCARDED，FINISHED）.
- progress - Job进度.

#### 响应示例
```json
{
   "code":"000",
   "data":{  
     "uuid":"c143e0e4-ac5f-434d-acf3-46b0d15e3dc6",
     "last_modified":1407908916705,
     "version": "3.0.0.1",
     "name":"test_kylin_cube_with_slr_empty - 19700101000000_20140731160000 - BUILD - PDT 2014-08-12 22:48:36",
     "type":"BUILD",
     "duration":0,
     "related_cube":"test_kylin_cube_with_slr_empty",
     "display_cube_name": "test_kylin_cube_with_slr_empty",
     "related_segment":"19700101000000_20140731160000",
     "exec_start_time":0,
     "exec_end_time":0,
     "exec_interrupt_time": 0,
     "mr_waiting":0,
     "steps":[  
      {  
         "interruptCmd":null,
         "id": "dd31d565-c450-4312-bd31-fd388d99bc88-00",
         "name":"Create Intermediate Flat Hive Table",
         "sequence_id":0,
         "exec_cmd":"hive -e \"DROP TABLE IF EXISTS kylin_intermediate_test_kylin_cube_with_slr_desc_19700101000000_20140731160000_c143e0e4_ac5f_434d_acf3_46b0d15e3dc6;\nCREATE EXTERNAL TABLE IF NOT EXISTS kylin_intermediate_test_kylin_cube_with_slr_desc_19700101000000_20140731160000_c143e0e4_ac5f_434d_acf3_46b0d15e3dc6\n(\nCAL_DT date\n,LEAF_CATEG_ID int\n,LSTG_SITE_ID int\n,META_CATEG_NAME string\n,CATEG_LVL2_NAME string\n,CATEG_LVL3_NAME string\n,LSTG_FORMAT_NAME string\n,SLR_SEGMENT_CD smallint\n,SELLER_ID bigint\n,PRICE decimal\n)\nROW FORMAT DELIMITED FIELDS TERMINATED BY '\\177'\nSTORED AS SEQUENCEFILE\nLOCATION '/tmp/kylin-c143e0e4-ac5f-434d-acf3-46b0d15e3dc6/kylin_intermediate_test_kylin_cube_with_slr_desc_19700101000000_20140731160000_c143e0e4_ac5f_434d_acf3_46b0d15e3dc6';\nSET mapreduce.job.split.metainfo.maxsize=-1;\nSET mapred.compress.map.output=true;\nSET mapred.map.output.compression.codec=com.hadoop.compression.lzo.LzoCodec;\nSET mapred.output.compress=true;\nSET mapred.output.compression.codec=com.hadoop.compression.lzo.LzoCodec;\nSET mapred.output.compression.type=BLOCK;\nSET mapreduce.job.max.split.locations=2000;\nSET hive.exec.compress.output=true;\nSET hive.auto.convert.join.noconditionaltask = true;\nSET hive.auto.convert.join.noconditionaltask.size = 300000000;\nINSERT OVERWRITE TABLE kylin_intermediate_test_kylin_cube_with_slr_desc_19700101000000_20140731160000_c143e0e4_ac5f_434d_acf3_46b0d15e3dc6\nSELECT\nTEST_KYLIN_FACT.CAL_DT\n,TEST_KYLIN_FACT.LEAF_CATEG_ID\n,TEST_KYLIN_FACT.LSTG_SITE_ID\n,TEST_CATEGORY_GROUPINGS.META_CATEG_NAME\n,TEST_CATEGORY_GROUPINGS.CATEG_LVL2_NAME\n,TEST_CATEGORY_GROUPINGS.CATEG_LVL3_NAME\n,TEST_KYLIN_FACT.LSTG_FORMAT_NAME\n,TEST_KYLIN_FACT.SLR_SEGMENT_CD\n,TEST_KYLIN_FACT.SELLER_ID\n,TEST_KYLIN_FACT.PRICE\nFROM TEST_KYLIN_FACT\nINNER JOIN TEST_CAL_DT\nON TEST_KYLIN_FACT.CAL_DT = TEST_CAL_DT.CAL_DT\nINNER JOIN TEST_CATEGORY_GROUPINGS\nON TEST_KYLIN_FACT.LEAF_CATEG_ID = TEST_CATEGORY_GROUPINGS.LEAF_CATEG_ID AND TEST_KYLIN_FACT.LSTG_SITE_ID = TEST_CATEGORY_GROUPINGS.SITE_ID\nINNER JOIN TEST_SITES\nON TEST_KYLIN_FACT.LSTG_SITE_ID = TEST_SITES.SITE_ID\nINNER JOIN TEST_SELLER_TYPE_DIM\nON TEST_KYLIN_FACT.SLR_SEGMENT_CD = TEST_SELLER_TYPE_DIM.SELLER_TYPE_CD\nWHERE (test_kylin_fact.cal_dt < '2014-07-31 16:00:00')\n;\n\"",
         "interrupt_cmd":null,
         "exec_start_time":0,
         "exec_end_time":0,
         "exec_wait_time":0,
         "step_status":"PENDING",
         "cmd_type":"SHELL_CMD_HADOOP",
         "info":null,
         "run_async":false
      },
      {  
         "interruptCmd":null,
         "id": "dd31d565-c450-4312-bd31-fd388d99bc88-01",
         "name":"Extract Fact Table Distinct Columns",
         "sequence_id":1,
         "exec_cmd":" -conf C:/kylin/Kylin/server/src/main/resources/hadoop_job_conf_medium.xml -cubename test_kylin_cube_with_slr_empty -input /tmp/kylin-c143e0e4-ac5f-434d-acf3-46b0d15e3dc6/kylin_intermediate_test_kylin_cube_with_slr_desc_19700101000000_20140731160000_c143e0e4_ac5f_434d_acf3_46b0d15e3dc6 -output /tmp/kylin-c143e0e4-ac5f-434d-acf3-46b0d15e3dc6/test_kylin_cube_with_slr_empty/fact_distinct_columns -jobname Kylin_Fact_Distinct_Columns_test_kylin_cube_with_slr_empty_Step_1",
         "interrupt_cmd":null,
         "exec_start_time":0,
         "exec_end_time":0,
         "exec_wait_time":0,
         "step_status":"PENDING",
         "cmd_type":"JAVA_CMD_HADOOP_FACTDISTINCT",
         "info":null,
         "run_async":true
      },
      {  
         "interruptCmd":null,
         "id": "dd31d565-c450-4312-bd31-fd388d99bc88-12",
         "name":"Load HFile to HBase Table",
         "sequence_id":12,
         "exec_cmd":" -input /tmp/kylin-c143e0e4-ac5f-434d-acf3-46b0d15e3dc6/test_kylin_cube_with_slr_empty/hfile/ -htablename KYLIN-CUBE-TEST_KYLIN_CUBE_WITH_SLR_EMPTY-19700101000000_20140731160000_11BB4326-5975-4358-804C-70D53642E03A -cubename test_kylin_cube_with_slr_empty",
         "interrupt_cmd":null,
         "exec_start_time":0,
         "exec_end_time":0,
         "exec_wait_time":0,
         "step_status":"PENDING",
         "cmd_type":"JAVA_CMD_HADOOP_NO_MR_BULKLOAD",
         "info":null,
         "run_async":false
      }
     ],
     "submitter": "ADMIN",
     "job_status":"PENDING",
     "progress":0.0},
  "msg":""
}
```

#### Curl 示例

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json'  http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/resume
```

### 终止Job

`请求方式 PUT`

`访问路径 http://host:port/kylin/api/jobs/{jobId}/cancel`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量
* jobId - `必选` `string` Job id.

#### 请求示例

`请求路径: http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/cancel`

#### 响应示例
(同 "恢复 job")

#### Curl 示例

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json'  http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/cancel
```

### 暂停Job

`请求方式 PUT`

`访问路径 http://host:port/kylin/api/jobs/{jobId}/pause`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量

- jobId - `必选` `string` Job id.

#### 请求示例

`请求路径: http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/pause`

#### 响应示例

(同 "恢复 job")

#### Curl 示例

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json'  http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/pause
```

### 删除Job

`请求方式 DELETE`

`访问路径 http://host:port/kylin/api/jobs/{jobId}/drop`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量

- jobId - `必选` `string` Job id.

#### 请求示例

`请求路径: http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/drop`

#### 响应示例

(同 "恢复 job")

#### Curl 示例

```
curl -X DELETE -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json'  http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/drop
```

### 返回Job信息

`请求方式 GET`

`访问路径 http://host:port/kylin/api/jobs/{jobId}`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量
* jobId - `必选` `string` Job id.

#### 请求示例

`请求路径: http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838`

#### 响应示例
(同 "恢复 Job")

#### Curl 示例

```
curl -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json'  http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838
```

### 返回Job每步输出

`请求方式 GET`

`访问路径 http://host:port/kylin/api/jobs/{jobId}/steps/{stepId}/output`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量
* jobId - `必选` `string` Job id.
* stepId - `必选` `string` 步骤 id;  步骤id由Job id和步骤序列id组成; 例如, jobId 是 "fb479e54-837f-49a2-b457-651fc50be110", 第三步 步骤 id 是 "fb479e54-837f-49a2-b457-651fc50be110-03", 

#### 请求示例

`请求路径:  http://host:port/kylin/api/jobs/fb479e54-837f-49a2-b457-651fc50be110/steps/fb479e54-837f-49a2-b457-651fc50be110-03/output`

#### 响应示例
```json
{  
   "code":"000",
   "data":{  
     "jobId":"fb479e54-837f-49a2-b457-651fc50be110",
     "cmd_output":"log string",
     "stepId": "fb479e54-837f-49a2-b457-651fc50be110-03"
   },
   "msg":""
}
```

#### Curl 示例

```
curl -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json'  http://host:port/kylin/api/jobs/fb479e54-837f-49a2-b457-651fc50be110/steps/fb479e54-837f-49a2-b457-651fc50be110-03/output
```

### 返回 Job 列表

`请求方式 GET`

`访问路径 http://host:port/kylin/api/jobs`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### 路径变量

- jobName - `可选` `string`，任务名称。
- projectName - `可选` `string` ，项目名称。
- status - `可选` `int` ，Job 状态，如 (NEW: 0, PENDING: 1, RUNNING: 2, STOPPED: 32, FINISHED: 4, ERROR: 8, DISCARDED: 16)
- pageOffset - `可选` `int` ，分页所用偏移。
- pageSize - `可选` `int`，每页返回的 Job。
- timeFilter - `必选` `int`，如 (LAST ONE DAY: 0, LAST ONE WEEK: 1, LAST ONE MONTH: 2, LAST ONE YEAR: 3, ALL: 4)。
- sortby -  `可选`  `string`，默认"last_modify"，排序字段。
- reverse - `可选` `boolean`，默认true，是否倒序。

#### 请求示例

`请求路径: http://host:port/kylin/api/jobs?status=&pageOffset=0&pageSize=10&projectName=TEST&timeFilter=1&jobName=&sortby=last_modify`

#### 响应示例

```json
{
    "code":"000",
    "data":{
       "size":1,
       "jobs":[
        { 
          "uuid": "9eb7bccf-4448-4578-9c29-552658b5a2ca", 
          "last_modified": 1490957579843, 
          "version": "3.0.0.1",
          "name": "Sample_Cube - 19700101000000_20150101000000 - BUILD - GMT+08:00 2017-03-31 18:36:08", 
          "type": "BUILD", 
          "duration": 936, 
          "related_cube": "Sample_Cube",
          "display_cube_name": "Sample_Cube",
          "related_segment": "53a5d7f7-7e06-4ea1-b3ee-b7f30343c723", 
          "exec_start_time": 1490956581743, 
          "exec_end_time": 1490957518131,
          "exec_interrupt_time": 0,
          "mr_waiting": 0, 
          "steps": [
            { 
              "interruptCmd": null, 
              "id": "9eb7bccf-4448-4578-9c29-552658b5a2ca-00", 
              "name": "Create Intermediate Flat Hive Table", 
              "sequence_id": 0, 
              "exec_cmd": null, 
              "interrupt_cmd": null, 
              "exec_start_time": 1490957508721, 
              "exec_end_time": 1490957518102, 
              "exec_wait_time": 0, 
              "step_status": "DISCARDED", 
              "cmd_type": "SHELL_CMD_HADOOP", 
              "info": { "endTime": "1490957518102", "startTime": "1490957508721" }, 
              "run_async": false 
            }, 
            { 
              "interruptCmd": null, 
              "id": "9eb7bccf-4448-4578-9c29-552658b5a2ca-01", 
              "name": "Redistribute Flat Hive Table", 
              "sequence_id": 1, 
              "exec_cmd": null, 
              "interrupt_cmd": null, 
              "exec_start_time": 0, 
              "exec_end_time": 0, 
              "exec_wait_time": 0, 
              "step_status": "DISCARDED", 
              "cmd_type": "SHELL_CMD_HADOOP", 
              "info": {}, 
              "run_async": false 
            }
          ],
          "submitter": "ADMIN", 
          "job_status": "FINISHED", 
          "progress": 100.0 
        }
       ]
    },
    "msg":""
}
```

#### Curl 示例

```
curl -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json'  http://host:port/kylin/api/jobs?timeFilter=1&pageOffset=0&pageSize=10&status=&projectName=your_project&jobName=&sortby=last_modify
```

### 