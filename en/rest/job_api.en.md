## Job API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Get Job List](#Get-Job-List)
* [Get Job Information](#Get-Job-Information)
* [Get Job Step Output](#Get-Job-Step-Output)
* [Pause a Job](#Pause-a-Job)
* [Resume a Job](#Resume-a-Job)
* [Discard a Job](#Cancel-a-Job)
* [Delete a Job](#Delete-a-Job)



### Get Job List {#Get-Job-List}

- `GET http://host:port/kylin/api/jobs`

- URL Parameters
  - `timeFilter` - `required` `int`

    | Time Range     | Value |
    | -------------- | ----- |
    | LAST ONE DAY   | 0     |
    | LAST ONE WEEK  | 1     |
    | LAST ONE MONTH | 2     |
    | LAST ONE YEAR  | 3     |
    | ALL            | 4     |

  - `jobName` - `optional` `string`, job name

  - `projectName` - `optional` `string`, project name

  - `status` - `optional` `int`

    | Job Status | Value |
    | ---------- | ----- |
    | NEW        | 0     |
    | PENDING    | 1     |
    | RUNNING    | 2     |
    | FINISHED   | 4     |
    | ERROR      | 8     |
    | DISCARDED  | 16    |
    | STOPPED    | 32    |

  - `pageOffset` - `optional` `int`, offset of returned result, 0 by default

  - `pageSize` - `optional` `int`, quantity of returned result per page, 10 by default

  - `sortby` -  `optional`  `string`, sort field,  "last_modify" by default

  - `reverse` - `optional` `boolean`, whether sort reverse, "true" by default

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/jobs?timeFilter=0&pageSize=1' \
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
          "size":1,
          "jobs":[
              {
                  "uuid":"05926c0e-7785-4691-8e23-3441c9baebfa",
                  "last_modified":1536748978697,
                  "version":"3.0.0.1",
                  "name":"BUILD CUBE - kylin_sales_cube - 20140101000000_20140102000000 - GMT+00:00 2018-09-12 10:00:03",
                  "type":"BUILD",
                  "duration":2573,
                  "related_cube":"kylin_sales_cube",
                  "display_cube_name":"kylin_sales_cube",
                  "related_segment":"a1b61f36-c2e7-4185-b6a9-8974606502ab",
                  "exec_start_time":0,
                  "exec_end_time":0,
                  "exec_interrupt_time":0,
                  "mr_waiting":280,
                  "steps":[...],
                  "submitter":"ADMIN",
                  "job_status":"FINISHED",
                  "progress":100
              }
          ]
      },
      "msg":""
  }
  
  ```



### Get Job Information {#Get-Job-Information}

- `GET http://host:port/kylin/api/jobs/{jobId}`

- URL Parameters

  - `jobId` - `required` `string`, Job ID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    http://host:port/kylin/api/jobs/{jobId} \
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
          "uuid":"a82a2ce1-bef2-4af2-a08e-adaa58fecada",
          "last_modified":1535696142826,
          "version":"3.0.0.1",
          "name":"BUILD CUBE - {cubeName} - FULL_BUILD - GMT+08:00 2018-08-31 11:29:43",
          "type":"BUILD",
          "duration":1494,
          "related_cube":"{cubeName}",
          "display_cube_name":"{cubeName}",
          "related_segment":"5a8220bf-59ff-438c-bd4b-0e567341dbb4",
          "exec_start_time":0,
          "exec_end_time":0,
          "exec_interrupt_time":0,
          "mr_waiting":202,
          "steps":[...],
          "submitter":"ADMIN",
          "job_status":"FINISHED",
          "progress":100
      },
      "msg":""
  }
  
  ```



### Get Job Step Output {#Get-Job-Step-Output}

- `GET http://host:port/kylin/api/jobs/{jobId}/steps/{stepId}/output`

- URL Parameters
  - `jobId` - `required` `string`, Job ID
  - `stepId` - `required` `string`, Step ID, which consists of Job ID and step sequence id, eg,.  Job ID is "fb479e54-837f-49a2-b457-651fc50be110", and the step sequence ID is "02",  then the Step ID is "fb479e54-837f-49a2-b457-651fc50be110-02"

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/jobs/{jobId}/steps/{stepId}/output' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```json
  {
      "code": "000",
      "data": {
          "jobId": "a54683d7-2a54-4717-ab44-2bf7107c4be5",
          "cmd_output": "result code:0",
          "stepId": "a54683d7-2a54-4717-ab44-2bf7107c4be5-02"
      },
      "msg": ""
  }
  ```



### Pause a Job {#Pause-a-Job}

- `PUT http://host:port/kylin/api/jobs/{jobId}/pause`

- URL Parameters

  - `jobId` - `required` `string`, Job ID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/jobs/{jobId}/pause' \
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
          "uuid":"9277ca7a-7d99-456e-827c-2ebd1371c210",
          "last_modified":1536739063548,
          "version":"3.0.0.1",
          "name":"BUILD CUBE - kylin_sales_cube - 20140101000000_20140101000000 - GMT+08:00 2018-09-10 14:37:23",
          "type":"BUILD",
          "duration":13405,
          "related_cube":"kylin_sales_cube",
          "display_cube_name":"kylin_sales_cube",
          "related_segment":"01c4a559-ed4a-4273-803d-acade58f4676",
          "exec_start_time":0,
          "exec_end_time":0,
          "exec_interrupt_time":0,
          "mr_waiting":147,
          "steps":[...],
          "submitter":"ADMIN",
          "job_status":"STOPPED",
          "progress":19.444444444444443
      },
      "msg":""
  }
  ```



### Resume a Job {#Resume-a-Job}

- `PUT http://host:port/kylin/api/jobs/{jobId}/resume`

- URL Parameters

  - `jobId` - `required` `string`, Job ID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/jobs/{jobId}/resume' \
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
          "uuid":"5b30c6b2-d950-4085-8e4e-cd8bc94e0d69",
          "last_modified":1536737919796,
          "version":"3.0.0.1",
          "name":"BUILD CUBE - kylin_sales_cube - 20140101000000_20140101000000 - GMT+08:00 2018-09-07 11:45:07",
          "type":"BUILD",
          "duration":283211,
          "related_cube":"kylin_sales_cube",
          "display_cube_name":"kylin_sales_cube",
          "related_segment":"12fdbe4d-00c8-484e-8bd5-363f3fce87ce",
          "exec_start_time":0,
          "exec_end_time":0,
          "exec_interrupt_time":0,
          "mr_waiting":455,
          "steps":[...],
          "submitter":"ADMIN",
          "job_status":"PENDING",
          "progress":13.88888888888889
      },
      "msg":""
  }
  ```

- Response Information

  - `uuid` - Job ID
  - `last_modified` - last mofidied time of the job
  - `name` - job name
  - `type` - job type, ie., "BUILD", "MERGE", "REFRESH"
  - `duration` - job duration
  - `related_cube` - Cube related to job
  - `related_segment` - segment related to job
  - `exec_start_time` - start time of execution
  - `exec_end_time` - end time of execution
  - `steps` - steps executed
  - `job_status` -  job status, ie., "RUNNING", "PENDING", "STOPPED", "ERROR", "DISCARDED", "FINISHED"
  - `progress` -  job progress



### Discard a Job {#Cancel-a-Job}

- `PUT http://host:port/kylin/api/jobs/{jobId}/cancel`

- URL Parameters

  - `jobId` - `required` `string`, Job ID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/jobs/{jobId}/cancel' \
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
          "uuid":"5b30c6b2-d950-4085-8e4e-cd8bc94e0d69",
          "last_modified":1536738761394,
          "version":"3.0.0.1",
          "name":"BUILD CUBE - kylin_sales_cube - 20140101000000_20140101000000 - GMT+08:00 2018-09-07 11:45:07",
          "type":"BUILD",
          "duration":284053,
          "related_cube":"kylin_sales_cube",
          "display_cube_name":"kylin_sales_cube",
          "related_segment":"12fdbe4d-00c8-484e-8bd5-363f3fce87ce",
          "exec_start_time":0,
          "exec_end_time":0,
          "exec_interrupt_time":0,
          "mr_waiting":911,
          "steps":[...],
          "submitter":"ADMIN",
          "job_status":"DISCARDED",
          "progress":36.111111111111114
      },
      "msg":""
  }
  ```



### Delete a Job {#Delete-a-Job}

- `DELETE http://host:port/kylin/api/jobs/{jobId}/drop`

- URL Parameters

  - `jobId` - `required` `string`, Job ID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X DELETE \
    'http://host:port/kylin/api/jobs/0140b8e1-d74e-4c01-86d0-a114f59ba787/drop' \
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
          "uuid":"0140b8e1-d74e-4c01-86d0-a114f59ba787",
          "last_modified":1536757263622,
          "version":"3.0.0.1",
          "name":"BUILD CUBE - {cubeName} - FULL_BUILD - GMT+08:00 2018-08-29 14:53:42",
          "type":"BUILD",
          "duration":221,
          "related_cube":"{cubeName}",
          "display_cube_name":"{cubeName}",
          "related_segment":"369fc50c-bf6e-474c-a07f-a572c4404bee",
          "exec_start_time":0,
          "exec_end_time":0,
          "exec_interrupt_time":0,
          "mr_waiting":18,
          "steps":[...],
          "submitter":"ADMIN",
          "job_status":"DISCARDED",
          "progress":31.25
      },
      "msg":""
  }
  ```
