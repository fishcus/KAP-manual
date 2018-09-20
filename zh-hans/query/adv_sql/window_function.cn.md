## 如何在 Kyligence Enterprise 中使用窗口函数

从 KAP 2.1 版本后，用户就可以在 Kyligence Enterprise 中使用窗口函数来完成更多复杂的查询，来简化查询过程并且获得更好的统计结果。本节将介绍如何使用这些窗口函数。



### 窗口函数简介

目前被 Kyligence Enterprise 支持的窗口函数介绍如下：

| 执行语法                                 | 返回描述                                     |
| ------------------------------------ | :--------------------------------------- |
| ROW_NUMBER() OVER ()                 | 返回当前行在其分区中的序列数，从 1 算起。                     |
| RANK() OVER (order by)               | 返回当前行的位置(可能存在间隙)；并列时，RANK 返回值等同于 ROW_NUMBER 返回的第一个值（例：rank：1，2，2，4；row_number：1，2，3，4；）。 |
| DENSE_RANK() OVER (order by )        | 返回当前行的位置(无间隙)；此函数将计算并列组为同一值。             |
| FIRST_VALUE(value) OVER ()           | 返回窗口框架中计算行中第一行的值。                        |
| LAST_VALUE(value) OVER ()            | 返回窗口框架中计算行中最后一行的值。                       |
| LEAD(value, offset, default) OVER () | 返回分区内当前行的偏移行中向前的偏移值；如果无法返回对应行，则返回默认值替代。偏移值和默认值都是相对于当前行进行的评估后返回。如果省略不设置，则偏移量默认为 1，默认值为空（NULL）。 |
| LAG(value, offset, default) OVER ()  | 返回分区内当前行的偏移行中向后的偏移值；如果无法返回对应行，则返回默认值替代。偏移值和默认值都是相对于当前行进行的评估后返回。如果省略不设置，则偏移量默认为 1，默认值为空（NULL）。 |
| NTILE(value) OVER ()                 | 返回从1到该值的整数，尽可能的等分所选分区。                   |



### 实例介绍

本节中，我们将使用 Kyligence Enterprise 中的公开数据集作为数据源来实践上文所述的查询语句。我们将分步介绍如何在 Kyligence Enterprise 中使用窗口函数。

#### 数据源

在这里我们使用了一个名为 `learn_kylin` 的数据源。点击该数据源，数据源中的表和表结构将陈列开：此数据源中有一张事实表（`KYLIN_SALES`）和两张维度表（`KYLIN_CAL_DT` 和 `KYLIN_CATEGORY_GROUPINGS`）。请认真了解 `KYLIN_SALES` 的表结构以便后文理解。

![](images/wd_datasample.png)



#### 排名函数（row_number，rank，dense_rank，ntile）

在本表中，我们虽然已经具有 ROW 这列来标记行序列数，但对于数据分析师来说，在一般的表中获得不同分区下的行序列非常重要，可以方便了解当前行在分区中的位置。例如： `select price, LSTG_FORMAT_NAME, row_number() over(partition by LSTG_FORMAT_NAME) as format_id from kylin_sales` ，则结果返回了不同的 LSTG_FORMAT_NAME 下，产品价格高低的相对关系。

结果（局部）返回如下：

![](images/wd_row_number.png)



#### 偏移函数（first_value，last_value，lead，lag）

类似于排名函数，偏移函数可以提供对当前行的一定偏移量的偏移值。比如，要获得离当前日期最近的下一个日期，则可以输入：`select price, part_dt, lead(part_dt,1) over(partition by LSTG_FORMAT_NAME) as latest_dt from kylin_sales`，返回的结果为日期行中偏移一行后的偏移值。

结果（局部）返回如下：

![](images/wd_lead_date.png)



注：此函数不适用于可计算列。有关可计算列，参见**数据建模**一章中的[可计算列](model/computed_column.cn.md)一节。
