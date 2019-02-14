## Access and Authentication API

### Access Information
The access prefix of all Kyligence Enterpriese APIs is `/kylin/api`. This prefix is required regardless of which module API is accessed. For example,  accessing cubes uses API of `/kylin/api/cubes`, and the correspondingly complete path is `http://host:port/kylin/api/cubes`.



### Authentication
All APIs in Kyligence Enterprise are based on [Basic Authentication](http://en.wikipedia.org/wiki/Basic_access_authentication) authentication mechanism. Basic Authentication is a simple access control mechanism, which encodes account and password information based on Base64. Adding these information as request headers to HTTP request commands,  the back-end will decode the account and password information from the request header for authentication. Take the default account and  password of  Kyligence Enterprise , `ADMIN:KYLIN`, as an example, after encoding, the corresponding authentication information would be `Basic QURNSU46S1lMSU4=`, and the corresponding HTTP header information is `Authorization: Basic QURNSU46S1lMSU4=`. 



### Authentication Essentials
* Add `Authorization` to HTTP header
  * Or users could get authorized through `POST http://host:port/kylin/api/user/authentication`. Once the authentication passes, the authentication information would be stored in cookie files for the following visit. 


- HTTP Header
  - `Authorization:Basic QURNSU46S1lMSU4=`
  - `Accept: application/vnd.apache.kylin-v2+json`
  - `Accept-Language: en`
  - `Content-Type: application/json;charset=utf-8`

- Curl Request Example

  ```sh
  curl -X POST \
    'http://host:port/kylin/api/user/authentication' \
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



### JavaScript Authentication Request Example

> Note:  You can download "jquery.base64.js" at [https://github.com/yckart/jquery.base64.js](https://github.com/yckart/jquery.base64.js)

```javascript
var authorizationCode = $.base64('encode', 'NT_USERNAME' + ":" + 'NT_PASSWORD');
 
$.ajaxSetup({
   headers: { 
    'Authorization': "Basic " + authorizationCode, 
    'Content-Type': 'application/json;charset=utf-8',
    'Accept': 'application/vnd.apache.kylin-v2+json'
   }
});
```

```javascript
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

