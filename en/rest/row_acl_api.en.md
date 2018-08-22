## Row ACL REST API

> **Tip**
>
> Before using API, please make sure that you have read the previous chapter of *Access and Authentication* in advance and know how to add verification information in API. 


* [Get Row ACL](#get-row-acl)
* [Add Row ACL](#add-row-acl)
* [Batch Add Row ACL](#batch-add-row-acl)
* [Modify Row ACL](#modify-row-acl)
* [Delete Row ACL](#delete-row-acl)

### Get Row ACL
`Request Mode GET`

`Access Path http://host:port/kylin/api/acl/row/paged/{project}/{table}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* project - `required` `string`, project name
* table - `required` `string`, table name

#### Request Body
* pageSize - `optional` `int`, default 10, how many lines would be included in each returned page.
* pageOffset - `optional` `int`, default 0, get data start subscript.

#### Request Example
`Request Path:http://host:port/kylin/api/acl/row/paged/learn_kylin/DEFAULT.KYLIN_SALES`

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic xxxxxx" -H Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{"pageSize":10，pageOffset":0 }' http://host:port/kylin/api/acl/row/paged/learn_kylin/DEFAULT.KYLIN_SALES
```

#### Response Information
- type - the value can only be CLOSED currently, indicating equal =
- leftExpr - value to be restricted
- rightExpr - value to be restricted, rightExpr shall be equal to leftExpr


#### Response Example
```json
{
  "code":"000",
  "data":
    {
      "size":1,
      "user":[
       {
          "ADMIN":{
             "ACCOUNT_BUYER_LEVEL":[[1,"333"],[1,"444"],[1,"332323"]],
             "ACCOUNT_ID":[[1,"123"],[1,"444"],[1,"555"]]}
          }
      ],
      "group":[
          "ROLE_ADMIN":{
             "ACCOUNT_BUYER_LEVEL":[[1,"333"],[1,"444"],[1,"332323"]],
             "ACCOUNT_ID":[[1,"123"],[1,"444"],[1,"555"]]}
          }
      ]
    },
    "msg":"get column cond list in table"
}
```

### Add Row ACL
`Request Mode POST`

`Access Path http://host:port/kylin/api/acl/row/{project}/{type}/{table}/{username}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* project - `required` `string`, project name
* type - `required` `string`, indicate the type of action, value: user/group
* table - `required` `string`, table name
* username - `required` `string`, user name

#### Request Body
* condsWithColumn - `required` `map`, key-value pairs of column and conditions. For details, see the request body in the following request example.

#### Request Example
`Request Path:http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN`

```
Request Body:TRANS_ID's values:1,2,3.(TRANS_ID=1 OR TRANS_ID=2 OR TRANS_ID=3)

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

#### Curl Request Example
```
curl -X POST -H "Authorization: Basic xxxxxx" -H Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "condsWithColumn":[{type: "CLOSED", leftExpr: "1", rightExpr: "1"}]}' http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN
```

#### Response Example
```json
{"code":"000","data":"","msg":"add user row cond list."}
```

### Batch Add Row ACL
`Request Mode POST`

`Access Path http://host:port/kylin/api/acl/row/batch/{project}/{type}/{table}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* project - `required` `string`, project name
* type - `required` `string`, indicate the type of action, value: user/group
* table - `required` `string`, table name


#### Request Body
* The request body is a map structure, key is the user name, value is also a map structure which has the column name as key and set of column values as value. For details, see the request body in the following request example.

#### Request Example
`Request Path:http://host:port/kylin/api/acl/row/batch/learn_kylin/user/DEFAULT.KYLIN_SALES`

```
Request Body:
LSTG_FORMAT_NAME's values:'Auction','ABIN' and OPS_REGION's value: 'BEIJING' for user ADMIN;
LSTG_FORMAT_NAME's value:'ABIN' for user ANALYST

{
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
}
```

#### Curl Request Example
```
curl -X POST -H "Authorization: Basic xxxxxx" -H Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "ADMIN": { "LSTG_FORMAT_NAME":["Auction", "ABIN"],"OPS_REGION":["BEIJING"]},"ANALYST": { "LSTG_FORMAT_NAME":["ABIN"]} }' http://host:port/kylin/api/acl/row/batch/learn_kylin/user/DEFAULT.KYLIN_SALES
```


#### Response Example
```json
{"code":"000","data":"","msg":"${user_count} user row ACL(s) updated"}
```

### Modify Row ACL
`Request Mode PUT`

`Access Path http://host:port/kylin/api/acl/row/{project}/{type}/{table}/{username}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* project - `required` `string`, project name
* type - `required` `string`, indicate the type of action, value: user/group
* table - `required` `string`, table name
* username - `required` `string`, user name

#### Request Body
* condsWithColumn - `required` `map`, key-value pairs of column and conditions. For details, see the request body in the following request example.

#### Request Example
`Request Path:http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN`

```
Request Body:TRANS_ID's values:1,2,3.(TRANS_ID=1 OR TRANS_ID=2 OR TRANS_ID=3)

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

#### Curl Request Example
```
curl -X PUT -H "Authorization: Basic xxxxxx" -H Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "condsWithColumn":[{type: "CLOSED", leftExpr: "1", rightExpr: "1"}]}' http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN
```

#### Response Example
```json
{"code":"000","data":"","msg":"update user's row cond list"}
```

### Delete Row ACL
`Request Mode DELETE`

`Access Path http://host:port/kylin/api/acl/row/{project}/{type}/{table}/{username}`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en`

#### Path Variable
* project - `required` `string`, project name
* type - `required` `string`, indicate the type of action, value: user/group
* table - `required` `string`, table name
* username - `required` `string`, user name

#### Request Body

`Request Path:http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN`


#### Curl Request Example
```
curl -X DELETE -H "Authorization: Basic xxxxxx" -H Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN
```

#### Response Example
```
{"code":"000","data":"","msg":"delete user's row cond list"}
```