## 列级访问权限 REST API

> **提示**
>
> 使用API前请确保已阅读前面的**访问及安全认证**章节，知道如何在API中添加认证信息。
>


* [获取表下列的黑名单](#获取表下列的黑名单)
* [添加用户不能访问的列](#添加用户不能访问的列)
* [修改用户不能访问的列](#修改用户不能访问的列)
* [删除用户的列级ACL](#删除用户的列级ACL)

### 获取表下列的黑名单

`请求方式 GET`

`访问路径 http://host:port/kylin/api/acl/column/paged/{project}/{table}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* project - `必选` `string`，项目名称
* table - `必选` `string`，表名称

#### 请求主体
* pageSize - `可选` `int`, 默认为10 分页返回每页返回的条数
* pageOffset - `可选` `int`, 默认为0 返回数据的起始下标

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/column/paged/learn_kylin/DEFAULT.KYLIN_SALES`

#### 响应示例
```json
{
  "code": "000",
  "size": 2,
  "data": {
    "user": [{
    	"admin": [
    	  "BUYER_ID",
    	  "SELLER_ID"
    	]
    }],
    "group": [{
    	"ADMIN": [
    	  "BUYER_ID",
    	  "SELLER_ID"
    	]
    }]
  },
  "msg": "get column acl"
}
```

### 添加用户不能访问的列
`请求方式 POST`

`访问路径 http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* project - `必选` `string`，项目名称
* type - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
* table - `必选` `string`，表名称
* username - `必选` `string`，用户名

#### 请求主体
* columns - `必选` `string列表` 列名称，详见下面请求示例中的请求主体

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

`请求主体:["CAL_DT", "YEAR_BEG_DT"]`

#### 响应示例
```json
{"code":"000","data":"","msg":"add user to column black list."}
```

### 修改用户不能访问的列
`请求方式 PUT`

`访问路径 http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* project - `必选` `string`，项目名称
* type - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
* table - `必选` `string`，表名称
* username - `必选` `string`，用户名

#### 请求主体
* columns - `必选` `string列表`，列名称，详见下面请求示例中的请求主体

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

`请求主体:["YEAR_BEG_DT", "CAL_DT", "QTR_BEG_DT"]`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 响应示例
```json
{"code":"000","data":"","msg":"update user's black column list"}
```

### 删除用户的列级ACL
`请求方式 DELETE`

`访问路径 http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* project - `必选` `string`，项目名称
* type - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
* table - `必选` `string`，表名称
* username - `必选` `string`，用户名

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

#### 响应示例
```
{"code":"000","data":"","msg":"delete user from DEFAULT.KYLIN_CAL_DT's column black list"}
```