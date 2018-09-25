## 与 Cognos 10.X集成

### 安装 Kyligence ODBC 驱动程序

有关安装信息，参考页面 [Kyligence ODBC 驱动程序教程](../driver/kyligence_odbc.cn.md)。

### 前置条件

- Cognos Framework manager 的版本与 Cognos server 的版本一致。

- Framework manager 和 Cognos server使用相同版本ODBC driver（若之前安装了64位的ODBC，需要卸载）

- DSN 的名字在 Framework manager 和 Cognos server 上一致。

- ODBC driver 版本跟 Kyligence Enterprise 版本的匹配。


### 创建一个Cognos数据源

在安装完 Kyligence ODBC Driver 并配置好 DSN 后，打开一个已有 Cognos 项目或者创建一个新项目。在本例中我们将创建一个新项目。

1. 创建新项目![](images/cognos/1.png)

2. 使用`元数据向导`创建新`数据源`。![](images/cognos/2.png)

3. 在`新建数据源向导`第一步中输入数据源名称。![](images/cognos/3.png)

4. 选择`ODBC`作为连接类型。在`隔离级别`中，选择`使用默认对象Gateway`。![](images/cognos/4.png)

5. 在 ODBC 数据源中填入上一步创建的 DSN 的名称。勾选`Unicode ODBC`。在`登陆`项中勾选`无身份验证`。

   随后点击`测试连接`。![](images/cognos/6.png)

   如果一切配置正确的话，测试连接会顺利通过。![](images/cognos/7.png)![](images/cognos/8.png)

   这样数据源就创建成功了。

   > **提示**：考虑到本 BI 工具的连接数据源时的探测特性，为了避免在超大数据量情形下连接数据源响应时间过长，请调整 `kylin.properties` 中的 `kylin.query.force-limit` 参数为1000，表示数据源限制 `select *` 探测语句返回的记录数为1000。

6. 点击`下一步`你可以继续在`元数据向导`中测试表的连接。![](images/cognos/9.png)



### Cognos 与 Kyligence Enterprise 权限集成

为了支持输入不同的用户名和密码，需要进行 Cognos 与 Kyligence Enterprise 权限集成。本小节在默认已经配置 Cognos 认证程序的基础上进行 Kyligence Enterprise 与 Cognos 的 ODBC 用户集成，以自定义的 Java 为样例来进行介绍。有关详细信息，请参考 Cognos SDK 对应的 AuthenticationProvider 文档。下图是以 Java 程序为例子的典型 Cognos 外部认证空间：

![](images/cognos/cognos_acl_1.png)

在 Cognos 权限认证对应的数据库中，添加 Kyligence Enterprise 的用户名和密码：

![](images/cognos/cognos_acl_2.png)

创建一个 Cognos 数据源，第一步至第四步与上面相同，在第五步中，选择`外部名称空间`：

![](images/cognos/cognos_acl_3.png)



点击测试连接后，可以看到测试成功的提示，这说明 Cognos 通过 Kyligence Enterprise 的 ODBC 已成功连接 Kyligence Enterprise 的 server。

![](images/cognos/cognos_acl_4.png)



### 测试连接

下面我们对已创建的数据源连接进行测试。首先选择需要导入项目中的表。

![](images/cognos/10.png)

下一步的所有参数可以保留默认配置。

![](images/cognos/11.png)

现在新数据源已经被导入到项目中了。右键一个表测试表的连接。

![](images/cognos/12.png)

在测试的弹窗中，点击`测试示样`来测试与表的连接。如果连接配置正确，测试结果会返回在弹窗中。

![](images/cognos/13.png)



### 发布数据包

在项目查看器中，右键`数据包`->`新建`->`数据包`将需要使用的表进行发布。

![](images/cognos/14.png)

首先创建数据包，在创建流程中第一步先为数据包命名。

![](images/cognos/15.png)

第二步选择数据包中需要包含的表和列。

![](images/cognos/16.png)

第三步选择包中支持的`函数集`，这里可以保留默认的设置。

![](images/cognos/17.png)

这样数据包就创建成功了，接下来进入`发布数据包向导`。

下面的步骤可以保留默认配置。

![](images/cognos/18.png)

![](images/cognos/19.png)

![](images/cognos/20.png)

![](images/cognos/21.png)

![](images/cognos/22.png)

这样数据包就发布成功了。



### 创建一个简单的图表

下面我们可以使用发布好的数据包来制作一个简单的图表。

在 Cognos 网页端启动`Report Studio`。

![](images/cognos/23.png)

选择之前创建好的数据包。

![](images/cognos/32.png)

在`Report Studio`中选择`新建`。

![](images/cognos/24.png)

使用新创建的数据包，选择`图表`。

![](images/cognos/25.png)

选择一个图表类型。

![](images/cognos/26.png)

将维度和度量拉拽到报表上。

![](images/cognos/27.png)

点击菜单中的`运行`键运行报表。

这样你就成功的使用 Kyligence Enterprise 作为数据源创建了一个图表。

![](images/cognos/28.png)

