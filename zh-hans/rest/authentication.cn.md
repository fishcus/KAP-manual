## 访问与安全认证


### 访问
Kyligence Enterprise API 的访问前缀为 `/kylin/api`，不管对哪个模块的 API 访问都需要加上该前缀，比如访问所有 Cube 的 API 为 `/kylin/api/cubes`，对应的完整路径为 `http://host:port/kylin/api/cubes`。

### 认证
Kyligence Enterprise 所有的 API 都是基于 [Basic Authentication](http://en.wikipedia.org/wiki/Basic_access_authentication) 认证机制。Basic Authentication 是一种简单的访问控制机制，将帐号密码基于 Base64 编码后作为请求头添加到 HTTP 请求头中，后端会读取请求头中的帐号密码信息进行认证。以 Kyligence Enterprise 默认的账户密码 `ADMIN:KYLIN` 为例，对应帐号密码编码后结果为 `'Basic QURNSU46S1lMSU4='`，那么 HTTP 对应的头信息为 `'Authorization: Basic QURNSU46S1lMSU4='`。

- 在 HTTP 头添加 `Authorization` 信息
- 或者可以通过 `POST http://localhost:7070/kylin/api/user/authentication` 进行认证，一旦认证通过，接下来对 API 请求基于 cookies 在 HTTP 头中免去 `Authorization `信息


- `POST http://host:port/kylin/api/user/authentication`


- HTTP Header
	- `Authorization:Basic QURNSU46S1lMSU4=`
	- `Accept: application/vnd.apache.kylin-v2+json`
	- `Accept-Language: cn|en`
	- `Content-Type: application/json;charset=utf-8`


**Curl 请求示例**

```
curl -X POST \
  'http://host:port/kylin/api/user/authentication' \
  -H 'Accept: application/vnd.apache.kylin-v2+json' \
  -H 'Accept-Language: cn|en' \
  -H 'Authorization: Basic QURNSU46S1lMSU4=' \
  -H 'Content-Type: application/json;charset=utf-8'
```

**响应示例**

```JSON
{
    "code": "000",
    "data": {
        "username": "ADMIN",
        "password": "$2a$10$blHVMbzIgaw4NUBEGHBgIeCEA9xT8PHMR2eRMX1ylcA6GNEVD4RPS",
        "authorities": [...],
        "disabled": false,
        "defaultPassword": true,
        "locked": false,
        "lockedTime": 0,
        "wrongTime": 1,
        "uuid": "f5513792-f70b-42f5-b667-abf1d4a3876c",
        "last_modified": 1535938728227,
        "version": "3.0.0.1"
    },
    "msg": ""
}
```



**JavaScript 认证请求示例**

> 提示：您可以通过如下路径下载 "jquery.base64.js" https://github.com/yckart/jquery.base64.js

```javascript
var authorizationCode = $.base64('encode', 'NT_USERNAME' + ":" + 'NT_PASSWORD');

$.ajaxSetup({
   headers: { 
    'Authorization': "Basic " + authorizationCode, 
    'Content-Type': 'Content-Type: application/json;charset=utf-8',
    'Accept': 'application/vnd.apache.kylin-v2+json'
   }
});
```

```javascript
$.ajaxSetup({
      headers: { 
        'Authorization': 'Basic eWFu**********X***ZA==', 
        'Content-Type': 'Content-Type: application/json;charset=utf-8',
        'Accept': 'application/vnd.apache.kylin-v2+json'
      } // use your own authorization code here
    });
    var request = $.ajax({
       url: "http://host:port/kylin/api/query",
       type: "POST",
       data: '{"sql":"select count(*) from SUMMARY;","offset":0,"limit":50000,"acceptPartial":true,"project":"test"}',
       dataType: "json"
    });
    request.done(function( msg ) {
       alert(msg);
    }); 
    request.fail(function( jqXHR, textStatus ) {
       alert( "Request failed: " + textStatus );
  });
```


