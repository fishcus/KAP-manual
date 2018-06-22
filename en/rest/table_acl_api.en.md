## Table ACL REST API

> Tip**
>
> Before using API, please make sure that you have read the previous chapter of *Access and Authentication* in advance and know how to add verification information in API. 


* [Get Table ACL](#get-table-acl)
* [Grant Table ACL](#grant-table-acl)
* [Delete Table ACL](#delete-table-acl)

### Get Table ACL
`Request Mode GET`

`Access Path http://host:port/kylin/api/acl/table/paged/{project}/{table}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* project - `required` `string`, project name
* table - `required` `string`, table name

#### Request Body
* pageSize - `optional` `int`, default 10, how many lines would be included in each returned page.
* pageOffset - `optional` `int`, default 0, get data start subscript.

#### Request Example
`Request Path:http://host:port/kylin/api/acl/table/paged/learn_kylin/DEFAULT.KYLIN_SALES`


#### Curl Request Example
```
curl -X GET -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -d '{"pageSize":10，“pageOffset”:0 }' http://host:port/kylin/api/acl/table/paged/learn_kylin/DEFAULT.KYLIN_SALES
```

#### Response Example
```json
{
  "code": "000",
  "data": {
    "size": 2,
    "user": [
      "ROLE_ADMIN"
    ],
    group: [
      "ADMIN"
    ]
  },
  "msg": "get table acl"
}
```

### Grant Table ACL
`Request Mode POST`

`Access Path http://host:port/kylin/api/acl/table/{project}/{type}/{table}/{name}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* project - `required` `string`, project name
* type - `required` `string`, indicate the type of action, value: user/group
* table - `required` `string`, table name
* username - `required` `string`, user name

#### Request Example
`Request Path:http://host:port/kylin/api/acl/table/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

#### Curl Request Example
```
curl -X POST -H "Authorization: Basic xxxxxx" -H “Accept: application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/acl/table/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN
```

#### Response Example
```json
{"code":"000","data":"","msg":"grant user table query permission and remove user from table black list."}
```

### Delete Row ACL
`Request Mode DELETE`

`Access Path http://host:port/kylin/api/acl/table/{project}/{type}/{table}/{name}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* project - `required` `string`, project name
* type - `required` `string`，indicate the type of action, value: user/group
* table - `required` `string`, table name
* username - `required` `string`, user name

#### Request Example
`Request Path:http://host:port/kylin/api/acl/table/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

#### Curl Request Example
```
curl -X DELETE -H "Authorization: Basic xxxxxx" -H “Accept: application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/acl/table/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN
```

#### Response Example
```
{"code":"000","data":"","msg":"revoke user table query permission and add user to table black list."}
```