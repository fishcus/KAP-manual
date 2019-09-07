## 半累加度量（Beta）

在很多业务的数据分析场景中，半累加度量是很常见的，它可以用于处理证券、账户余额、人力资源等业务领域。比如在银行在使用账户交易记录数据来统计储蓄账户余额时，对于非时间维度，使用正常的求和，而对于时间维度，则需要取最后一条记录的值。

本产品从 v3.4 版本开始，实现了对半累加度量的支持。在 Kyligence Enterprise 中定义聚合函数为 SUM 的度量时，可以启用半累加度量，指定半累加函数和时间维度（TIMESTAMP 或 DATE 类型），即可实现度量的半累加行为。Kyligence Enterprise 在聚合计算时，对于每一个 Group By 结果集的多条记录，只取时间维度上最靠后的记录，如果时间最靠后有多条记录，再将它们进行正常的累加。

###  使用方法

半累加功能要求事实表包含随时间变化的**快照数据**，比如产品库存快照，或账户余额快照。快照数据要求每一个记录时间点上都有所有账号的一条记录，比如下面的 *SEMI_SCENE* 表。

| TX_DATE    | ACCOUNT   | EXPENSE | INCOME | BALANCE |
| ---------- | --------- | ------- | ------ | ------- |
| 2018-01-01 | account_a | 100     |        | 1000    |
| 2018-01-01 | account_b | 200     |        | 800     |
| 2018-01-01 | account_c | 300     |        | 500     |
| 2018-02-15 | account_a |         | 200    | 1200    |
| 2018-02-15 | account_b |         | 300    | 1100    |
| 2018-02-15 | account_c |         | 50     | 550     |

*SEMI_SCENE* 表中有两个记录时间点，分别是 2018-01-01 和 2018-02-15，且每个时间点上都有 3 个账号的记录，是标准的快照数据。

在这种情形下，就可以将账户余额 *BALANCE* 定义为半累加度量，在交易时间 *TX_DATE* 维度上对账户余额进行聚合取最后的记录。下面是如何定义该半累加度量。

1. 以 *SEMI_SCENE* 为事实表创建 Cube。

2. 在度量版面**添加度量**，选择 *SUM* 表达式，并勾选中半累加。

3. 选择 BALANCE 为度量，TX_DATE 为时间维度。

4. 选择半累加函数为 LastChild，也是当前唯一支持的函数。

5. 完成其他 Cube 信息并保存。
  
   ![添加度量](../images/semi_sum.cn.png)



构建加载数据后，就可以查询。例如：

1. 分析每个账户支出总额、收入总额和账户余额

   ```sql
   SELECT ACCOUNT, SUM(EXPENSE),SUM(INCOME),SUM(BALANCE)
   FROM SEMI_SCENE
   GROUP BY ACCOUNT
   ```

   结果为

   ```sql
   account_a, 100, 200, 1200
   account_b, 200, 300, 1100
   account_c, 300, 50, 550
   ```

2. 获得 2018 年 1 月底的所有账户余额

   ```sql
   SELECT ACCOUNT, SUM(BALANCE)
   FROM SEMI_SCENE
   WHERE TX_DATE <= '2018-01-31'
   GROUP BY ACCOUNT
   ```
   
   结果为
   
   ```sql
   account_a, 1000
   account_b, 800
   account_c, 500
   ```
   
3. 分析 2018 年所有账户的总支出、总收入、总账户余额

   ```sql
   SELECT SUM(EXPENSE),SUM(INCOME),SUM(BALANCE)
   FROM SEMI_SCENE
   WHERE YEAR(TX_DATE) = 2018
   ```

   结果为

   ```sql
   600, 550, 2850
   ```

4. 分析 2018 年每个月所有账户的总支出、总收入、总账户余额

   ```sql
   SELECT MONTH(TX_DATE),SUM(EXPENSE),SUM(INCOME),SUM(BALANCE)
   FROM SEMI_SCENE
   WHERE YEAR(TX_DATE) = 2018
   GROUP BY MONTH(TX_DATE)
   ```

   结果为

   ```sql
   201801, 600, 0, 2300
   201802, 0, 550, 2850
   ```



### 注意事项和已知限制

- 如果事实表中并非完整的快照数据，查询的结果可能与用户的期望不符。
  
  比如下面的数据集，在 2018-02-15 时间点上缺失 2 条记录：
  
  | TX_DATE    | ACCOUNT   | EXPENSE | INCOME | BALANCE |
  | ---------- | --------- | ------- | ------ | ------- |
  | 2018-01-01 | account_a | 100     |        | 1000    |
  | 2018-01-01 | account_b | 200     |        | 800     |
  | 2018-01-01 | account_c | 300     |        | 500     |
  | 2018-02-15 | account_a |         | 200    | 1200    |
  
  此时查询
  
  ```sql
  SELECT ACCOUNT, SUM(BALANCE)
  FROM SEMI_SCENE
  GROUP BY ACCOUNT
  ```
  
  结果为
  
  ```sql
  account_a, 1200
  account_b, 800
  account_c, 500
  ```

  可能与期望 2018-02-15 时刻 account_b 和 account_c 余额不存在即为零不符。

  此外，如果在 2018-02-15 时刻有多条 account_a 的记录，也会导致查询结果有歧义。
  
- 半累加度量不支持表索引、查询下压和异步查询。在上述情况中，查询结果将返回全累加值。

- 半累加度量定义方面的限制

  - 只有聚合函数为 SUM 的度量才可以设置半累加度量，半累加函数当前只支持 LastChild。
  - 在同一个项目中，基于事实表中的同一列不能同时定义半累加度量和全累加度量。比如在一个项目中，不能同时定义 BALANCE 的全累加和半累加的度量，那样会造成查询语句中 SUM(BALANCE) 的二义性。
  - 在同一个项目中，同一个半累加度量的时间维度必须一致。比如，如果 BALANCE 半累加在多个 Cube 中被定义，它们的时间维度应该一致。
  - 当前的半累加（Beta）功能并不向前兼容，老版本含半累加的 Cube 在升级后将为 Broken 状态，需要先清理 Cube Segment，然后编辑 Cube 并重新定义半累加度量。

