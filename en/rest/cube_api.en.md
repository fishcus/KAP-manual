## Cube API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Get Cube List](#get-cube-list)
* [Get Specific Cube](#get-specific-cube)
* [Get Cube Description](#get-cube-description)
* [Build a Cube with Date Partition](#build-a-cube-with-date-partition)
* [Full Build a Cube ](#full-build-a-cube)
* [Build a Cube in batch](#build-a-cube-in-batch)
* [Clone a Cube](#clone-a-cube)
* [Enable a Cube](#enable-a-cube)
* [Disable a Cube](#disable-a-cube)
* [Purge a Cube](#purge-a-cube)
* [Manage Segments](#manage-segments)
* [Get Holes in Cube](#get-holes-in-cube)
* [Fill Holes in Cube](#fill-holes-in-cube)
* [Export TDS File](#export-tds-file)



### Get Cube List    {#get-cube-list}

- `GET http://host:port/kylin/api/cubes`

- URL Parameters
  - `pageOffset` - `optional` `int`, offset of returned result, 0 by default
  - `pageSize` - `optional` `int`, quantity of returned result per page, 10 by default
  - `cubeName` - `optional` `string`,  cube name
  - `exactMatch` - `optional` `boolean`, whether matchs cube name exactly, `true` by default
  - `modelName` - `optional` `string`, corresponding model name
  - `projectName` - `optional` `string`, project name
  - `sortBy` - `optional` `string`, sort field,  `update_time` by default
  - `reverse` - `optional` `boolean`, whether sort reversely,  `true` by default

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```shell
  curl -X GET \
    'http://host:port/kylin/api/cubes?pageSize=10&modelName=kylin_sales_model' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```JSON
  {
      "code":"000",
      "data":{
          "size":3,
          "cubes":[...]
      },
      "msg":""
  }
  
  ```



### Get Specific Cube   {#get-specific-cube}

- `GET http://host:port/kylin/api/cubes`

- URL Parameters
  - `cubeName` - `required` `string`, cube name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```shell
  curl -X GET \
    'http://host:port/kylin/api/cubes?cubeName=kylin_sales_cube' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```JSON
  {
      "code":"000",
      "data":{
          "size":1,
          "cubes":[...]
      },
      "msg":""
  }
  ```



### Get Cube Description  {#get-cube-description}

- `GET http://host:port/kylin/api/cube_desc/{projectName}/{cubeName}`

- URL Parameters
  - `projectName` - `required` `string`, project name
  - `cubeName` - `required` `string `,  cube name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```shell
  curl -X GET \
    'http://host:port/kylin/api/cube_desc/learn_kylin/kylin_sales_cube' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```JSON
  {
      "code":"000",
      "data":{
          "cube":{
              "uuid":"0ef9b7a8-3929-4dff-b59d-2100aadc8dbf",
              "last_modified":1534836872000,
              "version":"3.0.0.1",
              "name":"kylin_sales_cube",
              "is_draft":false,
              "model_name":"kylin_sales_model",
              "description":"",
              "null_string":null,
              "dimensions":[...],
              "measures":[...],
              "rowkey":{...},
              "hbase_mapping":{...},
              "aggregation_groups":[...],
              "signature":null,
              "notify_list":[...],
              "status_need_notify":[...],
              "partition_date_start":1325376000000,
              "partition_date_end":3153600000000,
              "auto_merge_time_ranges":[
  
              ],
              "volatile_range":0,
              "retention_range":0,
              "engine_type":100,
              "storage_type":100,
              "override_kylin_properties":{...},
              "cuboid_black_list":[...],
              "parent_forward":3,
              "mandatory_dimension_set_list":[...]
          }
      },
      "msg":""
  }
  ```



### Build a Cube with Date Partition  {#build-a-cube-with-date-partition}

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

  ```shell
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

  ```JSON
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


- Curl Request Example

  ```shell
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

  ```JSON
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

### Build a Cube in Batch {#build-a-cube-in-batch}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/batch_sync`

- URL Parameters

  - `cubeName` - `required` `string`, cube name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `pointList` - `optional` `string`, partition values of corresponding model
  - `rangeList` - `optional` `string`, partition values of corresponding model
  - `mpValues` - `optional` `string`,  partition values of corresponding model

- Curl Request Example

  ```shell
  curl -X PUT \
    'http://host:port/kylin/api/cubes/{cubeName}/batch_sync' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '[{"mpValues": "300","pointList": ["1","2","3","4","5","6","7","8","9","10"],"rangeList": [["50","70"],["90","110"]]},{"mpValues": "301","pointList": ["1","2","3","4","5","6","7","8","9","10"],"rangeList": [["20","30"],["30","40"]]}]'
  ```

- Response Example

  ```JSON
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

  ```shell
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
  ```JSON
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

  ```shell
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/enable' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```JSON
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

  ```shell
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/disable' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- Response Example

  ```JSON
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
  - `mpValues` - `optional` `string`, multiple partition values of corresponding model
  - `project` - `required` `string`, project name

- Curl Request Example

  ```shell
  curl -X PUT \
    'http://host:port/kylin/api/cubes/{cubeName}/purge' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{"mpValues": "", "project": "learn_kylin"}'
  ```


- Response Example

  ```JSON
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



### Manage Segments {#manage-segments}

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments`


- URL Parameters
  - `cubeName` - `required` `string`, cube name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `buildType`  -  `required` `string`, supported build type, ie., "MERGE", "REFRESH" or "DROP"
  - `segments`  -  `required` `string[]`, segment name
  - `mpValues`  -  `optional` `string`,  multiple partition values of corresponding model
  - `force`  -  `optional` `boolean`, whether force to operate, ie., "true" or  "false"


- Curl Request Example

  ```shell
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/segments' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{"buildType":"REFRESH",
  "segments":["20180908000000,20180909000000"],
  "mpValues":"",
  "force":true
  }'
  ```


- Response Example

  ```JSON
  {
      "code": "000",
      "data": [],
      "msg": ""
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

  ```shell
  curl -X GET \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/holes' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```JSON
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

  ```shell
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
  - `windowUrl` - `optional` `string`, url of Kyligence Enterprise windows, for example, `http://localhost:7070/kylin`, and the default value is none.
  - `containTableIndex` - `optional` `boolean`, whether includes the columns set to table index, the default value is `false`

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```shell
  curl -X GET \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/export/tds' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```



