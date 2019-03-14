## 用户管理 API

> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](../authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [返回用户列表](#返回用户列表)
* [创建用户](#创建用户)
* [修改用户](#修改用户)
* [删除用户](#删除用户)
* [返回用户拥有的项目及表权限](#返回用户拥有的项目及表权限)
* [返回用户拥有的行级权限](#返回用户拥有的行级权限)
* [返回用户拥有的列级权限](#返回用户拥有的列级权限)



### 返回用户列表

- `GET http://host:port/kylin/api/kap/user/users`


- URL Parameters
  - `project` - `可选` `string`，项目名称
  - `name` - `可选` `string`，用户名称
  - `isCaseSensitive` - `可选` `boolean`，对用户名称的模糊匹配是否区分大小写，默认不区分
  - `pageOffset` - `可选` `int`，返回数据的起始下标，默认为 0 
  - `pageSize` - `可选` `int`，分页返回每页返回的条数，默认为 10


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/kap/user/users?pageSize=1&project=learn_kylin' \
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
          "users": [
              {
                  "username": "ADMIN",
                  "password": "$2a$10$UfSim3k3g6mBCPnZULlynuyyV3OVKhy174iOBoNVplZXZJlb2TPRu",
                  "authorities": [...],
                  "disabled": false,
                  "defaultPassword": true,
                  "locked": false,
                  "lockedTime": 0,
                  "wrongTime": 0,
                  "uuid": "aec35307-8d41-45a0-a942-91d4e92e11e4",
                  "last_modified": 1537860587117,
                  "version": "3.0.0.1"
              }
          ]
      },
      "msg": ""
  }
  ```



### 创建用户

- `POST http://host:port/kylin/api/kap/user/{userName}`


- URL Parameters
  - `userName` - `必选` `string`，用户名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `password` - `必选` `string`，用户密码
  - `disabled` - `必选` `boolean`，是否启用，可填内容 ``true``（代表该用户处于禁用状态），``false``（代表该用户处于启用状态）
  - `authorities` - `必选` `string[]`，用户所属用户组


- Curl 请求示例

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/kap/user/test' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
  	"password": "test@Kyligence",
  	"disabled": false, 
  	"authorities": ["ROLE_ADMIN"]
  	
  }'
  ```


- 响应示例

  ```json
  {
      "username": "test",
      "password": "$2a$10$Iw4NYBNW2bCTN3BqCGVfrO5Loesn/UigQxvbBQFebH2fEkFE2gcHy",
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
      "wrongTime": 0,
      "uuid": "ffdd3033-d516-4b4f-a7fe-6718280746bb",
      "last_modified": 1538964238173,
      "version": "3.0.0.1"
  }
  ```



### 修改用户

- `PUT http://host:port/kylin/api/kap/user/{userName}`


- URL Parameters
  - `userName` - `必选` `string`，用户名称


- HTTP Body: JSON Object
  - `password` - `必选` `string`，用户密码
  - `disabled` - `必选` `boolean`，是否启用，可填内容 ``true``（代表该用户处于禁用状态），``false``（代表该用户处于启用状态）
  - `authorities` - `必选` `string[]`，用户所属用户组


- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/kap/user/test' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
  	"password": "test123.",
  	"disabled": false, 
  	"authorities": ["ROLE_ANALYST"]
  	
  }'
  ```


- 响应示例

  ```json
  {
      "username": "test",
      "password": "$2a$10$M3u5cQztMHg3LIvMFJ4ZY.RidLB9RAw0gBHHV6EBNzEvxMk6Pf69u",
      "authorities": [...],
      "disabled": false,
      "defaultPassword": false,
      "locked": false,
      "lockedTime": 0,
      "wrongTime": 0,
      "uuid": "4713b0fb-4f4b-4842-af33-863f3b8bc7e2",
      "last_modified": 1538965388437,
      "version": "3.0.0.1"
  }
  ```



### 删除用户

- `DELETE http://host:port/kylin/api/kap/user/{userName}`


- URL Parameters
  - `userName` - `必选` `string`，用户名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例

  ```sh
  curl -X DELETE \
    'http://host:port/kylin/api/kap/user/test' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```



### 返回用户拥有的项目及表权限

* `GET http://host:port/kylin/api/access/{userName}`

* URL Parameters

  * `userName` - `必选` `string`，用户名称
* HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

* Curl 请求示例

  ```shell
  curl -X GET \
  'http://host:port/kylin/api/access/ADMIN' \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8'
  ```

* 响应示例

  ```json
  {
      "code":"000",
      "data":[
          {
              "project_name":"test1",
              "table_name":[
                  "KAP.KYLIN_ACCOUNT",
                  "KAP.KYLIN_CAL_DT",
                  "KAP.KYLIN_SALES",
                  "KAP.KYLIN_COUNTRY",
                  "KAP.KYLIN_CATEGORY_GROUPINGS"
              ]
          }
      ],
      "msg":""
  }
  ```


### 返回用户拥有的行级权限

* `GET http://host:port/kylin/api/access/{userName}/{projectName}/{tableName}/row`

* URL Parameters

  - `userName` - `必选` `string`，用户名称
  - `projectName` - `必选` `string`，项目名称
  - `tableName` - `必选` `string`，表名称

* HTTP Header

  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

* Curl 请求示例

  ```shell
  curl -X GET \
  'http://host:port/kylin/api/access/ADMIN/learn_kylin/DEFAULT.KYLIN_SALES/row' \
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
          "white_list":"(PART_DT=DATE '2012-01-01')",
          "user_name":"ADMIN",
          "project_name":"learn_kylin",
          "table_name":"DEFAULT.KYLIN_SALES"
      },
      "msg":""
  }
  ```



### 返回用户拥有的列级权限

* `GET http://host:port/kylin/api/access/{userName}/{projectName}/{tableName}/column`

* URL Parameters

  - `userName` - `必选` `string`，用户名称
  - `projectName` - `必选` `string`，项目名称
  - `tableName` - `必选` `string`，表名称

* HTTP Header

  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

* Curl 请求示例

  ```shell
  curl -X GET \
  'http://host:port/kylin/api/access/ADMIN/learn_kylin/DEFAULT.KYLIN_SALES/column' \
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
          "black_list":[
              "TRANS_ID"
          ],
          "user_name":"ADMIN",
          "project_name":"learn_kylin",
          "table_name":"DEFAULT.KYLIN_SALES"
      },
      "msg":""
  }
  ```