## Column ACL API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Get Column ACL](#Get Column ACL)
* [Grant Column ACL](#Grant Column ACL)
* [Grant Column ACL In Batch](#Grant Column ACL In Batch)
* [Update Column ACL](#Update Column ACL)
* [Revoke Column ACL](#Revoke Column ACL)



### Get Column ACL

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

  ```shell
  curl -X GET \
    'http://host:port/kylin/api/acl/column/paged/learn_kylin/DEFAULT.KYLIN_CAL_DT' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```JSON
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



### Grant Column ACL

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

  ```shell
  curl -X POST \
    'http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '["QTR_BEG_DT"]'
  ```

  > Note: The Curl request example grants  column acl on DEFAULT.KYLIN_CAL_DT. QTR_BEG_DT  to ADMIN.


- Response Example

  ```JSON
  {
      "code": "000",
      "data": "",
      "msg": "add user to column black list."
  }
  ```



### Grant Column ACL In Batch

- `POST http://host:port/kylin/api/acl/column/batch/{project}/{type}/{table}/{username}`


- URL Parameters
  - `project` - `required` `string`, project name
  - `type` - `required` `string`, operation object, ie., user or group
  - `table` - `required` `string`, table name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - A key-value structure with user names as key and corresponding columns as values


- Curl Request Example

  ```shell
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

  > Note: The Curl request example grants column acl on DEFAULT.KYLIN_SALES.TRANS_ID and DEFAULT.KYLIN_SALES.PART_DT to ADMIN; grants column acl on DEFAULT.KYLIN_SALES.PRICE to MODELER.


- Response Example

  ```JSON
  {
      "code": "000",
      "data": "",
      "msg": "2 user column ACL(s) updated"
  }
  ```


### Update Column ACL

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

  ```shell
  curl -X PUT \
    'http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_SALES/ADMIN' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '["TRANS_ID"]'
  ```

  > Note: The Curl request example updates columns acl on DEFAULT.KYLIN_SALES.TRANS_ID to ADMIN.


- Response Example

  ```JSON
  {
      "code": "000",
      "data": "",
      "msg": "update user's black column list"
  }
  ```

### Revoke Column ACL

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

  ```shell
  curl -X DELETE \
    'http://host:port/kylin/api/acl/column/learn_kylin/user/DEFAULT.KYLIN_SALES/ANALYST' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

  > Note: The Curl request example revokes column acl on DEFAULT.KYLIN_SALES to  ANALYST.

- Response Example

  ```JSON
  {
      "code": "000",
      "data": "",
      "msg": "delete user from DEFAULT.KYLIN_SALES's column black list"
  }
  ```
