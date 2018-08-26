## 列级访问权限 REST API

> **提示**
>
> 使用 API 前请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，知道如何在 API 中添加认证信息。
>
> 当您的访问路径中含有 `&` 符号时，请在 URL 两端加上引号`""` 或者添加反斜杠来避免转义 `\&` 。


* [获取表中列的黑名单](#获取表下列的黑名单)
* [添加用户不能访问的列](#添加用户不能访问的列)
* [批量添加用户不能访问的列](#批量添加用户不能访问的列)
* [修改用户不能访问的列](#修改用户不能访问的列)
* [删除用户的列级ACL](#删除用户的列级ACL)

### 获取表中列的黑名单

`请求方式 GET`

`访问路径 http://host:port/kylin/api/acl/column/paged/{project}/{table}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### 路径变量
* project - `必选` `string`，项目名称
* table - `必选` `string`，表名称

#### 请求主体
* pageSize - `可选` `int`, 默认为10 分页返回每页返回的条数
* pageOffset - `可选` `int`, 默认为0 返回数据的起始下标

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/column/paged/learn_kylin/DEFAULT.KYLIN_SALES`

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{"pageSize":10，"pageOffset":0 }' http://host:port/kylin/api/acl/column/paged/learn_kylin/DEFAULT.KYLIN_SALES
```

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

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

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

#### Curl Request Example
```
curl -X POST -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '["YEAR_BEG_DT", "CAL_DT", "QTR_BEG_DT"]' http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN
```

#### 响应示例
```json
{"code":"000","data":"","msg":"add user to column black list."}
```

### 批量添加用户不能访问的列
`请求方式 POST`

`访问路径 http://host:port/kylin/api/acl/column/batch/{project}/{type}/{table}/{username}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### 路径变量
* project - `必选` `string`，项目名称
* type - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
* table - `必选` `string`，表名称

#### 请求主体
* 请求体是一个的map结构，key值为用户名，value值列的集合。详见下面请求示例中的请求主体

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/column/batch/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

```
请求主体:
ADMIN的取值为'LSTG_FORMAT_NAME','PART_DT';
ANALYST的取值为'LSTG_FORMAT_NAME'

{
	"ADMIN": [
		"LSTG_FORMAT_NAME",
		"PART_DT"
	],
	"ANALYST": [
		"LSTG_FORMAT_NAME"
	]
}
```

#### Curl Request Example
```
curl -X POST -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "ADMIN": ["LSTG_FORMAT_NAME", "PART_DT"],"ANALYST": ["LSTG_FORMAT_NAME"]}' http://host:port/kylin/api/acl/column/batch/learn_kylin/user/DEFAULT.KYLIN_CAL_DT
```

#### 响应示例
```json
{"code":"000","data":"", "msg":"${user_count} user column ACL(s) updated"}
```


### 修改用户不能访问的列
`请求方式 PUT`

`访问路径 http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

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

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Curl Request Example
```
curl -X PUT -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '["YEAR_BEG_DT", "CAL_DT", "QTR_BEG_DT"]' http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN
```


#### 响应示例
```json
{"code":"000","data":"","msg":"update user's black column list"}
```

### 删除用户的列级ACL
`请求方式 DELETE`

`访问路径 http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### 路径变量
* project - `必选` `string`，项目名称
* type - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
* table - `必选` `string`，表名称
* username - `必选` `string`，用户名

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

#### Curl Request Example
```
curl -X DELETE -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN
```

#### 响应示例
```
{"code":"000","data":"","msg":"delete user from DEFAULT.KYLIN_CAL_DT's column black list"}
```