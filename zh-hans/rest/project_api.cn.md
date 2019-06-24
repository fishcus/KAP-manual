## 项目 API

> 提示：
>
> 1. 请确保已阅读前面的[访问及安全认证](authentication.cn.md)章节，了解如何在 REST API 语句中添加认证信息。
>
> 2. 在 Curl 命令行上，如果您访问的 URL 中含有 `&` 符号，请注意转义，比如在 URL 两端加上引号。



* [获取项目列表](#获取项目列表)
* [创建项目](#创建项目)
* [编辑项目](#编辑项目)
* [删除项目](#删除模型)



### 获取项目列表

- `GET http://host:port/kylin/api/projects`

- URL Parameters
  - `projectName` - `可选` `string`， 项目名称（完全匹配）
  - `pageOffset` - `可选` `int`，返回数据起始下标，默认为 0 
  - `pageSize` - `可选` `int `，每页返回多少，默认为 10 
  
- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl 请求示例

  ```sh
  curl -X GET \
    'http://host:port/kylin/api/projects?pageOffset=0&pageSize=10&projectName=test' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```

- 响应示例

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



### 创建项目

- `POST http://host:port/kylin/api/projects`

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`
  
- HTTP Body: JSON Object
  - `projectDescData` - `必选` `JSON String`，项目信息
    - `name` - `必选` `string`，项目名称
    - `description` - `可选` `string`，项目描述
    - `override_kylin_properties` - `可选` `JSON String` ，项目级配置覆盖

- Curl 请求示例

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

- 响应示例

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


### 编辑项目

- `PUT http://host:port/kylin/api/projects`

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`
  
- HTTP Body: JSON Object
  - `formerProjectName` - `必选` `string`，被修改的项目的名称
  - `projectDescData` - `必选` `JSON String`，项目信息
    - `name` - `必选` `string`，项目名称
    - `description` - `可选` `string`，项目描述
    - `override_kylin_properties` - `可选` `JSON String` ，项目级配置覆盖

- Curl 请求示例

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

- 响应示例

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



### 删除项目

- `DELETE http://host:port/kylin/api/projects/{projectName}`

- URL Parameters	
  
	- `projectName` - `必选` `string`， 项目名称
	
- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl 请求示例

  ```sh
  curl -X DELETE \
    'http://host:port/kylin/api/projects/test' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```
  
  
- 响应示例
  
  ```json
  {"code":"000","data":null,"msg":""}
  ```