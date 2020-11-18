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

### FAQ

**Q: How to purge query cache？**

A: While the parameter `entity` in the above api is one of "all", "project_schema", "project_data" and "project_acl", the query cache will be purged, and the parameter `event` does not affect the result. If you want to purge the query cache for all projects, you need to set `entity` as "all" and set `cacheKey` as any non-empty string, such as `http://host:port/kylin/api/cache/all/project/update `; If you want to purge the query cache of a specific project, you need to set `entity` as "project_schema", "project_data" or "project_acl", and set `cacheKey` as the project name, such as `http://host:port/kylin/api/cache/project_data/project_1/update`.