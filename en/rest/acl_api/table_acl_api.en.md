## Table ACL API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Get Table ACL](#Get-Table-ACL)
* [Grant Table ACL](#Grant-Table-ACL)
* [Grant Table ACL in batch](#Grant-Table-ACL-in-batch)
* [Revoke Table ACL](#Revoke-Table-ACL)



### Get Table ACL {#Get-Table-ACL}

- `GET http://host:port/kylin/api/acl/table/paged/{project}/{table}`


- URL Parameters
  - `project` - `required` `string`, project name
  - `table` - `required` `string`, table name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `pageSize` - `optional` `int`, quantity of returned result per page, 10 by default
  - `pageOffset` - `optional` `int`,  offset of returned result, 0 by default


- Curl Request Example

  ```shell
  curl -X GET \
    'http://host:port/kylin/api/acl/table/paged/learn_kylin/DEFAULT.KYLIN_SALES' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```JSON
  {
      "code": "000", 
      "data": {
          "size": 2, 
          "user": [
              "ADMIN"
          ], 
          "group": [
              "ROLE_ADMIN"
          ]
      }, 
      "msg": "get table acl"
  }
  ```



### Grant Table ACL {#Grant-Table-ACL}

- `POST http://host:port/kylin/api/acl/table/{project}/{type}/{table}/{name}`


- URL Parameters
  - `project` - `required` `string`, project name
  - `type` - `required` `string`, operation object, ie., user or group
  - `table` - `required` `string`, table name
	* `name` - `required` `string`, user name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```shell
  curl -X POST \
    'http://host:port/kylin/api/acl/table/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- Response Example

  ```JSON
  {
      "code": "000",
      "data": "",
      "msg": "grant user table query permission and remove user from table black list."
  }
  ```



### Grant Table ACL in Batch {#Grant-Table-ACL-in-batch}


- `POST http://host:port/kylin/api/acl/table/batch/{project}/{table}`


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

  ```shell
  curl -X POST \
    'http://host:port/kylin/api/acl/table/batch/learn_kylin/DEFAULT.KYLIN_CAL_DT' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json' \
    -d '[{
  	"sid":"ADMIN",
  	"principal":"true"
  },
  {
  	"sid":"{username}",
  	"principal":"true"
  }
  ]'
  ```

- Response Example

  ```JSON
  {
      "code": "000",
      "data": "",
      "msg": "batch grant user table query permission and remove user from table black list"
  }
  ```



### Revoke Table ACL {#Revoke-Table-ACL}

- `DELETE http://host:port/kylin/api/acl/table/{project}/{type}/{table}/{name}`


- URL Parameters
  - `project` - `required` `string`, project name
  - `type` - `required` `string`, operation object, ie., user or group
  - `table` - `required` `string`, table name
  - `name` - `required` `string`, user name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```shell
  curl -X DELETE \
    'http://host:port/kylin/api/acl/table/learn_kylin/user/DEFAULT.KYLIN_CAL_DT/ADMIN' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- Response Example

  ```JSON
  {
      "code": "000",
      "data": "",
      "msg": "revoke user table query permission and add user to table black list."
  }
  ```
