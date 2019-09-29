## Intersect Function

Users can use intersection function to calculate the value of the intersection of two data sets, with some same dimensions and one varied dimension, to analyze the retention or conversion rates.

Kyligence Enterprise supports the following intersection function,




### INTERSECT_COUNT

- Description

  - Returns the count of the value of the intersection of the results of two SQL statements

- Syntax

  - `intersect_count(column To Count, column To Filter, filter Value List)`

- Parameters

  - `column To Count`,  the column to be calculated and applied on distinct count
  - `column To Filter`, the varied dimension and only one can be specified
  - `filter Value List`, the value of the varied dimensions listed in `array[]`, A single element in an array can map multiple values. By default, the '|' is split. You can use `kylin.query.udf.intersect.separator` to configure the separator. This configuration is global.


- Query Example

  Take the sample dataset provided by Kyligence Enterprise as an example, table `KYLIN_SALES` simulates the online transaction data, and the following query can return the percentile of sellers who are trading day by day during 2012.01.01 to 2012.01.03.

  ```SQL
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

- Response Example

  ![](images/intersect_count.1.png)

  The result shows that there is no seller keeps trading constantly during this period.
  
  
### INTERSECT_VALUE

- Description

  - Returns the value of the intersection of the results of two SQL statements

- Syntax

  - `intersect_value(column To Count, column To Filter, filter Value List)`

- Parameters

  - `column To Count`,  the column to be calculated and applied on distinct count
  - `column To Filter`, the varied dimension and only one can be specified
  - `filter Value List`, the value of the varied dimensions listed in `array[]`, A single element in an array can map multiple values. By default, the '|' is split. You can use `kylin.query.udf.intersect.separator` to configure the separator. This configuration is global.


- Query Example

  Take the sample dataset provided by Kyligence Enterprise as an example, table `KYLIN_SALES` simulates the online transaction data, and the following query can return the percentile of sellers who are trading day by day during 2012.01.01 to 2012.01.03.

  ```SQL
  select LSTG_FORMAT_NAME,
  intersect_value(SELLER_ID, PART_DT, array[date'2012-01-01']) as first_day,
  intersect_value(SELLER_ID, PART_DT, array[date'2012-01-02']) as second_day,
  intersect_value(SELLER_ID, PART_DT, array[date'2012-01-03']) as third_day,
  intersect_value(SELLER_ID, PART_DT, array[date'2012-01-01',date'2012-01-02']) as retention_oneday, 
  intersect_value(SELLER_ID, PART_DT, array[date'2012-01-01',date'2012-01-02',date'2012-01-03']) as retention_twoday 
  from KYLIN_SALES
  where PART_DT in (date'2012-01-01',date'2012-01-02',date'2012-01-03')
  group by LSTG_FORMAT_NAME
  ```

- Response Example

  ![](images/intersect_value.1.png)

  The result shows that set of keeping trading constantly's sellerId during this period.
