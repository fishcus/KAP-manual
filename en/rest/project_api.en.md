## User Management API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](../authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Get project list](#Get-project-list)
* [Create a project](#Create-a-project)
* [Modify a project](#Modify-a-project)
* [Delete a project](#Delete-a-project)



### Get Project List {#Get-project-list}

- `GET http://host:port/kylin/api/projects`


- URL Parameters
  - `project` - `optional` `string`, project name (totally match)
  - `pageOffset` - `optional` `int`, offset of returned result, 0 by default
  - `pageSize` - `optional` `int`, quantity of returned result per page, 10 by default


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/projects?pageOffset=0&pageSize=10&projectName=test' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- Response Example

  ```json
  {
      "code": "000",
      	"data": {
      		"projects": [{
      			"uuid": "b8bfd776-1dc4-48ba-81fa-251565f33d9c",
      			"last_modified": 0,
      			"version": "3.4.0.0",
      			"name": "test",
      			"tables": [],
      			"owner": "ADMIN",
      			"status": null,
      			"create_time_utc": 1560307784472,
      			"last_update_time": null,
      			"description": "a test project",
      			"realizations": [],
      			"models": [],
      			"ext_filters": [],
      			"override_kylin_properties": {
      				"kylin.query.force-limit": "-1"
      			},
      			"project_dictionaries": null,
      			"resource_groups": null,
      			"suite_id": null,
      			"resource_group_instances": null
      		}],
      		"size": 1
      	},
      	"msg": ""
  }
  ```



### Create a Project {#Create-a-project}

- `POST http://host:port/kylin/api/projects`

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- HTTP Body: JSON Object
  - `projectDescData` - `required` `JSON String`，project information
    - `name` - `required` `string`，project name
    - `description` - `optional` `string`，project description
    - `override_kylin_properties` - `optional` `JSON String` ，project level configs override


- Curl Request Example

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/projects' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
  	"projectDescData": "{\"name\":\"test\",\"description\":\"a test project\",\"override_kylin_properties\":{\"kylin.query.force-limit\":\"-1\"}}"
     }'
  ```


- Response Example

  ```json
  {
  	"code": "000",
  	"data": {
  		"uuid": "b8bfd776-1dc4-48ba-81fa-251565f33d9c",
  		"last_modified": 1560307784472,
  		"version": "3.4.0.0",
  		"name": "test",
  		"tables": [],
  		"owner": "ADMIN",
  		"status": "ENABLED",
  		"create_time_utc": 1560307784472,
  		"last_update_time": null,
  		"description": "a test project",
  		"realizations": [],
  		"models": [],
  		"ext_filters": [],
  		"override_kylin_properties": {
  			"kylin.query.force-limit": "-1"
  		},
  		"project_dictionaries": null,
  		"resource_groups": []
  	},
  	"msg": ""
  }
  ```



### Modify a Project {#Modify-a-project}

- `PUT http://host:port/kylin/projects`


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- HTTP Body: JSON Object
  - `formerProjectName` - `required` `string`，project to be modified
  - `projectDescData` - `required` `JSON String`，project information
    - `name` - `required` `string`，project name
    - `description` - `optional` `string`，project description
    - `override_kylin_properties` - `optional` `JSON String` ，project level configs override


- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/projects' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d '{
  	 "formerProjectName": "test",
  	 "projectDescData": "{\"name\":\"test\",\"description\":\"a modified test project\",\"override_kylin_properties\":{\"kylin.query.force-limit\":\"-1\",\"kylin.engine.spark-conf.spark.yarn.queue\":\"MY_QUEUE_NAME\"}}"
     }'
  ```


- Response Example

  ```json
  {
  	"code": "000",
  	"data": {
  		"uuid": "012d4363-b472-4278-a1ef-2ebe092784ac",
  		"last_modified": 1560309162436,
  		"version": "3.4.0.0",
  		"name": "test",
  		"tables": [],
  		"owner": "ADMIN",
  		"status": "ENABLED",
  		"create_time_utc": 1560307897447,
  		"last_update_time": null,
  		"description": "a modified test project",
  		"realizations": [],
  		"models": [],
  		"ext_filters": [],
  		"override_kylin_properties": {
  			"kylin.query.force-limit": "-1",
  			"kylin.engine.spark-conf.spark.yarn.queue": "MY_QUEUE_NAME"
  		},
  		"project_dictionaries": null,
  		"resource_groups": null
  	},
  	"msg": ""
  }
  ```



### Delete a Project {#Delete-a-project}

- `DELETE http://host:port/kylin/api/projects/{projectName}`


- URL Parameters
  - `projectName` - `required` `string`, project name


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```sh
  curl -X DELETE \
    'http://host:port/kylin/api/projects/test' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```


- Response Example

  ```json
  {"code":"000","data":null,"msg":""}
  ```