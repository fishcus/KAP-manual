## 用户组管理 API

> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](../authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [返回用户组列表](#返回用户组列表)
* [返回用户组及其用户](#返回用户组及其用户)
* [返回指定用户组的用户列表](#返回指定用户组的用户列表)
* [增加用户组](#增加用户组)
* [删除用户组](#删除用户组)
* [更新用户组](#更新用户组)



### 返回用户组列表

- `GET http://host:port/kylin/api/user_group/groups`


- URL Parameters
  - `project` - `必选` `string`，项目名称，返回该项目下用户组列表


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/user_group/groups?project=learn_kylin' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- 响应示例

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



### 返回用户组及其用户

- `GET http://host:port/kylin/api/user_group/usersWithGroup`


- URL Parameters
  - `pageOffset` - `可选` `int`，返回数据的起始下标，默认为 0 
  - `pageSize` - `可选` `int`，分页返回每页返回的条数，默认为 10


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/user_group/usersWithGroup?pageSize=1' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- 响应示例

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
                  ],
                  "key": "ALL_USERS",
                  "value": [
                      "ADMIN",
                      "ANALYST",
                      "MODELER"
                  ]
              }
          ]
      },
      "msg": "get users with group"
  }
  ```



### 返回指定用户组的用户列表

- `GET http://host:port/kylin/api/user_group/groupMembers/{groupName}`


- URL Parameters
  - `groupName` - `必选` `string`，用户组名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/user_group/groupMembers/ALL_USERS' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- 响应示例

  ```json
  {
      "code":"000",
      "data":{
          "groupMembers":[
              {
                  "username":"ADMIN",
   				"password":"...",
                  "authorities":[...],
                  "disabled":false,
                  "defaultPassword":true,
                  "locked":false,
                  "lockedTime":0,
                  "wrongTime":0,
                  "uuid":"aec35307-8d41-45a0-a942-91d4e92e11e4",
                  "last_modified":1537860587117,
                  "version":"3.0.0.1"
              }
          ],
          "size":1
      },
      "msg":"get groups members"
  }
  ```



### 增加用户组

- `POST http://host:port/kylin/api/user_group/{groupName}`


- URL Parameters
  - `groupName` - `必选` `string`，用户组名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/user_group/group_test' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- 响应示例

  ```json
  {
      "code": "000",
      "data": "",
      "msg": "add user group"
  }
  ```


### 删除用户组

- `DELETE http://host:port/kylin/api/user_group/{groupName}`


- URL Parameters
  - `groupName` - `必选` `string`，用户组名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例

  ```sh
  curl -X DELETE \
    'http://host:port/kylin/api/user_group/group_test' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- 响应示例

  ```json
  {
      "code": "000",
      "data": "",
      "msg": "del user group"
  }
  ```



### 更新用户组

> 注意：更新用户组并非新增用户到指定用户组，而是覆盖原有的用户列表。

- `POST http://host:port/kylin/api/user_group/users/{groupName}`


- URL Parameters
  - `groupName` - `必选` `string`，用户组名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object

  - `必选` `string[]`，用户名称列表

- Curl 请求示例

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/user_group/users/group_test' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '["ADMIN","ANALYST"]'
  ```


- 响应示例

  ```json
  {
      "code": "000",
      "data": "",
      "msg": "modify users in user group"
  }
  ```
