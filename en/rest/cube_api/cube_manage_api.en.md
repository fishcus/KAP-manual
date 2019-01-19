## Cube Manage API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](../authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Clone a Cube](#clone-a-cube)
* [Enable a Cube](#enable-a-cube)
* [Disable a Cube](#disable-a-cube)
* [Purge a Cube](#purge-a-cube)
* [Get Holes in Cube](#get-holes-in-cube)
* [Fill Holes in Cube](#fill-holes-in-cube)
* [Export TDS File](#export-tds-file)



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

  ```sh
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

  ```sh
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

  ```sh
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
  - `windowUrl` - `optional` `string`, url of Kyligence Enterprise windows, for example, `http://localhost:7070/kylin`, and the default value is none.
  - `containTableIndex` - `optional` `boolean`, whether includes the columns set to table index, the default value is `false`

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/cubes/kylin_sales_cube/export/tds' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```



