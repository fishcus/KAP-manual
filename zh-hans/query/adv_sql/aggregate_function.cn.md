## 聚合函数

| 函数语法                              | 描述                                       | 示例                                       | 返回结果              |
| --------------------------------- | ---------------------------------------- | ---------------------------------------- | ----------------- |
| AVG( [ ALL ] numeric)             | 返回所有输入值中类型为 *numeric* 的平均值（算术平均值）        | SELECT AVG(PRICE) FROM KYLIN_SALES       | 49.23855638491023 |
| SUM( [ ALL ] numeric)             | 返回所有输入值中类型为 *numeric* 的总计值               | SELECT SUM(PRICE) FROM KYLIN_SALES       | 244075.5240       |
| MAX( [ ALL  ] value)              | 返回所有输入值中 *value* 的最大值                    | SELECT MAX(PRICE) FROM KYLIN_SALES       | 99.9865           |
| MIN( [ ALL ] value)               | 返回所有输入值中 *value* 的最小值                    | SELECT MIN(PRICE) FROM KYLIN_SALES       | 0.0008            |
| COUNT( [ ALL ] value [, value ]*) | 返回 *value* 不为 Null（如果 *value* 为复合值时，则完全不为 Null）的输入行的数量 | SELECT count(PRICE) FROM KYLIN_SALES     | 4957              |
| COUNT(*)                          | 返回输入的行数                                  | SELECT COUNT(*) FROM KYLIN_COUNTRY       | 244               |
| STDDEV_POP( [ ALL ] numeric)      | 返回所有输入值中类型为 *numeric* 的总体标准差             | SELECT STDDEV_POP(ITEM_COUNT) FROM KYLIN_SALES | 5                 |
| STDDEV_SAMP( [ ALL ] numeric)     | 返回所有输入值中类型为 *numeric* 的样本标准差             | SELECT STDDEV_SAMP(ITEM_COUNT) FROM KYLIN_SALES | 5                 |
| VAR_POP( [ ALL ] value)           | 返回所有输入值中类型为 *numeric* 的总体方差（总体标准差的平方）    | SELECT var_pop(ITEM_COUNT) FROM KYLIN_SALES | 33                |
| VAR_SAMP( [ ALL ] numeric)        | 返回所有输入值中类型为 *numeric* 的样本方差（样本标准差的平方）    | SELECT var_samp(ITEM_COUNT) FROM KYLIN_SALES | 33                |

> **注意**：此函数不适用于可计算列。有关可计算列，参见**数据建模**一章中的[可计算列](../../model/computed_column/README.cn.md)部分。
