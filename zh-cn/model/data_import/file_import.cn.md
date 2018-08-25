## 基数 Hive 数据文件的近实时数据导入 (Beta)

Kyligence Enterprise 3.1.0 开始支持直接从 Hive 数据文件导入数据，与上游 ETL 配合，可以做到 10 分钟级别的近实时数据导入。

该功能暂时为 **Beta** 状态，使用起来需要用户对产品和 Hive 数据库有较深的技术知识。请在完全理解本文档的前提下使用。

### 背景和适用场景

传统的 Hive 数据导入通常按固定的时间周期导入数据，比如按天导入。它要求每天的数据全部到位后，才开始导入到 Cube。这导致对分析而言，有一个时间周期的数据延迟。而这样比如长达一天的数据延迟，显然不能满足一些实时性要求较高的分析场景。

为了满足近实时数据导入的需求，我们提出一种新的基于数据文件的导入方法：

- 上游 ETL 以文件的形式持续传送增量数据给 Kyligence Enterprise，粒度一般为每小时几个到十几个增量文件。
- 每个增量文件到达时，系统就立即启动构建任务，导入增量数据。当构建任务完成，对应的增量数据就可以立即查询，满足近实时分析需求。
- 系统允许增量数据文件的到达次序可以与数据时间顺序无关。比如第一个小时的最后一个文件，可能比第二个小时的第一个文件晚到。这在流式 ETL 中是很常见的现象。

这种数据导入方法适合一些近实时的分析场景，可以将分析数据延迟缩短到 10 分钟左右。

### 工作原理

从原理上，这是一种 Hive 数据导入功能的变体。用户首先要像往常一样，以 Hive 为数据源创建模型和 Cube。每个增量数据文件都被认为是模型中事实表的一个数据文件，必需符合 Hive 事实表的表结构定义。当导入数据时，系统会模仿事实表克隆出一张新的临时 Hive 表，并将增量数据文件挂载到这张临时 Hive 表中，再以这张临时 Hive 表代替模型中原有的事实表，完成 Cube 构建。整个导入过程中，模型中的事实表仅起到一个定义数据文件格式的作用，其中的数据则会被忽略。

另一个要点是用户需将数据文件映射到 **Segment 时间线**（Segment Timeline），并通过调用 Rest API 及时地合并 Segment，从而保证查询性能不会因为小 Segment 太多而变慢。原本从 Hive 导入数据，每个 Segment 都有清晰的起始和结束时间，即 **Segment 区间**（Segment Range），多个 Segment 区间连在一起，构成 Segment 时间线。但在文件导入的场景里，每个文件所代表的区间范围系统很难自动识别。改由用户指定会更加准确和高效，并为后续的 Segment 合并带来方便。

比如，一种常用的文件映射到 Segment 时间线的方案是用 “**年月日+小时+文件序号**” 数字编码构成 Segment 区间。如下所示，Segment 区间由 13 位数字表示，前 10 位数字表示年、月、日、小时，后 3 位数字表示小时内第几个文件。

- 假定文件 A 是 2018-11-12日 6 am 的第一个文件，则它对应到 [2018111206000, 2018111206001)。
- 假定文件 B 是 2018-11-12日 6 am 的第二个文件，则它对应到 [2018111206001, 2018111206002)。
- 假定文件 C 是 2018-11-12日 7 am 的第一个文件，则它对应到 [2018111207000, 2018111207001)。
- 假定文件 D 是 2018-11-12日 6 am 的第三个文件（迟到），则它对应到 [2018111206002, 2018111207003)。

这样，当需要合并 6 am 的所有 Segment 的时候，只需要指定合并 Segment 区间 [2018111206000, 2018111207000)，即可达到合并 A、B、D 的目的。同理合并 Segment 区间 [2018111200000, 2018111300000) 即是合并所有 2018-11-12 日的 Segment 的意思。

### 使用方法

1. 准备数据

   * 在 Hive 中准备事实表，该表只用于描述数据文件的字段结构，其中的数据会被忽略。

     > 注意：创建 Hive 表时，请不要使用分区列，否则会影响后面的数据文件载入。

   * 再准备若干数据文件，它们必需符合事实表的表结构定义。

   * 作为验证，可以将数据文件复制到事实表对应的存储路径下。然后在 Hive 中查询事实表，确认能返回数据文件中的记录。

2. 创建模型和 Cube

   * 以上面的事实表为中心，创建模型。具体方法可以参考 [设计模型](../data_modeling.cn.md)。

     > 注意：请不要在模型中使用维度表，当前的数据文件导入还不支持。

   * 基于上述模型，创建 Cube。具体方法可以参考 [创建Cube](../cube/create_cube.cn.md)。

   * 在 Cube 高级设置中添加下面的配置项，启用基于 Hive 数据文件的导入功能。

     ```properties
     kap.source.hive.file-incremental-mount-script=/{KE-install-dir}/bin/file-incr-load-prepare-hive.sh
     ```
     > 注意：请将上例中的 `{KE-install-dir}` 替换为 Kyligence Enterprise 的安装目录绝对路径。该脚本将在每次增量构建时被调用，它将模仿事实表克隆出一张新的临时 Hive 表，并将增量数据文件挂载到这张临时 Hive 表中。

3. 加载数据

   * 对于启用了 Hive 数据文件导入功能的 Cube，启动构建任务时必需指明数据文件列表，因此暂时无法通过 GUI 触发加载数据。请参考下面的 Rest API 来构建新的 Segment。
   * 类似的，对于合并 Segment 也有特殊的 Rest API。详见下面的 Rest API 说明。

### Rest API: 根据 Hive 数据文件构建新的 Segment

根据指定的新增数据文件，构建一个新的 Cube Segment。

* `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_by_files`
* HTTP Header

  * `Content-Type: application/json;charset=utf-8`
  * `Accept: application/vnd.apache.kylin-v2+json`
  * `Accept-Language: cn|en` 
* URL Parameter
  * `cubeName` - `必选` `string` Cube 名称
* HTTP Body: Json 对象，包含下述字段。
  * `startOffset` - `必选` `long` Segment 区间的起始值（包含）。目前支持 “**年月日+小时+文件序号**” 格式的 13 位数字。例如，2018042210000表示2018年4月22日10点， 最后三位表示同一个小时内增量的构建序数，最大值为100。

  * `endOffset` - `可选` `long` Segment 区间的结束值（不包含）。如果省略该值，系统将根据 Cube 中已有的 Segment 和给定的 `startOffset` 自动调整 Segment 区间。典型的用法是，用户可以用相同的小时 `startOffset` 多次请求构建。例如，假设以 `startOffset=2018042210000` 连续请求三次构建，`endOffset` 省略，系统将依次生产这个小时内的三个连续的 Segment：[2018042210000, 2018042210001), [2018042210001, 2018042210002), [2018042210002, 2018042210003)。

  * `buildType` - `必选` `string` 支持的构建类型为 `BUILD`。

  * `files` - `必选` `string[]` 新增数据文件在 HDFS 中的绝对路径列表。

  * > 注意：为了防止意外的重复数据，系统不允许在同一个 Cube 中重复加载同一个数据文件。

**Curl 请求示例**

```bash
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/json;charset=utf-8" -H "Accept: application/vnd.apache.kylin-v2+json"  -d '{"startOffset":2018042210000, "buildType":"BUILD", "files":["/sample/path/file1"]}' http://localhost:port/kylin/api/cubes/cubeName/segments/build_by_files
```

**响应示例**

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

### Rest API: （按小时）合并所有连续的 Segment

假设使用了 “**年月日+小时+文件序号**” 的 Segment 区间格式，调用这个 API 将合并所有同一小时内的连续 Segment。例如，如果已有下面的 Segment：

* [2018042210000, 2018042210001)         -- 21点的第一个 Segment
* [2018042210001, 2018042210002)         -- 21点的第二个 Segment
* [2018042210002, 2018042210003)         -- 21点的第三个 Segment
* [2018042220000, 2018042220001)         -- 22点的第一个 Segment
* [2018042220001, 2018042220002)         -- 22点的第二个 Segment

则调用 API 后，将把上面所有 Segment 合并为21点和22点二个小时级的 Segment ：

* [2018042210000, 2018042210003)         -- 21点的合并 Segment
* [2018042220000, 2018042220002)         -- 22点的合并 Segment

**具体调用方法**

* `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/merge_consecutive_segs_by_files`
* HTTP Header
  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: cn|en` 

- URL Parameter
  - `cubeName` - `必选` `string` Cube 名称

**Curl 请求示例**

```bash
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/json;charset=utf-8" -H "Accept: application/vnd.apache.kylin-v2+json" http://localhost:port/kylin/api/cubes/cubeName/segments/merge_consecutive_segs_by_files
```

**响应示例**

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

### Rest API: 自定义区间合并 Segment

根据自定义的区间合并 Segment。

* `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_by_files`
* HTTP Header
  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: cn|en` 

- URL Parameter
  - `cubeName` - `必选` `string` Cube 名称
- HTTP Body: Json 对象，包含下述字段。
  - `startOffset` - `必选` `long` 合并区间起始值（包含），例如 `2018042210000` 表示2018年4月22日10点。
  - `endOffset` - `必选` `long` 合并区间结束值（不包含），例如 `2018042213000` 表示2018年4月22日13点。
  - `buildType` - `必选` `string` 支持的构建类型为 `MERGE`。

**Curl 请求示例**

```bash
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/json;charset=utf-8" -H "Accept: application/vnd.apache.kylin-v2+json" -d '{"startOffset":2018042210000, "endOffset": 2018042213000, "buildType":"MERGE"}' http://localhost:port/kylin/api/cubes/cubeName/segments/build_by_files
```

**响应示例**

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

### Rest API: 刷新 Segment

一般而言，已经导入的数据不应该再有变化。但如果源数据确实发生了变化，也可以刷新（即重新载入）一个已经存在的 Segment。

* `PUT http://host:port/kylin/api/cubes/{cubeName}/segments/build_by_files`
* HTTP Header
  - `Content-Type: application/json;charset=utf-8`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: cn|en` 

- URL Parameter
  - `cubeName` - `必选` `string` Cube 名称
- HTTP Body: Json 对象，包含下述字段。
  - `startOffset` - `必选` `long` 要刷新的 Segment 的区间起始值（包含）。
  - `endOffset` - `必选` `long` 要刷新的 Segment 的区间结束值（不包含）。
  - `buildType` - `必选` `string` 支持的构建类型为`BUILD`。
  - `files` - `必选` `string[]` 刷新数据文件的绝对路径列表。

**Curl 请求示例**

```bash
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/json;charset=utf-8" -H "Accept: application/vnd.apache.kylin-v2+json" -d '{"startOffset":2018042210000, "endOffset":2018042210001, "buildType":"BUILD", "files":["/sample/path/file1", "/sample/path/file5"]}' 
http://localhost:port/kylin/api/cubes/cubeName/segments/build_by_files
```

**响应示例**

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

