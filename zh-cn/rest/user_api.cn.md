## 用户管理 REST API

> **提示**
>
> 使用API前请确保已阅读前面的**访问及安全认证**章节，知道如何在API中添加认证信息。
>


* [获取所有用户](#获取所有用户)
* [创建用户](#创建用户)
* [修改用户](#修改用户)
* [删除用户](#删除用户)

### 获取所有用户
`请求方式 GET`

`访问路径 http://host:port/kylin/api/kap/users/user`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 请求参数
* project - `可选` `string`，用来判断当前用户是否有拉取所有用户的权限，为空时需要全局 admin 权限才能拉取
* name - `可选` `string`，用来过滤拉取的用户列表
* isCaseSensitive - `可选` `bool`，表示上面 name 参数的模糊匹配是否为区分大小写，默认不区分大小写
* pageOffset - `可选` `int`
* pageSize - `可选` `int`

#### 请求示例
`请求路径: http://host:port/kylin/api/kap/user/users?pageSize=9&pageOffset=0&project=default`

#### 响应示例
```json
{
  "code": "000",
  "data": {
    "size": 3,
    "users": [
      {
        "username": "ADMIN",
        "password": "$2a$10$T6mhEmdwwwZJPPoON3k7t.9StfCCK1MkxMKNB8ZhsGqg853d5h2cS",
        "authorities": [
          {
            "authority": "ROLE_ADMIN"
          },
          {
            "authority": "ALL_USERS"
          }
        ],
        "disabled": false,
        "defaultPassword": false,
        "locked": false,
        "lockedTime": 0,
        "wrongTime": 1,
        "uuid": null,
        "last_modified": 1511179915000,
        "version": "3.0.0.1"
      },
      {
        "username": "ANALYST",
        "password": "$2a$10$Fy9s6NNxVX7YyoVW6cA35ucxgRzw41tdKG9WfyINHBcAAj7bWLPXa",
        "authorities": [
          {
            "authority": "ALL_USERS"
          }
        ],
        "disabled": false,
        "defaultPassword": true,
        "locked": false,
        "lockedTime": 0,
        "wrongTime": 0,
        "uuid": null,
        "last_modified": 1511073720000,
        "version": "3.0.0.1"
      },
      {
        "username": "MODELER",
        "password": "$2a$10$GHuQqTyjcymxwAYUJ8B2F.kDG3arZaYVKABNgX1Kh1HrTjV3hqBTS",
        "authorities": [
          {
            "authority": "ALL_USERS"
          }
        ],
        "disabled": false,
        "defaultPassword": true,
        "locked": false,
        "lockedTime": 0,
        "wrongTime": 0,
        "uuid": null,
        "last_modified": 1511073720000,
        "version": "3.0.0.1"
      }
    ]
  },
  "msg": ""
}
```

### 创建用户
`请求方式 POST`

`访问路径 http://host:port/kylin/api/kap/user/{userName}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* userName - `必选` `string`，用户名

#### 请求主体
* username - `必选` `string`，用户名
* password - `必选` `string`，密码
* disabled - `必选` `bool`，是否启用
* authorities - `必选` `string列表`，用户属于哪些组

#### 请求示例
`请求路径:http://host:port/kylin/api/kap/user/t`

`请求主体:{username: "t", password: "1qaz@WSX", disabled: false, authorities: ["ROLE_ADMIN"]}`

#### 响应示例
```json
{
  "username": "t",
  "password": "$2a$10$IhAeH0lIBDGI2Qw2lDvehuGQUOXkbYL/BmV/iu7dTpmNt3fUx7QTa",
  "authorities": [
    {
      "authority": "ROLE_ANALYST"
    }
  ],
  "disabled": false,
  "defaultPassword": false,
  "locked": false,
  "lockedTime": 0,
  "wrongTime": 0,
  "uuid": null,
  "last_modified": 1506583927000,
  "version": "3.0.0.1"
}
```

### 修改用户
`请求方式 PUT`

`访问路径 http://host:port/kylin/api/kap/user/{userName}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* userName - `必选` `string`，用户名

#### 请求主体
* username - `必选` `string`，用户名
* password - `必选` `string`，密码
* disabled - `必选` `bool`，是否启用
* authorities - `必选` `string列表`

#### 请求示例
`请求路径:http://host:port/kylin/api/kap/user/t`

`请求主体:{username: "t", password: "1qaz@WSX", disabled: false, authorities: ["ROLE_ADMIN"]}`

#### 响应示例
```json
{
  "username": "t",
  "password": "$2a$10$IhAeH0lIBDGI2Qw2lDvehuGQUOXkbYL/BmV/iu7dTpmNt3fUx7QTa",
  "authorities": [
    {
      "authority": "ROLE_ANALYST"
    }
  ],
  "disabled": false,
  "defaultPassword": false,
  "locked": false,
  "lockedTime": 0,
  "wrongTime": 0,
  "uuid": null,
  "last_modified": 1506583927000,
  "version": "3.0.0.1"
}
```

### 删除用户
`请求方式 DELETE`

`访问路径 http://host:port/kylin/api/kap/user/{userName}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* userName - `必选` `string`，用户名

#### 请求示例
`请求路径:http://host:port/kylin/api/kap/user/t`