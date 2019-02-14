## 列级访问控制权限 API

> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](../authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [获取列级访问控制权限](#获取列级访问控制权限)
* [赋予列级访问控制权限](#赋予列级访问控制权限)
* [批量赋予列级访问控制权限](#批量赋予列级访问控制权限)
* [修改列级访问控制权限](#修改列级访问控制权限)
* [删除列级访问控制权限](#删除列级访问控制权限)



### 获取列级访问控制权限

- `GET http://host:port/kylin/api/acl/column/paged/{project}/{table}`


- URL Parameters
  - `project` - `必选` `string`，项目名称
  - `table` - `必选` `string`，表名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `pageSize` - `可选` `int`，每页返回的条数，默认为 10 
  - `pageOffset` - `可选` `int`，返回数据的偏移量，默认为 0 


- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/acl/column/paged/learn_kylin/DEFAULT.KYLIN_CAL_DT' \
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
          "size": 0,
          "user": [],
          "group": []
      },
      "msg": "get column acl"
  }
  ```



### 赋予列级访问控制权限

- `POST http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

- URL Parameters
  - `project` - `必选` `string`，项目名称
  - `type` - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
  - `table` - `必选` `string`，表名称
  - `username` - `必选` `string`，用户名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - 请求体是 string 列表 ，即需要赋予列级访问权限的列


- Curl 请求示例

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '["QTR_BEG_DT"]'
  ```

  > 提示：示例 Curl 请求将 ADMIN 用户赋予对表 DEFAULT.KYLIN_CAL_DT 在 QTR_BEG_DT 的列级访问控制权限。


- 响应示例

  ```json
  {
      "code": "000",
      "data": "",
      "msg": "add user to column black list."
  }
  ```



### 批量赋予列级访问控制权限

- `POST http://host:port/kylin/api/acl/column/batch/{project}/{type}/{table}/{username}`


- URL Parameters
  - `project` - `必选` `string`，项目名称
  - `type` - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
  - `table` - `必选` `string`，表名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - 请求体是键值对结构，键为用户名，值为对应的列。


- Curl 请求示例

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/acl/column/batch/learn_kylin/user/DEFAULT.KYLIN_SALES' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
    "ADMIN": ["TRANS_ID","PART_DT"],
    "MODELER": ["PRICE"]
   }'
  ```

  > 提示：示例 Curl 请求将 ADMIN 用户赋予对表 DEFAULT.KYLIN_SALES 的 TRANS_ID 和 PART_DT 的列级访问控制权限；将 MODELER 用户赋予对表 DEFAULT.KYLIN_SALES 在 PRICE 的列级访问控制权限。


- 响应示例

  ```json
  {
      "code": "000",
      "data": "",
      "msg": "2 user column ACL(s) updated"
  }
  ```



### 修改列级访问控制权限

- `PUT http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

- URL Parameters
  - `project` - `必选` `string`，项目名称
  - `type` - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
  - `table` - `必选` `string`，表名称
  - `username` - `必选` `string`，用户名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - 请求体为 string 列表，即需要修改列级访问权限的列


- Curl 请求示例

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '["TRANS_ID"]'
  ```

  > 提示：示例 Curl 请求将 ADMIN 用户修改对表 DEFAULT.KYLIN_SALES 在 TRANS_ID 的列级访问控制权限。


- 响应示例

  ```json
  {
      "code": "000",
      "data": "",
      "msg": "update user's black column list"
  }
  ```



### 删除列级访问控制权限

- `DELETE  http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

- URL Parameters
  - `project` - `必选` `string`，项目名称
  - `type` - `必选` `string`，用来表示操作是用户操作还是用户组操作，取值：user/group
  - `table` - `必选` `string`，表名称
  - `username` - `必选` `string`，用户名称

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例

  ```sh
  curl -X DELETE \
    'http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_SALES/ANALYST' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

  > 提示：示例 Curl 请求删除 ANALYST 用户对表 DEFAULT.KYLIN_SALES  的列级访问控制权限。

- 响应示例

  ```json
  {
      "code": "000",
      "data": "",
      "msg": "delete user from DEFAULT.KYLIN_SALES's column black list"
  }
  ```
