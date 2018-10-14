## 聚合函数

| 语法                 | 说明                                                         | 示例                                                         |
| -------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| AVG(numeric)         | 返回所有输入值中类型为 numeric 的算术平均值                  | `SELECT AVG(PRICE) FROM KYLIN_SALES`<br /> = 49.23855638491023 |
| SUM(numeric)         | 返回所有输入值中类型为 numeric 的总计值                      | `SELECT SUM(PRICE) FROM KYLIN_SALES`<br /> = 244075.5240     |
| MAX(value)           | 返回所有输入值中 value 的最大值                              | `SELECT MAX(PRICE) FROM KYLIN_SALES`<br /> = 99.9865         |
| MIN(value)           | 返回所有输入值中 value 的最小值                              | `SELECT MIN(PRICE) FROM KYLIN_SALES`<br /> = 0.0008          |
| COUNT(value)         | 返回所有输入值中 value 不为 NULL 的输入行的数量              | `SELECT count(PRICE) FROM KYLIN_SALES`<br /> = 4957          |
| COUNT(*)             | 返回输入的行数                                               | `SELECT COUNT(*) FROM KYLIN_COUNTRY`<br /> = 244             |
| STDDEV_POP(numeric)  | 返回所有输入值中类型为 numeric 的总体标准差                  | `SELECT STDDEV_POP(ITEM_COUNT) FROM KYLIN_SALES`<br /> = 5   |
| STDDEV_SAMP(numeric) | 返回所有输入值中类型为 numeric 的样本标准差                  | `SELECT STDDEV_SAMP(ITEM_COUNT) FROM KYLIN_SALES`<br /> = 5  |
| VAR_POP(value)       | 返回所有输入值中类型为 numeric 的总体方差（总体标准差的平方） | `SELECT var_pop(ITEM_COUNT) FROM KYLIN_SALES`<br /> = 33     |
| VAR_SAMP(numeric)    | 返回所有输入值中类型为 numeric 的样本方差（样本标准差的平方） | `SELECT var_samp(ITEM_COUNT) FROM KYLIN_SALES` <br /> = 33   |
