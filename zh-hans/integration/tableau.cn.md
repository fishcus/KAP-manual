
## 与 Tableau  集成

Tableau 是Windows平台上最流行的商业智能工具之一，它操作简介，功能强大，通过简单地拖拽就可以将大量数据体现在可视化图表中。Kyligence Enterprise 提供与Tableau Desktop不同的集成方式。

本小节将介绍Kyligence Enterprise 与 Tableau Desktop的2种集成方式。

- Kyligence Enterprise 快捷导入导出同步模型方式
- Kyligence Enterprise 手动映射模型方式

### 前置条件

- 安装 Kyligence ODBC 驱动程序

  > 注：有关安装信息，参考页面 [Kyligence ODBC 驱动程序教程](../driver/kyligence_odbc.cn.md)。

- 如果希望进行明细查询，需要在Cube中配置**表索引**或开启**查询下压**。

  

### 方式一：Kyligence Enterprise 快捷导入导出同步模型方式

用户在完成 Kyligence Enterprise 建模与创建Cube阶段后，可以通过导出Tableau对应的数据定义文件，

并在Tableau中一键导入该文件，快速完成模型同步。

> 注：Kyligence Enterprise 3.0.1 以上版本支持该方式

该方式主要步骤如下：

1. Kyligence Enterprise 导出Tableau Data Source(TDS)文件：
   - 进入**建模**功能下的**Cube**模型清单
   - 选择Ready状态的的**Cube**
   - 在 **更多操作** 中选择 **导出TDS** 
2. 将导出的TDS文件导入至Tableau
   - 在已部署的Tableau环境中，双击导出的**TDS**文件
   - 在弹出的认证窗口中，输入连接认证信息
   - 点击**OK**
3. 在Tableau中，检查导入的模型内容, 如维度，度量之类。



### 方式二：Kyligence Enterprise手动映射模型方式 

用户可通过ODBC Driver连接Kyligence Enterprise数据源, 并在Tableau中重新建立模型完成映射。

该方式主要步骤如下：

1. 启动Tableau，在 **数据**->**新建数据源** 下，选择 **其他数据库(ODBC)**
2. 在弹出窗口，选择 **KyligenceODBCDriver** ，点击 **连接**
3. 在**连接属性**中，配置以下信息以创建Kyligence Enterprise数据源连接
   - 服务器地址
   - 端口
   - 项目
   - 用户名
   - 密码
4. （或者）在弹出窗口，选择已配置的 **DSN** 进行连接
5. 在Tableau中，重建Kyligence Enterprise模型的关联关系，完成模型映射。Tableau建模方式请参考Tableau官方说明。

### 其他注意事项

当您连接Tableau时，Tableau会发送全表查询语句进行查询。如果表数据量较大，会造成查询返回时间较长。如等待时间过长，建议您参考**配置**章节对项目参数进行优化减少等待时间。

> 注释：比如可以通过调整`kylin.query.force-limit` 以限制返回记录数。启动该功能的方法为将该设置的值设置为正整数，如1000，该值会被用在LIMIT分句。