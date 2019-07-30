## 与 Cognos 集成

### 安装 Kyligence ODBC 驱动程序

Kyligence Enterprise 支持通过 Kyligence ODBC 驱动程序与 Cognos 集成，目前支持Window 及 Linux 版本的Cognos，已测试支持版本包含 Cognos 10.x 及 11.x。


有关Kyligence ODBC安装信息，请参考页面 [Kyligence ODBC 驱动程序教程](../driver/odbc/README.md)。

### 前置条件

- Cognos Framework Manager 的版本与 Cognos Server 的版本需要一致。

- Framework Manager 和 Cognos Server 需要使用**相同版本的 32位 ODBC Driver**。

- Framework Manager 和 Cognos Server 安装的机器都需要安装 Kyligence ODBC 驱动且 DSN 的名字在 Framework Manager 和 Cognos Server 需要一致。


### 创建一个 Cognos 数据源

在安装完 Kyligence ODBC Driver 并配置好 DSN 后，打开一个已有 Cognos 项目或者创建一个新项目。在本例中我们将创建一个新项目。

1. 创建新项目![](../images/cognos/1.png)

   左下角的 `Use Dynamic query Mode`不要打勾。

2. 使用`元数据向导`创建新`数据源`。![](../images/cognos/2.png)

3.  选择 New 新建一个数据连接，如果已经存在的连接可用，请直接选择。


   ![](../images/cognos/new_connection.png)
   ​		

4. 在`新建数据源向导`第一步中输入数据源名称。![](../images/cognos/3.png)

5. 选择`ODBC`作为连接类型。在`隔离级别`中，选择`使用默认对象Gateway`。![](../images/cognos/4.png)

6. 在 ODBC 数据源中填入上一步创建的 DSN 的名称。勾选`Unicode ODBC`。在`登陆`项中勾选`无身份验证` 或者选择`登陆`此处需要输入登录Kyligence Enterprise的账号。随后点击`测试连接`。![](../images/cognos/ODBC_connection_stirng.png)

7. 如果一切配置正确的话，测试连接会顺利通过。![](../images/cognos/7.png)![](../images/cognos/8.png)

   这样数据源就创建成功了。

8. 点击`下一步`你可以继续在`元数据向导`中测试表的连接。![](../images/cognos/9.png)

### 测试连接

下面我们对已创建的数据源连接进行测试。

1. 首先选择需要导入项目中的表。
   ![](../images/cognos/10.png)

2. 下一步的所有参数可以保留默认配置。
   ![](../images/cognos/11.png)

3. 现在新数据源已经被导入到项目中了。右键一个表测试表的连接。
   ![](../images/cognos/12.png)

4. 在测试的弹窗中，点击`测试示样`来测试与表的连接。如果连接配置正确，测试结果会返回在弹窗中。
   ![](../images/cognos/13.png)

5. Cognos 对 Kyligence Enterprise 的字段属性不识别，因此需要修改对应字段的属性，调整字段的 Usage 类型。每个字段在 Cognos 里面有 4 个类型，Fact，Identifier， Attribute 和 Unknown。日期和做 ID 的字段可以选为 Identifier， 数字类型可累加的 选 fact，字符型选 Attribute。
   ![](../images/cognos/usage.png)

6. 右键表名，为表设置 Relationship。
   ![](../images/cognos/define_relationship.png)

7. 为表设置 relationship。在选择 Cardinality 和 Operator 的时候，会显示相应解释
   ![](../images/cognos/relationship.png)

8. 或者您也可以双击数据源名称，在 Diagram 页面，通过 ctrl+ 点选两个字段后，右键选择 Create -> Relationship 可建立表之间的关联。
   ![](../images/cognos/model.png)

### 自定义 SQL

如果遇到需要对现有表结构，列进行调整，如转换某列对格式，您也可以选择使用自定义 SQL。

1. 选择右键数据源选择新建 Query Subject。

   ![](../images/cognos/create_query_subject.png)

2. 第二步选择创建 `Data Source` 类型。

   ![](../images/cognos/query_subject_name_type.png)

3. 选择数据源，请注意不要勾选 “Run databases query subject wizard”。

   ![](../images/cognos/query_subject_data_source.png)

4. 输入 SQL 语句，点击 Validate，确认没有报错后，点击 OK。

   ![](../images/cognos/query_subject_sql.png)

   ```sql
   select
   	KYLIN_CAL_DT.CAL_DT, 
   	KYLIN_SALES.PART_DT, 
   	KYLIN_SALES.BUYER_ID, 
   	KYLIN_SALES.ITEM_COUNT
   From
   [sandbox-dong].KYLIN_SALES as KYLIN_SALES
   join
   [sandbox-dong].KYLIN_CAL_DT as KYLIN_CAL_DT
   on KYLIN_SALES.PART_DT = KYLIN_CAL_DT.CAL_DT
   ```

### 创建命名空间

建立好模型后可右键数据源，选择 Create -> Namespace。然后可以将导航栏中的表拖拽到同一个命名空间中。

![](../images/cognos/namespace.png)

### 发布数据包

在项目查看器中，右键`数据包`->`新建`->`数据包`将需要使用的表进行发布。

![](../images/cognos/14.png)

首先创建数据包，在创建流程中第一步先为数据包命名。

![](../images/cognos/15.png)

第二步选择数据包中需要包含的表。

![](../images/cognos/package_define_object.png)

第三步选择包中支持的`函数集`，这里可以保留默认的设置。

![](../images/cognos/17.png)

这样数据包就创建成功了，接下来进入`发布数据包向导`。

下面的步骤可以保留默认配置。

![](../images/cognos/18.png)

![](../images/cognos/19.png)

![](../images/cognos/20.png)

![](../images/cognos/21.png)

![](../images/cognos/22.png)

这样数据包就发布成功了。

发布成功后，在IBM Cognos Connection 网页端中可查看到已发布的数据包。

![](../images/cognos/check_published_package.png)

###创建一个简单的图表

下面我们可以使用发布好的数据包来制作一个简单的图表。

在 IBM Cognos Conenction 网页端启动`Report Studio`。

![](../images/cognos/23.png)

选择之前创建好的数据包。

![](../images/cognos/32.png)

在`Report Studio`中选择`新建`。

![](../images/cognos/24.png)

使用新创建的数据包，选择`图表`。

![](../images/cognos/25.png)

选择一个图表类型。

![](../images/cognos/26.png)

将维度和度量拉拽到报表上。

![](../images/cognos/27.png)

点击菜单中的`运行`键运行报表。

这样你就成功的使用 Kyligence Enterprise 作为数据源创建了一个图表。

![](../images/cognos/28.png)

### Cognos 与 Kyligence Enterprise 权限集成

为了支持输入不同的用户名和密码，需要进行 Cognos 与 Kyligence Enterprise 权限集成。本小节在默认已经配置 Cognos 认证程序的基础上进行 Kyligence Enterprise 与 Cognos 的 ODBC 用户集成，以自定义的 Java 为样例来进行介绍。有关详细信息，请参考 Cognos SDK 对应的 AuthenticationProvider 文档。下图是以 Java 程序为例子的典型 Cognos 外部认证空间：

![](../images/cognos/cognos_acl_1.png)

在 Cognos 权限认证对应的数据库中，添加 Kyligence Enterprise 的用户名和密码：

![](../images/cognos/cognos_acl_2.png)

创建一个 Cognos 数据源，第一步至第四步与上面相同，在第五步中，选择`外部名称空间`：

![](../images/cognos/cognos_acl_3.png)



点击测试连接后，可以看到测试成功的提示，这说明 Cognos 通过 Kyligence Enterprise 的 ODBC 已成功连接 Kyligence Enterprise 的 server。

![](../images/cognos/cognos_acl_4.png)

### 已知局限

1. Kyligence Enterprise 在建模时不支持 fact table right join lookup 的形式。

   解决方案:  可以建立视图为

   ```sql
   create view vw_1 as 
   sleect * 
   from fact table 
   right join lookup table
   ```

   然后以该视图作为建模的事实表，则可以实现 right join，缺点是需要单独对视图建模。

2. Kyligence Enterprise 暂不支持多事实表建模。

   解决方案： 在 Cognos 的 Framework Manager 中建立查询时 sql 写成子查询 join 的形式，每个子查询针对一个事实表，类似下面这样(在 learn_kylin 的 project 下可以测试):

   ```sql
   select a.part_dt,sum_price,sum_item 
   from
   
   (select part_dt,sum(price) as sum_price 
    from KYLIN_SALES 
    group by PART_DT havingsum(price)>1000) a
   
   join (
     select part_dt,sum(ITEM_COUNT) as sum_item 
     from KYLIN_SALES 
     where LSTG_FORMAT_NAME='Others' 
     group by part_dt) b
   
   on a.part_dt=b.part_dt	
   ```

