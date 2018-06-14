## Column ACL REST API

> **Tip**
>
> Before using API, please make sure that you have read the previous chapter of *Access and Authentication* in advance and know how to add verification information in API. 


* [Get Black List under Column](#get-black-list-under-column)
* [Add Column ACL](#add-column-acl)
* [Modify Column ACL](#modify-column-acl)
* [Delete Column ACL](#delete-column-acl)

### Get Black List under Column

`Request Mode GET`

`Access Path http://host:port/kylin/api/acl/column/paged/{project}/{table}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### Path Variable
* project - `required` `string`, project name
* table - `required` `string`, table name

#### Request Body
* pageSize - `optional` `int`, default 10, how many lines would be included in each returned page.
* pageOffset - `optional` `int`, default 0, get data start subscript.

#### Request Example
`Request Path:http://host:port/kylin/api/acl/column/paged/learn_kylin/DEFAULT.KYLIN_SALES`

#### Response Example
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

### Add Column ACL
`Request Mode POST`

`Access Path http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### Path Variable
* project - `required` `string`, project name
* type - `required` `string`, indicate the type of action, value: user/group
* table - `required` `string`, table name
* username - `required` `string`, user name

#### Request Body
* columns - `required` `string list`, list name. For details, see the request body in the following request example.

#### Request Example
`Request Path:http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

`Request Body:["CAL_DT", "YEAR_BEG_DT"]`

#### Response Example
```json
{"code":"000","data":"","msg":"add user to column black list."}
```

### Modify Column ACL
`Request Mode PUT`

`Access Path http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### Path Variable
* project - `required` `string`, project name
* type - `required` `string`，indicate the type of action, value: user/group
* table - `required` `string`, table name
* username - `required` `string`, user name

#### Request Body
* columns - `required` `string list`, column name. For details, see the request body in the following request example.

#### Request Example
`Request Path:http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

`Request Body:["YEAR_BEG_DT", "CAL_DT", "QTR_BEG_DT"]`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### Response Example
```json
{"code":"000","data":"","msg":"update user's black column list"}
```

### Delete Column ACL
`Request Mode DELETE`

`Access Path http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

`Content-Type: application/vnd.apache.kylin-v2+json`

#### Path Variable
* project - `required` `string`, project name
* type - `required` `string`，indicate the type of action, value: user/group
* table - `required` `string`, table name
* username - `required` `string`, user name

#### Request Example
`Request Path:http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

#### Response Example
```
{"code":"000","data":"","msg":"delete user from DEFAULT.KYLIN_CAL_DT's column black list"}
```