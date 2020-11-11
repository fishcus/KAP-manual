## 缓存 API

> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [清理集群缓存](#清理集群缓存)
* [清理单节点缓存](#清理单节点缓存)



### 清理集群缓存

- `PUT http://host:port/kylin/api/cache/announce/{entity}/{cacheKey}/{event}`

- URL Parameters
  - `entity` - `必选` `string`，实体，如 "all"，"project_schema" ，"project_data" 或者 "project_acl" 
  - `cacheKey` - `必选` `string`，缓存键值，比如项目名称
  - `event` - `必选` `string`，事件，如 "create"，"update" 或者 "drop"

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cache/announce/all/learn_kylin/update' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```



### 清理单节点缓存

- `PUT http://host:port/kylin/api/cache/{entity}/{cacheKey}/{event}`

- URL Parameters
  - `entity` - `必选` `string`，实体，如 "all"，"project_schema" ，"project_data" 或者 "project_acl" 
  - `cacheKey` - `必选` `string`，缓存键值，比如项目名称
  - `event` - `必选` `string`，事件，如 "create"，"update" 或者 "drop"

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X PUT \
    http://host:port/kylin/api/cache/project_data/learn_kylin/update \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

### FAQ

**Q: 如何清理查询缓存？**

A: 当上述 api 中的参数 `entity` 为 "all"，"project_schema"，"project_data"，"project_acl" 中的任意值时都将触发查询缓存清理机制，参数`event`不影响结果。如果希望清理所有项目的查询缓存，需要设置 `entity` 为 "all", `cacheKey` 为任意非空字符串，如 `http://host:port/kylin/api/cache/all/project/update`; 如果希望清理特定项目的查询缓存，需要设置 `entity` 为 "project_schema"，"project_data"，"project_acl" 中的任意值，`cacheKey` 为项目名，如 `http://host:port/kylin/api/cache/project_data/project_1/update`.