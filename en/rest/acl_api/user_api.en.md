## User Management API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Get user list](#Get-user-list)
* [Create a user](#Create-a-user)
* [Modify a user](#Modify-a-user)
* [Delete a user](#Delete-a-user)



### Get User List {#Get-user-list}
 
- `GET http://host:port/kylin/api/kap/user/users`


- URL Parameters
  - `project` - `optional` `string`, project name
  - `name` - `optional` `string`, user name
  - `isCaseSensitive` - `optional` `boolean`, whether case sensitive on user name, "false" by default
  - `pageOffset` - `optional` `int`, offset of returned result, 0 by default
  - `pageSize` - `optional` `int`, quantity of returned result per page, 10 by default


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/kap/user/users?pageSize=1&project=learn_kylin' \
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
          "users": [
              {
                  "username": "ADMIN",
                  "password": "$2a$10$UfSim3k3g6mBCPnZULlynuyyV3OVKhy174iOBoNVplZXZJlb2TPRu",
                  "authorities": [...],
                  "disabled": false,
                  "defaultPassword": true,
                  "locked": false,
                  "lockedTime": 0,
                  "wrongTime": 0,
                  "uuid": "aec35307-8d41-45a0-a942-91d4e92e11e4",
                  "last_modified": 1537860587117,
                  "version": "3.0.0.1"
              }
          ]
      },
      "msg": ""
  }
  ```



### Create a User {#Create-a-user}

- `POST http://host:port/kylin/api/kap/user/{userName}`


- URL Parameters
  - `userName` - `required` `string`, user name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `password` - `required` `string`, user password
  - `disabled` - `required` `bool`, enable the user or not
  - `authorities` - `required` `string[]`, corresponding user group


- Curl Request Example

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/kap/user/test' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
    "password": "test@Kylingence",
    "disabled": false, 
    "authorities": ["ROLE_ADMIN"]
    
  }'
  ```


- Response Example

  ```JSON
  {
      "username": "test",
      "password": "$2a$10$Iw4NYBNW2bCTN3BqCGVfrO5Loesn/UigQxvbBQFebH2fEkFE2gcHy",
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
      "wrongTime": 0,
      "uuid": "ffdd3033-d516-4b4f-a7fe-6718280746bb",
      "last_modified": 1538964238173,
      "version": "3.0.0.1"
  }
  ```



### Modify a User {#Modify-a-user}

- `PUT http://host:port/kylin/api/kap/user/{userName}`


- URL Parameters
  - `userName` - `required` `string`, user name


- HTTP Body: JSON Object
  - `password` - `required` `string`, user password
  - `disabled` - `required` `bool`, enable the user or not
  - `authorities` - `required` `string[]`, corresponding user group


- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/kap/user/test' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
    "password": "test123.",
    "disabled": false, 
    "authorities": ["ROLE_ANALYST"]
    
  }'
  ```


- Response Example

  ```JSON
  {
      "username": "test",
      "password": "$2a$10$M3u5cQztMHg3LIvMFJ4ZY.RidLB9RAw0gBHHV6EBNzEvxMk6Pf69u",
      "authorities": [...],
      "disabled": false,
      "defaultPassword": false,
      "locked": false,
      "lockedTime": 0,
      "wrongTime": 0,
      "uuid": "4713b0fb-4f4b-4842-af33-863f3b8bc7e2",
      "last_modified": 1538965388437,
      "version": "3.0.0.1"
  }
  ```



### Delete a User {#Delete-a-user}

- `DELETE http://host:port/kylin/api/kap/user/{userName}`


- URL Parameters
  - `userName` - `required` `string`, user name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```sh
  curl -X DELETE \
    'http://host:port/kylin/api/kap/user/test' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```
