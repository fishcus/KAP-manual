## 表级访问权限 REST API

> **提示**
>
> 使用 API 前请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，知道如何在 API 中添加认证信息。
>
> 当您的访问路径中含有 `&` 符号时，请在 URL 两端加上引号`""` 或者添加反斜杠来避免转义 `\&`。


* [获取用户表级查询权限](#获取用户表级的查询权限)
* [赋予用户表级查询权限](#赋予用户表级的查询权限)
* [收回用户的表级查询权限](#收回用户的表级查询权限)
* [批量授予用户表级查询权限](#批量授予用户表级查询权限)

### 获取用户表级查询权限
`请求方式 GET`

`访问路径 http://host:port/kylin/api/acl/table/paged/{project}/{table}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`


#### 路径变量
* project - `必选` `string`，项目名称
* table - `必选` `string`，表名称


#### 请求主体
* pageSize - `可选` `int`, 默认为10 分页返回每页返回的条数
* pageOffset - `可选` `int`, 默认为0 返回数据的起始下标

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/table/paged/learn_kylin/DEFAULT.KYLIN_SALES`

#### Curl 访问示例
```
curl -X GET -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{"pageSize":10，"pageOffset":0 }' http://host:port/kylin/api/acl/table/paged/learn_kylin/DEFAULT.KYLIN_SALES
```

#### 响应示例

```json
{
  "code": "000",
  "data": {
    "size": 2,
    "user": [
      "ROLE_ADMIN"
    ],
    group: [
      "ADMIN"
    ]
  },
  "msg": "get table acl"
}
```

### 赋予用户表级查询权限
`请求方式 POST`

`访问路径 http://host:port/kylin/api/acl/table/{project}/{type}/{table}/{name}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### 路径变量
* project - `必选` `string`，项目名称
* type - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
* table - `必选` `string`，表名称
* name - `必选` `string`，用户名

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/table/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

#### Curl 访问示例
```
curl -X POST -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/acl/table/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN
```

#### 响应示例
```json
{"code":"000","data":"","msg":"grant user table query permission and remove user from table black list."}
```

### 收回用户的表级查询权限
`请求方式 DELETE`

`访问路径 http://host:port/kylin/api/acl/table/{project}/{type}/{table}/{name}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### 路径变量
* project - `必选` `string`，项目名称
* type - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
* table - `必选` `string`，表名称
* name - `必选` `string`，用户名

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/table/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

#### Curl 访问示例
```
curl -X DELETE -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json"  -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/acl/table/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN
```

#### 响应示例
```
{"code":"000","data":"","msg":"revoke user table query permission and add user to table black list."}
```

### 批量授予用户表级查询权限
`请求方式 POST`

`访问路径 http://host:port/kylin/api/acl/table/batch/{project}/{table:.+}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### 路径变量
* project - `必选` `string`，项目名称
* table - `必选` `string`，表名称

#### 请求主体
* sid - `必选` `string`，用户或组名
* principal - `必选` `boolean`，是否为用户

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/table/batch/acl_test/DEFAULT.TEST_ACCOUNT`

`请求主体:
[
	{
		"sid": "ACL_TEST",
		"principal": true
	},
	{
		"sid": "ANALYST",
		"principal": true
	}
]`

#### Curl 访问示例
```
curl -X POST -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json"  -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '[{"sid": "ACL_TEST", "principal": true}, {"sid": "ANALYST", "principal": true}]' http://host:port/kylin/api/acl/table/batch/acl_test/DEFAULT.TEST_ACCOUNT
```

#### 响应示例
```
{"code": "000", "data": "", "msg": "batch grant user table query permission and remove user from table black list"}
```