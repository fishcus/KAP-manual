## Semi-Additive Measure (Beta)

Semi-additive measures are very common in various data analysis scenarios, like account balance or inventory analysis. Take account balance as an example, you can analyze account balance based on the account transactions history, SUM() is used when aggregated by default, but for aggregating multiple records under the same account, we need to use last record value along the time dimension.

Since v3.4, Kyligence Enterprise supports semi-additive measure. When defining a SUM() measure, you can enable semi-additive behavior by specifying a semi-additive function and a time dimension (of type TIMESTAMP or DATE). When doing group-by aggregation, Kyligence Enterprise will take only the last record(s) along the time dimension for one group-by result set. If multiple records share the last position in time dimension, further aggregation takes place using normal sum.

### How to Use

The semi-additive feature requires the fact table to contain snapshots over time such as products inventory or accounts balances. At each point of time, the fact table must contain one record for all accounts, like the *SEMI_SCENE* table below.

| TX_DATE    | ACCOUNT   | EXPENSE | INCOME | BALANCE |
| ---------- | --------- | ------- | ------ | ------- |
| 2018-01-01 | account_a | 100     |        | 1000    |
| 2018-01-01 | account_b | 200     |        | 800     |
| 2018-01-01 | account_c | 300     |        | 500     |
| 2018-02-15 | account_a |         | 200    | 1200    |
| 2018-02-15 | account_b |         | 300    | 1100    |
| 2018-02-15 | account_c |         | 50     | 550     |

The *SEMI_SCENE* table contains two points of time, 2018-01-01 and 2018-02-15. At each point of time, there are records for all 3 accounts. It is a typical snapshot dataset.

We can create a semi-additive measure on the *BALANCE* column along the *TX_DATE* time dimension by the following steps.

1. Create a cube with *SEMI_SCENE* as fact table.
2. In the measure panel, add a new measure using SUM expression and turn on the Semi-Additive switch.
3. Select BALANCE as measure column and TX_DATE as time dimension.
4. Select LastChild as the semi-additive function, which is also the only choice at the moment.
5. Go on to complete the cube creation process and save.

   ![Create measure](../images/semi_sum.en.png)



Load data by building the cube and it is ready for queries. Some query examples:

1. Get the total expense, income, and balance of all accounts.

   ```sql
   SELECT ACCOUNT, SUM(EXPENSE),SUM(INCOME),SUM(BALANCE)
   FROM SEMI_SCENE
   GROUP BY ACCOUNT
   ```

   Results

   ```sql
   account_a, 100, 200, 1200
   account_b, 200, 300, 1100
   account_c, 300, 50, 550
   ```

2. Get the remaining balance of all accounts by January 2018.

   ```sql
   SELECT ACCOUNT, SUM(BALANCE)
   FROM SEMI_SCENE
   WHERE TX_DATE <= '2018-01-31'
   GROUP BY ACCOUNT
   ```
   
   Results
   
   ```sql
   account_a, 1000
   account_b, 800
   account_c, 500
   ```
   
3. Get the total expense, income, and balance for year 2018.

   ```sql
   SELECT SUM(EXPENSE),SUM(INCOME),SUM(BALANCE)
   FROM SEMI_SCENE
   WHERE YEAR(TX_DATE) = 2018
   ```

   Results

   ```sql
   600, 550, 2850
   ```

4. Break down the expense, income, balance of year 2018 by month.

   ```sql
   SELECT MONTH(TX_DATE),SUM(EXPENSE),SUM(INCOME),SUM(BALANCE)
   FROM SEMI_SCENE
   WHERE YEAR(TX_DATE) = 2018
   GROUP BY MONTH(TX_DATE)
   ```

   Results

   ```sql
   201801, 600, 0, 2300
   201802, 0, 550, 2850
   ```



### Notes and Limitations

- If the fact table does not contains snapshots data over time, the query results may not be what is expected.
  
  For example, the dataset below misses 2 records on date 2018-02-15.
  
| TX_DATE    | ACCOUNT   | EXPENSE | INCOME | BALANCE |
| ---------- | --------- | ------- | ------ | ------- |
| 2018-01-01 | account_a | 100     |        | 1000    |
| 2018-01-01 | account_b | 200     |        | 800     |
| 2018-01-01 | account_c | 300     |        | 500     |
| 2018-02-15 | account_a |         | 200    | 1200    |
  
  Run the query
  
  ```sql
  SELECT ACCOUNT, SUM(BALANCE)
  FROM SEMI_SCENE
  GROUP BY ACCOUNT
  ```
  
  Results
  
  ```sql
  account_a, 1200
  account_b, 800
  account_c, 500
  ```

  If user expects zero balance on date 2018-02-15 for account_b and account_c because of missing records, then this is not what user wants.

  Also, if there are multiple records of account_a on date 2018-02-15, it also leads to ambiguous result.
  
- Semi-additive measure does not work with table index and query pushdown. Normal sum will take place in these cases. 

- Some limitation when defining semi-additive measure.

  - Semi-additive is only exposed through SUM expression and only supports LastChild semi-additive function.
  - Within one project, normal sum and semi-additive sum cannot coexist on the same column. For example, you cannot define SUM(BALANCE) as both normal sum and semi-additive sum at the same time. That causes ambiguity when parsing a query.
  - Within one project, if semi-additive sum on one column is defined multiple times in multiple cubes, their time dimension must be consistent.
  - The v3.3 version of this product also provides a *LASTVALUE* semi-additive feature (Beta), however that has been deprecated. The current semi-additive feature (Beta) is not backward compatible. If you upgrade from a previous version, any old cube containing old semi-additive measure will become broken. In that case, please purge the old cube segments and edit the cube to redefine the semi-additive measure.

