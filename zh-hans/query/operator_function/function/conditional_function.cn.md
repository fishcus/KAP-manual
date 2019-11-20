## 条件函数

| 语法                                                         | 说明                                 | 示例                                                         |
| ------------------------------------------------------------ | ------------------------------------ | ------------------------------------------------------------ |
| CASE value WHEN value1 THEN result1 WHEN valueN THEN resultN ELSE resultZ END | 简单 CASE 语句                       | `CASE OPS_REGION WHEN 'Beijing' THEN 'BJ' WHEN 'Shanghai' THEN 'SH'WHEN 'Hongkong' THEN 'HK' END FROM KYLIN_SALES` <br /> = HK SH BJ |
| CASE WHEN condition1 THEN result1WHEN conditionN THEN resultN ELSE resultZ END | 搜索 CASE 语句                       | `CASE WHEN OPS_REGION='Beijing'THEN 'BJ' WHEN OPS_REGION='Shanghai' THEN 'SH' WHEN OPS_REGION='Hongkong' THEN 'HK' END FROM KYLIN_SALES`<br /> = HK SH BJ |
| NULLIF(value, value)                                         | 如果两个值相同返回 NULL              | `NULLIF(5,5)`<br /> = null                                   |
| IF(condition, value_if_true, value_if_false)                 | 根据条件返回对应值，等同搜索CASE语句 | `IF(BUYER_ID IS NULL, 0, 1)`<br />= 1                        |
| COALESCE(value, value [, value ]*)                           | 返回第一个不为 NULL 的值             | `COALESCE(NULL,NULL,5)`<br /> = 5                            |

