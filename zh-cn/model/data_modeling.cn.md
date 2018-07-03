## 设计模型
### 概述

本小节基于本产品自带的数据集， 介绍模型设计和相关步骤

### 什么是模型设计

在数据源可连通的基础之上，建模用户或分析用户根据需求进行数据模型的设计。

模型设计主要包含以下内容：

- 定义事实表与维度表类型

- 定义字段为维度，度量类型

- 定义表与表的关联关系

  

### 如何进入数据模型设计

**步骤一：** 登录本产品Web UI，切换进入具体项目

**步骤二：** 点击左侧导航栏的**建模**，再点击右侧**概览**->**模型**标签页， 主页面将以卡片形式显示已有的数据模型列表

![创建模型](images/model_design_update_cn_1.png)

### 新建或编辑模型

- **新建模型**

1. ​	点击**+ 模型**按钮
2. 在弹出窗口中，输入**模型名称** （必填）和 描述
3. 点击 **递交** 按钮，进入模型编辑界面。

> 提示：新建模型能够完成保存必须要满足以下条件：
>
> - 模型至少包含一个事实表
> - 模型表至少需要选择一个维度列

- **编辑模型**

  在已有的模型列表中， 选择具体模型，点击右下角铅笔形状的**编辑**图标，进入模型编辑页面

  

### 样例数据集建模

在模型编辑页面下，用户可以通过可视化的方式定义事实表 (Fact Table) 或维度表 (Lookup Table)

具体操作步骤如下：

**步骤一**：定义事实表：

1. 从左侧数据源表清单中，将事实表拖至建模画布中央， 本样例数据集中的事实表为`KYLIN_SALES`
2. 单击表右上角的**设置**图标，选择表的类型设为**事实表**

**步骤二**：定义维度表：

- 从左侧数据源表清单中，将多个维度表拖至建模画布中央

  本样例中, 我们的模型可定义多个维度表如下：

  `KYLIN_CAL_DT`

  `KYLIN_CATEGORY_GROUPINGS`

  `KYLIN_ACCOUNT`

  `KYLIN_COUNTRY`

  

  由于`KYLIN_ACCOUNT`和`KYLIN_COUNTRY`表数据即包含卖家账户也包含卖家用户，我们可以分别将其拖出来两次，修改表别名为`SELLER_ACCOUNT`，`BUYER_ACCOUNT`，`SELLER_COUNTRY`和`BUYER_COUNTRY`

  

- 单击这些表右上角的**设置**图标，选择表的类型设为**维度表**

  

![选择事实表和维度表](images/model_design_update_cn_2.png)



**步骤三：** 对表字段定义维度和度量类型：

> 从本产品2.5.4版本开始，支持表字段类型批量定义，并新增系统自动推荐定义设置。

- 单击表上方左侧第一个图标 **DM** ，开启可编辑模式。再次点击图标会关闭编辑模式
- 在可编辑模式下， 表字段列表上方会显示工具栏
  - 图标 `D` 表示维度
  - 图标`M` 表示度量
  - 图标`—` 表示禁用
  - 图标`A` 表示使用系统推荐类型（自动定义维度和度量）。
- 选择需要参与建模的表字段，再点击工具栏类型图标设定该字段类型。

在本例中，我们勾选工具栏左侧，全选表字段， 并点击图标`A` 使用系统推荐定义功能，完成快速字段类型定义。



![设置维度和度量](images/model_design_update_cn_3.png)



**步骤四**：建立表与表连接关系：

表与表关系的建立可以通过拖拽表上的列完成。

本例中，我们选中事实表 `KYLIN_SALES`的时间外键字段`PART_DT`拖向时间维表`KYLIN_CAL_DT`的主键字段`CAL_DT`.

在弹出窗口我们可以修改连接方式或增加其他字段关联关系。

点击**确认** 按钮保存新建连接

![添加表连接](images/model_design_update_cn_4.png)

参照以上方法，设置好所有连接条件（如下所示）：

1. KYLIN_SALES *Inner Join* KYLIN\_CAL\_DT 

   连接条件：

   DEFAULT.KYLIN\_SALES.PART_DT = DEFAULT.KYLIN\_CAL\_DT.CAL\_DT

2. KYLIN_SALES *Inner Join* KYLIN\_CATEGORY_GROUPINGS 

   连接条件：

   KYLIN_SALES.LEAF_CATEG_ID=KYLIN\_CATEGORY\_GROUPINGS.LEAF_CATEG_ID

   KYLIN_SALES.LSTG_SITE_ID=KYLIN\_CATEGORY\_GROUPINGS.SITE_ID 

3. KYLIN_SALES *Inner Join* BUYER_ACCOUNT (alias of KYLIN_ACCOUNT)

   连接条件：

   KYLIN_SALES.BUYER_ID=BUYER_ACCOUNT.ACCOUNT_ID 

4. KYLIN_SALES *Inner Join* SELLER_ACCOUNT (alias of KYLIN_ACCOUNT) 

   连接条件：

   KYLIN_SALES.SELLER_ID=SELLER_ACCOUNT.ACCOUNT_ID 

5. BUYER_ACCOUNT (alias of KYLIN_ACCOUNT) *Inner Join* BUYER_COUNTRY(alias of KYLIN\_COUNTRY) 

   连接条件：

   BUYER_ACCOUNT.ACCOUNT_COUNTRY=BUYER_COUNTRY.COUNTRY 

6. SELLER_ACCOUNT (alias of KYLIN_ACCOUNT) *Inner Join* SELLER_COUNTRY(alias of KYLIN\_COUNTRY)

   连接条件：

   SELLER_ACCOUNT.ACCOUNT_COUNTRY=SELLER_COUNTRY.COUNTRY

下图是设置好之后的界面（单击连接中的标志（join），可以展开连接具体内容）：
![建立表连接](images/model_design_update_cn_5.png)



> 提示：本产品还支持添加可计算列，充分利用了产品预计算能力，进一步提升查询性能，更多设置详情请参考[可计算列章节](../model/computed_column/README.cn.md)

**步骤五**：完成模型定义后， 单击右下角**保存”按钮

**步骤六：**设置分区列：

在保存时， 系统弹出窗口（如下图所示），用户可以设置分区字段列。分区列是可选项，如果不设置，则留空。

本产品自带时间分区列定义，字段类型支持data, timestamp, string, varchar, int, integer, bigint



> 说明：本样例中，假设KYLIN_SALES表事实表的销售数据与日俱增的，我们表的PART_DT字段为时间分区列， 选择yyyy-MM-dd为其时间格式。我们选择增量构建方式构建Cube



![保存模型](images/model_design_update_cn_7.png)

**步骤七**: 单击**提交**按钮，到此数据模型就创建成功了。



### 其他高级设置

#### 定义维度表存储形式

如果要设置数据存储形式，可在页面下方的设置窗口，依次单击**概览**->**模型**，这样会显示所选的事实表和维度表。默认当维度表小于 300M 时，表以 snapshot 形式存储，以提高查询效率；当维度表大于 300M 时，本产品通常不支持以 snapshot 形式存储。此时，如果要以 snapshot 形式存储较大维度表，可在 kylin.properties 中更改 snapshot存储的限制（具体调整请联系tech support: kybot.io）。

![维度表存储形式](images/model_design_update_cn_6.png)



#### 选择维度及度量

在建立连接后，可在页面下方的设置窗口，继续根据需要选择作为维度 (D: Dimension) 和度量 (M: Measure) 的字段。单击**概览**，将显示维度和度量选项卡。单击维度或度量对应的 X 号，可删除此维度或度量。通常，时间会用来作为过滤条件，所以一般会选择时间字段。此外，还会选择商品分类、卖家ID等字段为维度。
![选择维度](images/model_design_update_cn_8.png)



一般地，PRICE字段用来衡量销售额，ITEM_COUNT字段用来衡量商品销量，SELLER_ID用来衡量卖家的销售能力。选择度量字段后的结果如下图所示：
![选择度量](images/model_design_update_cn_9.png)