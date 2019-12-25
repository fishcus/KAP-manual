## 与 OBIEE 12c 集成

Oracle Business Intelligence Enterprise Edition (OBIEE) 是 Oracle 旗下的 BI 产品，可提供完整的 BI 功能，包括交互式信息板、完全即席的主动式智能和警报、企业和财务报表、实时预测智能以及离线分析等。本文将分步介绍使用 OBIEE 连接 Kyligence Enterprise 的方法。

### 前提条件
- Kyligence Enterprise 版本高于 3.0
- Kyligence ODBC 驱动版本高于 2.2

### 配置 ODBC 及 DSN

1. 配置 OBIEE Client

   需要先安装 BI Administrator Tool ，安装后在 ODBC 管理器中增加对 BIEE Server 的连接 DSN。

   ![配置ODBC](../../images/OBIEE12/00.png)

   连接后在 BI Administrator Tool 中点击菜单**打开** -> **联机**，即可管理 BIEE Server 中的数据模型。

   ![连接OBIEE](../../images/OBIEE12/001.png)

2. 设置 DSN

   在 Client 端和 Server 端都需要安装 Kylignece ODBC 并配置 DSN，且两端的 DSN 名称应**保持一致**。

   有关 Windows 下 Kyligence ODBC 的配置，请参考 [Windows下安装与配置Kyligence ODBC驱动](../../driver/odbc/win_odbc.cn.md)。

   有关 Linux 下 Kyligence ODBC 的配置，请参考 [Linux 下安装与配置 Kyligence ODBC 驱动](https://docs.oracle.com/middleware/12212/biee/BIEMG/GUID-CCDD9782-BC2A-497A-8ED0-AECA2ECFB3AE.htm#config_native_dbs)中的 Configuring Database Connections Using Native ODBC Drivers 部分。

   在`odbc.ini`文件中增加的 Kyligence 数据源格式为：

   ```
   [KyligenceDataSource]
   Driver = KyligenceODBC64
   PORT = 7070
   PROJECT = learn_kylin
   SERVER = http://kapdemo.chinaeast.cloudapp.chinacloudapi.cn   
   UID = ADMIN  
   PWD = KYLIN
   ```

### 创建数据模型

1. 在 BI Administrator Tool 中点击**导入元数据**来增加数据源。

    ![导入元数据](../../images/OBIEE12/01.png)

2. 选择 ODBC 3.5，将 Kyligence Enterprise 中的表导入。

    ![导入向导](../../images/OBIEE12/ODBC35.png)

3. 导入成功后，在物理模型里面找到之前创建的数据源，右键选择**属性**->**通用**->**数据源定义**，将**数据库类型**修改为 **Apache Spark SQL**。

   ![选择数据源](../../images/OBIEE12/database_type.png)

4. 下一步您可定义数据模型，复选需要建模的表右键，选择**物理图表**进行建模。

   ![物理表建模](../../images/OBIEE12/03.jpeg)

5. 点击**新建联接**定义表关联关系，然后保存物理模型。

   ![建立连接](../../images/OBIEE12/04.jpeg)

6. 保存模型后，您需要手动检索并更改数据类型为字符串的物理列，展开表后，右键点击各列，点击属性，即可进入编辑页面

   ![编辑物理列](../../images/OBIEE/edit_column.cn.png)
   
7. 您在手动检索并更改数据类型为字符串的物理列，如果长度显示为 0，则需要更改为 Kyligence Enterprise 中字段的实际长度。

	![](../../images/OBIEE12/05.jpeg)

7. 保存物理模型后，您需要在业务模型和映射区域，右键点击空白区域，出现菜单，以新建业务模型。

   ![新建业务模型](../../images/OBIEE/create_business.cn.png)

9. 保存物理模型后新建业务模型，然后将刚才增加的物理模型拖动到业务模型。

   ![更新业务模型](../../images/OBIEE/refresh_business.cn.png)

10. 如需 left outer join 可以选择编辑业务模型, 在此处设置为**左外部连接**， 并保存到业务模型。

   ![](../../images/OBIEE12/06.png)

   ![](../../images/OBIEE12/07.png)

11. 然后将刚才增加的逻辑模型拖动到表示层，并保存到表示层。

    ![更新表示层](../../images/OBIEE/refresh_show.cn.png)

12. 点击 BI Administrator Tool 中左上角的**文件**->**保存**，保存整个模型。

    ![](../../images/OBIEE12/08.jpeg)

13.  登陆 BIEE 服务器，使用以下代码，重启 BIEE Server。

    ```sh
    $ service obiee stop
    - 停止服务器
    
    $ service obiee start
    - 启动服务器
    ```


### 创建分析

有两种方式可以使用刚才创建的模型中的数据进行分析。

- **方法一**

  1. 在BIEE主页点击**新建-分析**，使用在 client 端创建的主题区域即可使用 Kyligence Enterprise 进行分析。这种方式使用拖拽查询方式方式。

     ![](../../images/OBIEE12/09.png)

  2. 拖动所需字段到所选列即可，度量需要点击字段右下角的**编辑公式**编辑聚合方式。

     ![](../../images/OBIEE12/10.png)

     其他需要再加工的字段都可以在**编辑公式**里进行再定义。

      ![](../../images/OBIEE12/11.png)

  3. 点击**结果**即可看到查询结果，然后编辑所需图表类型及相关样式即可。

      ![](../../images/OBIEE12/12.png)


- **方法二**

  1. 在 BIEE 主页点击**新建-分析-创建直接数据库查询**，使用自定义 SQL 进行查询。

  2. 选择在 client 端创建的数据源的连接池名进行连接，输入查询 SQL 进行分析。

     连接池名称格式：`"dsn_name"."connect_pool_name"`

     ![](../../images/OBIEE12/13.png)

  3. 点击**结果**即可得到查询结果，点击结果左下角的**新建视图**可以更改图表类型。

     ![](../../images/OBIEE12/14.png)

     ![](../../images/OBIEE12/15.png)

### 注意事项

1. 根据 BIEE 的开发规范，在 client 端创建的模型最少需要有两张表，否则上载模型会导致 BIEE 无法启动服务。
2. 由于 BIEE 产生的查询 SQL 不带 Schema ，拖拽查询则需要一个项目里只包含同一个 Schema 的表。在连接池查询时使用**自定义 SQL 查询**可以避免此问题 。
