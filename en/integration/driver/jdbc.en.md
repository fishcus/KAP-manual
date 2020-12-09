## Kyligence JDBC Driver
Kyligence Enterprise provides JDBC driver, which enables BI or other applications with JDBC interface to access Kyligence Enterprise instance.  

### How to get JDBC Driver

You can download Kyligence JDBC driver from  [Kyligence Download](http://download.kyligence.io/#/download) , and placed in the BI or other third party applications specified path.

> **Note：**
>
> 1. Support connecting to Kyligence Enterprise 3.2.x, 3.3.x, 3.4.x, 4.0.x, 4.1.x and higher versions
>
> 2. In earlier Kyligence Enterprise versions, under Kyligence Enterprise's installation directory's subdirectory `./lib`, users would find a jar package named as kylin-jdbc-kap-\<version\>.jar, which is the JDBC driver of Kyligence Enterprise.
>
> 3. Not support connecting  to Apache Kylin



### How to configure JDBC connection

Kyligence Enterprise JDBC driver follows the JDBC standard interface, users can specify the Kyligence Enterprise service to which the JDBC connection is made via the URL and the URL form is:

```
jdbc:kylin://<hostname>:<port>/<project_name>
```

URL parameter description is as follows:

- &lt;hostname&gt;: If Kyligence Enterprise service start SSL, then JDBC should use the HTTPS port of the Kyligence Enterprise service 

- &lt;port&gt;：If port has not been specified, then JDBC driver would use default port of HTTP and HTTPS 
- &lt;project_name&gt;:  Required. users have to ensure the project exist in Kyligence Enterprise service 



Besides, users need to specify username, password and whether SSL would be true for connection, these properties are as follow: 

- &lt;user&gt;: 	username to login Kyligence Enterprise service
- &lt;password&gt;: password to login Kyligence Enterprise service
- <ssl&gt;: enable ssl parameter. Set up string type "true" / "false", the default setting for this parameter  is "false". If the value is "true", all accesses to Kyligence Enterprise are based on HTTPS



Here lists an example of Connection: 

```java
Driver driver = (Driver) Class.forName("org.apache.kylin.jdbc.Driver").newInstance();
Properties info = new Properties();
info.put("user", "ADMIN");
info.put("password", "KYLIN");
//info.put("ssl","true");
Connection conn = driver.connect("jdbc:kylin://localhost:7070/kylin_project_name", info);
```



The following sections describe how two JAVA programs can connect to JDBC

#### Query based on Statement 
Here lists an example of Query based on Statement：
```java
Driver driver = (Driver) Class.forName("org.apache.kylin.jdbc.Driver").newInstance();
Properties info = new Properties();
info.put("user", "ADMIN");
info.put("password", "KYLIN");
//info.put("ssl","true");
Connection conn = driver.connect("jdbc:kylin://localhost:7070/kylin_project_name", info);
Statement state = conn.createStatement();
ResultSet resultSet = state.executeQuery("select * from test_table");
while (resultSet.next()) {
    System.out.println(resultSet.getString(1));
    System.out.println(resultSet.getString(2));
    System.out.println(resultSet.getString(3));
}
```


#### Query based on Prepared Statement 
Here lists an example of Query based on Prepared Statement： 

```java
Driver driver = (Driver) Class.forName("org.apache.kylin.jdbc.Driver").newInstance();
Properties info = new Properties();
info.put("user", "ADMIN");
info.put("password", "KYLIN");
//info.put("ssl","true");
Connection conn = driver.connect("jdbc:kylin://localhost:7070/kylin_project_name", info);
PreparedStatement state = conn.prepareStatement("select * from test_table where id=?");
state.setInt(1, 10);
ResultSet resultSet = state.executeQuery();
while (resultSet.next()) {
    System.out.println(resultSet.getString(1));
    System.out.println(resultSet.getString(2));
    System.out.println(resultSet.getString(3));
}
```

Among them, Prepared Statement supports assignment for the following types: 

* setString
* setInt
* setShort
* setLong
* setDouble
* setBoolean
* setByte
* setDate
* setTimestamp


**Dynamic Parametes In Prepared Statement**
By default, there are the following limitations on using dynamic parameters in Prepared Statement:

- Query pushdown is not supported when using Prepared Statement.
- Dynamic Param cannot be used in string functions, such as `substring`
- Dynamic param cannot follow with <b>'-'</b>, e.g. `SUM(price - ?)`
- Dynamic param cannot be used in <b>case when</b>, e.g. `case when xxx then ? else ? end`

We provide a way to bind dynamic parameter values. You need to configure the corresponding parameters to enable this function. Then all the [arithmetic functions](../../query/operator_function/function/arithmetic_function.en.md) and [string functions](../../query/operator_function/function/string_function.en.md) can be used with dynamic parameters.

The configuration method is: if the configuration file has contained item `kylin.query.transformers`, please add `io.kyligence.kap.query.util.BindParameters` to the end of it's value and separate them with comma; If not, please add item `kylin.query.transformers` and set it as `kylin.query.transformers=io.kyligence.kap.query.util.BindParameters`

In addition, we also provide a property to bind all dynamic parameter values, `kap.query.enable-replace-dynamic-parameters`, `false` by default.

It's recommended that you enable the above two configurations at the same time. After enabling, the dynamic parameter limit converges to

- Column names and time units cannot be used as dynamic parameters.
- Type conversion functions date and timestamp do not support dynamic parameters.
- Some functions such as subtract_count support array parameter. The parameters in array also support dynamic parameters, such as `array['FP-GTC|FP-non GTC ', ?]`, but dynamic parameters are not supported in single quotes, such as `array['?|?', ?]`.



### FAQ

**Q: How to upgrade the JDBC Driver?** 

A: Remove the Kyligence JDBC Driver package for BI or other third-party applications，and replace it with a new JDBC driver package.
