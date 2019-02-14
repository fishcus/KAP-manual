## Segment Manage API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](../authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Merge/Refresh/Delete Segments](#manage-segments)
* [File Datasource: Merge All Consecutive Segments (by Hour)](#File-Datasource-Merge-All-Consecutive-Segments-by-Hour)
* [File Datasource: Merge Segment using Customized Range](#File-Datasource-Merge-Segment-using-Customized-Range)
* [File Datasource: Refresh a Segment](#File-Datasource-Refresh-a-Segment)



### Merge/Refresh/Delete Segments {#manage-segments}

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

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/segments' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{"buildType":"REFRESH",
  "segments":["20180908000000_20180909000000"],
  "mpValues":"",
  "force":true
  }'
  ```


- Response Example

  ```json
  {
    "code":"000",
    "data":[
        {
            "uuid":"90be8cbb-4141-4af7-a57e-0a3b1b5504bd",
            "last_modified":1545912427926,
            "version":"3.2.1.2001",
            "name":"BUILD CUBE - kylin_sales_cube - 20180908000000_20180909000000 - GMT+08:00 2018-12-27 20:07:07",
            "type":"BUILD",
            "duration":0,
            "related_cube":"kylin_sales_cube",
            "display_cube_name":"kylin_sales_cube",
            "related_segment":"76910915-d869-4ed4-9d31-55c419e7a6b2",
            "exec_start_time":0,
            "exec_end_time":0,
            "exec_interrupt_time":0,
            "mr_waiting":0,
            "steps":[...],
            "submitter":"ADMIN",
            "job_status":"PENDING",
            "progress":0
        }
    ],
    "msg":""
  }
  ```



### File Datasource: Merge All Consecutive Segments (by Hour) {#File-Datasource-Merge-All-Consecutive-Segments-by-Hour}

Assuming the "YYYYMMDD+Hour+BatchNum" timeline format, calling this API will merge all consecutive segments within an hour. For example, given the below existing segments:

- [2018042210000, 2018042210001)         -- the 1st segment of hour 21
- [2018042210001, 2018042210002)         -- the 2nd segment of hour 21
- [2018042210002, 2018042210003)         -- the 3rd segment of hour 21
- [2018042220000, 2018042220001)         -- the 1st segment of hour 22
- [2018042220001, 2018042220002)         -- the 2nd segment of hour 22

Calling this API will merge the above into 2 segments for hour 21 and 22:

- [2018042210000, 2018042210003)         -- the merged segment of hour 21
- [2018042220000, 2018042220002)         -- the merged segment of hour 22

**API Invocation**

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/merge_consecutive_segs_by_files`

- URL Parameters

  - `cubeName` - `required` `string` The name of the cube to operate on.

- HTTP Header

  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en` 

- Curl Request Example

  ```sh
  curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/json;charset=utf-8" -H "Accept: application/vnd.apache.kylin-v2+json" http://localhost:port/kylin/api/cubes/cubeName/segments/merge_consecutive_segs_by_files
  ```

- Response Example

  ```json
  {
      "code":"000",
      "data":[
          {
              "uuid":"03fdc009-ae6d-4632-8ebd-9ea9ac42f8e9",
              "last_modified":1533781944054,
              "version":"3.0.0.1",
              "name":"MERGE CUBE - file_test - 2018042210000_2018042210002 - GMT+08:00 2018-08-09 10:32:24",
              "type":"BUILD",
              "duration":0,
              "related_cube":"file_test",
              "display_cube_name":"file_test",
              "related_segment":"d1b06278-1443-4dc9-9e75-1129b39c7552",
              "exec_start_time":0,
              "exec_end_time":0,
              "exec_interrupt_time":0,
              "mr_waiting":0,
              "steps":[...],
              "submitter":"SYSTEM",
              "job_status":"PENDING",
              "progress":0
          }
      ],
      "msg":"1 jobs submitted"
  }
  ```



### File Datasource: Merge Segment using Customized Range {#File-Datasource-Merge-Segment-using-Customized-Range}

Specify a customized range to merge segments.

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_by_files`

- URL Parameters

  - `cubeName` - `required` `string`, the name of the cube to operate on.

- HTTP Header

  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en` 

- HTTP Body: JSON Object

  - `startOffset` - `required` `long`, the start value (inclusive) of the segment range to merge.
  - `endOffset` - `required` `long`, the end value (exclusive) of the segment range to merge.
  - `buildType` - `required` `string`, the build type must be `MERGE`.

- Curl Request Example

  ```sh
  curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/json;charset=utf-8" -H "Accept: application/vnd.apache.kylin-v2+json" -d '{"startOffset":2018042210000, "endOffset": 2018042213000, "buildType":"MERGE"}' http://localhost:port/kylin/api/cubes/cubeName/segments/build_by_files
  ```

- Response Example

  ```json
  {
      "code":"000",
      "data":[
          {
              "uuid":"bf941173-3c81-42f3-b482-b4daf4668cc4",
              "last_modified":1533790550188,
              "version":"3.0.0.1",
              "name":"MERGE CUBE - file_test - 2018042210000_2018042213000 - GMT+08:00 2018-08-09 12:55:50",
              "type":"BUILD",
              "duration":0,
              "related_cube":"file_test",
              "display_cube_name":"file_test",
              "related_segment":"a48e5c84-0917-44d3-a50b-be565806703c",
              "exec_start_time":0,
              "exec_end_time":0,
              "exec_interrupt_time":0,
              "mr_waiting":0,
              "steps":[...],
              "submitter":"SYSTEM",
              "job_status":"PENDING",
              "progress":0
          }
      ],
      "msg":"1 jobs submitted"
  }
  ```



### File Datasource: Refresh a Segment {#File-Datasource-Refresh-a-Segment}

Generally speaking, we don't expect data changes in a built segment. However, if source data did change, it is possible to rebuild (refresh) an existing segment by invoking this API.

- `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_by_files`

- URL Parameters

  - `cubeName` - `required` `string`, the name of the cube to operate on.

- HTTP Header

  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en` 

- HTTP Body: JSON Object

  - `startOffset` - `required` `long`, the start value (inclusive) of the segment range to refresh.
  - `endOffset` - `required` `long`, the end value (exclusive) of the segment range to refresh.
  - `buildType` - `required` `string`, the build type must be `BUILD`.
  - `files` - `required` `string[]`, the absolute paths of the data files on HDFS to refresh.

- Curl Request Example

  ```sh
  curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/json;charset=utf-8" -H "Accept: application/vnd.apache.kylin-v2+json" -d '{"startOffset":2018042210000, "endOffset":2018042210001, "buildType":"BUILD", "files":["/sample/path/file1", "/sample/path/file5"]}' 
  http://localhost:port/kylin/api/cubes/cubeName/segments/build_by_files
  ```

- Response Example

  ```json
  {
      "code":"000",
      "data":{
          "uuid":"2624277d-5e34-4022-aa75-25c70a31474f",
          "last_modified":1533790808154,
          "version":"3.0.0.1",
          "name":"BUILD CUBE - file_test - 2018042211000_2018042211001 - GMT+08:00 2018-08-09 13:00:08",
          "type":"BUILD",
          "duration":0,
          "related_cube":"file_test",
          "display_cube_name":"file_test",
          "related_segment":"fa739a23-ee90-4dd1-8055-6bf24c6908e9",
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

