## 用户组管理 REST API

> **提示**
>
> 使用API前请确保已阅读前面的**访问及安全认证**章节，知道如何在API中添加认证信息。
>


* [获取所有用户组](#获取所有用户组)
* [获取用户组及其用户](#获取用户组及其用户)
* [增加用户组](#增加用户组)
* [删除用户组](#删除用户组)
* [获取特定用户组下的所有用户](#获取特定用户组下的所有用户)
* [向用户组中加入用户](#向用户组中加入用户)

### 获取所有用户组
`请求方式 GET`

`访问路径 http://host:port/kylin/api/user_group/groups`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 请求主体
* project - `必须` `string`，用来判断当前用户是否有拉取所有用户的权限

#### 请求示例
`请求路径:http://host:port/kylin/api/user_group/groups?project=a`

#### 响应示例
```json
{
    "code": "000",
    "data": [
        "ALL_USERS",
        "ROLE_ADMIN",
        "ROLE_ANALYST",
        "ROLE_MODELER"
    ],
    "msg": "get groups"
}
```

### 获取用户组及其用户
`请求方式 GET`

`访问路径 http://host:port/kylin/api/user_group/usersWithGroup`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 请求参数
* pageOffset - `可选` `int`
* pageSize - `可选` `int`

#### 请求示例
`请求路径:http://host:port/kylin/api/user_group/usersWithGroup?pageSize=9&pageOffset=0`

#### 响应示例
```json
{
  "code": "000",
  "data": {
    "size": 4,
    "usersWithGroup": [
      {
        "first": "ALL_USERS",
        "second": [
          "ADMIN",
          "ANALYST",
          "MODELER"
        ]
      },
      {
        "first": "ROLE_ADMIN",
        "second": [
          "ADMIN"
        ]
      },
      {
        "first": "ROLE_ANALYST",
        "second": []
      },
      {
        "first": "ROLE_MODELER",
        "second": []
      }
    ]
  },
  "msg": "get users with group"
}
```

### 增加用户组
`请求方式 POST`

`访问路径 http://host:port/kylin/api/user_group/{groupName}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* groupName - `必选` `string` 组名

#### 请求示例
`请求路径:http://host:port/kylin/api/user_group/g1`

### 删除用户组
`请求方式 DELETE`

`访问路径 http://host:port/kylin/api/user_group/{groupName}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* groupName - `必选` `string` 组名

#### 请求示例
`请求路径:http://host:port/kylin/api/user_group/g1`

### 获取特定用户组下的所有用户
`请求方式 GET`

`访问路径 http://host:port/kylin/api/user_group/groupMembers/{name}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* name - `必选` `string` 组名

#### 请求示例
`请求路径:http://host:port/kylin/api/user_group/groupMembers/ALL_USERS`

#### 响应示例
```json
{
    "code": "000",
    "data": {
        "groupMembers": [
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
        ],
        "size": 3
    },
    "msg": "get groups members"
}
```

### 向用户组中加入用户
`请求方式 POST`

`访问路径 http://host:port/kylin/api/user_group/users/{groupName}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### 路径变量
* groupName - `必选` `string` 组名

#### 请求主体
用户列表，详见下面请求示例中的请求主体

#### 请求示例
`请求路径:http://host:port/kylin/api/user_group/users/g1`

`请求主体:["ADMIN","ANALYST","MODELER"]`