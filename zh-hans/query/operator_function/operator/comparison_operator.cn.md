## 比较运算符

| 运算符                  | 描述                                 | 语法                                       | 示例                                       |
| -------------------- | ---------------------------------- | ---------------------------------------- | ---------------------------------------- |
| <                    | 小于                                 | A<B                                      | Profit < Cost                            |
| <=                   | 小于或等于                              | A<=B                                     | Profit <=Cost                            |
| >                    | 大于                                 | A>=B                                     | Profit >Cost                             |
| >=                   | 大于或等于                              | A>=B                                     | Profit >=Cost                            |
| <>                   | 不等于                                | A<>B                                     | Profit1<>Profit2                         |
| IS NULL              | 判断值是否为 NULL                         | value IS NULL                            | profit IS NULL                           |
| IS NOT NULL          | 判断值是否不为 NULL                        | value IS NOT NULL                        | profit IS NOT NULL                       |
| IS DISTINCT FROM     | 判断两个值是否不相等，其中有值为 NULL 时当作相等。         | value1 IS DISTINCT FROM value2           | profit1 IS DISTINCT FROM profit2         |
| IS NOT DISTINCT FROM | 判断两个值是否相等，其中有值为 NULL 时当作相等。          | value1 IS NOT DISTINCT FROM value2       | profit1 IS NOT DISTINCT FROM profit2     |
| BETWEEN              | 如果具体的值大于等于 value1 且小于等于 value2，返回结果为真 | A BETWEEN   value1 AND value2            | profit BETWEEN 1 AND 1000      Date BETWEEN '2016-01-01' AND '2016-12-30' |
| NOT BETWEEN          | 如果具体的值大于等于 value1 且小于等于 value2，返回结果为假 | value1 NOT BETWEEN value2 AND value3     | profit NOT BETWEEN 1 AND 1000      Date NOT BETWEEN '2016-01-01' AND '2016-12-30' |
| LIKE                 | string1 是否和 string2 的样式匹配             | sptring1 LIKE spring2                    | name LIKE '%frank%'                                                                    |
| NOT LIKE             | string1 是否和 string2 的样式不匹配            | string1 NOT LIKE string2 [ ESCAPE string3 ] | name NOT LIKE '%frank%'                  |
| SIMILAR TO           | string1 是否和 string2 按正则表达式匹配          | string1 SIMILAR TO string2               | name SIMILAR TO 'frank'                  |
| NOT SIMILAR TO       | string1 是否和 string2 按正则表达式不匹配         | string1 NOT SIMILAR TO string2           | name NOT SIMILAR TO 'frank'              |