## Aggregate Function

| Syntax                            | Description                              | Example                                  | Return            |
| --------------------------------- | ---------------------------------------- | ---------------------------------------- | ----------------- |
| AVG( [ ALL ] numeric)             | Returns the average (arithmetic mean) of *numeric*across all input values | SELECT AVG(PRICE) FROM KYLIN_SALES       | 49.23855638491023 |
| SUM( [ ALL ] numeric)             | Returns the sum of *numeric*across all input values | SELECT SUM(PRICE) FROM KYLIN_SALES       | 244075.5240       |
| MAX( [ ALL ] value)               | Returns the maximum value of *value* across all input values | SELECT MAX(PRICE) FROM KYLIN_SALES       | 99.9865           |
| MIN( [ ALL ] value)               | Returns the minimum value of *value* across all input values | SELECT MIN(PRICE) FROM KYLIN_SALES       | 0.0008            |
| COUNT( [ ALL ] value [, value ]*) | Returns the number of input rows for which *value* is not null (wholly not null if *value* is composite) | SELECT count(PRICE) FROM KYLIN_SALES     | 4957              |
| COUNT(*)                          | Returns the number of input rows         | SELECT COUNT(*) FROM KYLIN_COUNTRY       | 244               |
| STDDEV_POP( [ ALL ] numeric)      | Returns the population standard deviation of *numeric*across all input values | SELECT STDDEV_POP(ITEM_COUNT) FROM KYLIN_SALES | 5                 |
| STDDEV_SAMP( [ ALL ] numeric)     | Returns the sample standard deviation of *numeric* across all input values | SELECT STDDEV_SAMP(ITEM_COUNT) FROM KYLIN_SALES | 5                 |
| VAR_POP( [ ALL ] value)           | Returns the population variance (square of the population standard deviation) of *numeric* across all input values | SELECT var_pop(ITEM_COUNT) FROM KYLIN_SALES | 33                |
| VAR_SAMP( [ ALL ] numeric)        | Returns the sample variance (square of the sample standard deviation) of *numeric* across all input values | SELECT var_samp(ITEM_COUNT) FROM KYLIN_SALES | 33                |

> **Caution**: These functions cannot be applied to **Computed Column**. For details about computed column, please refer to [Computed Column](../../model/computed_column/README.en.md) in the chapter of **Modeling**.
