## 与 SmartBI Insight 集成

SmartBI Insight
是企业级的商业智能分析平台，定位于前端数据分析，对接各种数据库、数据仓库和大数据平台，构建交互式仪表盘，满足多样性的数据分析应用需求，如大数据分析、企业报表平台、自主探索分析等。本文将分步介绍 SmartBI Insight 与 Kyligence Enterprise 的连接。

### 安装 SmartBI Insight

有关 SmartBI Insight 的安装说明，请访问 [SmartBI Insight 下载页面](http://www.SmartBI.com.cn/download)

### 使用 JDBC 连接 Kyligence Enterprise

1. 安装 Kyligence JDBC 驱动程序

   SmartBI Insight 通过JDBC连接 Kyligence Enterprise，所以首先需要在SmartBI Insight 上安装 Kyligence JDBC 驱动程序

   + 获取 Kyligence JDBC 驱动程序：

     请参考 [Kyligence JDBC 驱动程序说明](../driver/jdbc.cn.md)

   + 向 SmartBI Insight 增加 JDBC 驱动程序：

     具体步骤如下：

     (1)停止tomcat，删除war包（**安装目录\Tomcat\webapps\SmartBI.war**）中的jar包 **_JDBC_kylin-jdbc-1.5.0-SNAPSHOT.jar** 

     注：此处可以直接使用 WinRAR 删除、添加文件，而无需解压缩再压缩

     (2)修改后，需要删除 (**安装目录\Tomcat\webapps\SmartBI**) 文件夹 ，清空（**安装目录\Tomcat\temp**）文件夹和（**安装目录\Tomcat\work**）文件夹

     (3)添加新的jar包到war包并保存war包

     (4)重启tomcat

2. 建立 Kyligence Enterprise 数据源连接 

   + **进入界面**

     在 **定制管理**->**数据管理**->**数据源** 节点下右键选择新建关系数据源，或是在定制管理快捷按钮选择 **数据源连接**，则打开数据源连接窗口。

     ![进入界面](../images/SmartBI/01.PNG)

   + **新建数据源**

     选择**Kylin**驱动程序类型，将服务器IP地址等信息填写到连接字符串（字符串格式为:**jdbc:kylin://<hostname>:<port>/<project_name>**) ,然后**保存**数据源连接。

     这里默认选择用户验证类型为**静态验证**，输入Kyligence Enterprise的用户名和密码进行连接。

     如需使用**动态验证**方式，请参考本文下方的**用户的动态验证方式**。

     ![新建数据源](../images/SmartBI/02.PNG)

   + **管理数据源**

     对数据源进行管理，将表结构信息（表名、字段名、字段类型等）添加到 SmartBI Insight 中。

     ![管理数据源1](../images/SmartBI/09.PNG)

     也可以对选择设置字段别名，设置数据类型、数据格式等操作。

     ![管理数据源2](../images/SmartBI/10.PNG)

     对于星型模型的多表关联，会按照按外键、列名等方式自动创建表之间的关联关系，也可以手动拖拽建立关联关系。（注：这里的关联关系需要与接下来使用的cube中的**关联关系**相匹配）

     ![管理数据源3](../images/SmartBI/11.PNG)

3. 制作图表

   + 新建透视分析，选择新建的数据源，拖拽字段到行列区和过滤区，进行自助式探索分析。可将任意字段作为查询条件进行数据筛查，并进行数据的排序、钻取、行列互换、同环比时间计算等。

     ![制作图表1](../images/SmartBI/12.PNG)

   + 根据分析需要，灵活生成各种分析图表。

     ![制作图表2](../images/SmartBI/13.PNG)

4. 使用用户的动态验证方式

   + 首先设置用户的扩展属性

     ![设置拓展属性](../images/SmartBI/05.PNG)

   + 创建新用户

     ![创建新用户](../images/SmartBI/06.PNG)

   + 在建立数据源连接时选用动态验证方式，将左侧菜单栏中的**用户名**及**密码**字符串拖动过来即可。

     ![登录](../images/SmartBI/07.PNG)

### 使用 MDX Service 连接 Kyligence Enterprise

1. 安装 MDX Service

   请参考 [与 Excel 集成](../excel.cn.md)

2. 建立多维数据源连接

   + 点击选项卡右侧的定制管理，点击数据源连接，选择多维数据源

     ![创建连接](../images/SmartBI/SmartBI-MDX_01.png)

   + 数据库类型选择 Mondrian, 连接地址格式为 http://{mdx.host}:{mdx.port}/mdx/xmla/{project}

     ![输入连接地址](../images/SmartBI/SmartBI-MDX_02.png)

   + 输入账号密码，需要注意的是，SmartBI 支持的密码格式仅包含字母数字下划线，然后点击测试连接

     ![测试连接](../images/SmartBI/SmartBI-MDX_03.png)

   + 测试通过后，选择一个多维数据库，然后点击保存

     ![保存连接](../images/SmartBI/SmartBI-MDX_04.png)

   + 然后在左侧数据管理 --> 数据源中找到刚才创建的连接，右键数据集管理，将刚才选择的多维数据集同步到右侧

     ![同步连接](../images/SmartBI/SmartBI-MDX_05.png)

3. 多维分析与图表制作

   + 在定制管理页卡中选择其他分析中的多维分析

     ![选择多维分析](../images/SmartBI/SmartBI-MDX_06.png)

   + 选择刚才创建的多维数据集，点击开始分析

     ![打开多维分析](../images/SmartBI/SmartBI-MDX_07.png)

   + 将维度度量过滤条件拖动到相应区域，点击刷新，获取数据

     ![获取数据](../images/SmartBI/SmartBI-MDX_08.png)

   + 选择相应的图形展示数据

     ![图形展示](../images/SmartBI/SmartBI-MDX_09.png)
