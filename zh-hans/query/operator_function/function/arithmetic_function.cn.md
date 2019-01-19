## 算数函数

| 语法                           | 说明                                                         | 示例                         |
| ------------------------------ | ------------------------------------------------------------ | ---------------------------- |
| POWER(numeric1, numeric2)      | 返回数字（numeric1）乘幂（numeric2）的结果                   | ` POWER(5,2)`<br /> = 25.0 |
| ABS(numeric)                   | 返回数字（numeric）的绝对值                                  | ` ABS(-2)`<br /> = 2   |
| MOD(numeric1, numeric2)        | 返回被除数（numeric1）与除数（ numeric2）相除的余数， 结果的符号与被除数相同 | ` MOD(-3, 2)`<br /> = -1 |
| SQRT(numeric)                  | 返回数字（numeric）的平方根                                  | ` SQRT(16)`<br /> = 4.0 |
| LN(numeric)                    | 返回数字（numeric）的自然对数                                | ` LN(2)`<br /> = 0.6931471805599453 |
| LOG10(numeric)                 | 返回数字（numeric）以 10 为底的对数                          | ` LOG10(100)`<br /> = 2.0 |
| EXP(numeric)                   | 返回 e 的 numeric 次幂                                       | ` EXP(1)`<br /> = 2.718281828459045 |
| CEIL(numeric)                  | 返回大于或者等于数字（numeric）的最小整数                    | ` CEIL(-2.2)` <br /> = -2 |
| FLOOR(numeric)                 | 返回小于或者等于数字（numeric）的最大整数                    | ` FLOOR(-2.2)`<br /> = -3 |
| RAND([seed])                   | 生成一个大于等于 0 且小于 1 的随机实数<br />- `seed`：`可选` 用于初始化随机数生成器 | ` RAND(15)`<br /> = 0.45951471073476047 |
| RAND_INTEGER([seed, ] numeric) | 生成一个大于等于 0 且小于数字（numeric）的整数<br />- `seed`：`可选` 用于初始化随机数生成器 | ` RAND_INTEGER(15,50)`<br /> = 22 |
| ACOS(numeric)                  | 返回数字（numeric）的反余弦                                  | ` ACOS(0.8)`<br /> = 0.6435011087932843 |
| ASIN(numeric)                  | 返回数字（numeric）的反正弦                                  | ` ASIN(0.8)`<br /> = 0.9272952180016123 |
| ATAN(numeric)                  | 返回数字（numeric）的反正切                                  | ` ATAN(0.8)`<br /> = 0.6747409422235527 |
| ATAN2(numeric1, numeric2)      | 返回坐标 (numeric1, numeric2) 的反正切                       | ` ATAN2(0.2, 0.8)`<br /> = 0.24497866312686414 |
| COS(numeric)                   | 返回数字（numeric）的正弦                                    | ` COS(5)`<br /> = 0.28366218546322625 |
| COT(numeric)                   | 返回数字（numeric）的余切                                    | ` COT(5)`<br /> = -0.2958129155327455 |
| DEGREES(numeric)               | 将弧度（numeric）转成角度                             | ` DEGREES(5)`<br /> = 286.4788975654116 |
| PI()                           |       返回无限接近 π 的数字                                                     |   ` PI()`<br /> = 3.141592653589793 |
| RADIANS(numeric)               | 将角度（numeric）转成弧度                              | ` RADIANS(90)`<br /> = 1.5707963267948966 |
| ROUND(numeric1, numeric2)      | 将数字（numeric1）取数字（numeric2，默认为 0 ）位小数        | ` ROUND(5.55555,2)`<br /> = 5.56 |
| SIGN(numeric)                  | 返回数字（numeric）的符号                                    | ` SIGN(-5)`<br /> = -1 |
| SIN(numeric)                   | 返回数字（numeric）的正弦                                    | ` SIN(5)`<br /> = -0.9589242746631385 |
| TAN(numeric)                   | 返回数字（numeric）的正切                                    | ` TAN(5)`<br /> = -3.380515006246586 |
| TRUNCATE(numeric1, numeric2)   | 将数字（numeric1）截断到数字（numeric2，默认为 0）              | ` TRUNCATE(5.55555,2)`<br /> = 5.55 |
