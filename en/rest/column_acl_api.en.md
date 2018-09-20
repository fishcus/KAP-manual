## Column ACL API

> **Tip**
>
> Before using API, make sure that you read the previous chapter of [Access and Authentication](authentication.en.md), and know how to add authentication information in API.
>
> If there exists `&` in your request path, please enclose the URL in quotation marks `""` or add a backslash ahead  `\&`  to avoid being escaped.


* [Get Black List under Column](#get-black-list-under-column)
* [Add Column ACL](#add-column-acl)
* [Batch Add Column ACL](#batch-add-column-acl)
* [Modify Column ACL](#modify-column-acl)
* [Delete Column ACL](#delete-column-acl)

### Get Black List under Column

`Request Mode GET`

`Access Path http://host:port/kylin/api/acl/column/paged/{project}/{table}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variables
* project - `required` `string`, project name
* table - `required` `string`, table name

#### Request Body
* pageSize - `optional` `int`, default 10, how many lines would be included in each returned page.
* pageOffset - `optional` `int`, default 0, get data start subscript.

#### Request Example
`Request Path:http://host:port/kylin/api/acl/column/paged/learn_kylin/DEFAULT.KYLIN_SALES`

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{"pageSize":10，"pageOffset":0 }' http://host:port/kylin/api/acl/column/paged/learn_kylin/DEFAULT.KYLIN_SALES
```

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

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variables
* project - `required` `string`, project name
* type - `required` `string`, indicate the type of action, value: user/group
* table - `required` `string`, table name
* username - `required` `string`, user name

#### Request Body
* columns - `required` `string list`, list name. For details, see the request body in the following request example.

#### Request Example
`Request Path:http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

`Request Body:["CAL_DT", "YEAR_BEG_DT"]`

#### Curl Request Example
```
curl -X POST -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '["YEAR_BEG_DT", "CAL_DT", "QTR_BEG_DT"]' http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN
```

#### Response Example
```json
{"code":"000","data":"","msg":"add user to column black list."}
```

### Batch Add Column ACL
`Request Mode POST`

`Access Path http://host:port/kylin/api/acl/column/batch/{project}/{type}/{table}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* project - `required` `string`, project name
* type - `required` `string`, indicate the type of action, value: user/group
* table - `required` `string`, table name

#### Request Body
* The request body is a map structure with user name as the key and column list as the value. For details, see the request body in the following request example.

#### Request Example
`Request Path:http://host:port/kylin/api/acl/column/batch/learn_kylin/user/DEFAULT.KYLIN_CAL_DT`

```
Request Body:
ADMIN's values:'LSTG_FORMAT_NAME','PART_DT';
ANALYST's value:'LSTG_FORMAT_NAME'

{
	"ADMIN": [
		"LSTG_FORMAT_NAME",
		"PART_DT"
	],
	"ANALYST": [
		"LSTG_FORMAT_NAME"
	]
}
```

#### Curl Request Example
```
curl -X POST -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "ADMIN": ["LSTG_FORMAT_NAME", "PART_DT"],"ANALYST": ["LSTG_FORMAT_NAME"]}' http://host:port/kylin/api/acl/column/batch/learn_kylin/user/DEFAULT.KYLIN_CAL_DT
```

#### Response Example
```json
{"code":"000","data":"","msg":"${user_count} user column ACL(s) updated"}
```

### Modify Column ACL
`Request Mode PUT`

`Access Path http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variables
* project - `required` `string`, project name
* type - `required` `string`，indicate the type of action, value: user/group
* table - `required` `string`, table name
* username - `required` `string`, user name

#### Request Body
* columns - `required` `string list`, column name. For details, see the request body in the following request example.

#### Request Example
`Request Path:http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

`Request Body:["YEAR_BEG_DT", "CAL_DT", "QTR_BEG_DT"]`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Curl Request Example
```
curl -X PUT -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '["YEAR_BEG_DT", "CAL_DT", "QTR_BEG_DT"]' http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN
```

#### Response Example
```json
{"code":"000","data":"","msg":"update user's black column list"}
```

### Delete Column ACL
`Request Mode DELETE`

`Access Path http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variables
* project - `required` `string`, project name
* type - `required` `string`，indicate the type of action, value: user/group
* table - `required` `string`, table name
* username - `required` `string`, user name

#### Request Example
`Request Path:http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN`

#### Curl Request Example
```
curl -X DELETE -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json"  -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN
```

#### Response Example
```
{"code":"000","data":"","msg":"delete user from DEFAULT.KYLIN_CAL_DT's column black list"}
```