## 表级访问控制权限 API

> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [获取表级访问控制权限](#获取表级访问控制权限)
* [赋予表级访问控制权限](#赋予表级访问控制权限)
* [批量赋予表级访问控制权限](#批量赋予表级访问控制权限)
* [删除表级访问控制权限](#删除表级访问控制权限)



### 获取表级访问控制权限

- `GET http://host:port/kylin/api/acl/table/paged/{project}/{table}`


- URL Parameters
  - `project` - `必选` `string`，项目名称
  - `table` - `必选` `string`，表名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `pageSize` - `可选` `int`， 分页返回每页返回的条数，默认为10
  - `pageOffset` - `可选` `int`， 返回数据的起始下标，默认为0


- Curl 请求示例

```shell
  curl -X GET \
    'http://host:port/kylin/api/acl/table/paged/learn_kylin/DEFAULT.KYLIN_SALES' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
```

- 响应示例

```JSON
  {
      "code": "000"，
      "data": {
          "size": 2，
          "user": [
              "ADMIN"
          ]，
          "group": [
              "ROLE_ADMIN"
          ]
      }，
      "msg": "get table acl"
  }
```



### 赋予表级访问控制权限

- `POST http://host:port/kylin/api/acl/table/{project}/{type}/{table}/{name}`


- URL Parameters
  - `project` - `必选` `string`，项目名称
  - `type` - `必选` `string`，操作对象，取值：user 或 group
  - `table` - `必选` `string`，表名称
  - `name` - `必选` `string`，用户名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例

```shell
  curl -X POST \
    'http://host:port/kylin/api/acl/table/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
```


- 响应示例

```JSON
  {
      "code": "000",
      "data": "",
      "msg": "grant user table query permission and remove user from table black list."
  }
```



### 批量赋予表级访问控制权限


- `POST http://host:port/kylin/api/acl/table/batch/{project}/{table}`


- URL Parameters
  - `project` - `必选` `string`，项目名称
  - `table` - `必选` `string`，表名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `sid` - `必选` `string`，用户或组名
  - `principal` - `必选` `boolean`，是否为用户，"true" 或者 "false"


- Curl 请求示例

```shell
  curl -X POST \
    'http://host:port/kylin/api/acl/table/batch/learn_kylin/DEFAULT.KYLIN_CAL_DT' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json' \
    -d '[{
  	"sid":"ADMIN",
  	"principal":"true"
  },
  {
  	"sid":"{username}",
  	"principal":"true"
  }
  ]'
```

- 响应示例

```JSON
  {
      "code": "000",
      "data": "",
      "msg": "batch grant user table query permission and remove user from table black list"
  }
```



### 删除表级访问控制权限

- `DELETE http://host:port/kylin/api/acl/table/{project}/{type}/{table}/{name}`


- URL Parameters
  - `project` - `必选` `string`，项目名称
  - `type` - `必选` `string`，操作对象，取值：user 或 group
  - `table` - `必选` `string`，表名称
  - `name` - `必选` `string`，用户名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例

```shell
  curl -X DELETE \
    'http://host:port/kylin/api/acl/table/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
```


- 响应示例

```JSON
  {
      "code": "000",
      "data": "",
      "msg": "revoke user table query permission and add user to table black list."
  }
```
