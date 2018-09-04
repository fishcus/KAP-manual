## Near Real-time Data Import using Hive Data Files (Beta)

Kyligence Enterprise 3.1.0 starts to support data import directly from Hive data files. Together with upstream ETL, it can achieve near real-time data import and allow query of changes in the last few minutes.

This feature is still in **Beta** state. It requires users to have a good understanding of Kyligence Enterprise and Hive database. Please read and understand this guide thoroughly before put it into real use.

### Problem Background

Traditionally, the Hive data import is scheduled by fixed period (e.g. daily). It requires a whole day's data be ready in Hive before the import can start. This causes an one-day delay before new data can serve queries, as a result, cannot satisfy many near real-time analytics scenarios.

To allow for near real-time analysis, we came up with a new way of import directly using Hive data files. It is summarized as below.

- Upstream ETL sends new data to Kyligence Enterprise in the form of data files, typically several to a dozen of files per hour.
- The new file(s) kicks off data import immediately, and the new data is ready for query as soon as the data import job is completed.
- The system tolerates late coming data files, for example, the last file of the first hour can come later than the first file of the second hour. The late coming of data is common in streaming ETL.

This method of data import can reduce data delay to a few minutes. It enables near real-time analytics scenarios with minor change of the import process, which is described as below.

### How It Works

Technically, this feature is a variant of the normal Hive data import. First, user creates model and cube based on Hive tables as usual. The new data files that upstream sends over must match the Hive table schema defined by the fact table in the model. During data import process, the system will clone a new temporary table from the fact table in the model, and mount the new data files under it. The temporary Hive table is then used in place of the fact table in the model for the rest of data loading. Throughout the whole process, the data in the fact table is ignored. The purpose of the fact table is to define the data schema for new data files.

Another key point is that, user is responsible for mapping data files to the **Segment Timeline** and continuously merge small segments by calling rest APIs provided by the system. Like normal Hive data import, every segment needs a clear start time and end time, which is its **Segment Range**. Multiple segment ranges connect together and form a timeline. The same concept applies to file based data import. The only difference is that the system will rely on the users to specify the segment range of new data files.

For instance, a typical mapping of segment timeline is called "YYYYMMDD+Hour+BatchNum", which is a segment range format made up of 13 digits. Like the samples below, the first 10 digits represent year, month, day, and hour. The last 3 digits represent the batch number within the hour.

- Assume A is the 1st file in *6 am 2018-11-12*, it maps to range [2018111206000, 2018111206001)
- Assume B is the 2nd file in *6 am 2018-11-12*, it maps to range [2018111206001, 2018111206002)
- Assume C is the 1st file in *7 am 2018-11-12*, it maps to range [2018111207000, 2018111207001)
- Assume D is the 3rd file in *6 am 2018-11-12* (late coming), it maps to range [2018111206002, 2018111207003)

Then, to merge all segments in the 6 am, that is A, B, and D, we just need to specify the merge range of [2018111206000, 2018111207000). Similarly, to merge all segments of date 2018-11-12, we just specify the merge range of [2018111200000, 2018111300000).

### Usage

1. Prepare Data Files

   * Create a new fact table in Hive. It is only for the description of data schema. Any data inside the fact table will be ignored.

     > Note: Please don't use partition column on this fact table, or it will cause problem to later data import.

   * Prepare a few data files that can be loaded into the Hive fact table.

   * As a test, try to copy the data files to the storage location of the Hive table, then query from Hive command line. The query result should contain the records from the data files.

2. Create Model and Cube

   * With the above Hive fact table, create a model as usual. Please refer to [the model design guide](../data_modeling.en.md) for more information.

     > Note: Please don't use lookup table in the model yet. It is not supported at the moment.

   * Create a cube based on the model above. Please refer to [the cube guide](../cube/create_cube.en.md) for more information.

   * To enable data import by files on the cube, add the following to the cube's advanced settings.

     ```properties
     kap.source.hive.file-incremental-mount-script=/{KE-install-dir}/bin/file-incr-load-prepare-hive.sh
     ```
     > Note: Please replace the `{KE-install-dir}` in the above example with the install location of Kyligence Enterprise. The `file-incr-load-prepare-hive.sh` will be called at the beginning of data import. In this script, a new temporary Hive table will be cloned from the model fact table and under which the given data files will be mounted.

3. Import Data

   * For cubes with file data import enabled, a new Rest API must be used to trigger build jobs. No data import is allowed from web GUI at the moment. Please refer to the Rest API documented below.
   * Similarly, segment merge is also triggered via Rest API, please see the document below.

### Rest API: Build New Segment from Hive Data Files

Given new Hive data files, build a new cube segment and load data into it.

* `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_by_files`
* HTTP Header

  * `Content-Type: application/json;charset=utf-8`
  * `Accept: application/vnd.apache.kylin-v2+json`
  * `Accept-Language: cn|en` 
* URL Parameter
  * `cubeName` - `required` `string` The name of the cube to operate on.
* HTTP Body: A Json object with the following members.
  * `startOffset` - `required` `long` The start value (inclusive) of the new segment range. Should be a number that represents a point in time. For example, with the "YYYYMMDD+Hour+BatchNum" format, 2018042210000 stands for the 1st batch of 10 am 2018-4-22. The last 3 digits is batch sequence number.

  * `endOffset` - `optional` `long` The end value (exclusive) of the new segment range. When omitted, the system will automatically determine the range based on existing segments and the given `startOffset`. The typical usage is requesting multiple builds in a row with the same `startOffset`, and the system will figure out the batch numbers automatically. For example, if request new builds with `startOffset=2018042210000` for 3 times in a row, the resulted segment ranges will be [2018042210000, 2018042210001), [2018042210001, 2018042210002), [2018042210002, 2018042210003).

  * `buildType` - `required` `string` The build type must be `BUILD`.

  * `files` - `required` `string[]` The absolute paths of the new data files on HDFS.

  * > Note: In order to prevent unintentional duplicated data, the system don't allow one file be imported multiple times into a cube.

**Curl Request Example**

```bash
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/json;charset=utf-8" -H "Accept: application/vnd.apache.kylin-v2+json"  -d '{"startOffset":2018042210000, "buildType":"BUILD", "files":["/sample/path/file1"]}' http://localhost:port/kylin/api/cubes/cubeName/segments/build_by_files
```

**Response Example**

```json
{
    "code":"000",
    "data":{
        "uuid":"44c2a986-7535-4579-b84a-72c9c802318d",
        "last_modified":1533731858358,
        "version":"3.0.0.1",
        "name":"BUILD CUBE - file_test - 2018042210000_2018042210001 - GMT+08:00 2018-08-08 20:37:38",
        "type":"BUILD",
        "duration":0,
        "related_cube":"file_test",
        "display_cube_name":"file_test",
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

### Rest API: Merge All Consecutive Segments (by Hour)

Assuming the "YYYYMMDD+Hour+BatchNum" timeline format, calling this API will merge all consecutive segments within an hour. For example, given the below existing segments:

* [2018042210000, 2018042210001)         -- the 1st segment of hour 21
* [2018042210001, 2018042210002)         -- the 2nd segment of hour 21
* [2018042210002, 2018042210003)         -- the 3rd segment of hour 21
* [2018042220000, 2018042220001)         -- the 1st segment of hour 22
* [2018042220001, 2018042220002)         -- the 2nd segment of hour 22

Calling this API will merge the above into 2 segments for hour 21 and 22:

* [2018042210000, 2018042210003)         -- the merged segment of hour 21
* [2018042220000, 2018042220002)         -- the merged segment of hour 22

**API Invocation**

* `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/merge_consecutive_segs_by_files`
* HTTP Header
  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: cn|en` 

- URL Parameter
  - `cubeName` - `required` `string` The name of the cube to operate on.

**Curl Request Example**

```bash
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/json;charset=utf-8" -H "Accept: application/vnd.apache.kylin-v2+json" http://localhost:port/kylin/api/cubes/cubeName/segments/merge_consecutive_segs_by_files
```

**Response Example**

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

### Rest API: Merge Segment using Customized Range

Specify a customized range to merge segments.

* `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_by_files`
* HTTP Header
  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: cn|en` 

- URL Parameter
  - `cubeName` - `required` `string` The name of the cube to operate on.
- HTTP Body: A Json object with the following members.
  - `startOffset` - `required` `long` The start value (inclusive) of the segment range to merge.
  - `endOffset` - `required` `long` The end value (exclusive) of the segment range to merge.
  - `buildType` - `required` `string` The build type must be `MERGE`.

**Curl Request Example**

```bash
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/json;charset=utf-8" -H "Accept: application/vnd.apache.kylin-v2+json" -d '{"startOffset":2018042210000, "endOffset": 2018042213000, "buildType":"MERGE"}' http://localhost:port/kylin/api/cubes/cubeName/segments/build_by_files
```

**Response Example**

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

### Rest API: Refresh a Segment

Generally speaking, we don't expect data changes in a built segment. However, if source data did change, it is possible to rebuild (refresh) an existing segment by invoking this API.

* `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_by_files`
* HTTP Header
  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: cn|en` 

- URL Parameter
  - `cubeName` - `required` `string` The name of the cube to operate on.
- HTTP Body: A Json object with the following members.
  - `startOffset` - `required` `long` The start value (inclusive) of the segment range to refresh.
  - `endOffset` - `required` `long` The end value (exclusive) of the segment range to refresh.
  - `buildType` - `required` `string` The build type must be `BUILD`.
  - `files` - `required` `string[]` The absolute paths of the data files on HDFS to refresh.

**Curl Request Example**

```bash
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/json;charset=utf-8" -H "Accept: application/vnd.apache.kylin-v2+json" -d '{"startOffset":2018042210000, "endOffset":2018042210001, "buildType":"BUILD", "files":["/sample/path/file1", "/sample/path/file5"]}' 
http://localhost:port/kylin/api/cubes/cubeName/segments/build_by_files
```

**Response Example**

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

