## 行级访问控制权限 API

> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [获取行级访问控制权限](#获取行级访问控制权限)
* [赋予行级访问控制权限](#赋予行级访问控制权限)
* [批量赋予行级访问控制权限](#批量赋予行级访问控制权限)
* [修改行级访问控制权限](#修改行级访问控制权限)
* [删除行级访问控制权限](#删除行级访问控制权限)



### 获取行级访问控制权限

- `GET http://host:port/kylin/api/acl/row/paged/{project}/{table}`


- URL Parameters
  - project - `必选` `string`，项目名称
  - table - `必选` `string`，表名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - pageSize - `可选` `int`，分页返回每页返回的条数，默认为 10 
  - pageOffset - `可选` `int`，返回数据的起始下标，默认为 0


- Curl 请求示例

```shell
  curl -X GET \
    'http://host:port/kylin/api/acl/row/paged/learn_kylin/DEFAULT.KYLIN_SALES' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
```

  > 提示：示例 Curl 请求返回 learn_kylin 项目下，表 DEFAULT.KYLIN_SALES 的行级访问控制权限。


- 响应示例

```JSON
  {
      "code": "000",
      "data": {
          "size": 1,
          "user": [
              {
                  "ADMIN": {
                      "PART_DT": [
                          [
                              1,
                              "1"
                          ]
                      ]
                  }
              }
          ],
          "group": []
      },
      "msg": "get column cond list in table"
  }
```



### 赋予行级访问控制权限

- `POST http://host:port/kylin/api/acl/row/{project}/{type}/{table}/{username}`


- URL Parameters
  - `project` - `必选` `string`，项目名称
  - `type` - `必选` `string`，操作对象，用户：user；用户组：group
  - `table` - `必选` `string`，表名称
  - `username` - `必选` `string`，用户名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `condsWithColumn` - `必选` `map`，列与对应行级访问控制权限的键值对，其中行级访问控制权限需要包括以下参数：
  - `type` - "CLOSED"，表示等号
  - `leftExpr` - 需要限定的值
  - `rightExpr` - 需要限定的值，`rightExpr` 必须与 `leftExpr` 相等


- Curl 请求示例

```shell
  curl -X POST \
    'http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
    "condsWithColumn": {
      "PART_DT": [
        {
          "type": "CLOSED",
          "leftExpr": "1",
          "rightExpr": "1"
        }
      ]
    }
  }'
```

  > 提示：示例 Curl 请求赋予用户 ADMIN 对表 DEFAULT.KYLIN_SALES 在 PART_DT 值为 1 的行级访问控制权限。


- 响应示例

```JSON
  {
      "code": "000",
      "data": "",
      "msg": "add user row cond list."
  }
```



### 批量赋予行级访问控制权限

- `POST http://host:port/kylin/api/acl/row/batch/{project}/{type}/{table}`


- URL Parameters
  - `project` - `必选` `string`，项目名称
  - `type` - `必选` `string`，操作对象，用户：user；用户组：group
  - `table` - `必选` `string`，表名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - 用户名和对应行级访问控制权限的键值对


- Curl 请求示例

```shell
  curl -X POST \
    'http://host:port/kylin/api/acl/row/batch/{project}/user/DEFAULT.KYLIN_SALES' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '  {
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
  }'
```

  > 提示：示例 Curl 请求赋予用户 ADMIN 对表 DEFAULT.KYLIN_SALES 在行 LSTG_FORMAT_NAME 取值为 'Auction' 和 'ABIN'，OPS_REGION 取值为 'BEIJING' 的行级访问控制权限，同时赋予用户 ANALYST 对表 DEFAULT.KYLIN_SALES 在行 LSTG_FORMAT_NAME 取值为 'ABIN' 的行级访问控制权限。


- 响应示例

```JSON
  {
      "code": "000",
      "data": "",
      "msg": "2 user row ACL(s) updated"
  }
```



### 修改行级访问控制权限

- `PUT http://host:port/kylin/api/acl/row/{project}/{type}/{table}/{username}`


- URL Parameters
  - `project` - `必选` `string`，项目名称
  - `type` - `必选` `string`，操作对象，用户：user；用户组：group
  - `table` - `必选` `string`，表名称
  - `username` - `必选` `string`，用户名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `condsWithColumn` - `必选`，列与对应行级访问控制权限的键值对


- Curl 请求示例

```shell
  curl -X POST \
    'http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
    "condsWithColumn": {
      "PART_DT": [
        {
          "type": "CLOSED",
          "leftExpr": "1",
          "rightExpr": "1"
        }
      ]
    }
  }'
```

  > 提示：示例 Curl 请求修改用户 ADMIN 对表 DEFAULT.KYLIN_SALES 在 PART_DT 取值为 '1' 的行级访问控制权限。


- 响应示例

```JSON
  {
      "code": "000",
      "data": "",
      "msg": "update user's row cond list"
  }
```



### 删除行级访问控制权限

- `DELETE http://host:port/kylin/api/acl/row/{project}/{type}/{table}/{username}`


- URL Parameters
  - `project` - `必选` `string`，项目名称
  - `type` - `必选` `string`，操作对象，用户：user；用户组：group
  - `table` - `必选` `string`，表名称
  - `username` - `必选` `string`，用户名称


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例

```shell
  curl -X DELETE \
    'http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
```

  > 提示：示例 Curl 请求删除用户 ADMIN 对表 DEFAULT.KYLIN_SALES 的行级访问控制权限。

- 响应示例

```JSON
  {
      "code": "000",
      "data": "",
      "msg": "delete user's row cond list"
  }```
```
