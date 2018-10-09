## Project ACL  AP

> Reminders:
>
> 1. Please read [Access and Authentication REST API](authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Get Project ACL](#Get Project ACL)
* [Grant Project ACL](#Grant Project ACL)
* [Update Project ACL](#Update Project ACL)
* [Revoke Project ACL](#Revoke Project ACL)



### Get Project ACL

- `GET http://host:port/kylin/api/access/{type}/{uuid}`

- URL Parameters
  - `type` - `required` `string`, "ProjectInstance"
  - `uuid` - `required` `string`, project UUID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```shell
  curl -X GET \
    'http://host:port/kylin/api/access/ProjectInstance/{uuid}' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```JSON
  {
    "code": "000",
    "data": [
      {
        "permission": {
          "mask": 16,
          "pattern": "...........................A...."
        },
        "id": 0,
        "sid": {
          "principal": "ADMIN"
        },
        "granting": true
      }
    ],
    "msg": ""
  }
  ```



### Grant Project ACL

- `POST http://host:port/kylin/api/access/{type}/{uuid}`

- URL Parameters
  - `type` - `required` `string`, "ProjectInstance"
  - `uuid` - `required` `string`, project UUID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `permission` - `required` `string`, project acl
  - `principal` - `required` `boolean`, user or not, "true" for user and "false" for usergroup
  - `sid` - `required` `string`, user name

- Curl Request Example

  ```shell
  curl -X POST \
    'http://host:port/kylin/api/access/ProjectInstance/{uuid}' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
  	"permission": "READ",
  	"principal": true, 
  	"sid": "ANALYST"
  }'
  ```

- Response Example

  ```JSON
  {
      "code": "000",
      "data": "",
      "msg": ""
  }
  ```



### Update Project ACL

- `PUT http://host:port/kylin/api/access/{type}/{uuid}`

- URL Parameters
  - `type` - `required` `string`, "ProjectInstance"
  - `uuid` - `required` `string`, project UUID

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `permission` - `required` `string`, project acl
  - `principal` - `required` `boolean`, user or not, "true" for user and "false" for usergroup
  - `sid` - `required` `string`, user name
  - `accessEntryId` - `required` `int`, user UUID


- Curl Request Example 

  ``` shell
  curl -X PUT \
    'http://host:port/kylin/api/access/ProjectInstance/{uuid}' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
  	"permission": "OPERATION",
  	"principal": true, 
  	"sid": "ANALYST",
  	"accessEntryId": 1
  }'
  ```


- Response Example

  ```JSON
  {
      "code": "000",
      "data": "",
      "msg": ""
  }
  ```



### Revoke Project ACL

- `DELETE http://host:port/kylin/api/access/{type}/{uuid}`


- URL Parameters
  - `type` - `required`  `string`, "ProjectInstance"
  - `uuid` - `required`  `string`, project UUID
  - `accessEntryId` - `required` `int`, user UUID
  - `sid` - `required` `string`, user name
  - `principal` - `required` `boolean`, user or not, "true" for user and "false" for usergroup


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `accessEntryId` - `required` `int`, user UUID
  - `sid` - `required` `string`, user name
  - `principal` - `required` `boolean`, user or not, "true" for user and "false" for usergroup


- Curl Request Example

  ```shell
  curl -X DELETE \
    'http://host:port/kylin/api/access/ProjectInstance/{uuid}?accessEntryId=1&sid=ANALYST&principal=true' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
  	"principal": true, 
  	"sid": "ANALYST",
  	"accessEntryId": 1
  }'
  ```


- Response Example

  ```JSON
  {
      "code": "000",
      "data": "",
      "msg": ""
  }
  ```
