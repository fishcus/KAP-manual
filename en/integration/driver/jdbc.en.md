## Kyligence JDBC Driver
Kyligence Enterprise provides JDBC driver, which enables applications with JDBC interface to access Kyligence Enterprise instance.  

Under Kyligence Enterprise's installation directory's subdirectory "lib", users would find a jar package named as kylin-jdbc-kap-*.jar, which is the JDBC driver of Kyligence Enterprise.

#### Connecting Steps
Kyligence Enterprise JDBC driver follows the JDBC standard interface, users can specify the Kyligence Enterprise service to which the JDBC connection is made via the URL and the URL form is:

<!-- ``` -->
jdbc:kylin://<hostname>:<port>/<project_name>
```
* &lt;hostname&gt; : If Kyligence Enterprise service start SSL, then JDBC should use the HTTPS port of the Kyligence Enterprise service 
* &lt;port&gt;: If port has not been specified, then JDBC driver would use default port of HTTP and HTTPS 
* &lt;project_name&gt; : Required. users have to ensure the project exist in Kyligence Enterprise service 

Besides, users need to specify username, password and whether SSL would be true for connection, these properties are as follow: 

* &lt;user&gt;: username to login Kyligence Enterprise service
* &lt;password&gt;: password to login Kyligence Enterprise service
* &lt;ssl&gt;: enable ssl parameter. Set up string type "true" / "false", the default setting for this parameter  is "false". If the value is "true", all accesses to Kyligence Enterprise are based on HTTPS

Here lists an example of Connection: 

```java
Driver driver = (Driver) Class.forName("org.apache.kylin.jdbc.Driver").newInstance();
Properties info = new Properties();
info.put("user", "ADMIN");
info.put("password", "KYLIN");
//info.put("ssl","true");
Connection conn = driver.connect("jdbc:kylin://localhost:7070/kylin_project_name", info);
```

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
* setFloat
* setDouble
* setBoolean
* setByte
* setDate
* setTime
* setTimestamp


**Prepared Statement Known Limitation**

- Query pushdown is not supported when using Prepared Statement.
- Dynamic param cannot follow with <b>'-'</b>, e.g. `SUM(price - ?)`
- Dynamic param cannot use in <b>group by</b>, e.g. `group by trans_id/?`
- Dynamic param cannot use in <b>case when</b>, e.g. `case when xxx then ? else ? end`

It's recommended to use dynamic param in filters only, e.g. `where id = ?`.