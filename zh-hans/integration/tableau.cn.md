
## 与 Tableau  集成

Tableau 是 Windows 平台上最流行的商业智能工具之一，它操作简介，功能强大，通过简单地拖拽就可以将大量数据体现在可视化图表中。Kyligence Enterprise 提供与 Tableau Desktop 不同的集成方式。

本小节将介绍 Kyligence Enterprise 与 Tableau Desktop 的2种集成方式。

- Kyligence Enterprise 快捷导入导出同步模型方式
- Kyligence Enterprise 手动映射模型方式

### 前置条件

- 安装 Kyligence ODBC 驱动程序。有关详细安装信息，请参考 [Kyligence ODBC 驱动程序](../driver/kyligence_odbc.cn.md)。

- 如果希望进行明细查询，需要在 Cube 中配置**表索引**或开启**查询下压**。


### 方式一：Kyligence Enterprise 快捷导入导出同步模型方式

用户在完成 Kyligence Enterprise 建模与创建 Cube 阶段后，可以通过导出 Tableau 对应的数据定义文件，

并在 Tableau 中一键导入该文件，快速完成模型同步。

> **注意：** 仅 Kyligence Enterprise 3.0.1 以上版本支持该方式

该方式主要步骤如下：

1. Kyligence Enterprise 导出 Tableau Data Source (TDS) 文件：
   - 进入**建模**功能下的**Cube**模型清单
   - 选择Ready状态的的**Cube**
   - 在 **更多操作** 中选择 **导出TDS** 
2. 将导出的 TDS 文件导入至 Tableau。
   - 在已部署的 Tableau 环境中，双击导出的**TDS**文件
   - 在弹出的认证窗口中，输入连接认证信息
   - 点击**OK**
3. 在 Tableau 中，检查导入的模型内容, 如维度，度量之类。



### 方式二：Kyligence Enterprise 手动映射模型方式 

用户可通过 ODBC Driver 连接 Kyligence Enterprise 数据源, 并在 Tableau 中重新建立模型完成映射。

该方式主要步骤如下：

1. 启动 Tableau，在 **数据**->**新建数据源** 下，选择 **其他数据库 (ODBC)**。
2. 在弹出窗口，选择 **KyligenceODBCDriver** ，点击 **连接**。
3. 在**连接属性**中，配置以下信息以创建 Kyligence Enterprise 数据源连接。
   - 服务器地址
   - 端口
   - 项目
   - 用户名
   - 密码
4. （或者）在弹出窗口，选择已配置的 **DSN** 进行连接。
5. 在 Tableau 中，重建 Kyligence Enterprise 模型的关联关系，完成模型映射。Tableau 建模方式请参考 Tableau 官方说明。

### 其他注意事项

当您使用 Tableau 连接 Kyligence Enterprise 时，Tableau 会发送一个全表查询语句。如果表数据量较大，会造成查询返回时间较长。

以下两种方式可以避免这种情况：

**方法一**：您可以从官网下载并配置 Kyligence 的 Tableau Datasource Customization (TDC) 文件。该文件可以帮助 Tableau 更好的连接 Kyligence 数据。

Tableau 提供定制 TDC 配置文件的方式， 以满足 Kyligence Enterprise 特殊的查询规范。这样的优势在于：

- 通过减少每次使用 ODBC 连接时的探查次数，有效缩短连接等待时间。

- 提供对 Tableau 连接的查询规范定制化支持，增强系统健壮性。


步骤一：在 [Kyligence Download](http://download.kyligence.io/#/addons) 下载名为 Tableau Datasource Customization 的文件。

步骤二：将 TDC 拷贝至 Tableau 相关安装目录下即可。

- Tableau Desktop 版本, 缺省路径为:

  `Documents\My Tableau Repository\Datasources`

- Tableau Server 版本，缺省路径为： 

  Windows 环境

  `Program Files\Tableau\Tableau Server\<version>\bin`

  或者

  `ProgramData\Tableau\Tableau Server\data\tabsvc\vizqlserver\Datasources`

  Linux 环境

  `/var/opt/tableau/tableau_server/data/tabsvc/vizqlserver/Datasources/`


**方法二**：您可以通过调整`kylin.query.force-limit` 以限制返回记录数。启动该功能的方法为将该设置的值设置为正整数，如1000。
