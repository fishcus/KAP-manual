## 与 Tableau Desktop 集成

Tableau 是 Windows 平台上最流行的商业智能工具之一，它操作简洁，功能强大，通过简单地拖拽就可以将大量数据体现在可视化图表中。Kyligence Enterprise 提供与 Tableau Desktop 不同的集成方式。

Kyligence Enterprise 支持与 Tableau 8.X，9.X，10.X，2018.X，2019.X ，2020.1 集成，本小节以 Tableau 2019.2 为例，将分步介绍 Kyligence Enterprise 与 Tableau Desktop 集成操作。

### 前置条件

- 安装 Kyligence ODBC 驱动程序。有关安装信息，请参考页面 [Kyligence ODBC 驱动程序介绍](../../driver/odbc/README.md)。

- 安装 Tableau Desktop。有关 Tableau 的安装说明，请访问 [Tableau Desktop 下载页面](https://www.tableau.com/zh-cn/support/releases)。

- 配置 Tableau Datasource Customization (TDC) 文件。

  Tableau 支持配置 TDC 文件，以达到自定义和调整 ODBC 连接。针对该特性，Kyligence 提供满足 Kyligence Enterprise 特殊的查询规范的 TDC 文件，以帮助 Tableau 更好的连接 Kyligence 数据。

  配置步骤如下：

  1. 在 [Kyligence下载中心](http://download.kyligence.io/#/download) 下载 **Tableau Datasource Customization** (TDC) 文件

  2. 将 TDC 文件拷贝至 Tableau Desktop 相关安装目录下即可，默认目录为 ` Documents\My Tableau Repository\Datasources`


### 连接 Kyligence Enterprise

打开 Tableau Desktop，单击左侧面板中的 Other Database (ODBC)，可选择**驱动程序**或者 **DSN** 方式连接。选择**驱动程序**方式，需要在弹出窗口中输入连接认证信息（服务器地址、端口、项目、用户名、密码）, 选择 **DSN** 方式，直接下拉选择本地已创建好的 DSN 。点击**连接**，验证通过后，即可获取该账户下所有有权限访问的表和数据。 

> **注意：**当您在 Tableau Desktop 使用 **DSN** 方式连接到 Kyligence Enterprise，并需要将工作薄发布至 Tableau Server 时，应在 Tableau Server 创建与本地同名的 DSN，DSN 类型必须是**系统 DSN**。若您使用**驱动程序**方式连接时，不需要在 Tableau Server 创建 DSN。

![连接 Kyligence Enterprise](../../images/tableau_desktop/5_ODBC.png)

### 创建数据模型

在 Tableau Desktop 左边面板中，选择 **default** 作为数据库，在搜索框中点击 **Search** 图标，将会列出所有的表，可通过拖拽的方式把表拖到右边面板中，创建表与表的连接关系 。

![创建数据模型](../../images/tableau_desktop/6_MODEL.png)

### 设置实时连接

Tableau 中提供两种数据源连接类型，大数据场景下，建议您选择**实时**（Live）连接。

![设置实时连接](../../images/tableau_desktop/7_LIVE.png)

### 自定义 SQL

如果用户想通过自定义SQL进行交互，可以点击模型界面左下角的**新建自定义 SQL**（New Custom SQL），在弹出的框中输入 SQL 即可实现。

![自定义 SQL 交互](../../images/tableau_desktop/8_Custom_SQL.png)

### 可视化

现在您可以进一步使用 Tableau 进行可视化分析，拖拽维度、度量字段，就可以生成自己的图表了。

![可视化分析](../../images/tableau_desktop/4_Charts.png)



