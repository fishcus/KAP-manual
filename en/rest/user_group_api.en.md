## User Group Management REST API

> **Tip**
>
> Before using API, please make sure that you have read the previous chapter of *Access and Authentication* in advance and know how to add verification information in API. 


* [Get All User Groups](#get-all-user-groups)
* [Get User Group and its Users](#get-user-group-and-its-users)
* [Add User Group](#add-user-group)
* [Delete User Group](#delete user group)
* [Get All Users under Specified User Group](#get-all-users-under-specified-user-group)
* [Add Users to User Group](#add-users-to-user-group)

### Get All User Group
`Request Mode GET`

`Access Path http://host:port/kylin/api/user_group/groups`

`Accept: application/vnd.apache.kylin-v2+json` 

`Accept-Language: cn|en` 

#### Request Body
* project - `required` `string`, determine if the current user has the permission to get all users.

#### Request Example
`Request Path:http://host:port/kylin/api/user_group/groups?project=a`

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic xxxxxx" -H “Accept: application/vnd.apache.kylin-v2+json" -d '{ "projectName":"test"}' http://host:port/kylin/api/user_group/groups
```

#### Response Example
```json
{
    "code": "000",
    "data": [
        "ALL_USERS",
        "ROLE_ADMIN",
        "ROLE_ANALYST",
        "ROLE_MODELER"
    ],
    "msg": "get groups"
}
```

### Get User Group and its Users
`Request Mode GET`

`Access Path http://host:port/kylin/api/user_group/usersWithGroup`

`Accept: application/vnd.apache.kylin-v2+json` 

`Accept-Language: cn|en` 

#### Request Parameter
* pageOffset - `optional` `int`
* pageSize - `optional` `int`

#### Request Example
`Request Path:http://host:port/kylin/api/user_group/usersWithGroup?pageSize=9&pageOffset=0`

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic xxxxxx" -H “Accept: application/vnd.apache.kylin-v2+json" -d '{"pageSize":10，“pageOffset”:0 }' http://host:port/kylin/api/user_group/usersWithGroup?pageSize=9&pageOffset=0
```



#### Response Example
```json
{
  "code": "000",
  "data": {
    "size": 4,
    "usersWithGroup": [
      {
        "first": "ALL_USERS",
        "second": [
          "ADMIN",
          "ANALYST",
          "MODELER"
        ]
      },
      {
        "first": "ROLE_ADMIN",
        "second": [
          "ADMIN"
        ]
      },
      {
        "first": "ROLE_ANALYST",
        "second": []
      },
      {
        "first": "ROLE_MODELER",
        "second": []
      }
    ]
  },
  "msg": "get users with group"
}
```

### Add User Group
`Request Mode POST`

`Access Path http://host:port/kylin/api/user_group/{groupName}`

`Accept: application/vnd.apache.kylin-v2+json` 

`Accept-Language: cn|en` 

#### Path Variable
* groupName - `required` `string`, group name

#### Request Example
`Request Path:http://host:port/kylin/api/user_group/g1`

### Delete User Group
`Request Mode DELETE`

`Access Path http://host:port/kylin/api/user_group/{groupName}`

`Accept: application/vnd.apache.kylin-v2+json` 

`Accept-Language: cn|en` 

#### Path Variable
* groupName - `required` `string` , group name

#### Request Example
`Request Path:http://host:port/kylin/api/user_group/g1`

#### Curl Request Example

```
curl -X DELETE -H "Authorization: Basic xxxxxx" -H “Accept: application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/user_group/g1
```

#### 



### Get All Users under Specified User Group
`Request Mode GET`

`Access Path http://host:port/kylin/api/user_group/groupMembers/{name}`

`Accept: application/vnd.apache.kylin-v2+json` 

`Accept-Language: cn|en` 

#### Path Variable
* name - `required` `string` group name

#### Request Example
`Request Path:http://host:port/kylin/api/user_group/groupMembers/ALL_USERS`

#### Curl Request Example
```
curl -X GET -H "Authorization: Basic xxxxxx" -H “Accept: application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/user_group/groupMembers/ALL_USERS
```

#### Response Example
```json
{
    "code": "000",
    "data": {
        "groupMembers": [
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
        ],
        "size": 3
    },
    "msg": "get groups members"
}
```

### Add Users to User Group
`Request Mode POST`

`Access Path http://host:port/kylin/api/user_group/users/{groupName}`

`Accept: application/vnd.apache.kylin-v2+json` 

`Accept-Language: cn|en` 

#### Path Variable
* groupName - `required` `string`, group name

#### Request Body
User list, please see the request body in the following request example for details.

#### Request Example
`Request Path:http://host:port/kylin/api/user_group/users/g1`

`Request Body:["ADMIN","ANALYST","MODELER"]`

#### Curl Request Example
```
curl -X POST -H "Authorization: Basic xxxxxx" -H “Accept: application/vnd.apache.kylin-v2+json" -d '["ADMIN","ANALYST","MODELER"]' http://host:port/kylin/api/user_group/users/g1
```