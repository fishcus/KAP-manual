## Access and Authentication

### Access information
The access prefix of KAP API is "/kylin/api". This prefix is required regardless of which module API is accessed,  such as accessing all cubes whose APIs are "/kylin/api/cubes", and correspondingly the complete path is http://host:port/kylin/api/cubes.


### Authentication
All APIs in KAP are based on [basic authentication](http://en.wikipedia.org/wiki/Basic_access_authentication) authentication mechanism. Basic Authentication is a simple access control mechanism, which encodes account and password information based on Base64, and add these information as request headers to HTTP request headers, then the back-end will read account information from the request header for authentication. Take KAP default account password ADMIN:KYLIN as an example, after encoding, the corresponding account password would be "Basic QURNSU46S1lMSU4 =", so the corresponding HTTP header information is "Authorization: Basic QURNSU46S1lMSU4 =". 

### Authentication essentials
* Add `Authorization` to HTTP header
* Or users could get authorization through `POST http://localhost:7070/kylin/api/user/authentication` . Once the authentication passes, the authentication information would be stored in cookie files for the following visit. 

`请求方式 POST`

`访问路径 http://host:port/kylin/api/user/authentication `

`Authorization:Basic xxxxJD124xxxGFxxxSDF`

`Content-Type: application/vnd.apache.kylin-v2+json;charset=UTF-8`

`Accept: application/vnd.apache.kylin-v2+json`

Here we use javascript and curl as examples to introduce how to add authentication information when accessing the API. 

## Query API Example
```
$.ajaxSetup({
      headers: { 
        'Authorization': "Basic eWFu**********X***ZA==",
        'Content-Type': 'application/json;charset=utf-8',
        'Accept': 'application/vnd.apache.kylin-v2+json'
      } // use your own authorization code here
    });
    var request = $.ajax({
       url: "http://hostname/kylin/api/query",
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

How does Javascript generate authorization information (download "jquery.base64.js" [https://github.com/yckart/jquery.base64.js](https://github.com/yckart/jquery.base64.js)).

```
var authorizationCode = $.base64('encode', 'NT_USERNAME' + ":" + 'NT_PASSWORD');
 
$.ajaxSetup({
   headers: { 
    'Authorization': "Basic " + authorizationCode, 
    'Content-Type': 'application/json;charset=utf-8',
    'Accept': 'application/vnd.apache.kylin-v2+json'
   }
});
```

## Curl Example

Using curl to get authorization:

```
curl -X POST -H 'Authorization: Basic XXXXXXXXX' -H 'Content-Type: application/vnd.apache.kylin-v2+json;charset=UTF-8' -H  'Accept: application/vnd.apache.kylin-v2+json' http://host:port/kylin/api/user/authentication
```

Adding authorization information when using api to get access:

```
curl -X PUT -H 'Authorization: Basic XXXXXXXXX' -H 'Content-Type: application/vnd.apache.kylin-v2+json;charset=UTF-8' -H 'Accept: application/vnd.apache.kylin-v2+json' -d '{"startTime":'1423526400000', "endTime":'1423626400000', "buildType":"BUILD", "mpValues":""}' http://host:port/kylin/api/cubes/your_cube/segments/build
```

