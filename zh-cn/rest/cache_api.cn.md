## 缓存 REST API

> **提示**
>
> 使用 API 前请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，知道如何在 API 中添加认证信息。
>
> 当您的访问路径中含有 `&` 符号时，请在 URL 两端加上引号`""` 或者添加反斜杠来避免转义 `\&` 。

### 清理集群缓存
`请求方式 PUT`

`访问路径 http://host:port/kylin/api/cache/announce/{entity}/{cacheKey}/{event}`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en` 

#### 路径变量
* entity - `必选` `string` 'all', 'project_schema', 'project_data' 或者 'project_acl'.
* cacheKey - `必选` `string` 缓存键值, 比如 Project名称.
* event - `必选` `string` 'create', 'update' or 'drop'.

#### 请求示例

`请求路径: http://host:port/kylin/api/cache/announce/project_data/your_project/update`

#### Curl 访问示例

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H 'Accept: application/vnd.apache.kylin-v2+json' -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/cache/announce/project_data/your_project/update
```

### 清理单节点缓存
`请求方式 PUT`

`访问路径 http://host:port/kylin/api/cache/{entity}/{cacheKey}/{event}`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en` 

#### 路径变量
* entity - `必选` `string` 'all','project_schema','project_data' 或者 'project_acl'
* cacheKey - `必选` `string` 缓存键值, 比如 Project名称.
* event - `必选` `string` 'create', 'update' or 'drop'

#### 请求示例

`请求路径: http://host:port/kylin/api/cache/project_data/your_project/update`

#### Curl 访问示例

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H 'Accept: application/vnd.apache.kylin-v2+json' -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/cache/project_data/your_project/update
```