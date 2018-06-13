## 表级访问权限 REST API

> **提示**
>
> 使用API前请确保已阅读前面的**访问及安全认证**章节，知道如何在API中添加认证信息。
>


* [获取用户表级查询权限](#获取用户表级的查询权限)
* [赋予用户表级查询权限](#赋予用户表级的查询权限)
* [收回用户的表级查询权限](#收回用户的表级查询权限)

### 获取用户表级查询权限
`请求方式 GET`

`访问路径 http://host:port/kylin/api/acl/table/{project}/{table}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* project - `必选` `string`，项目名称
* table - `必选` `string`，表名称

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/table/learn_kylin/DEFAULT.KYLIN_SALES`

#### 响应示例
first: 用户名/用户组名
second: 表示是用户还是用户组

```json
{
  "code": "000",
  "data": [
    {
      "first": "ADMIN",
      "second": "u",
      "value": "u",
      "key": "ADMIN"
    },
    {
      "first": "ROLE_ADMIN",
      "second": "g",
      "value": "g",
      "key": "ROLE_ADMIN"
    }
  ],
  "msg": "get table acl"
}
```

### 赋予用户表级查询权限
`请求方式 POST`

`访问路径 http://host:port/kylin/api/acl/table/{project}/{type}/{table}/{name}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* project - `必选` `string`，项目名称
* type - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
* table - `必选` `string`，表名称
* name - `必选` `string`，用户名

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/table/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

#### 响应示例
```json
{"code":"000","data":"","msg":"grant user table query permission and remove user from table black list."}
```

### 收回用户的表级查询权限
`请求方式 DELETE`

`访问路径 http://host:port/kylin/api/acl/table/{project}/{type}/{table}/{name}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* project - `必选` `string`，项目名称
* type - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
* table - `必选` `string`，表名称
* name - `必选` `string`，用户名

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/table/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

#### 响应示例
```
{"code":"000","data":"","msg":"revoke user table query permission and add user to table black list."}
```