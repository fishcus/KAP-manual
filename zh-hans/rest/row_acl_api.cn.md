## 行级访问权限 REST API

> **提示**
>
> 使用 API 前请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，知道如何在 API 中添加认证信息。
>
> 当您的访问路径中含有 `&` 符号时，请在 URL 两端加上引号`""` 或者添加反斜杠来避免转义 `\&`。


* [获取用户的行级ACL](#获取用户的行级ACL)
* [添加用户的行级ACL](#添加用户的行级ACL)
* [批量添加用户的行级ACL](#批量添加用户的行级ACL)
* [修改用户的行级ACL](#修改用户的行级ACL)
* [删除用户的行级ACL](#删除用户的行级ACL)

### 获取用户的行级ACL
`请求方式 GET`

`访问路径 http://host:port/kylin/api/acl/row/paged/{project}/{table}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### 路径变量
* project - `必选` `string`，项目名称
* table - `必选` `string`，表名称

#### 请求主体
* pageSize - `可选` `int`, 默认为10 分页返回每页返回的条数
* pageOffset - `可选` `int`, 默认为0 返回数据的起始下标

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/row/paged/learn_kylin/DEFAULT.KYLIN_SALES`

#### Curl 访问示例
```
curl -X GET -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{"pageSize":10，"pageOffset":0 }' http://host:port/kylin/api/acl/row/paged/learn_kylin/DEFAULT.KYLIN_SALES
```

#### 响应信息

- type - 目前只有值：CLOSED，表示等号 =
- leftExpr - 需要限定的值
- rightExpr - 需要限定的值，rightExpr 必须与 leftExpr 相等

#### 响应示例
```json
{
  "code":"000",
  "data":
    {
      "size":1,
      "user":[
       {
          "ADMIN":{
             "ACCOUNT_BUYER_LEVEL":[[1,"333"],[1,"444"],[1,"332323"]],
             "ACCOUNT_ID":[[1,"123"],[1,"444"],[1,"555"]]}
          }
      ],
      "group":[
          "ROLE_ADMIN":{
             "ACCOUNT_BUYER_LEVEL":[[1,"333"],[1,"444"],[1,"332323"]],
             "ACCOUNT_ID":[[1,"123"],[1,"444"],[1,"555"]]}
          }
      ]
    },
    "msg":"get column cond list in table"
}
```

### 添加用户的行级ACL
`请求方式 POST`

`访问路径 http://host:port/kylin/api/acl/row/{project}/{type}/{table}/{username}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### 路径变量
* project - `必选` `string`，项目名称
* type - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
* table - `必选` `string`，表名称
* username - `必选` `string`，用户名

#### 请求主体
* condsWithColumn - `必选` `map` 列与conditions的键值对，详见下面请求示例中的请求主体

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN`

```

请求主体:代表 TRANS_ID 的取值为1,2,3.(TRANS_ID=1 OR TRANS_ID=2 OR TRANS_ID=3)

{
  "condsWithColumn": {
    "TRANS_ID": [
      {
        "type": "CLOSED",
        "leftExpr": "1",
        "rightExpr": "1"
      },
      {
        "type": "CLOSED",
        "leftExpr": "2",
        "rightExpr": "2"
      },
      {
        "type": "CLOSED",
        "leftExpr": "3",
        "rightExpr": "3"
      }
    ]
  }
}
```

#### Curl 访问示例
```
curl -X POST -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "condsWithColumn":[{type: "CLOSED", leftExpr: "1", rightExpr: "1"}]}' http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN
```

#### 响应示例
```json
{"code":"000","data":"","msg":"add user row cond list."}
```

### 批量添加用户的行级ACL
`请求方式 POST`

`访问路径 http://host:port/kylin/api/acl/row/batch/{project}/{type}/{table}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### 路径变量
* project - `必选` `string`，项目名称
* type - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
* table - `必选` `string`，表名称

#### 请求主体
* 请求体是一个的map结构，key值为用户名，value也是一个map结构，它的key和value分别是列名和其列值的集合。详见下面请求示例中的请求主体

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/row/batch/learn_kylin/user/DEFAULT.KYLIN_SALES`

```

请求主体:
对于ADMIN用户，LSTG_FORMAT_NAME 的取值为 'Auction'，'ABIN'，OPS_REGION 的取值 'BEIJING';
对于ANALYST用户， LSTG_FORMAT_NAME 的取值为 'ABIN'

{
	"ADMIN": {
		"LSTG_FORMAT_NAME":[
			"Auction",
			"ABIN"
		],
		"OPS_REGION":[
			"BEIJING"
		]
	},
	"ANALYST": {
		"LSTG_FORMAT_NAME":[
			"ABIN"
		]
	}
}
```

#### Curl 访问示例
```
curl -X POST -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "ADMIN": { "LSTG_FORMAT_NAME":["Auction", "ABIN"],"OPS_REGION":["BEIJING"]},"ANALYST": { "LSTG_FORMAT_NAME":["ABIN"]} }' http://host:port/kylin/api/acl/row/batch/learn_kylin/user/DEFAULT.KYLIN_SALES
```

#### 响应示例
```json
{"code":"000","data":"","msg":"${user_count} user row ACL(s) updated"}
```

### 修改用户的行级ACL
`请求方式 PUT`

`访问路径 http://host:port/kylin/api/acl/row/{project}/{type}/{table}/{username}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### 路径变量
* project - `必选` `string`，项目名称
* type - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
* table - `必选` `string`，表名称
* username - `必选` `string`，用户名

#### 请求主体
* condsWithColumn - `必选` `map` 列与conditions的键值对，详见下面的请求示例中的请求主体

#### **请求示例**

`请求路径:http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN`

```
请求主体: 代表 TRANS_ID 的取值为1,2,3.(TRANS_ID=1 OR TRANS_ID=2 OR TRANS_ID=3)

{
  "condsWithColumn": {
    "TRANS_ID": [
      {
        "type": "CLOSED",
        "leftExpr": "1",
        "rightExpr": "1"
      },
      {
        "type": "CLOSED",
        "leftExpr": "2",
        "rightExpr": "2"
      },
      {
        "type": "CLOSED",
        "leftExpr": "3",
        "rightExpr": "3"
      }
    ]
  }
}
```
#### Curl 访问示例
```
curl -X PUT -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "condsWithColumn":[{type: "CLOSED", leftExpr: "1", rightExpr: "1"}]}' http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN
```

#### 响应示例

```json
{"code":"000","data":"","msg":"update user's row cond list"}
```

### 删除用户的行级ACL
`请求方式 DELETE`

`访问路径 http://host:port/kylin/api/acl/row/{project}/{type}/{table}/{username}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### 路径变量
* project - `必选` `string`，项目名称
* type - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
* table - `必选` `string`，表名称
* username - `必选` `string`，用户名

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN`

#### Curl 访问示例
```
curl -X DELETE -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN
```

#### 响应示例
```
{"code":"000","data":"","msg":"delete user's row cond list"}
```