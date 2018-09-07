## User Management REST API

> **Tip**
>
> Before using API, make sure that you read the previous chapter of [Access and Authentication](authentication.en.md), and know how to add authentication information in API.
>
> If there exists `&` in your request path, please enclose the URL in quotation marks `""` or add a backslash ahead  `\&`  to avoid being escaped.


* [Get All Users](#get-all-users)
* [Create User](#create-user)
* [Modify User](#modify-user)
* [Delete User](#delete-user)

### Get All Users
`Request Mode GET`

`Access Path http://host:port/kylin/api/kap/users/user`

`Accept: application/vnd.apache.kylin-v2+json` 

`Accept-Language: cn|en` 

#### Request Parameters
* project - `optional` `string`, determine if the current user has the permission to get all users. If it is blank, the current user shall have Admin permission to get all users.
* name - `optional` `string`, filter the user list.
* isCaseSensitive - `optional` `bool`, indicate if the fuzzy matching of the above parameter, name, is case sensitive. It is case insensitive by default. 
* pageOffset - `optional` `int`
* pageSize - `optional` `int`

#### Request Example
`Request Path: "http://host:port/kylin/api/kap/user/users?pageSize=9&pageOffset=0&project=default"`

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" "http://host:port/kylin/api/kap/user/users?pageSize=9&pageOffset=0&project=default"
```

#### Response Example
```json
{
  "code": "000",
  "data": {
    "size": 3,
    "users": [
      {
        "username": "ADMIN",
        "password": "$2a$10$T6mhEmdwwwZJPPoON3k7t.9StfCCK1MkxMKNB8ZhsGqg853d5h2cS",
        "authorities": [
          {
            "authority": "ROLE_ADMIN"
          },
          {
            "authority": "ALL_USERS"
          }
        ],
        "disabled": false,
        "defaultPassword": false,
        "locked": false,
        "lockedTime": 0,
        "wrongTime": 1,
        "uuid": null,
        "last_modified": 1511179915000,
        "version": "3.0.0.1"
      },
      {
        "username": "ANALYST",
        "password": "$2a$10$Fy9s6NNxVX7YyoVW6cA35ucxgRzw41tdKG9WfyINHBcAAj7bWLPXa",
        "authorities": [
          {
            "authority": "ALL_USERS"
          }
        ],
        "disabled": false,
        "defaultPassword": true,
        "locked": false,
        "lockedTime": 0,
        "wrongTime": 0,
        "uuid": null,
        "last_modified": 1511073720000,
        "version": "3.0.0.1"
      },
      {
        "username": "MODELER",
        "password": "$2a$10$GHuQqTyjcymxwAYUJ8B2F.kDG3arZaYVKABNgX1Kh1HrTjV3hqBTS",
        "authorities": [
          {
            "authority": "ALL_USERS"
          }
        ],
        "disabled": false,
        "defaultPassword": true,
        "locked": false,
        "lockedTime": 0,
        "wrongTime": 0,
        "uuid": null,
        "last_modified": 1511073720000,
        "version": "3.0.0.1"
      }
    ]
  },
  "msg": ""
}
```

### Create User
`Request Mode POST`

`Access Path http://host:port/kylin/api/kap/user/{userName}`

`Accept: application/vnd.apache.kylin-v2+json` 

`Accept-Language: cn|en` 

#### Path Variable
* userName - `required` `string`, user name

#### Request Body
* username - `required` `string`, user name
* password - `required` `string`, password
* disabled - `required` `bool`, enabled or not
* authorities - `required` `string list`, determine which group the user belongs to

#### Request Example
`Request Path:http://host:port/kylin/api/kap/user/t`

`Request Body:{username: "t", password: "1qaz@WSX", disabled: false, authorities: ["ROLE_ADMIN"]}`

#### Curl Request Example
```
curl -X POST -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "username":"test", "password":"KYLIN"，"disabled":false，"authorities":["ROLE_ADMIN"] }' http://host:port/kylin/api/kap/user/t
```

#### Response Example
```json
{
  "username": "t",
  "password": "$2a$10$IhAeH0lIBDGI2Qw2lDvehuGQUOXkbYL/BmV/iu7dTpmNt3fUx7QTa",
  "authorities": [
    {
      "authority": "ROLE_ANALYST"
    }
  ],
  "disabled": false,
  "defaultPassword": false,
  "locked": false,
  "lockedTime": 0,
  "wrongTime": 0,
  "uuid": null,
  "last_modified": 1506583927000,
  "version": "3.0.0.1"
}
```

### Modify User
`Request Mode PUT`

`Access Path http://host:port/kylin/api/kap/user/{userName}`

`Accept: application/vnd.apache.kylin-v2+json` 

`Accept-Language: cn|en` 

#### Path Variable
* userName - `required` `string`, user name

#### Request Body
* username - `required` `string`, user name
* password - `required` `string`, password
* disabled - `required` `bool`, enabled or not
* authorities - `required` `string list`

#### Request Example
`Request Path:http://host:port/kylin/api/kap/user/t`

`Request Body:{username: "t", password: "1qaz@WSX", disabled: false, authorities: ["ROLE_ADMIN"]}`

#### Curl Request Example
```
curl -X PUT -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{ "username":"test", "password":"KYLIN"，"disabled":false，"authorities":["ROLE_ADMIN"] }' http://host:port/kylin/api/kap/user/t
```

#### Response Example
```json
{
  "username": "t",
  "password": "$2a$10$IhAeH0lIBDGI2Qw2lDvehuGQUOXkbYL/BmV/iu7dTpmNt3fUx7QTa",
  "authorities": [
    {
      "authority": "ROLE_ANALYST"
    }
  ],
  "disabled": false,
  "defaultPassword": false,
  "locked": false,
  "lockedTime": 0,
  "wrongTime": 0,
  "uuid": null,
  "last_modified": 1506583927000,
  "version": "3.0.0.1"
}
```

### Delete User
`Request Mode DELETE`

`Access Path http://host:port/kylin/api/kap/user/{userName}`

`Accept: application/vnd.apache.kylin-v2+json` 

`Accept-Language: cn|en` 

#### Path Variable
* userName - `required` `string`, user name

#### Request Example
`Request Path:http://host:port/kylin/api/kap/user/t`

#### Curl Request Example
```
curl -X DELETE -H "Authorization: Basic xxxxxx" -H "Accept: application/vnd.apache.kylin-v2+json" -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/kap/user/t
```