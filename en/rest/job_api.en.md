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
`Request Mode PUT`

`Access Path http://host:port/kylin/api/jobs/{jobId}/resume`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* jobId - `required` `string` job id.

#### Request Example

`Request Path: http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/resume`

#### Response Information

- uuid - job ID.
- last_modified - the last modified time of job.
- name - job name.
- type - job type, such as BUILD, MERGE, REFRESH.
- duration - job duration.
- related_cube - Cube related to job.
- related_segment - segment related to job.
- exec_start_time - start time of execution.
- exec_end_time - end time of execution.
- steps - steps executed.
- job_status - job status: RUNNING，PENDING，STOPPED，ERROR，DISCARDED，FINISHED.
- progress - job progress.

#### Response Example
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

#### Curl Example

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H 'Accept: application/vnd.apache.kylin-v2+json' -H "Content-Type:application/vnd.apache.kylin-v2+json"  http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/resume
```

### Discard Job

`Request Mode PUT`

`Access Path http://host:port/kylin/api/jobs/{jobId}/cancel`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* jobId - `required` `string` Job id.

#### Request Example

`Request Path: http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/cancel`

#### Response Example
(same as "Resume Job")

#### Curl Example

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H 'Accept: application/vnd.apache.kylin-v2+json'  http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/cancel
```

### Pause Job

`Request Mode PUT`

`Access Path http://host:port/kylin/api/jobs/{jobId}/pause`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable

- jobId - `required` `string` Job id.

#### Request Example

`Request Path: http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/pause`

#### Response Example

(same as "Resume Job")

#### Curl Example

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H 'Accept: application/vnd.apache.kylin-v2+json' -H "Content-Type:application/vnd.apache.kylin-v2+json"  http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/pause
```

### Drop Job

`Request Mode DELETE`

`Access Path http://host:port/kylin/api/jobs/{jobId}/drop`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable

- jobId - `required` `string` Job id.

#### Request Example

`Request Path: http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/drop`

#### Response Example

(same as "Resume Job")

#### Curl Example

```
curl -X DELETE -H "Authorization: Basic XXXXXXXXX" -H 'Accept: application/vnd.apache.kylin-v2+json' -H "Content-Type:application/vnd.apache.kylin-v2+json"  http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838/drop
```

### Get Job Status

`Request Mode GET`

`Access Path http://host:port/kylin/api/jobs/{jobId}`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* jobId - `required` `string` job id.

#### Request Example

`Request Path: http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838`

#### Response Example
(same as "Resume Job")

#### Curl Example

```
curl -H "Authorization: Basic XXXXXXXXX" -H 'Accept: application/vnd.apache.kylin-v2+json'  -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/jobs/7cba7f9d-7cd3-44e7-905c-9f88ff5ee838
```

### Get Job Step Output

`Request Mode GET`

`Access Path http://host:port/kylin/api/jobs/{jobId}/steps/{stepId}/output`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* jobId - `required` `string` job id.
* stepId - `required` `string` step id;  step id is consist of Job id and step sequence id. For example, job id is "fb479e54-837f-49a2-b457-651fc50be110", then step id of the third step is "fb479e54-837f-49a2-b457-651fc50be110-03".

#### Request Example

`Request Path: http://host:port/kylin/api/jobs/fb479e54-837f-49a2-b457-651fc50be110/steps/fb479e54-837f-49a2-b457-651fc50be110-03/output`

#### Response Example
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
#### Curl Example

```
curl -H "Authorization: Basic XXXXXXXXX" -H 'Accept: application/vnd.apache.kylin-v2+json' -H "Content-Type:application/vnd.apache.kylin-v2+json"   http://host:port/kylin/api/jobs/fb479e54-837f-49a2-b457-651fc50be110/steps/fb479e54-837f-49a2-b457-651fc50be110-03/output
```

### Get Job List

`Request Mode GET`

`Access Path http://host:port/kylin/api/jobs`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable

- jobName - `optional` `string` Cube name.
- projectName - `optional` `string` Project name.
- status - `optional` `int` Job status, e.g. (NEW: 0, PENDING: 1, RUNNING: 2, STOPPED: 32, FINISHED: 4, ERROR: 8, DISCARDED: 16)
- pageOffset - `optional` `int` Offset used by pagination.
- pageSize - `optional `int` Jobs per page.
- timeFilter - `required` `int`, e.g. (LAST ONE DAY: 0, LAST ONE WEEK: 1, LAST ONE MONTH: 2, LAST ONE YEAR: 3, ALL: 4).
- sortby - `optional` `string` default:"last_modyfy", sort field.
- reverse - `optional` `boolean` default:true.

#### Request Example

`Request Path: http://host:port/kylin/api/jobs?status=&pageOffset=0&pageSize=10&projectName=TEST&timeFilter=1&jobName=&sortby=last_modify`

#### Response Sample

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

#### Curl Example

```
curl -X GET -H "Authorization: Basic XXXXXXXXX" -H 'Accept: application/vnd.apache.kylin-v2+json'  -H "Content-Type:application/vnd.apache.kylin-v2+json"  http://host:port/kylin/api/jobs?timeFilter=1&pageOffset=0&pageSize=10&status=&projectName=your_project&jobName=&sortby=last_modify
```

