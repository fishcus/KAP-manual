## 与 Tableau 10.x 集成

### 安装 Kyligence ODBC 驱动程序

有关安装信息，参考页面 [Kyligence ODBC 驱动程序教程](../driver/kyligence_odbc.cn.md)。

### 连接 KAP Server
在Tableau 10.X创建新的数据连接，单击左侧面板中的`其他数据库(ODBC)`，并在弹出窗口中选择`Kyligence ODBC Driver` 


![](images/tableau_10/step1_cn.png)

![](images/tableau_10/step2-2_cn.png)

输入你的服务器地址、端口、项目、用户名和密码，点击`Connect`可获取有权限访问的所有项目列表。


![](images/tableau_10/kyligence_odbc_03_cn.png)

### 映射数据模型

在左侧的列表中，选择数据库`defaultCatalog`并单击”搜索“按钮，将列出所有可查询的表。用鼠标把表拖拽到右侧区域，就可以添加表作为数据源，并创建好表与表的连接关系（映射信息如图）。

**注意：Tableau 会发送查询"select \* from fact\_table"，如果被查询表格数据量太大，Tableau可能需要等待很长时间拿到返回结果。请参见[配置](../config/basic_settings.cn.md#kylinqueryforce-limit)对KAP进行配置绕过该问题。**

![](images/tableau_10/step5_cn.png)


![](images/tableau_10/step11_cn.png)



![](images/tableau_10/step12_cn.png)

### 保持数据实时性

Tableau 10.1中有两种数据源连接类型，选择 `连接`选项以确保使用`实时`模式。

![](images/tableau_10/step9_cn.png)

### 自定义SQL
如果需要使用自定义SQL，可以单击左侧`自定义SQL`并在弹窗中输入SQL语句，就可添加为数据源。
![](images/tableau_10/step10_cn.png)

### 可视化
现在你可以进一步使用Tableau进行可视化分析。
![](images/tableau_10/step13_cn.png)

### 发布到Tableau服务器
如果希望发布到Tableau服务器, 点击`服务器`菜单并选择`发布工作簿`。
![](images/tableau_10/step14_cn.png)

### 查看KAP明细数据
> 注：查看KAP明细数据需要在KAP Cube中配置了Table Index或KAP开启了查询下压。

如图，当在Tableau中查看聚合数据时，点击需要查看明细的行或列。点击如图所示图标，选择查看数据的图标。
![](images/tableau_10/step15.PNG)点击查看完整数据，即可看到对应的数据明细

![](images/tableau_10/step16_cn.png)

### 从KAP同步模型至Tableau
#### 在KAP中导出TDS文件

选择一个Ready状态的Cube, 在更多操作中选择导出TDS，即可下载TDS文件。

![](images/tableau_10/step17_cn.png)

#### 用TDS文件连接Kyligence数据源
在安装了tableau的环境上，双击TDS文件，填写认证信息，即可连接Kyligence数据源

![](images/tableau_10/step18_cn.png)

![](images/tableau_10/step19_cn.png)