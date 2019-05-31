## 相关函数 CORR (Beta)

相关性系数通常在统计中用于测量两个变量间的相关性强弱。在本产品 V2.5.5版本以上，支持使用相关系数函数，函数名为 **corr**。



### CORR 简介 ###

CORR 函数返回数值为衡量两个变量之间的线性关系。结果范围为 -1 至 +1（包括 -1 和 +1），其中 1 表示精确的正向线性关系，比如一个变量中的正向更改即表示另一个变量中对应量级的正向更改，0 表示变量之间没有线性关系，而 −1 表示精确的反向关系。

使用的规则如下：

> corr({measure1}，{measure2})，measure 为要计算的度量。其中需要注意的是，在当前版本中，所支持度量的数据类型为：bigint，integer，int4，long8，tinyint，smallint，decimal，double，float，real 和 numeric。日期类型暂不支持计算。
>
> 请注意：如果其中一个度量的数据类型为 decimal 时，则另外一个度量的的数据类型也需要为 decimal。其他数据类型组合则不受影响。

查询示例如下：

```sql
SELECT corr(TOTAL_AMOUNT, PRICE)
FROM KYLIN_SALES
```



### 使用方法 ###

首先，在新建 Cube 界面，点击左下角**添加度量**来添加新的度量。

![添加度量页面](../images/corr/cube_cn.png)

第二步，输入度量名称，选择 **CORR** 为表达式，选择度量。这里需要注意度量的**数据类型**应符合上文的使用规则。

![选择CORR表达式](../images/corr/expression_cn.png)

第三步，设计并构建完 Cube 后，转至**分析**页面进行如下查询。

![SQL 查询](../images/corr/query_cn.png)
