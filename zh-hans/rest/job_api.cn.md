## 任务 API

> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [返回任务列表](#返回任务列表)
* [返回任务信息](#返回任务信息)
* [返回任务某步输出](#返回任务某步输出)
* [暂停任务](#暂停任务)
* [恢复任务](#恢复任务)
* [终止任务](#终止任务)
* [删除任务](#删除任务)




### 返回任务列表

- `GET http://host:port/kylin/api/jobs`

- URL Parameters
  - `timeFilter` - `必选` `int`，时间范围。对应关系如下：“最近一天” ：0 ；“最近一周” ： 1；"最近一月" ：2；"最近一年" ：3；"所有" ：4
  - `jobName` - `可选` `string`，任务名称
  - `projectName` - `可选` `string`，项目名称
  - `status` - `可选` `int`，任务状态，对应关系如下：" NEW"：0；"PENDING"：1；"RUNNING"：2；"STOPPED"：32 ；"FINISHED"： 4；"ERROR"：8；"DISCARDED"： 16
  - `pageOffset` - `可选` `int`，每页返回的任务的偏移量
  - `pageSize` - `可选` `int`，每页返回的任务数量
  - `sortby` -  `可选`  `string`，排序字段，默认为 "last_modify"
  - `reverse` - `可选` `boolean`，是否倒序，默认为 "true"

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

```shell
  curl -X GET \
    'http://host:port/kylin/api/jobs?timeFilter=0&pageSize=1' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
```


- 响应示例

```JSON
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



### 返回任务信息

- `GET http://host:port/kylin/api/jobs/{jobId}`

- URL Parameters
  - `jobId` - `必选` `string`，任务对应的 Job ID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

```shell
  curl -X GET \
    'http://host:port/kylin/api/jobs/{jobId}' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
```


- 响应示例

```JSON
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



### 返回任务某步输出

- `GET http://host:port/kylin/api/jobs/{jobId}/steps/{stepId}/output`


- URL Parameters
  - `jobId` - `必选` `string`，任务对应的 Job ID
  - `stepId` - `必选` `string`，步骤对应的 ID，由 Job ID 和序列 ID 组成；例如，Job ID 是 "fb479e54-837f-49a2-b457-651fc50be110"，第三步的序列 ID 是 02，步骤 ID 是"fb479e54-837f-49a2-b457-651fc50be110-02"


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

```shell
  curl -X GET \
    'http://host:port/kylin/api/jobs/{jobId}/steps/{stepId}/output' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
```


- 响应示例

```JSON
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




### 暂停任务

- `PUT http://host:port/kylin/api/jobs/{jobId}/pause`

- URL Parameters
  - `jobId` - `必选` `string`，任务对应的 Job ID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

```shell
  curl -X PUT \
    'http://host:port/kylin/api/jobs/{jobId}/pause' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
```


- 响应示例

```JSON
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




### 恢复任务

- `PUT http://host:port/kylin/api/jobs/{jobId}/resume`

- URL Parameters
  - `jobId` - `必选` `string`，任务对应的 Job ID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

```shell
  curl -X PUT \
    'http://host:port/kylin/api/jobs/{jobId}/resume' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
```


- 响应示例

```JSON
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


- 响应信息

  - `uuid` - 任务对应的 Job ID
  - `last_modified` - 任务最后修改时间
  - `name` - 任务名称
  - `type` - 任务执行的任务类型，如 “BUILD”，“MERGE”，“REFRESH”
  - `duration` - 任务耗时
  - `related_cube` - 任务相关联的 Cube 
  - `related_segment` - 任务相关联的 segment
  - `exec_start_time` - 执行开始时间
  - `exec_end_time` - 执行结束时间
  - `steps` - 步骤
  - `job_status` - 任务状态，如 “RUNNING”，“PENDING”，“STOPPED”，“ERROR”，"DISCARDED"，"FINISHED"
  - `progress` - 任务进度




### 终止任务

- `PUT http://host:port/kylin/api/jobs/{jobId}/cancel`

- URL Parameters
  - `jobId` - `必选` `string`，任务对应的 Job ID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

```shell
  curl -X PUT \
    'http://host:port/kylin/api/jobs/{jobId}/cancel' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
```


- 响应示例

```JSON
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



### 删除任务

- `DELETE http://host:port/kylin/api/jobs/{jobId}/drop`

- URL Parameters
  - `jobId` - `必选` `string`，任务对应的 Job ID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

```shell
  curl -X DELETE \
    'http://host:port/kylin/api/jobs/0140b8e1-d74e-4c01-86d0-a114f59ba787/drop' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
```


- 响应示例

```JSON
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
