## Kyligence JDBC 驱动程序
本产品支持JDBC接口，并提供了JDBC驱动程序。该驱动允许如第三方BI应用，SQL 查询工具或其他支持JDBC接口的应用访问本产品实例。



### 如何获取JDBC驱动程序

用户可以在产品安装目录的 `./lib`子目录下，获取相关JAR包文件。

文件名为： **kylin-jdbc-kap-\<version\>.jar**。

### 如何配置JDBC连接
本产品的 JDBC驱动程序遵循了JDBC标准接口，用户可通过URL指定JDBC方式连接到Kyligence服务。

URL格式为：

```
jdbc:kylin://<hostname>:<port>/<project_name>
```
URL参数说明如下：

- **\<hostname\>**:主机名

* **\<port\>**： 端口号，如果本产品部署启用了SSL安全认证服务，则应该使用相关HTTPS端口号

* **\<project_name\>**:  必须指定具体项目名称，并且确认该项目在服务中存在

  

其他配置参数如下：

* **\<user\>**: 	登陆服务实例的用户名
* **\<password\>**: 登陆服务实例的密码
* **\<ssl\>**: 是否开启SSL， 值为布尔型 true/false. 默认为false，如果是true，所有Kyligence的访问都将基于HTTPS

JAVA配置连接样例：

```java
Driver driver = (Driver) Class.forName("org.apache.kylin.jdbc.Driver").newInstance();
Properties info = new Properties();
info.put("user", "ADMIN");
info.put("password", "KYLIN");
//info.put("ssl","true");
Connection conn = driver.connect("jdbc:kylin://localhost:7070/kylin_project_name", info);
```



下面章节介绍两种JAVA程序调用 JDBC 的访问本产品

#### 方法一：基于Statement的查询

具体直接基于Statement进行查询的代码样例如下：
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


#### 方法二：基于PreparedStatement的查询
该方法支持在SQL语句中传入参数， 目前支持如下方法进行参数设置：

- setString
- setInt
- setShort
- setLong
- setFloat
- setDouble
- setBoolean
- setByte
- setDate
- setTime
- setTimestamp

具体基于Prepared Statement进行查询的代码样例如下：

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

