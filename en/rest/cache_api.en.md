## Cache API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Purge Cluster Cache](#Purge-Cluster-Cache)
* [Purge Single Node Cache](#Purge-Single-Node-Cache)



### Purge Cluster Cache {#Purge-Cluster-Cache}

- `PUT http://host:port/kylin/api/cache/announce/{entity}/{cacheKey}/{event}`


- URL Parameters
  - `entity` - `required` `string`, entity, ie., "all", "project_schema", "project_data" or "project_acl" 
  - `cacheKey` - `required` `string`, cache key, ie., project name
  - `event` - `required` `string`, event, ie., "create", "update" or "drop"


- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`


- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cache/announce/all/learn_kylin/update' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```



### Purge Single Node Cache {#Purge-Single-Node-Cache}

- `PUT http://host:port/kylin/api/cache/{entity}/{cacheKey}/{event}`

- URL Parameters
  - `entity` - `required` `string`,entity,ie., "all", "project_schema", "project_data" or "project_acl" 
  - `cacheKey` - `required` `string`, cache key, ie., project name
  - `event` - `required` `string`, event, ie., "create", "update" or "drop"

- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X PUT \
    'http://host:port/kylin/api/cache/project_data/learn_kylin/update' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json;charset=utf-8'
  ```
