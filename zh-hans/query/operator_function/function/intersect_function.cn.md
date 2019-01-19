## 交集函数

用户可以使用交集函数计算两个数据集的交集的值，它们具有一些相同的维度（城市，类别等）和一个变化的维度（日期等），可以用来计算留存率和转化率。

Kyligence Enterprise 支持如下交集函数



### INTERSECT_COUNT

- 说明

  - 返回两个 SELECT 语句的结果中共同的行

- 语法

  - `intersect_count(column To Count, column To Filter, filter Value List)`

- 参数

  - `column To Count` 指向用于计算的维度；必须已经被设定为可以精确去重计算的度量值
  - `column To Filter` 指向可变的维度；有且只有一个

  - `filter Value List` 数组形式，指向可变维度中的值

- 查询示例

  以 Kyligence Enterprise 的样例数据集为例，事实表 `KYLIN_SALES`  模拟了在线交易数据的记录表。
以下查询语句可以获得有多少比例的卖家能在新年假期阶段（2012.01.01-2012.01.03）进行持续的在线交易。

  ```sql
  select LSTG_FORMAT_NAME,
  intersect_count(SELLER_ID, PART_DT, array[date'2012-01-01']) as first_day,
  intersect_count(SELLER_ID, PART_DT, array[date'2012-01-02']) as second_day,
  intersect_count(SELLER_ID, PART_DT, array[date'2012-01-03']) as third_day,
  intersect_count(SELLER_ID, PART_DT, array[date'2012-01-01',date'2012-01-02']) as retention_oneday, 
  intersect_count(SELLER_ID, PART_DT, array[date'2012-01-01',date'2012-01-02',date'2012-01-03']) as retention_twoday 
  from KYLIN_SALES
  where PART_DT in (date'2012-01-01',date'2012-01-02',date'2012-01-03')
  group by LSTG_FORMAT_NAME
  ```

- 返回示例

  ![](images/intersect_count.1.png)
  
  结果表示没有卖家在新年阶段进行持续的在线交易。

