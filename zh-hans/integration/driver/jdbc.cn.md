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

**动态参数**

默认情况下，在 Prepared Statement 中使用动态参数存在以下限制

- 不支持查询下压
- 不支持部分函数，如substring
- 动态参数不支持与"-"放在一起，如`SUM(price - ?)`
- 动态参数不支持出现在 **case when** 中，如`case when xxx then ? else ? end`

我们提供了动态参数绑定功能，需要配置相应的参数开启该功能，开启之后所有的[算数函数](../../query/operator_function/function/arithmetic_function.cn.md)和[字符串函数](../../query/operator_function/function/string_function.cn.md)均可支持动态参数。

配置方法为：若配置文件中已存在配置项 `kylin.query.transformers` ，请直接在参数值后面追加 `io.kyligence.kap.query.util.BindParameters`，以逗号间隔；若不存在，请添加该配置项，并设置为 `kylin.query.transformers=io.kyligence.kap.query.util.BindParameters`

此外，我们也提供了参数用以绑定查询语句中的全部动态参数，`kap.query.replace-dynamic-parameters-enabled`, 默认关闭。

我们建议您同时启用上述两项配置，开启之后，动态参数的限制收敛为

- 动态参数的类型仅支持手册中提及到的类型，所以不支持**列名**和**时间单位**。
- 类型转换函数包括有 `data`, `timestamp` 和 `cast`, 其中 `date` 和 `timestamp` 不支持动态参数。
- 部分函数如 `subtract_count` 支持传 `array['FP-GTC,FP-non GTC', 'Others']` 类型的参数，array中的参数也支持使用动态参数，如 `array['FP-GTC|FP-non GTC', ?]`，但单引号内不支持动态参数，即不能使用 `array['?|?', ?]`

## JDBC 驱动日志

您可以启用驱动程序中的日志记录来跟踪活动和故障排除问题。

**重要:** 启动详细的的日志记录用来捕获问题，但日志记录会降低性能并消耗大量磁盘空间。

1. 在文本编辑器中打开 JDBC 驱动程序日志配置文件。

   例如，您可打开 {JDBC安装路径}/kyligence-jdbc.properties 文件

   > **注意**：kyligence-jdbc.properties 默认配置文件，需要与 JDBC jar 包放在同一路径。

2. 设置日志级别。下面列出了所有日志级别的信息，TRACE 在大多数情况下是最佳的。

   - **OFF** 禁用所有日志记录。
   - **FATAL** 记录非常严重的错误事件，可能导致驱动程序中止。
   - **ERROR** 记录错误事件，可能仍然允许驱动程序继续运行。
   - **WARN** 记录潜在的有害情况。
   - **INFO** 记录描述驱动程序进程的一般信息。
   - **DEBUG** 记录对调试驱动程序有用的详细信息。
   - **TRACE** 记录比日志DEBUG更详细的信息。

   例如: **LogLevel=TRACE**

3. 设置日志文件路径和名称。将 **LogPath** 属性设置为要保存日志文件的文件夹完整路径。这个路径确保存在，并且是可写的，包括如果使用驱动程序的应用程序作为特定用户运行，其他用户也可以写。

   例如: **LogPath=/usr/local/KyligenceJDBC.log**

4. 配置 **MaxBackupIndex** 属性以保留最大数量的日志文件。

   例如: **MaxBackupIndex=10**

   > **注意**: 在达到日志文件的最大数量之后，每次创建一个额外的文件，驱动程序都会删除最旧的文件。

5. 配置 **MaxFileSize** 属性设置为每个日志文件的最大大小 (以字节为单位)。

   例如: **MaxFileSize=268435456**

   > **注意:** 在达到最大文件大小之后，驱动程序创建一个新文件并继续日志记录。

6. 保存驱动程序配置文件。

   示例如下：

   ```
   # 设置日志级别
   LogLevel=TRACE
   
   # 设置日志路径
   LogPath=/usr/local/KyligenceJDBC.log
   
   # 设置保留最大数量的日志文件
   MaxBackupIndex=10
   
   # 设置每个日志文件的最大大小
   MaxFileSize=268435456
   ```

7. 重新启动使用驱动程序的应用程序。在重新加载驱动程序之前，应用程序不会应用配置更改。


### FAQ

**Q: 如何升级 JDBC 驱动?**   

A: 将 BI 或其它第三方应用的 Kyligence JDBC 驱动包移除，替换至新的 JDBC 驱动包即可。
