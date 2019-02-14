## Cube Metadata Export/Import API

> Reminders:
>
> 1. Please read [Access and Authentication REST API](authentication.en.md) and understand how authentication works.
> 2. On Curl command line, don't forget to quote the URL if it contains `&` or other special chars.



* [Export Cube Metadata](#Export-Cube-Metadata)
* [Import Cube Metadata](#Import-Cube-Metadata)



### Export Cube Metadata {#Export-Cube-Metadata}

- `POST http://host:port/kylin/api/metastore/export`
- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Encoding: gzip, deflate, br` 
  - `Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8`
  - `Accept-Language: en`
  - `Content-Type: application/x-www-form-urlencoded`
- HTTP Body: x-www-form-urlencoded
  - `project` - `required` `string`, project name
  - `cubes` - `required` `string`, cube name. Use `,` to split when you need to export multiple cubes.


- Curl Request Example

  ```sh
  curl -X POST \
    http://host:port/kylin/api/metastore/export \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Encoding: gzip, deflate, br' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'cache-control: no-cache,no-cache' \
    -d 'cubes=kylin_sales_cube&project=learn_kylin&undefined=' \
    -o /usr/local/kylin/learn_kylin.zip
  ```


- Response Example

  ```json
  % Total % Received % Xferd  Average Speed   Time    Time    Time  	Current
                              Dload   Upload  Total   Spent    Left  	Speed
  100  9600  100  9547 100 53  109k    620 --:--:-- --:--:-- --:--:--  109k
  ```


### Import Cube Metadata{#Import-Cube-Metadata}

- `POST http://host:port/kylin/api/metastore/import_metadata`
- HTTP Header
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Encoding: gzip, deflate, br` 
  - `Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8`
  - `Accept-Language: en`
  - `Content-Type: application/x-www-form-urlencoded`
- HTTP Body: JSON Object
  - `projectName` - `required` `string`, target project name
  - `path` - `required` `string`, path of importing metadata file

- Curl Request Example

  ```sh
  curl -X POST \
    http://host:port/kylin/api/metastore/import_metadata \
    -H 'Accept: application/vnd.apache.kylin-v2+json' \
    -H 'Accept-Language: en' \
    -H 'Authorization: Basic QURNSU46S1lMSU4=' \
    -H 'Content-Type: application/json' \
    -H 'cache-control: no-cache,no-cache' \
    -d '{
  	"projectName":"learn_kylin",
  	"path":"/usr/local/kylin/learn_kylin.zip"
  }'
  ```

* Response Example

  ```json
  {"code":"000","data":"","msg":"Import metadata successfully."}
  ```