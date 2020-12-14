## 与 Tableau Desktop 集成

Tableau 是 Windows 平台上最流行的商业智能工具之一，它操作简洁，功能强大，通过简单地拖拽就可以将大量数据体现在可视化图表中。Kyligence Enterprise 提供与 Tableau Desktop 不同的集成方式。

Kyligence Enterprise 支持与 Tableau 8.X，9.X，10.X，2018.X，2019.X ，2020.1 集成，本小节以 Tableau 2019.2 为例，将分步介绍 Kyligence Enterprise 与 Tableau Desktop 集成操作。

### 前置条件

- 安装 Kyligence ODBC 驱动程序。有关安装信息，请参考页面 [Kyligence ODBC 驱动程序介绍](../../driver/odbc/README.md)。
- 安装 Tableau Desktop。有关 Tableau 的安装说明，请访问 [Tableau Desktop 下载页面](https://www.tableau.com/zh-cn/support/releases)。

### 配置与 Kyligence 数据源连接

如您的 Tableau 版本为 2019.4 及以上，请配置 Kyligence 数据源连接器

1. 在 [Kyligence下载中心](http://download.kyligence.io/#/download) 下载 Kyligence Connector 文件  (.taco) 文件

2. 将 .taco 文件拷贝至 Tableau Desktop 安装目录，Tableau 安装目录为 

   ```
   Windows: My Documents/My Tableau Repository/Connectors
   macOS: ~/Documents/My Tableau Repository/Connectors 
   ```

   > **注意**：在 Tableau 2019.4 ~ 2020.3.2 版本，中文路径名会导致 Kyligence 连接器不生效，可通过自定义英文路径，并通过 TSM 配置 native_api.connect_plugins_path 解决。若您使用 Tableau 2020.3.2 及以上版本，不会遇到该问题。

3. 使用 TSM 配置 native_api.connect_plugins_path

   ```
   tsm configuration set -k native_api.connect_plugins_path -v {自定义路径}/tableau_connectors
   如果在此步骤中遇到配置错误，请尝试在命令末尾添加 --force-keys 选项
   ```

4. 重启 Tableau Desktop



如您的 Tableau 版本为 2019.4 以下，请配置 Tableau Datasource Customization (TDC) 文件。

> **注意**: Tableau 支持配置 TDC 文件，以达到自定义和调整 ODBC 连接。针对该特性，Kyligence 提供满足 Kyligence Enterprise 特殊的查询规范的 TDC 文件，以帮助 Tableau 更好的连接 Kyligence 数据。

配置步骤如下：

1. 在 [Kyligence下载中心](http://download.kyligence.io/#/download) 下载 **Tableau Datasource Customization** (TDC) 文件
2. 将 TDC 文件拷贝至 Tableau Desktop 相关安装目录下即可，默认目录为 Documents\My Tableau Repository\Datasources



Kyligence Enterprise 与 Tableau Desktop 支持2种集成方式，下文将分别介绍具体集成步骤。

- Kyligence Enterprise 快捷导入导出同步模型方式
- Kyligence Enterprise 手动映射模型方式


### 方式一：Kyligence Enterprise 快捷导入导出同步模型方式

您在Kyligence Enterprise 完成建模与创建Cube后，可以直接导出 Tableau 对应的数据源文件(.TDS)，

并在 Tableau 中一键导入该文件，快速完成模型同步。

> **注意：** 仅 Kyligence Enterprise 3.0.1 以上版本支持该方式

该方式主要步骤如下：

#### Kyligence Enterprise 导出 Tableau Data Source (.TDS) 文件

- 进入**建模**模块下的**Cube**页面
- 选择**Ready**状态的的**Cube**
- 在**更多操作**中选择**导出TDS** 

![](../../images/tableau_desktop/1_Export_TDS.png)

#### 将导出的.TDS文件导入至 Tableau

- 在已部署的 Tableau 环境中，双击导出的**TDS**文件
- 在弹出的认证窗口中，输入连接认证信息
- 点击**OK**

![](../../images/tableau_desktop/2_Connect_Information.png)

#### 在 Tableau 中，检查导入的模型内容, 如维度，度量

![](../../images/tableau_desktop/3_Review_Dimension_Measure.png)

#### 创建可视化图表

现在您可以进一步使用Tableau进行可视化分析，拖拽维度、度量字段，就可以生成自己的图表了。

![](../../images/tableau_desktop/4_Charts.png)



### 方式二：Kyligence Enterprise 手动映射模型方式 

您可通过Kyligence ODBC Driver 连接 Kyligence Enterprise 数据源, 并在 Tableau 中重新建立模型完成映射。

该方式主要步骤如下：


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



