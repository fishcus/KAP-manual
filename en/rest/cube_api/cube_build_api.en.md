## Cube Build API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](../authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Full Build a Cube ](#full-build-a-cube)
* [Build a Cube by date/time](#build-a-cube-by-date-time)
* [Build a streaming cube](#build-a-streaming-cube)
* [Build a Cube by file](#build-a-cube-by-file)
* [Customize build](#customize-build)
* [Build a Cube in batch](#build-a-cube-in-batch)



### Full Build a Cube   {#full-build-a-cube}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build`
- URL Parameters

  - `cubeName` - `required` `string`, cube name
- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`
- HTTP Body: JSON Object
  - `startTime` - `required` `long`, start time,  0
  - `endTime` - `required` `long`, end time,  0
  - `buildType` - `required` `string`, supported build type, "BUILD"
  - `mpValues` - `optional` `string`, multiple partition values of corresponding model
  - `force` - `optional` `boolean`, force submit mode, default is false

- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/{cubeName}/segments/build' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
  	"startTime": 0,
  	"endTime": 0,
  	"buildType": "BUILD"
  }'
  ```

- Response Example

  ```json
  {
      "code":"000",
      "data":{
          "uuid":"f055ceaa-4fa0-45ca-b862-ed52b1531ca6",
          "last_modified":1536302880808,
          "version":"3.0.0.1",
          "name":"BUILD CUBE - {cubeName}- FULL_BUILD - GMT+08:00 2018-09-07 14:48:00",
          "type":"BUILD",
          "duration":0,
          "related_cube":"{cubeName}",
          "display_cube_name":"{cubeName}",
          "related_segment":"5eda2c50-270c-4913-bf00-d8f006890a34",
          "exec_start_time":0,
          "exec_end_time":0,
          "exec_interrupt_time":0,
          "mr_waiting":0,
          "steps":[...],
          "submitter":"ADMIN",
          "job_status":"PENDING",
          "progress":0
      },
      "msg":""
  }
  ```



### Build a Cube by date/time {#build-a-cube-by-date-time}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build`

- URL Parameters

  - `cubeName` - `required` `string`, cube name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `startTime` - `required` `long`, start time, corresponding to the timestamp in GMT format,  for example, `1388534400000` corresponding to `2014-01-01 00:00:00`，[Unix Timestamp Conversion Tools](https://www.epochconverter.com/) can be used to convert date to timestamp
  - `endTime` - `required` `long`, end time, corresponding to the timestamp in GMT format
  - `buildType` - `required` `string`,supported build type, "BUILD"
  - `mpValues` - `optional` `string`, multiple partition values of corresponding model
  - `force` - `optional` `boolean`, force submit mode, default is false

  > **Note：**If your source data gets updated frequently and you need to refresh corresponding cube data accordingly, you can use this "force" option to build the segment in one step. Kyligence Enterprise will handle existing cube segment or job **with exactly the same time partition** automatically explained as below:
  >
  > - When there is no existing job or cube segment with the same time partition, this job will be sumitted without any special handling.
  > - When the cube contains the same successfully built segment, the new job will become a cube segment refresh job.
  > - When the cube contains a failed job with status error for this same segment, Kyligence Enterprise will discard the failed job before sumitting the new job.
  > - When the cube contains a running job or a pending job in the queue for the same segment, Kyligence Enterprise will discard the job before sumitting the new job.


- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/segments/build' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
  	"startTime": 0,
  	"endTime": 1388534400000,
  	"buildType": "BUILD",
  	"force": false
  }'
  ```

- Response Example

  ```json
  {
      "code":"000",
      "data":{
          "uuid":"83c6cd7a-61ce-4d66-9bd3-fea35487dcf7",
          "last_modified":1536289966183,
          "version":"3.0.0.1",
          "name":"BUILD CUBE - kylin_sales_cube - 20120415114212_20140101000000 - GMT+08:00 2018-09-07 11:12:45",
          "type":"BUILD",
          "duration":0,
          "related_cube":"kylin_sales_cube",
          "display_cube_name":"kylin_sales_cube",
          "related_segment":"739453a4-d59d-4a27-af37-d06d16ca17b1",
          "exec_start_time":0,
          "exec_end_time":0,
          "exec_interrupt_time":0,
          "mr_waiting":0,
          "steps":[...],
          "submitter":"ADMIN",
          "job_status":"PENDING",
          "progress":0
      },
      "msg":""
  }
  ```



### Build a Cube by file {#build-a-cube-by-file}
Given new Hive data files, build a new cube segment and load data into it.

* `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_by_files`

* URL Parameters

  * `cubeName` - `required` `string`, the name of the cube to operate on.

* HTTP Header

  * `Content-Type: application/json;charset=utf-8`
  * `Accept: application/vnd.apache.kylin-v2+json`
  * `Accept-Language: en` 

* HTTP Body: JSON Object

  * `startOffset` - `required` `long`, the start value (inclusive) of the new segment range. Should be a number that represents a point in time. For example, with the "YYYYMMDD+Hour+BatchNum" format, 2018042210000 stands for the 1st batch of 10 am 2018-4-22. The last 3 digits is batch sequence number.

  * `endOffset` - `optional` `long`, the end value (exclusive) of the new segment range. When omitted, the system will automatically determine the range based on existing segments and the given `startOffset`. The typical usage is requesting multiple builds in a row with the same `startOffset`, and the system will figure out the batch numbers automatically. For example, if request new builds with `startOffset=2018042210000` for 3 times in a row, the resulted segment ranges will be [2018042210000, 2018042210001), [2018042210001, 2018042210002), [2018042210002, 2018042210003).

  * `buildType` - `required` `string`, the build type must be `BUILD`.

  * `mpValues` - `optional` `string`, multiple partition values of corresponding model.

  * `force` - `optional` `boolean`, force submit mode, default is false.

  * `files` - `required` `string[]`, the absolute paths of the new data files on HDFS.

    > Note: In order to prevent unintentional duplicated data, the system don't allow one file be imported multiple times into a cube.

* Curl Request Example

  ```sh
  curl -X PUT \
  	-H "Authorization: Basic XXXXXXXXX" \
  	-H "Content-Type: application/json;charset=utf-8" \
  	-H "Accept: application/vnd.apache.kylin-v2+json" \
  	-d '{
  	"startOffset":2018042210000, 
  	"buildType":"BUILD", 
  	"files":["/sample/path/file1"]
  	}' 
  	http://localhost:port/kylin/api/cubes/cubeName/segments/build_by_files
  ```

* Response Example

```json
{
"code":"000",
"data":{
    "uuid":"44c2a986-7535-4579-b84a-72c9c802318d",
    "last_modified":1533731858358,
    "version":"3.0.0.1",
    "name":"BUILD CUBE - {cubeName} - 2018042210000_2018042210001 - GMT+08:00 2018-08-08 20:37:38",
    "type":"BUILD",
    "duration":0,
    "related_cube":"{cubeName}",
    "display_cube_name":"{cubeName}",
    "related_segment":"42598177-c5a2-4b3a-ab84-4a9f99639e6b",
    "exec_start_time":0,
    "exec_end_time":0,
    "exec_interrupt_time":0,
    "mr_waiting":0,
    "steps":[...],
    "submitter":"ADMIN",
    "job_status":"PENDING",
    "progress":0
},
"msg":""
}
```




### Build a streaming cube {#build-a-streaming-cube}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_streaming`
- URL Parameters

  - `cubeName` - `required` `string`, the name of the cube to operate on.

- HTTP Header

  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en` 

- HTTP Body: JSON Object

  - `sourceOffsetStart` - `required` `long`, the start offset where build begins. Here 0 means it is from the last position.
  - `sourceOffsetEnd` - `optional` `long`, the end offset where build ends. 9223372036854775807 (Long.MAX_VALUE) means to the end position on Kafka topic. 
  - `buildType` - `required` `string`, the build type must be `BUILD`.
  - `mpValues` - `optional` `string`, multiple partition values of corresponding model.
  - `force` - `optional` `boolean`, force submit mode, default is false.

- Curl Request Example

  ```sh
  curl -X PUT --user ADMIN:KYLIN 
    -H "Accept: application/vnd.apache.kylin-v2+json" 
    -H "Content-Type:application/json" 
    -H "Accept-Language: en" 
    -d '{ 
      "sourceOffsetStart": 0, 
      "sourceOffsetEnd": 9223372036854775807, 
      "buildType": "BUILD"}' http://localhost:7070/kylin/api/cubes/{cubeName}/build_streaming
  ```

- Response Example

  ```json
  {
    "code": "000",
    "data": {
        "uuid": "3adcdb03-0104-4d25-b252-1e0200fd695a",
        "last_modified": 1547026048215,
        "version": "3.2.2.2020",
        "name": "BUILD CUBE - {cubeName} - 19232_19684 - GMT+08:00 2019-01-09 17:27:28",
        "type": "BUILD",
        "duration": 0,
        "related_cube": "{cubeName}",
        "display_cube_name": "{cubeName}",
        "project_name": "{projectName}",
        "related_segment": "aea8e646-74ab-4263-a8bb-35b9dd8b73a4",
        "exec_start_time": 0,
        "exec_end_time": 0,
        "exec_interrupt_time": 0,
        "mr_waiting": 0,
        "steps": [...],
        "submitter": "ADMIN",
        "job_status": "PENDING",
        "progress": 0
    },
    "msg": ""
  }
  ```


### Customize build {#customize-build}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_customized`
- URL Parameters

  - `cubeName` - `required` `string`, the name of the cube to operate on.

- HTTP Header

  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en` 

- HTTP Body: JSON Object

  - `sourceOffsetStart` - `required` `long`, the start offset where build begins.
  - `sourceOffsetEnd` - `optional` `long`, the end offset where build ends.
  - `buildType` - `required` `string`, the build type must be `BUILD`.
  - `mpValues` - `optional` `string`, multiple partition values of corresponding model.
  - `force` - `optional` `boolean`, force submit mode, default is false.

- Curl Request Example

  ```sh
  curl -X PUT \
    http://host:port/kylin/api/cubes/{your_cube_name}/segments/build_customized \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: cn/en' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
   "sourceOffsetStart":201201010001,
   "sourceOffsetEnd":201201010002,
   "buildType":"BUILD",
   "force":true
  }'
  ```

- Response Example

  ```json
  {
    "code": "000",
    "data": {
        "uuid": "3f214b0b-84ab-46aa-a166-b7ab217ca8f4",
        "last_modified": 1547026478069,
        "version": "3.2.2.2020",
        "name": "BUILD CUBE - {cubeName} - 201812010001_201812010002 - GMT+08:00 2019-01-09 17:34:38",
        "type": "BUILD",
        "duration": 0,
        "related_cube": "{cubeName}",
        "display_cube_name": "{cubeName}",
        "project_name": "{projectName}",
        "related_segment": "5c6bfba9-c709-436d-853e-f7a9fb462530",
        "exec_start_time": 0,
        "exec_end_time": 0,
        "exec_interrupt_time": 0,
        "mr_waiting": 0,
        "steps": [...],
        "submitter": "ADMIN",
        "job_status": "PENDING",
        "progress": 0
    },
    "msg": ""
  }
  ```



### Build a Cube in Batch {#build-a-cube-in-batch}

> **Notice:** the current batch_sync API is only for model built by date/time and customized build model. 

- `PUT http://host:port/kylin/api/cubes/{cubeName}/batch_sync`

- URL Parameters

  - `cubeName` - `required` `string`, cube name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `pointList` - `optional` `string`, partition values of corresponding model.
  - `rangeList` - `optional` `string`, partition values of corresponding model.
  - `mpValues` - `optional` `string`, multiple partition values of corresponding model.
  - `force` - `optional` `boolean`, force submit mode, default is false.

- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/{cubeName}/batch_sync' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '[{"mpValues": "300","pointList": ["1","2","3","4","5","6","7","8","9","10"],"rangeList": [["50","70"],["90","110"]]},{"mpValues": "301","pointList": ["1","2","3","4","5","6","7","8","9","10"],"rangeList": [["20","30"],["30","40"]]}]'
  ```

- Response Example

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
              "name":"BUILD CUBE - {cubeName} - 1_2 - GMT+08:00 2018-06-19 17:24:36",
              "type":"BUILD",
              "duration":0,
              "related_cube":"{cubeName}",
              "display_cube_name":"{cubeName}",
              "related_segment":"5ef8d42b-5ed6-4489-b95c-07fe4cf5a2e6",
              "exec_start_time":0,
              "exec_end_time":0,
              "exec_interrupt_time":0,
              "mr_waiting":0,
              "steps":[...],
              "submitter":"ADMIN",
              "job_status":"PENDING",
              "progress":0.0
          },
          "msg":""
          }
      ],
      "msg":""
  }
  ```


