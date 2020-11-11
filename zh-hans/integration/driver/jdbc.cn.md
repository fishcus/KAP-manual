## Kyligence JDBC 驱动
本产品支持 JDBC 接口，并提供了 JDBC 驱动程序。该驱动允许如第三方BI应用，SQL 查询工具或其他支持 JDBC 接口的应用访问本产品实例。

### 如何获取 JDBC 驱动程序

在 [Kyligence 下载页面](http://download.kyligence.io/#/download) 下载 Kyligence JDBC 驱动程序，并放置在 BI 或其它第三方应用指定路径。

> **注意：**
>
> 1. 支持连接到 Kyligence Enterprise 3.2.x，3.3.x，3.4.x，4.0.x，4.1.x 及之后的高版本
> 2. 较早期的 Kyligence Enterprise版本，可以在产品安装目录的 `./lib`子目录下，获取 JDBC JAR 包文件进行连接, 文件名为：**kylin-jdbc-kap-\<version\>.jar**
> 3. 不支持连接到 Apache Kylin



### 如何配置 JDBC 连接

本产品的 JDBC 驱动程序遵循了 JDBC 标准接口，用户可通过 URL 指定 JDBC 方式连接到 Kyligence 服务。

URL 格式为：

```
jdbc:kylin://<hostname>:<port>/<project_name>
```
URL 参数说明如下：

- &lt;hostname&gt;: 主机名

* &lt;port&gt;：端口号，如果本产品部署启用了SSL安全认证服务，则应该使用相关HTTPS端口号

* &lt;project_name&gt;:  必须指定具体项目名称，并且确认该项目在服务中存在

  

其他配置参数如下：

* &lt;user&gt;: 	登陆服务实例的用户名

* &lt;password&gt;: 登陆服务实例的密码

* &lt;ssl&gt;: 是否开启SSL，值为String类型的"true"或"false"， 默认为"false"。如果是"true"，所有Kyligence的访问都将基于HTTPS

  

JAVA 配置连接样例：

```java
Driver driver = (Driver) Class.forName("org.apache.kylin.jdbc.Driver").newInstance();
Properties info = new Properties();
info.put("user", "ADMIN");
info.put("password", "KYLIN");
//info.put("ssl","true");
Connection conn = driver.connect("jdbc:kylin://localhost:7070/kylin_project_name", info);
```



下面章节介绍两种 JAVA 程序调用 JDBC 的连接方式

#### 方法一：基于 Statement 的查询

具体直接基于 Statement 进行查询的代码样例如下：
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


#### 方法二：基于 PreparedStatement 的查询
该方法支持在 SQL 语句中传入参数， 目前支持如下方法进行参数设置：

- setString
- setInt
- setShort
- setLong
- setDouble
- setBoolean
- setByte
- setDate
- setTimestamp

具体基于 Prepared Statement 进行查询的代码样例如下：

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

**Prepared Statement 已知限制**

- 不支持查询下压
- 动态参数不支持与"-"放在一起，如`SUM(price - ?)`
- 动态参数不支持出现在 **group by** 中，如 `group by trans_id/?`
- 动态参数不支持出现在 **case when** 中，如`case when xxx then ? else ? end`

此外，我们推荐您仅让动态参数出现在查询的过滤条件中，如 `where id = ?`



### FAQ

**Q: 如何升级 JDBC 驱动?**   

A: 将 BI 或其它第三方应用的 Kyligence JDBC 驱动包移除，替换至新的 JDBC 驱动包即可。

**Q: 系统如何支持在函数中使用动态参数?**

A: 当前的系统默认不支持在函数中使用动态参数，需要配置相应的参数开启该功能，开启之后所有的[算数函数](../../query/operator_function/function/arithmetic_function.cn.md)和[字符串函数](../../query/operator_function/function/string_function.cn.md)均可支持动态参数。

- 修改相应的配置：若配置文件中已存在配置项 `kylin.query.transformers` ，请直接在参数值后面追加 `io.kyligence.kap.query.util.BindParameters`，以逗号间隔；若不存在，请添加该配置项，并设置为 `kylin.query.transformers=io.kyligence.kap.query.util.BindParameters`
