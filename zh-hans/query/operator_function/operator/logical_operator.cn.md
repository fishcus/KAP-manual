## 逻辑运算符

| 运算符          | 描述                                       | 语法                    | 示例                            |
| ------------ | ---------------------------------------- | --------------------- | ----------------------------- |
| AND          | 是否条件1 *boolean1* 和 条件2 *boolean2* 都为真    | boolean1 AND boolean2 | Name ='frank' AND gender='M'  |
| OR           | 是否条件1 *boolean1* 或 条件2 *boolean2* 为真     | boolean1 OR boolean2  | Name='frank' OR Name='Hentry' |
| NOT          | 是否 *boolean* 不为真; 如果 *boolean* 为 UNKNOWN 则返回 UNKNOWN | NOT boolean           | NOT (NAME ='frank')           |
| IS FALSE     | 是否 *boolean* 为假; 如果 *boolean* 为 UNKNOWN 则返回假 | boolean IS FALSE      | Name ='frank' IS FALSE        |
| IS NOT FALSE | 是否 *boolean* 不为假; 如果 *boolean* 为 UNKNOWN 则返回真 | boolean IS NOT FALSE  | Name ='frank' IS NOT FALSE    |
| IS TRUE      | 是否 *boolean* 为真; 如果 *boolean* 为 UNKNOWN 则返回假 | boolean IS TRUE       | Name ='frank' IS TRUE         |
| IS NOT TRUE  | 是否 *boolean* 不为真; 如果 *boolean* 为 UNKNOWN 则返回真 | boolean IS NOT TRUE   | Name ='frank' IS NOT TRUE     |
