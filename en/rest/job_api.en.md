## Job REST API

> **Tip**
>
> Before using API, please make sure that you have read the Access and Authentication in advance and know how to add verification information. 
>


* [Resume Job](#resume-job)
* [Discard Job](#discard-job)
* [Pause Job](#pause-job)
* [Drop Job](#drop-job)
* [Get Job Status](#get-job-status)
* [Get Job Step Output](#get-job-step-output)
* [Get Job List](#get-job-list)

### Resume Job
`Rquest Mode PUT`

`Access Path http://host:port/kylin/api/jobs/{jobId}/resume`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### Path Variable
* jobId - `required` `string` job id.

#### Response Example
```
{  
   "uuid":"c143e0e4-ac5f-434d-acf3-46b0d15e3dc6",
   "last_modified":1407908916705,
   "name":"test_kylin_cube_with_slr_empty - 19700101000000_20140731160000 - BUILD - PDT 2014-08-12 22:48:36",
   "type":"BUILD",
   "duration":0,
   "related_cube":"test_kylin_cube_with_slr_empty",
   "related_segment":"19700101000000_20140731160000",
   "exec_start_time":0,
   "exec_end_time":0,
   "mr_waiting":0,
   "steps":[  
      {  
         "interruptCmd":null,
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
   "job_status":"PENDING",
   "progress":0.0
}
```

### Discard Job
`Request Mode PUT`

`Access Path http://host:port/kylin/api/jobs/{jobId}/cancel`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### Path Variable
* jobId - `required` `string` Job id.

#### Response Example
(same as "Resume Job")

### Pause Job

`Request Mode PUT`

`Access Path http://host:port/kylin/api/jobs/{jobId}/pause`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### Path Variable

- jobId - `required` `string` Job id.

#### Response Example

(same as "Resume Job")

### Drop Job

`Request Mode DELETE`

`Access Path http://host:port/kylin/api/jobs/{jobId}/drop`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### Path Variable

- jobId - `required` `string` Job id.

#### Response Example

(same as "Resume Job")

### Get Job Status
`GET /jobs/{jobId}`

#### Path Variable
* jobId - `required` `string` job id.

#### Response Example
(same as "Resume Job")

### Get Job Step Output
`GET /{jobId}/steps/{stepId}/output`

#### Path Variable
* jobId - `required` `string` job id.
* stepId - `required` `string` step id;  step id is consist of Job id and step sequence id. For example, job id is "fb479e54-837f-49a2-b457-651fc50be110", then step id of the third step is "fb479e54-837f-49a2-b457-651fc50be110-3".

#### Response Example
```
{  
   "cmd_output":"log string"
}
```
### Get Job List

`GET /kylin/api/jobs`

#### Path Variable

- cubeName - `required` `string` Cube name.
- projectName - `required` `string` Project name.
- status - `required` `int` Job status, e.g. (NEW: 0, PENDING: 1, RUNNING: 2, STOPPED: 32, FINISHED: 4, ERROR: 8, DISCARDED: 16)
- offset - `required` `int` Offset used by pagination.
- limit - `required` `int` Jobs per page.
- timeFilter - `required` `int`, e.g. (LAST ONE DAY: 0, LAST ONE WEEK: 1, LAST ONE MONTH: 2, LAST ONE YEAR: 3, ALL: 4)

#### Response Sample

```
[
  { 
    "uuid": "9eb7bccf-4448-4578-9c29-552658b5a2ca", 
    "last_modified": 1490957579843, 
    "version": "2.0.0", 
    "name": "Sample_Cube - 19700101000000_20150101000000 - BUILD - GMT+08:00 2017-03-31 18:36:08", 
    "type": "BUILD", 
    "duration": 936, 
    "related_cube": "Sample_Cube", 
    "related_segment": "53a5d7f7-7e06-4ea1-b3ee-b7f30343c723", 
    "exec_start_time": 1490956581743, 
    "exec_end_time": 1490957518131, 
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
```

------