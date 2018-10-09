## User Group Management API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Get user group list](#Get user group list)
* [Get user group and its user list](#Get user group and its user list)
* [Get user list of specified user group](#Get user list of specified user group)
* [Add a user group](#Add a user group)
* [Delete a user group](#Delete a user group)
* [Update a user group](#Update a user group)



### Get user group list

- `GET http://host:port/kylin/api/user_group/groups`


- URL Parameters
  - `project` - `required` `string`, project name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```shell
  curl -X GET \
    'http://host:port/kylin/api/user_group/groups?project=learn_kylin' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- Response Example

  ```JSON
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



### Get user group and its user list

- `GET http://host:port/kylin/api/user_group/usersWithGroup`


- URL Parameters
  - `pageOffset` - `optional` `int`, offset of returned result, 0 by default
  - `pageSize` - `optional` `int`, quantity of returned result per page, 10 by default


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```shell
  curl -X GET \
    'http://host:port/kylin/api/user_group/usersWithGroup?pageSize=1' \
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
          "size": 4,
          "usersWithGroup": [
              {
                  "first": "ALL_USERS",
                  "second": [
                      "ADMIN",
                      "ANALYST",
                      "MODELER"
                  ],
                  "key": "ALL_USERS",
                  "value": [
                      "ADMIN",
                      "ANALYST",
                      "MODELER"
                  ]
              }
          ]
      },
      "msg": "get users with group"
  }
  ```



### Get user list of specified user group

- `GET http://host:port/kylin/api/user_group/groupMembers/{groupName}`


- URL Parameters
  - `groupName` - `required` `string`, user group name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```shell
  curl -X GET \
    'http://host:port/kylin/api/user_group/groupMembers/ALL_USERS' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- Response Example

  ```JSON
  {
      "code":"000",
      "data":{
          "groupMembers":[
              {
                  "username":"ADMIN",
   				"password":"...",
                  "authorities":[...],
                  "disabled":false,
                  "defaultPassword":true,
                  "locked":false,
                  "lockedTime":0,
                  "wrongTime":0,
                  "uuid":"aec35307-8d41-45a0-a942-91d4e92e11e4",
                  "last_modified":1537860587117,
                  "version":"3.0.0.1"
              }
          ],
          "size":1
      },
      "msg":"get groups members"
  }
  ```



### Add a user group

- `POST http://host:port/kylin/api/user_group/{groupName}`


- URL Parameters
  - `groupName` - `required` `string`, user group name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```shell
  curl -X POST \
    'http://host:port/kylin/api/user_group/group_test' \
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
      "msg": "add user group"
  }
  ```


### Delete a user group

- `DELETE http://host:port/kylin/api/user_group/{groupName}`


- URL Parameters
  - `groupName` - `required` `string`, user group name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```shell
  curl -X DELETE \
    'http://host:port/kylin/api/user_group/group_test' \
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
      "msg": "del user group"
  }
  ```



### Update a user group

> Note: Updating a user group replaces the original user list in the specified user group rather than adding new users to it.

- `POST http://host:port/kylin/api/user_group/users/{groupName}`


- URL Parameters
  - `groupName` - `required` `string`, user group name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
	- `required` `string[]`, list of user names


- Curl Request Example

  ```shell
  curl -X POST \
    'http://host:port/kylin/api/user_group/users/group_test' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '["ADMIN","ANALYST"]'
  ```


- Response Example

  ```JSON
  {
      "code": "000",
      "data": "",
      "msg": "modify users in user group"
  }
  ```
