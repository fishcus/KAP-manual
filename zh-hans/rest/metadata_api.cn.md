## Cube 元数据导出/导入 API


> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [导出 Cube 元数据](#导出-Cube-元数据)
* [导入 Cube 元数据](#导入-Cube-元数据)



### 导出 Cube 元数据{#导出-Cube-元数据}

- `POST http://host:port/kylin/api/metastore/export`
- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Encoding: gzip, deflate, br` 
  - `Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8`
  - `Accept-Language: en`
  - `Content-Type: application/x-www-form-urlencoded`
- HTTP Body: x-www-form-urlencoded
  - `project` - `必选` `string`，导出的项目名
  - `cubes` - `必选` `string`，导出的cube名，当需要导出多个 cube 时，用 `,` 分割


- Curl 请求示例

  ```sh
  curl -X POST \
    http://host:port/kylin/api/metastore/export \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Encoding: gzip, deflate, br' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'cache-control: no-cache,no-cache' \
    -d 'cubes=kylin_sales_cube&project=learn_kylin&undefined=' \
    -o /usr/local/kylin/learn_kylin.zip
  ```


- 响应示例

  ```shell
  % Total % Received % Xferd  Average Speed   Time    Time    Time  	Current
                              Dload   Upload  Total   Spent    Left  	Speed
  100  9600  100  9547 100 53  109k    620 --:--:-- --:--:-- --:--:--  109k
  ```


### 导入 Cube 元数据{#导入-Cube-元数据}

- `POST http://host:port/kylin/api/metastore/import_metadata`
- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Encoding: gzip, deflate, br` 
  - `Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8`
  - `Accept-Language: en`
  - `Content-Type: application/x-www-form-urlencoded`
- HTTP Body: JSON Object
  - `projectName` - `必选` `string`，导入的目标项目名称
  - `path` - `必选` `string`，导入的元数据文件路径

- Curl 请求示例

  ```sh
  curl -X POST \
    http://host:port/kylin/api/metastore/import_metadata \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json' \
    -H 'cache-control: no-cache,no-cache' \
    -d '{
  	"projectName":"learn_kylin",
  	"path":"/usr/local/kylin/learn_kylin.zip"
  }'
  ```

* 响应示例

  ```json
  {"code":"000","data":"","msg":"Import metadata successfully."}
  ```
