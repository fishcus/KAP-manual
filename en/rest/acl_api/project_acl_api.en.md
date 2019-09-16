## Project ACL API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](../authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.
>
> 3. The following interfaces are all compatible with the old way of requesting interfaces in UUID mode.


* [Get Project ACL](#Get-Project-ACL)
* [Grant Project ACL](#Grant-Project-ACL)
* [Update Project ACL](#Update-Project-ACL)
* [Revoke Project ACL](#Revoke-Project-ACL)



### Get Project ACL {#Get-Project-ACL}

- `GET http://host:port/kylin/api/access/{type}/{projectName}`

- URL Parameters
  - `type` - `required` `string`, "ProjectInstance"
  - `projectName` - `required` `string`, project name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/access/ProjectInstance/{projectName}' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- Response Example

  ```json
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



### Grant Project ACL {#Grant-Project-ACL}

- `POST http://host:port/kylin/api/access/{type}/{projectName}`

- URL Parameters
  - `type` - `required` `string`, "ProjectInstance"
  - `projectName` - `required` `string`, project name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `permission` - `required` `string`, project ACL. e.g. ("READ" for "Query", "ADMINISTRATION" for "ADMIN", "OPERATION" for "OPERATION" and "MANAGEMENT" for "MANAGEMENT")
  - `principal` - `required` `boolean`, user or user group, "true" for user and "false" for user group
  - `sid` - `required` `string`, name of user or user group

- Curl Request Example

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/access/ProjectInstance/{projectName}' \
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

  ```json
  {
      "code": "000",
      "data": "",
      "msg": ""
  }
  ```



### Update Project ACL {#Update-Project-ACL}

- `PUT http://host:port/kylin/api/access/{type}/{projectName}`

- URL Parameters
  - `type` - `required` `string`, "ProjectInstance"
  - `projectName` - `required` `string`, project name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `permission` - `required` `string`, project ACL. e.g. ("READ" for "Query","ADMINISTRATION" for "ADMIN","OPERATION" for "OPERATION" and "MANAGEMENT" for "MANAGEMENT" )
  - `principal` - `required` `boolean`, user or user group, "true" for user and "false" for user group
  - `sid` - `required` `string`, name of user or user group
  - `accessEntryId` - `required` `int`, user or user group id in response of Get Project ACL API


- Curl Request Example 

  ``` sh
  curl -X PUT \
    'http://host:port/kylin/api/access/ProjectInstance/{projectName}' \
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

  ```json
  {
      "code": "000",
      "data": "",
      "msg": ""
  }
  ```



### Revoke Project ACL {#Revoke-Project-ACL}

- `DELETE http://host:port/kylin/api/access/{type}/{projectName}`


- URL Parameters
  - `type` - `required`  `string`, "ProjectInstance"
  - `projectName` - `required`  `string`, project name

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `permission` - `required` `string`, project ACL. e.g. ("READ" for "Query","ADMINISTRATION" for "ADMIN","OPERATION" for "OPERATION" and "MANAGEMENT" for "MANAGEMENT")
  - `accessEntryId` - `required` `int`, user UUID
  - `sid` - `required` `string`, name of user or user group
  - `principal` - `required` `boolean`, user or user group, "true" for user and "false" for user group


- Curl Request Example

 > Note: the following curl request example will delete "query" permission of user group "ROLE_ANALYST" on project "learn_kylin"


  ```sh
  curl -X DELETE \
   'http://host:port/kylin/api/access/ProjectInstance/{projectName}?accessEntryId=0&sid=ROLE_MODELER&principal=false' \
   -H 'accept: application/vnd.apache.kylin-v2+json' \
   -H 'accept-language: en' \
   -H 'authorization: Basic QURNSU46S1lMSU4=' \
   -H 'content-type: application/json;charset=utf-8'
  ```


- Response Example

  ```json
  {
      "code": "000",
      "data": "",
      "msg": ""
  }
  ```
