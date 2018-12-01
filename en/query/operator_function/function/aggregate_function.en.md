## Aggregate Functions

| Syntax               | Description                                                  | Example                                                      |
| -------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| AVG(numeric)         | Returns the average (arithmetic mean) of *numeric* across all input values | `SELECT AVG(PRICE) FROM KYLIN_SALES` <br /> = 49.23855638491023 |
| SUM(numeric)         | Returns the sum of *numeric* across all input values         | `SELECT SUM(PRICE) FROM KYLIN_SALES`<br /> = 244075.5240     |
| MAX(value)           | Returns the maximum value of *value* across all input values | `SELECT MAX(PRICE) FROM KYLIN_SALES`<br /> = 99.9865         |
| MIN(value)           | Returns the minimum value of *value* across all input values | `SELECT MIN(PRICE) FROM KYLIN_SALES`<br /> = 0.0008          |
| COUNT(value)         | Returns the number of input rows for which *value* is not null (wholly not null if *value* is composite) | `SELECT count(PRICE) FROM KYLIN_SALES` <br /> = 4957         |
| COUNT(*)             | Returns the number of input rows                             | `SELECT COUNT(*) FROM KYLIN_COUNTRY`<br /> = 244             |
| STDDEV_POP( numeric) | Returns the population standard deviation of *numeric* across all input values | `SELECT STDDEV_POP(ITEM_COUNT) FROM KYLIN_SALES`<br /> = 5   |
| STDDEV_SAMP(numeric) | Returns the sample standard deviation of *numeric* across all input values | `SELECT STDDEV_SAMP(ITEM_COUNT) FROM KYLIN_SALES`<br /> = 5  |
| VAR_POP(value)       | Returns the population variance (square of the population standard deviation) of *numeric* across all input values | `SELECT var_pop(ITEM_COUNT) FROM KYLIN_SALES`<br /> = 33     |
| VAR_SAMP(numeric)    | Returns the sample variance (square of the sample standard deviation) of *numeric* across all input values | `SELECT var_samp(ITEM_COUNT) FROM KYLIN_SALES`<br /> = 33    |

