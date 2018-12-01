## 字符串函数

| 语法                                     | 说明                               | 示例                                       |
| ---------------------------------------- | -------------------------------------- | ---------------------------------------- |
| CHAR_LENGTH(string)| 返回字符串（string）长度                                | `CHAR_LENGTH('Kyligence')`<br />  = 9 |
| CHARACTER_LENGTH(string)                 | 返回字符串（string）长度               | `CHARACTER_LENGTH('Kyligence')`<br /> = 9 |
| UPPER(string)| 返回字符串（string）为全大写   | `UPPER('Kyligence')`<br />  = KYLIGENCE |
| LOWER(string)| 返回字符串（string）为全小写 | `LOWER('Kyligence')`<br /> = kyligence |
| POSITION(string1 IN string2)| 返回字符串（string1）在字符串（string2）中的位置 | `POSITION('Kyli' IN 'Kyligence')`<br /> = 1 |
| TRIM( { BOTH \ LEADING\ TRAILING } string1 FROM string2) | 去掉字符串（string2）开头／结尾／两头最长的一个字符串（string1） | 示例 1：`TRIM(BOTH '6' FROM '666Kyligence66')`<br /> = Kyligence<br /><br />示例 2：`TRIM(LEADING '6' FROM '666Kyligence66')`<br /> = Kyligence66<br /><br />示例 3：`TRIM(TRAILING '6' FROM '666Kyligence66')`<br /> = 666Kyligence |
| OVERLAY(string1 PLACING string2 FROM integer [ FOR integer2 ])| 从字符串（string1）第 integer 位开始将字符替换为字符串（string2）   | `OVERLAY('666' placing 'KYLIGENCE' FROM 2 for 2)`<br /> = 6KYLIGENCE |
| SUBSTRING(string FROM integer)| 从第 integer 位开始，取字符串（string）的部分字符串 | `SUBSTRING('Kyligence' FROM 5)`<br /> = gence |
| SUBSTRING(string FROM integer1 FOR integer2) | 从第 integer1 位开始，取字符串（string）中的 integer2 个字符    | `SUBSTRING('Kyligence' from 5 for 2)`<br /> = ge |
| INITCAP(string)                          | 将字符串（string）的首字母替换成大写                          | `INITCAP('kyligence')`<br /> = Kyligence |
| REPLACE(string, search, replacement) | 将字符串（string）中的字符串（search） 替换为字符串（replacement） | ` REPLACE('Kyligence','Kyli','Kyliiiiiii')`<br /> = Kyliiiiiiigence |

