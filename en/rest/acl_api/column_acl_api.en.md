## Column ACL API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](../authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.
> 3. The column acl is a black list operation, which means the column will not be queried if it is granted.



* [Get Column ACL](#Get-Column-ACL)
* [Grant Column ACL](#Grant-Column-ACL)
* [Grant Column ACL in Batch](#Grant-Column-ACL-In-Batch)
* [Update Column ACL](#Update-Column-ACL)
* [Revoke Column ACL](#Revoke-Column-ACL)
* [Revoke User's Column ACL in Batch](#Revoke-User-Column-ACL-in-Batch)



### Get Column ACL {#Get-Column-ACL}

- `GET http://host:port/kylin/api/acl/column/paged/{project}/{table}`


- URL Parameters
  - `project` - `required` `string`, project name
  - `table` - `required` `string`, table name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `pageSize` - `optional` `int`, quantity of returned result per page, 10 by default
  - `pageOffset` - `optional` `int`, offset of returned result, 0 by default


- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/acl/column/paged/learn_kylin/DEFAULT.KYLIN_CAL_DT' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

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



### Grant Column ACL {#Grant-Column-ACL}

- `POST http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

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
  - a string list with columns need granting acl


- Curl Request Example

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '["QTR_BEG_DT"]'
  ```

  > **Note:** The Curl request example grants column acl on *DEFAULT.KYLIN_CAL_DT.QTR_BEG_DT* to *ADMIN*.


- Response Example

  ```json
  {
      "code": "000",
      "data": "",
      "msg": "add user to column black list."
  }
  ```



### Grant Column ACL in Batch {#Grant-Column-ACL-In-Batch}

- `POST http://host:port/kylin/api/acl/column/batch/{project}/{table}`


- URL Parameters
  - `project` - `required` `string`, project name
  - `table` - `required` `string`, table name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `sid` - `required` `string`, user name or group name
  - `principal` - `required` `boolean`, user or not,  "true" for user and "false" for group
  - `column` - `required`, A string list with columns need granting acl


- Curl Request Example

  ```sh
  curl -X POST \
    http://host:port/kylin/api/acl/column/batch/learn_kylin/DEFAULT.KYLIN_SALES \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json' \
    -H 'cache-control: no-cache,no-cache,no-cache,no-cache' \
    -d '[
  	{
  		"sid": "test1",
  		"principal": true,
  		"columns":["PART_DT","TRANS_ID"]
  	},
  	{
  		"sid": "test2",
  		"principal": true,
  		"columns":["SELLER_ID"]
  	}
  ]'
  ```

  > **Note:** The Curl request example grants column acl on *DEFAULT.KYLIN_SALES.TRANS_ID* and *DEFAULT.KYLIN_SALES.PART_DT* to *test1*; grants column acl on *DEFAULT.KYLIN_SALES.SELLER_ID* to *test2*.


- Response Example

  ```json
  {
      "code": "000",
      "data": "",
      "msg": "2 user column ACL(s) updated"
  }
  ```



### Update Column ACL {#Update-Column-ACL}

- `PUT http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

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
  - A string list with columns need updating acl


- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '["TRANS_ID"]'
  ```

  > **Note:** The Curl request example updates columns acl on *DEFAULT.KYLIN_SALES.TRANS_ID* to *ADMIN*.


- Response Example

  ```json
  {
      "code": "000",
      "data": "",
      "msg": "update user's black column list"
  }
  ```



### Revoke Column ACL {#Revoke-Column-ACL}

- `DELETE  http://host:port/kylin/api/acl/column/{project}/{type}/{table}/{username}`

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

  ```sh
  curl -X DELETE \
    'http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_SALES/ANALYST' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

  > **Note:** The Curl request example revokes column acl on *DEFAULT.KYLIN_SALES* to *ANALYST*.

- Response Example

  ```json
  {
      "code": "000",
      "data": "",
      "msg": "delete user from DEFAULT.KYLIN_SALES's column black list"
  }
  ```



### Revoke User's Column ACL in Batch {#Revoke-User-Column-ACL-in-Batch}

- `DELETE  http://host:port/kylin/api/acl/column/batch/{project}/{table}`
- URL Parameters
  - `project` - `required` `string`, project name
  - `table` - `required` `string`, table name
- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object

  - `sid` - `required` `string`, user name or group name
  - `principal` - `required` `boolean`, user or not,  "true" for user and "false" for group

- Curl Request Example

  ```sh
  curl -X DELETE \
    'http://10.1.2.134:7570/kylin/api/acl/column/batch/learn_kylin/DEFAULT.KYLIN_SALES' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json' \
    -H 'cache-control: no-cache,no-cache,no-cache' \
    -d '[
  	{
  		"sid": "test1",
  		"principal": true
  	},
  	{
  		"sid": "test2",
  		"principal": true
  	}
  ]'
  ```

  > **Note:** The Curl request example revokes column acl on *DEFAULT.KYLIN_SALES* to user named *test1* and *test2*.

- Response Example

  ```json
  {
      "code": "000",
      "data": "",
      "msg": ""
  }
  ```

