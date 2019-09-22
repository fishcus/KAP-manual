## 许可证容量

为保证 Kyligence Enterprise 系统健康，请留意许可证容量，并始终保持系统在许可证容量的范围内运行。可以将鼠标悬停在顶部状态栏“**许可证容量**”处，了解当前系统的使用情况。

![License Capacity](images/license_capacity_cn.png)

许可证包含以下容量控制：

- **已使用数据量**：系统中已加载的数据量。
- **活跃进程数**：系统中同时运行的服务进程数。

容量控制有以下几种状态：

- **正常**：系统在容量范围内运行，一切正常。
- **用量超额**：加载数据量或者活跃进程数超过配额。此时，系统将**不能继续加载新数据**，无法启动任何增量构建任务，而查询则不受影响。这时常用的处理方法有：
  - 若是数据量超额，可以通过删除 Cube Segment 的方法清理掉一些历史数据，从而降低加载数据量，让系统回复正常。
  - 若是进程数超额，可以停止一些 Kyligence Enterprise 服务进程，让系统回复正常。
  - 也可以联系 Kyligence 技术支持，扩容许可证容量。
- **不确定** / **出错**：个别情况下，系统有可能在计算数据容量时因无法访问源数据系统而处于“不确定”或者“出错”状态。这种情况一般可以通过重新计算恢复。若长时间无法恢复，请及时联系 Kyligence 技术支持，避免系统出现更多异常而无法使用。



### 数据容量的计算和规划

已使用数据量指已经载入 Kyligence Enterprise 的数据量。遵循以下规则计算：

- 只计算通过模型和 Cube 载入系统的表的行与列。
- 以解压后的文本形态计算数据量，避免不同压缩算法引入的不确定性。
- 在一个项目中，一张表即使参与多个模型和 Cube 也只计算一次。在不同的项目中，一张表将根据使用情况被多次计算。

为了作容量规划，常常需要估算将来系统的数据用量。下面以 [learn_kylin 样例数据](../installation/install_uninstall/install_validation.cn.md)为例，介绍一种简便的估算方法，只需将数据导出为文本形态，观察其大小即可。

- 事实表的容量估算

  先大致确定事实表中将会载入系统的列，应包含所有的维度和度量。例如完整的事实表可能有 100 列，但将会载入系统用作分析的也许只有 30 列，则下面只需计算这 30 列。导出一段时间的数据到文本文件，获得其解压缩后的文本形态的数据大小。

  以 KYLIN_SALES 表为例，可以运行如下 Hive 命令估算其载入系统后的容量。

  ```sh
  hive -f export_fact.sql > export_fact.out
  ```

  其中 `export_fact.sql` 文件的内容为：

  ```sql
  SELECT 
    TRANS_ID
    ,PART_DT
    ,LEAF_CATEG_ID
    ,LSTG_SITE_ID
    ,LSTG_FORMAT_NAME
    ,SELLER_ID
    ,BUYER_ID
    ,OPS_USER_ID
    ,OPS_REGION
    ,PRICE
    ,ITEM_COUNT
  FROM
    DEFAULT.KYLIN_SALES
  WHERE
    PART_DT>='2012-01-01' and PART_DT<'2014-01-01'
  ;
  ```

  导出的 `export_fact.out` 的字节大小即为其载入系统后的容量的一个估算。

  ```sh
  wc --bytes export_fact.out
  ```

  对于较大的事实表，建议只导出一小段时间的数据，再作乘法估算整体数据量。

  

- 维度表的容量估算

  相对庞大的事实表而言，维度表通常很小且内容稳定，在估算时可以考虑忽略不计。

  如果确要计算维度表，可以将整表导出为文本形态，观察其大小。

  以 learn_kylin 项目为例，可以运行如下 Hive 命令估算维度表载入系统后的容量。

  ```sh
  hive -f export_lookup.sql > export_lookup.out
  ```

  其中 `export_lookup.sql` 文件的内容为：

  ```sql
  SELECT * FROM DEFAULT.KYLIN_CAL_DT;
  SELECT * FROM DEFAULT.KYLIN_CATEGORY_GROUPINGS;
  SELECT * FROM DEFAULT.KYLIN_ACCOUNT;
  SELECT * FROM DEFAULT.KYLIN_COUNTRY;
  ```
  
  导出的 `export_lookup.out` 的字节大小即为上述维度表载入系统后的容量的一个估算。

  ```sh
  wc --bytes export_lookup.out
  ```

  

最后，加总所有事实表和维度表的估算即得完整的容量估算结果。通常，如果估算得比较保守，比如事实表上导出了足够多的列，维度表导出了整表，那么真实加载后的数据量应当略小于上述的估算结果。

