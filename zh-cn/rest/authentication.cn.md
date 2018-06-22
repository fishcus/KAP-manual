## 访问与安全认证

### 访问
KAP API 的访问前缀为 “/kylin/api”，不管对哪个模块的 API 访问都需要加上该前缀，比如访问所有 Cube 的 API 为 “/kylin/api/cubes”，对应的完整路径为 http://host:port/kylin/api/cubes。


### 认证
KAP 所有的 API 都是基于 [basic authentication](http://en.wikipedia.org/wiki/Basic_access_authentication) 认证机制，Basic Authentication 是非常简单的一种访问控制机制，将帐号密码基于 Base64 编码后作为请求头添加到 HTTP 请求头中，后端会读取请求头中的帐号密码信息进行认证。以 KAP 默认的账户密码 ADMIN:KYLIN 为例，对应帐号密码编码后结果为 “Basic QURNSU46S1lMSU4=“，那么 HTTP 对应的头信息为 “Authorization: Basic QURNSU46S1lMSU4=”。

### 认证要点
* 在 HTTP 头添加 `Authorization` 信息
* 或者可以通过 `POST http://localhost:7070/kylin/api/user/authentication` 进行认证，一旦认证通过，接下来对 API 请求基于 cookies 在 HTTP 头中免去 `Authorization `信息

`请求方式 POST`

`访问路径 http://host:port/kylin/api/user/authentication `

`Authorization:Basic xxxxJD124xxxGFxxxSDF`

`Content-Type: application/vnd.apache.kylin-v2+json;charset=UTF-8`

`Accept: application/vnd.apache.kylin-v2+json`

`Accept-Language: cn|en` 

这里以 javascript 和 curl 为例介绍在访问 API 时如何添加认证信息。
### Query API 示例
```javascript
$.ajaxSetup({
      headers: { 
        'Authorization': 'Basic eWFu**********X***ZA==', 
        'Content-Type': 'application/vnd.apache.kylin-v2+json;charset=UTF-8',
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

Javascript 如何生成 authorization 信息（下载 "jquery.base64.js" [https://github.com/yckart/jquery.base64.js](https://github.com/yckart/jquery.base64.js)）。

```javascript
var authorizationCode = $.base64('encode', 'NT_USERNAME' + ":" + 'NT_PASSWORD');
 
$.ajaxSetup({
   headers: { 
    'Authorization': "Basic " + authorizationCode, 
    'Content-Type': 'application/vnd.apache.kylin-v2+json;charset=UTF-8',
    'Accept': 'application/vnd.apache.kylin-v2+json'
   }
});
```

### Curl 示例

通过curl进行认证

```
curl -X POST -H 'Authorization: Basic XXXXXXXXX' -H  'Accept: application/vnd.apache.kylin-v2+json' -H "Content-Type:application/vnd.apache.kylin-v2+json" http://host:port/kylin/api/user/authentication
```

通过API访问时添加认证信息

```
curl -X PUT -H 'Authorization: Basic XXXXXXXXX' -H 'Accept: application/vnd.apache.kylin-v2+json' -H "Content-Type:application/vnd.apache.kylin-v2+json" -d '{"startTime":'1423526400000', "endTime":'1423626400000', "buildType":"BUILD", "mpValues":""}' http://host:port/kylin/api/cubes/your_cube/segments/build
```

