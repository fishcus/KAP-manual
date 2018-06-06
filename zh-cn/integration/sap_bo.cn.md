## 与SAP BO集成

SAP BusinessObjects（SAP BO）是SAP公司旗下的商务智能产品，自KAP3.0版本开始，支持与SAP BO 进行集成。
本文将分步介绍SAP BO Web Intelligence 4.1与KAP连接的方法。

### 配置ODBC及DSN

有关Kyligence ODBC的配置，请参考[Windows下安装与配置Kyligence ODBC驱动](http://docs.kyligence.io/v3.0/zh-cn/driver/kyligence_odbc_win.cn.html)。

### 使用Universe设计工具进行建模

1. **管理数据连接**

   1.1 点击**conections**，管理数据连接。

   ![connections](images/SAP_BO/connections.png)

   点击**新增**连接，增加连接。

   ![新增连接](images/SAP_BO/add_connection.png)

   ![选择下一步](images/SAP_BO/add_connection_next.png)

   1.2 选择Generic ODBC 数据源。

   ![选择数据源](images/SAP_BO/generic_odbc.png)

   1.3 输入用户名、密码和DSN名称即可。

   ![输入用户名等](images/SAP_BO/define_connection.png)

   1.4 选择连接池类型为始终保持连接，然后保存该连接即可。

   ![选择连接池](images/SAP_BO/keep_connection.png)

2. **创建数据模型**

   2.1 打开**Universe** 设计工具，使用刚才新建的数据连接创建模型。

   ![打开设计工具](images/SAP_BO/open_universe.png)

   2.2 将需要使用的表增加到右侧。

   ![增加表](images/SAP_BO/add_universe_table.png)

   2.3 将度量按照聚合形式增加到右侧，点击完成保存即可。

   ![增加度量](images/SAP_BO/add_universe_sum.png)

   2.4 导入表后会进入建模，首先会根据列名自动匹配连接关系，如果没有被连接的表可以点击**增加连接**进行连接。

   ![建立连接](images/SAP_BO/universe_model.png)

   2.5 点击连接线即可修改连接关系，如left join需要改为1:N（维度表：事实表）的关系。编辑全部关系后点击保存即可。

   ![修改连接](images/SAP_BO/universe_connection.png)

   > 注：此处如果需要outer join，需要在参数里设置**ANSI92=Yes**。
   >
   > ![修改参数](images/SAP_BO/universe_model_ansi92.jpg)

### 在Rich client中创建报表

   选择Universe为数据源，使用新建的Universe即可。把需要分析的字段拖动到右侧，点击运行查询

   ![运行查询](images/SAP_BO/3.1_query.png)

   即可得到查询结果

   ![运行查询](images/SAP_BO/3.2_queryend.png)

### 替换数据源的方法
   
   ***方法一 在报表内修改***

   首先创建kyligence的universe，然后在报表设计页面点击数据访问-更改源
   
   ![运行查询](images/SAP_BO/4.1.png)

   选择其他universe
   
   ![运行查询](images/SAP_BO/4.2.png)

   字段映射完毕后点击完成即可

   ![运行查询](images/SAP_BO/4.2.png)

   字段映射完毕后点击完成即可

   ![运行查询](images/SAP_BO/4.3.png)

   在查询界面点击运行查询即可还原报表

   ![运行查询](images/SAP_BO/4.4.png)

   ***方法二 在universe上修改***
   
   在universe里编辑Conenction
 
   ![运行查询](images/SAP_BO/4.5.png)

   修改DSN为需要的DSN，然后保存即可。

### 一些注意事项

BO发出的查询都会带上schema,包括default database，而default在KAP查询中是一个关键字不能使用default.table的形式的查询语句。
-->解决方式：在**kylin.properties**中把**kylin.query.escape-default-keyword**设为true，KAP会自动为default转为"DEFAULT"。


    


    











