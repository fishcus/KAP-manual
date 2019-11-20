## Conditional Functions

| Syntax                                                       | Description                                            | Example                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------ | ------------------------------------------------------------ |
| CASE value WHEN value1 THEN result1 WHEN valueN THEN resultN ELSE resultZ END | Simple case                                            | `CASE OPS_REGION WHEN 'Beijing' THEN 'BJ' WHEN 'Shanghai' THEN 'SH'WHEN 'Hongkong' THEN 'HK' END FROM KYLIN_SALES` <br /> = HK SH BJ |
| CASE WHEN condition1 THEN result1 WHEN conditionN THEN resultN ELSE resultZ END | Searched case                                          | `CASE WHEN OPS_REGION='Beijing'THEN 'BJ' WHEN OPS_REGION='Shanghai' THEN 'SH' WHEN OPS_REGION='Hongkong' THEN 'HK' END FROM KYLIN_SALES`<br /> = HK SH BJ |
| NULLIF(value, value)                                         | Returns NULL if the values are the same.               | `NULLIF(5,5)`<br /> = null                                   |
| IF(condition, value_if_true, value_if_false)                 | Return value on condition, equivalent to searched case | `IF(BUYER_ID IS NULL, 0, 1)`<br />= 1                        |
| COALESCE(value, value [, value ]*)                           | Provides a value if the first value is null.           | `COALESCE(NULL,NULL,5)`<br /> = 5                            |

