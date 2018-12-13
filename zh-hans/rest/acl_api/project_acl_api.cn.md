## 项目级访问控制权限 API

> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [获取项目级访问控制权限](#获取项目级访问控制权限)
* [赋予项目级访问控制权限](#赋予项目级访问控制权限)
* [修改项目级访问控制权限](#修改项目级访问控制权限)
* [删除项目级访问控制权限](#删除项目级访问控制权限)



### 获取项目级访问控制权限

- `GET http://host:port/kylin/api/access/{type}/{uuid}`

- URL Parameters
  - `type` - `必选` `string`，"ProjectInstance"
  - `uuid` - `必选` `string`，项目对应的 UUID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

```shell
  curl -X GET \
    'http://host:port/kylin/api/access/ProjectInstance/{uuid}' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
```

- 响应示例

```JSON
  {
    "code": "000",
    "data": [
      {
        "permission": {
          "mask": 16,
          "pattern": "...........................A...."
        },
        "id": 0,
        "sid": {
          "principal": "ADMIN"
        },
        "granting": true
      }
    ],
    "msg": ""
  }
```



### 赋予项目级访问控制权限

- `POST http://host:port/kylin/api/access/{type}/{uuid}`

- URL Parameters
  - `type` - `必选` `string`，"ProjectInstance"
  - `uuid` - `必选` `string`，项目对应的 UUID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `permission` - `必选` `string`，项目级访问控制权限，对应关系如下："READ" 对应 "Query"；"ADMINISTRATION" 对应 "ADMIN"；"OPERATION" 对应 "OPERATION"；"MANAGEMENT" 对应 "MANAGEMENT"  
  - `principal` - `必选` `boolean`，是否为用户，"true" 或者 "false"
  - `sid` - `必选` `string`，用户名称

- Curl 请求示例

```shell
  curl -X POST \
    'http://host:port/kylin/api/access/ProjectInstance/{uuid}' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
  	"permission": "READ",
  	"principal": true, 
  	"sid": "ANALYST"
  }'
```

- 响应示例

```JSON
  {
      "code": "000",
      "data": "",
      "msg": ""
  }
```



### 修改项目级访问控制权限

- `PUT http://host:port/kylin/api/access/{type}/{uuid}`

- URL Parameters
  - `type` - `必选` `string`，"ProjectInstance"
  - `uuid` - `必选` `string`，项目对应的 UUID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `permission` - `必选` `string`，项目级访问控制权限，对应关系如下："READ" 对应 "Query"；"ADMINISTRATION" 对应 "ADMIN"；"OPERATION" 对应 "OPERATION"；"MANAGEMENT" 对应 "MANAGEMENT"  - `principal` - `必选` `boolean`，是否为用户，"true" 或者 "false"
  - `sid` - `必选` `string`，用户名称
  - `accessEntryId` - `必选` `int`，用户对应的 UUID


- Curl 请求示例 

``` shell
  curl -X PUT \
    'http://host:port/kylin/api/access/ProjectInstance/{uuid}' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
  	"permission": "OPERATION",
  	"principal": true, 
  	"sid": "ANALYST",
  	"accessEntryId": 1
  }'
```


- 响应示例

```JSON
  {
      "code": "000",
      "data": "",
      "msg": ""
  }
```



### 删除项目级访问控制权限

- `DELETE http://host:port/kylin/api/access/{type}/{uuid}`


- URL Parameters
  - `type` - `必选`  `string`，"ProjectInstance"
  - `uuid` - `必选`  `string`，项目对应的 UUID


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `permission` - `必选` `string`，项目级访问控制权限，对应关系如下："READ" 对应 "Query"；"ADMINISTRATION" 对应 "ADMIN"；"OPERATION" 对应 "OPERATION"；"MANAGEMENT" 对应 "MANAGEMENT"
  - `accessEntryId` - `必选` `int`，用户对应的 UUID
  - `sid` - `必选` `string`，用户名称
  - `principal` - `必选` `boolean`，是否为用户，"true" 或者 "false"


- Curl 请求示例

> 提示：如下 Curl 请求将删除用户组 ROLE_ANALYST 对 learn_kylin 的 QUERY 项目级访问控制权限

```shell
curl -X PUT \
  'http://host:port/kylin/api/access/ProjectInstance/{uuid}?accessEntryId=0&sid=ROLE_MODELER&principal=false' \
  -H 'accept: application/vnd.apache.kylin-v2+json' \
  -H 'accept-language: en' \
  -H 'authorization: Basic QURNSU46S1lMSU4=' \
  -H 'content-type: application/json;charset=utf-8' \
  -d '{
	"permission":"READ",
	"principal": true, 
	"sid": "ROLE_ANALYST",
	"accessEntryId": 0
}'
```


- 响应示例

```JSON
  {
      "code": "000",
      "data": "",
      "msg": ""
  }
```
