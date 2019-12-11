## 数据构建

本产品从v3.3.0版本后，支持通过指定的元数据包路径进行导入并构建，构建后可以输出在指定的 HDFS 路径。目前该功能仅支持通过 **Rest API** 使用，通过该功能您可以快速的在构建集群中输入元数据包进行构建。同时该功能支持库名表名的映射，完成源数据信息的替换。

### 根据元数据包构建

- `POST http://host:port/kylin/api/cubes/enhanced_build`

- HTTP Header

  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW`

- HTTP Body: form-data

  - `file` - `可选` `string`，导入的元数据包路径，如 `file=@/Users/kylin/Documents/metadata.zip`。`file` 与 `srcHdfsPath` 两者必填其一。
  - `srcHdfsPath` - `可选` `string`，导入的元数据包在 HDFS 的路径，如 `hdfs://kycluster/kylin/metadata.zip`。`file` 与 `srcHdfsPath` 两者必填其一。
  - `destHdfsPath` - `必选` `string`，构建生成的数据文件存放路径，如`hdfs://kycluster/kylin/export_segment`
  - `buildType` - `必选` `string`，支持的计算类型: "BUILD"
  - `startTime` - `必选` `long`，开始时间，对应 GMT格式的时间戳，如 `1388534400000`对应 `2014-01-01 00:00:00` ，推荐使用[在线时间戳转换](https://www.epochconverter.com/)对时间进行处理。
  - `endTime` - `必选` `long`，结束时间，对应 GMT格式的时间戳。
  - `tableMapping['tablename1']` - `可选` `string`，可以将tablename1映射为tablename2，如 tableMapping['tablename1']=tablename2。支持添加多个键值对。

- Curl 请求示例

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/cubes/enhanced_build' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW' \
    -F 'file=@/Users/kylin/Documents/metadata.zip' \
    -F buildType=BUILD \
    -F startTime=0 \
    -F endTime=1552348800000 \
    -F destHdfsPath=hdfs://hacluster/kylin/export_segment \
    -F 'tableMapping["TEST.KYLIN_ACCOUNT"]=DEFAULT.KYLIN_ACCOUNT'
  
  ```

- 响应示例

  ```json
  {
      "code": "000",
      "data": "hdfs://10.1.2.28/kylin/export_segment/5acbca5f-6699-41d7-928d-66c865d5209d",
      "msg": ""
  }
  ```