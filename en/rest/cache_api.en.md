## Cache REST API

> **Tip**
>
> Before using API, please make sure that you have read the Access and Authentication in advance and know how to add verification information. 
>


### Purge Cluster Cache
`Request Mode PUT`

`Access Path http://host:port/kylin/api/cache/announce/{entity}/{cacheKey}/{event}`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### Path Variable

- entity - `required` `string` 'all', 'project_schema', 'project_data' or 'project_acl'.
- cacheKey - `required` `string` cache key, such as Project name.
- event - `required` `string` 'create', 'update' or 'drop'.


#### Request Example

`Request Path: http://host:port/kylin/api/cache/announce/project_data/your_project/update`

#### Curl Example

```
curl -X PUT -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' http://host:port/kylin/api/cache/announce/project_data/your_project/update
```

### Purge Single Node Cache

`Request Mode PUT`

`Access Path http://host:port/kylin/api/cache/{entity}/{cacheKey}/{event}`

`Content-Type: application/vnd.apache.kylin-v2+json`

`Accepe: application/vnd.apache.kylin-v2+json`

#### Path Variable

- entity - `required` `string`, 'all','project_schema','project_data' or 'project_acl'.
- cacheKey - `required` `string`, cache key, such as Project name.
- event - `required` `string`, 'create', 'update' or 'drop'.

#### Request Example

`Request Path: http://host:port/kylin/api/cache/project_data/your_project/update`

#### Curl Example

```
curl -H "Authorization: Basic XXXXXXXXX" -H "Content-Type: application/vnd.apache.kylin-v2+json" -H 'Accept: application/vnd.apache.kylin-v2+json' http://host:port/kylin/api/cache/project_data/your_project/update
```

### 