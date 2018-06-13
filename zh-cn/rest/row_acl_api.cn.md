## 行级访问权限 REST API

> **提示**
>
> 使用API前请确保已阅读前面的**访问及安全认证**章节，知道如何在API中添加认证信息。
>


* [获取用户的行级ACL](#获取用户的行级ACL)
* [添加用户的行级ACL](#添加用户的行级ACL)
* [修改用户的行级ACL](#修改用户的行级ACL)
* [删除用户的行级ACL](#删除用户的行级ACL)

### 获取用户的行级ACL
`请求方式 GET`

`访问路径 http://host:port/kylin/api/acl/row/{project}/{table}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* project - `必选` `string`，项目名称
* table - `必选` `string`，表名称

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/row/learn_kylin/DEFAULT.KYLIN_SALES`

#### 响应信息

- type - 目前只有值：CLOSED，表示等号 =
- leftExpr - 需要限定的值
- rightExpr - 需要限定的值，rightExpr 必须与 leftExpr 相等

#### 响应示例
```json
{
  "code": "000",
  "data": {
    "{ADMIN,u}": {
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
    },
    "{ALL_USERS,g}": {
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
  },
  "msg": "get column cond list in table"
}
```

### 添加用户的行级ACL
`请求方式 POST`

`访问路径 http://host:port/kylin/api/acl/row/{project}/{type}/{table}/{username}`

`Content-Type: application/vnd.apache.kylin-v2+json`

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

#### 响应示例
```json
{"code":"000","data":"","msg":"add user row cond list."}
```

### 修改用户的行级ACL
`请求方式 PUT`

`访问路径 http://host:port/kylin/api/acl/row/{project}/{type}/{table}/{username}`

`Content-Type: application/vnd.apache.kylin-v2+json`

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

#### 响应示例

```json
{"code":"000","data":"","msg":"update user's row cond list"}
```

### 删除用户的行级ACL
`请求方式 DELETE`

`访问路径 http://host:port/kylin/api/acl/row/{project}/{type}/{table}/{username}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* project - `必选` `string`，项目名称
* type - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
* table - `必选` `string`，表名称
* username - `必选` `string`，用户名

#### 请求示例
`请求路径:http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN`

#### 响应示例
```
{"code":"000","data":"","msg":"delete user's row cond list"}
```