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


**Prepared Statement Known Limitation**

- Query pushdown is not supported when using Prepared Statement.
- Dynamic param cannot follow with <b>'-'</b>, e.g. `SUM(price - ?)`
- Dynamic param cannot use in <b>case when</b>, e.g. `case when xxx then ? else ? end`

It's recommended to use dynamic param in filters only, e.g. `where id = ?`.



## JDBC Driver Logging

You can enable logging in the driver to track activity and troubleshoot issues.

**Important:** Only enable logging long enough to capture an issue. Logging decreases performance and can consume a large quantity of disk space.

1. Open the driver logging configuration file in a text editor.
   For example, you would open the  {JDBC installed path}/kyligence-jdbc.properties

   > **Note**：kyligence-jdbc.properties is the default configuration file that needs to be placed in the same path as the JDBC jar package

3. Set log level. Information on all of the Log Levels is listed below.Trace is best in most cases.

   - **OFF** disables all logging.
   - **FATAL** logs very severe error events that might lead the driver to abort.
   - **ERROR**  logs error events that might still allow the driver to continue running.
   - **WARN**  logs potentially harmful situations.
   - **INFO**  logs general information that describes the progress of the driver.
   - **DEBUG**  logs detailed information that is useful for debugging the driver.
   - **TRACE** logs more detailed information than log level DEBUG.

   For example: **LogLevel=TRACE**

5. Set the Log Path and file name.Set the **LogPath** attribute to the full path to the folder where you want to save log files. This directory must exist and be writable, including being writable by other users if the application using the driver runs as a specific user.
   For example: **LogPath=/usr/local/KyligenceJDBC.log**      

6. Set the **MaxBackupIndex** attribute to the maximum number of log files to keep.
   For example: **MaxBackupIndex=10**

   > **Note**: After the maximum number of log files is reached, each time an additional file is created, the driver deletes the oldest file.

7. Set the **MaxFileSize** attribute to the maximum size of each log file in bytes.
   For example: **MaxFileSize=268435456**

   > **Note:** After the maximum file size is reached, the driver creates a new file and continues logging.

6. Save the driver configuration file.

   ```
   # Set log level
   LogLevel=TRACE
   
   # Set log path and file name
   LogPath=/usr/local/KyligenceJDBC.log
   
   # Set maximum number of log files to keep
   MaxBackupIndex=10
   
   # Set maximum size of each log file in bytes
   MaxFileSize=268435456
   ```

7. Restart the application you are using the driver with.Configuration changes will not be picked up by the application until it reloads the driver.

   

   

### FAQ

**Q: How to upgrade the JDBC Driver?** 

Remove the Kyligence JDBC Driver package for BI or other third-party applications，and replace it with a new JDBC driver package.
