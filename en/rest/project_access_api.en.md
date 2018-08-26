## Project Access REST API

> **Tip**
>
> Before using API, make sure that you read the previous chapter of [Access and Authentication](authentication.en.md), and know how to add authentication information in API.
>
> If there exists `&` in your request path, please enclose the URL in quotation marks `""` or add a backslash ahead  `\&`  to avoid being escaped.


* [Get Project Access](#get-project-access)
* [Grant Project Access](#grant-project-access)
* [Modify Project Access](#modify-project-access)
* [Delete Project Access](#delete-project-access)

### Get Project Access
`Request Mode GET`

`Access Path http://host:port/kylin/api/access/{type}/{uuid}`

`Accept: application/vnd.apache.kylin-v2+json` 

`Accept-Language: cn|en` 

#### Path Variable
* type - `required` `string`, currently, type can only be ProjectInstance
* uuid - `required` `string`, project's ID

#### Request Example
`Request Path:http://host:port/kylin/api/access/ProjectInstance/2fbca32a-a33e-4b69-83dd-0bb8b1f8c91b`



#### Curl Request Example 

``` 

curl -X GET -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json"  http://host:port/kylin/api/access/ProjectInstance/2fbca32a-a33e-4b69-83dd-0bb8b1f8c91b

```


#### Response Example
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

### Grant Project Access
`Request Mode POST`

`Access Path http://host:port/kylin/api/access/{type}/{uuid}`

`Accept: application/vnd.apache.kylin-v2+json` 

`Accept-Language: cn|en` 

#### Path Variable
* type - `required` `string`, currently, type can only be ProjectInstance
* uuid - `required` `string`, project's ID

#### Request Body
* permission - `required` `string`, permissions on project
* principal - `required` `string`, principal is true
* sid - `required` `string`, user name

#### Request Example
`Request path:http://host:port/kylin/api/access/ProjectInstance/2fbca32a-a33e-4b69-83dd-0bb8b1f8c91b`

`request body:{permission: "READ", principal: true, sid: "MODELER"}`



#### Curl Request Example 

``` 

curl -X POST -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "permission":"READ", "principal":true，"sid:"MODELER" }' http://host:port/kylin/api/access/ProjectInstance/2fbca32a-a33e-4b69-83dd-0bb8b1f8c91b`

```



#### Response Example
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
    },
    {
      "permission": {
        "mask": 1,
        "pattern": "...............................R"
      },
      "id": 1,
      "sid": {
        "principal": "MODELER"
      },
      "granting": true
    }
  ],
  "msg": ""
}
```

### Modify Project Access
`Request Mode PUT`

`Access Path http://host:port/kylin/api/access/{type}/{uuid}`

`Accept: application/vnd.apache.kylin-v2+json` 

`Accept-Language: cn|en` 

#### Path Variable
* type - `required` `string`, currently, type can only be ProjectInstance
* uuid - `required` `string`, project's ID

#### Request Body
* permission - `required` `string`, permissions on project
* principal - `required` `string`, principal is true
* sid - `required` `string`, user name

#### Request Example
`Request Path:http://host:port/kylin/api/access/ProjectInstance/2fbca32a-a33e-4b69-83dd-0bb8b1f8c91b`

`Request Body:{permission: "READ", principal: true, sid: "MODELER"}`


#### Curl Request Example 

``` 

curl -X PUT -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "permission":"READ", "principal":true，"sid:"MODELER" }' http://host:port/kylin/api/access/ProjectInstance/2fbca32a-a33e-4b69-83dd-0bb8b1f8c91b`

```



#### Response Example
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
    },
    {
      "permission": {
        "mask": 1,
        "pattern": "...............................R"
      },
      "id": 1,
      "sid": {
        "principal": "MODELER"
      },
      "granting": true
    }
  ],
  "msg": ""
}
```

### Delete Project Access
`Request Mode DELETE`

`Access Path http://host:port/kylin/api/access/{type}/{uuid}`

`Accept: application/vnd.apache.kylin-v2+json` 

`Accept-Language: cn|en` 

#### Path Variable
* type - `required` `string`, currently, type can only be ProjectInstance
* uuid - `required` `string`, project's ID

#### Request Body
* accessEntryId - `required` `string`, ACL's serial number
* sid - `required` `string`, user name

#### Request Example
`Request Path:http://host:port/kylin/api/access/ProjectInstance/2fbca32a-a33e-4b69-83dd-0bb8b1f8c91b`


#### Curl Request Example
```
curl -X DELETE -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "accessEntryId":"1", "sid":'admin' }' http://host:port/kylin/api/access/ProjectInstance/2fbca32a-a33e-4b69-83dd-0bb8b1f8c91b
```


#### Response Example
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
    },
    {
      "permission": {
        "mask": 1,
        "pattern": "...............................R"
      },
      "id": 1,
      "sid": {
        "principal": "MODELER"
      },
      "granting": true
    }
  ],
  "msg": ""
}
```