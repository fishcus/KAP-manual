## Row ACL API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Get Row ACL ](#Get-Row-ACL)
* [Grant Row ACL ](#Grant-Row-ACL)
* [Grant Row ACL in batch](#Grant-Row-ACL-in-batch)
* [Update Row ACL](#Update-Row-ACL)
* [Revoke Row ACL](#Revoke-Row-ACL)



### Get Row ACL  {#Get-Row-ACL}

- `GET http://host:port/kylin/api/acl/row/paged/{project}/{table}`


- URL Parameters
  - project - `required` `string`, project name
  - table - `required` `string`, table name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `pageSize` - `optional` `int`, quantity of returned result per page, 10 by default
  - `pageOffset` - `optional` `int`, offset of returned result, 0 by default


- Curl Request Example

  ```shell
  curl -X GET \
    'http://host:port/kylin/api/acl/row/paged/learn_kylin/DEFAULT.KYLIN_SALES' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

  > Note: The Curl request example returns the row acl of table DEFAULT.KYLIN_SALES of project learn_kylin


- Response Example

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



### Grant Row ACL  {#Grant-Row-ACL}

- `POST http://host:port/kylin/api/acl/row/{project}/{type}/{table}/{username}`


- URL Parameters
  - `project` - `required` `string`, project name
  - `type` - `required` `string`, operation object, ie.,user or group
  - `table` - `required` `string`, table name
  - `username` - `required` `string`, user name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `condsWithColumn` - `required` `map`, the key-value pairs of columns and corresponding row acl, and row acl requires the following parameters,
  - `type` - "CLOSED", which means "equal to"
  - `leftExpr` - specified value
  - `rightExpr` - specified value, `rightExpr` must be equal to `leftExpr`


- Curl Request Example

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

  > Note: The Curl Request Example grants row acl on table DEFAULT.KYLIN_SALES on column PART_DT equals to value 1 to user ADMIN.


- Response Example

  ```JSON
  {
      "code": "000",
      "data": "",
      "msg": "add user row cond list."
  }
  ```



### Grant Row ACL in Batch  {#Grant-Row-ACL-in-batch}

- `POST http://host:port/kylin/api/acl/row/batch/{project}/{type}/{table}`


- URL Parameters
  - `project` - `required` `string`, project name
  - `type` - `required` `string`, operation object, ie., user or group
  - `table` - `required` `string`, table name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - Key-value pairs of user name and corresponding row ACL


- Curl Request Example

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

  > Note: The Curl Request Example grants row acl on table DEFAULT.KYLIN_SALES on column LSTG_FORMAT_NAME equaling to' Auction' and 'ABIN' to user ADMIN, also grants  row acl on table DEFAULT.KYLIN_SALES on column LSTG_FORMAT_NAME equaling to 'ABIN' to user ANALYST.


- Response Example

  ```JSON
  {
      "code": "000",
      "data": "",
      "msg": "2 user row ACL(s) updated"
  }
  ```



### Update Row ACL {#Update-Row-ACL}

- `PUT http://host:port/kylin/api/acl/row/{project}/{type}/{table}/{username}`


- URL Parameters
  - `project` - `required` `string`, project name
  - `type` - `required` `string`, operation object, ie., user or group
  - `table` - `required` `string`, table name
  - `username` - `required` `string`, user name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `condsWithColumn` - `required`, key-value pairs of columns and corresponding row ACL


- Curl Request Example

  ```shell
  curl -X POST \
    'http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
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

  > Note: The Curl Request Example updates the row acl on table DEFAULT.KYLIN_SALES on column PART_DT equaling to '1' to user ADMIN.


- Response Example

  ```JSON
  {
      "code": "000",
      "data": "",
      "msg": "update user's row cond list"
  }
  ```



### Revoke Row ACL {#Revoke-Row-ACL}

- `DELETE http://host:port/kylin/api/acl/row/{project}/{type}/{table}/{username}`


- URL Parameters
  - `project` - `required` `string`, project name
  - `type` - `required` `string`, operation object, ie., user or group
  - `table` - `required` `string`, table name
  - `username` - `required` `string`, user name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```shell
  curl -X DELETE \
    'http://host:port/kylin/api/acl/row/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

  > Note: The Curl Request Example revokes row acl on table DEFAULT.KYLIN_SALES to user ADMIN.

- Response Example

  ```JSON
  {
      "code": "000",
      "data": "",
      "msg": "delete user's row cond list"
  }
  ```
