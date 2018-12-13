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

```shell
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

```shell
  curl -X PUT \
    http://host:port/kylin/api/cache/project_data/learn_kylin/update \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
```
