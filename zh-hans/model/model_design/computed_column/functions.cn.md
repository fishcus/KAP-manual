## 可计算列支持的函数

本节以 Hive 为例，介绍本产品中可计算列支持的函数。

**注意：根据您使用的源数据系统的不同，可计算列支持的函数也是不同的。**这是因为 Kyligence Enterprise 通过提交 SQL 到源数据系统的方式执行可计算列，可计算列表达式必须能被源数据系统解析并执行。

- 对 Hive 数据源，请留意不同 Hive 版本支持函数的差异。比如，函数 `factorial` 与函数 `shiftleft` 从 Hive 1.2.0 版本开始才支持。而函数 `substring_index` 则需要 Hive 1.3.0 以上才支持。如果您不确认某个函数 Hive 是否支持，请与您的 Hadoop 管理员联系。
- 对 RDBMS 数据源，请参考 RDBMS 的官方文档了解支持的函数。
- 对 Kafka 数据源，暂时还不支持可计算列功能。

函数目录

- [算术函数](#算术函数)
- [日期函数](#日期函数)
- [类型转换函数](#类型转换函数)
- [条件函数](#条件函数)
- [字符串函数](#字符串函数)



### 算术函数

| 函数语法                                     |                    描述                    | 示例                                       |
| ---------------------------------------- | :--------------------------------------: | ---------------------------------------- |
| round(DOUBLE a)                          |        返回对 `a` 四舍五入的 `BIGINT` 值。         | round(10.5)                              |
| round(DOUBLE a, INT d)                   |             将 `a` 取 `d` 位小数。             | round(10.156, 2)                         |
| floor(DOUBLE a)                          |       返回等于或小于 `a` 的最大 `BIGINT` 值。        | floor(10.15)                             |
| ceil(DOUBLE a), ceiling(DOUBLE a)        |       返回等于或大于 `a` 的最小 `BIGINT` 值。        | ceil(10.6), ceiling(10.6)                |
| factorial(INT a)                         |      返回 `a` 的阶乘。`a` 的有效值为 [0..20]。       | factorial(10)                            |
| unhex(STRING a)                          |           将十六进制的字符转换为由数字表示的字符。           | unhex(616263)                            |
| ln(DOUBLE a), ln(DECIMAL a)              |             返回给定数值 a 的自然对数。              | ln(10.15), ln(10.5)                      |
| hex(BIGINT a), hex(STRING a), hex(BINARY a) |           将整数、字符或二进制转换为十六进制格式            | hex('abc'), hex(255)                     |
| rand(), rand(INT seed)                   | 随机返回均匀分布于 0 到 1 之间的数值。指定种子将确保生成的随机数序列是确定的。 | rand(), rand(1)                          |
| exp(DOUBLE a), exp(DECIMAL a)            |        返回 `e`[^a]，其中 `e` 是自然对数的底。        | exp(10.15), exp(10.5)                    |
| log10(DOUBLE a), log10(DECIMAL a)        |           返回以 10 为底的 `a` 的对数。            | log10(10.15), log10(2.5)                 |
| log2(DOUBLE a), log2(DECIMAL a)          |            返回以 2 为底的 `a` 的对数。            | log2(2.15), log2(2.5)                    |
| log(DOUBLE base, DOUBLE a), log(DECIMAL base, DECIMAL a) |         返回以 `base` 为底的 `a` 的对数。          | log(10.15, 2.15), log(10.5, 2.5)         |
| pow(DOUBLE a, DOUBLE p), power(DOUBLE a, DOUBLE p) |               返回 `a`[^p]。                | pow(10.15, 2.15), power(10.15, 2.15)     |
| sqrt(DOUBLE a), sqrt(DECIMAL a)          |               返回 `a` 的平方根。               | sqrt(2.15), sqrt(2.5)                    |
| abs(DOUBLE a)                            |                  返回绝对值。                  | abs(2.15)                                |
| sin(DOUBLE a), sin(DECIMAL a)            |         返回 `a` 的正弦值（`a` 用弧度表示）。          | sin(2.15), sin(2.5)                      |
| asin(DOUBLE a), asin(DECIMAL a)          |   如果 -1<=a<=1，返回 `a` 的反正弦值；否则返回 NULL。    | asin(0.15), asin(0.5)                    |
| cos(DOUBLE a), cos(DECIMAL a)            |         返回 `a` 的余弦值（`a` 用弧度表示）。          | cos(1.15), cos(1.5)                      |
| acos(DOUBLE a), acos(DECIMAL a)          |   如果 -1<=a<=1，返回 `a` 的反余弦值；否则返回 NULL。    | acos(0.15), acos(0.5)                    |
| tan(DOUBLE a), tan(DECIMAL a)            |         返回 `a` 的正切值（`a` 用弧度表示）。          | tan(1.15), tan(1.5)                      |
| atan(DOUBLE a), atan(DECIMAL a)          |              返回 `a` 的反正切值。               | atan(1.15), atan(1.5)                    |
| degrees(DOUBLE a), degrees(DECIMAL a)    |            将 `a` 的值从弧度转换为角度。             | degrees(10.15), degrees(10.5)            |
| radians(DOUBLE a), radians(DECIMAL a)    |            将 `a` 的值从角度转换为弧度。             | radians(10.15), radians(10.5)            |
| e()                                      |                返回 `e` 的值。                | e()                                      |
| pi()                                     |               返回 `pi` 的值。                | pi()                                     |
| cbrt(DOUBLE a)                           |               返回 `a` 的立方根。               | cbrt(10.15)                              |
| sign(DOUBLE a), sign(DECIMAL a)          |  如果 a 是正数则返回 1.0，是负数则返回 -1.0，否则返回 0.0。   | sign(10.15), sign(10.5)                  |
| pmod(INT a, INT b), pmod(DOUBLE a, DOUBLE b) |           返回正的 `a` 除以 `b` 的余数。           | pmod(10, 7), pmod(10.15, 5.15)           |
| positive(INT a), positive(DOUBLE a)      |                 返回 `a`。                  | positive(10), positive(10.15)            |
| negative(INT a), negative(DOUBLE a)      |                 返回 `-a`。                 | negative(10), negative(10.15)            |
| shiftleft(TINYINT/SMALLINT/INT a, INT b), shiftleft(BIGINT a, INT b) |                  按位左移。                   | shiftleft(10, 5), shiftleft(20, 5)       |
| shiftright(TINYINT/SMALLINT/INT a, INT b), shiftright(BIGINT a, INT b) |                  按位右移。                   | shiftright(10, 5), shiftright(20, 5)     |
| shiftrightunsigned(TINYINT/SMALLINT/INTa, INT b),shiftrightunsigned(BIGINT a, INT b) |                 无符号按位右移。                 | shiftrightunsigned(10, 5), shiftrightunsigned(20, 5) |
| bin(BIGINT a)                            |               以二进制格式返回数值。                | bin(10)                                  |
| conv(BIGINT num, INT from_base, INT to_base) |  将数值 num 从 from_base 进制转化到 to_base 进制。   | conv(-17,10,-18)                         |
| greatest(T v1, T v2, ...)                |               返回一列值中的最大值。                | greatest(5,10,15)                        |
| least(T v1, T v2, ...)                   |               返回一列值中的最小值。                | least(5,10,15)                           |



### 日期函数

| 函数语法                                     | 描述                                       | 示例                                       |
| :--------------------------------------- | ---------------------------------------- | ---------------------------------------- |
| from_unixtime(bigint unixtime[, string format]) | 转化 UNIX 时间戳（从1970-01-01 00:00:00 UTC 到指定时间的秒数）到当前时区的时间格式。 | from_unixtime(1514719868)                |
| unix_timestamp()                         | 获得当前时区的 UNIX 时间戳。                        | unix_timestamp()                         |
| unix_timestamp(string date)              | 转换格式为“yyyy-MM-dd HH:mm:ss“的日期到 UNIX 时间戳。如果转化失败，则返回 0。 | unix_timestamp('2009-03-20 11:30:01')    |
| unix_timestamp(string date, string pattern) | 转换 pattern 格式的日期到 UNIX 时间戳。如果转化失败，则返回 0。 | unix_timestamp('2009-03-20', 'yyyy-MM-dd') |
| to_date(string timestamp)                | 返回日期时间字段中的日期部分。                          | to_date('2012-01-01  00:00:00')          |
| year(string date)                        | 返回日期中的年份。                                | year('2012-01-01 00:00:00')              |
| month(string date)                       | 返回日期中的月份。                                | month('2012-11-01 00:00:00')             |
| hour(string date)                        | 返回日期中的小时。                                | hour('2009-07-30 12:58:59')              |
| minute(string date)                      | 返回日期中的分钟。                                | minute('2009-07-30 12:58:59')            |
| second(string date)                      | 返回日期中的秒。                                 | second('2009-07-30 12:58:59')            |
| weekofyear(string date)                  | 返回日期在当前的周数。                              | weekofyear('1970-11-01 00:00:00')        |
| datediff(string enddate, string startdate) | 返回结束日期减去开始日期的天数。                         | datediff('2009-03-01', '2009-02-27')     |
| date_add(date/timestamp/string startdate, tinyint/smallint/int days) | 返回开始日期 startdate 增加 days 天后的日期。          | date_add('2008-12-31', 1)                |
| date_sub(date/timestamp/string startdate, tinyint/smallint/int days) | 返回开始日期 startdate 减少 days 天后的日期。          | date_sub('2008-12-31', 1)                |
| from_utc_timestamp({any primitive type}*, string timezone) | 转换 UTC 时间为指定时区的时间。                       | from_utc_timestamp(2592000.0,'PST')      |
| to_utc_timestamp({any primitive type} ts, string timezone) | 转换指定时区的时间为 UTC 时间。                       | to_utc_timestamp(2592000.0,'PST')        |
| current_date                             | 返回查询时的日期。                                | current_date()                           |
| current_timestamp                        | 返回查询时的时间。                                | current_timestamp()                      |
| add_months(string start_date, int num_months) | 返回当前时间下再增加 num_months 个月的日期，如果当前日期是最后一天，则计算后的日期也为最后一天。 | add_months('2015-01-14', 5)              |
| last_day(string date)                    | 返回这个月的最后一天的日期，忽略时分秒部分。                   | last_day('2009-07-30 12:58:59')          |
| next_day(string start_date, string day_of_week) | 返回当前时间的下一个星期X所对应的日期。 day_of_week 是星期的 2 个、3 个或整个单词。 | next_day('2015-01-14', 'TU')             |
| trunc(string date, string format)        | 返回时间的最开始年份或月份 如 trunc(“2016-06-26”,“MM”)=2016-06-01 trunc(“2016-06-26”,“YY”)=2016-01-01。注意所支持的格式为 MONTH/MON/MM, YEAR/YYYY/YY。 | trunc('2015-03-17', 'MM')                |
| months_between(date1, date2)             | 返回 date1 与 date2 之间相差的月份， 如果 date1>date2，则返回正值，如果 date1<date2，则返回负值。 | months_between('2013-02-28 10:30:00', '2012-10-30') |
| date_format(date/timestamp/string ts, string fmt) | 按指定格式返回日期。                               | date_format('2015-04-08', 'y')           |



### 类型转换函数

| 函数语法                 | 描述                                       | 示例                  |
| -------------------- | ---------------------------------------- | ------------------- |
| cast(expr as <type>) | 将表达式 expr 转换为 type 类型，例如 cast('1' as BIGINT)。如果转换不成功，则返回 null；非空字符串转换为 boolean，返回 true。 | cast('1' as BIGINT) |



### 条件函数

| 函数语法                           | 描述                                       | 示例                |
| ------------------------------ | ---------------------------------------- | ----------------- |
| isnull( a )                    | a 为 null 时，返回 true；否则返回 false。           | isnull(NULL)      |
| isnotnull ( a )                | a 不为 null 时，返回 true；否则返回 false。          | isnotnull(1)      |
| nvl(T value, T default_value)  | value 为 null 时，返回 default_value；否则返回 value。 | nvl(null, 30)     |
| COALESCE(T v1, T v2, ...)      | 返回第一个不为 null 的值；都为 null 时，返回 null。       | COALESCE(null,30) |
| assert_true(boolean condition) | 当条件不为 true 时，抛出异常；否则返回 Null。             | assert_true (2<1) |



### 字符串函数

| 函数语法                                     | 描述                                       | 示例                                       |
| ---------------------------------------- | ---------------------------------------- | ---------------------------------------- |
| ascii(string str)                        | 返回 str 中首个 ASCII 字符串的整数值。                | ascii('abcde')                           |
| concat(string/binary A, string/binary B…) | 返回将 A 和 B 按顺序连接在一起的字符串，如：concat('foo', 'bar') 返回 'foobar'。 | concat('foo', 'bar')                     |
| concat_ws(string SEP, string A, string B...) | 类似 concat() ，但使用自定义的分隔符 SEP              | concat_ws(',','abc','def','gh')          |
| elt(N int,str1 string,str2 string,str3 string,...) | 如果 N=1，返回 str1；如果 N=2，返回 str2，等等。如果 N 小于 1 或大于参数个数，返回 NULL。ELT() 是 FIELD() 的反运算。 | elt(2,'hello','world')                   |
| field(val T,val1 T,val2 T,val3 T,...)    | 返回 val T 在 val1 T, val2 T, val3 T, ...清单的索引。如果 val T 未找到，则返回 0。FIELD() 是 ELT() 的反运算。 | field('world','say','hello','world')     |
| find_in_set(string str, string strList)  | 返回 str 在 strList 中第一次出现的位置，strList 为用逗号分隔的字符串，如果 str 包含逗号则返回 0，若任何参数为 null，返回 null。如：find_in_set('ab', 'abc,b,ab,c,def') 返回 3。 | find_in_set('ab', 'abc,b,ab,c,def')      |
| format_number(number x, int d)           | 将数字x格式化为 '#,###,###.##'，四舍五入为 d 位小数位，将结果做为字符串返回。如果 d=0，结果不包含小数点或小数部分。 | format_number(12.35, 1)                  |
| instr(string str, string substr)         | 返回 substr 在 str 中第一次出现的位置。若任何参数为 null，则返回 null；若 substr 不在 str 中，则返回 0。Str 中第一个字符的位置为 1。 | instr('I like this game', 'like')        |
| length(string A)                         | 返回 A 的长度。                                | length('abcdef')                         |
| locate(string substr, string str[, int pos]) | 返回 substr 第一次出现在 str 的 pos 后的位置。         | locate('I like this game', 'like')       |
| lower(string A) lcase(string A)          | 返回全部字符转为小写之后的字符串。                        | lower('fOoBaR')                          |
| lpad(string str, int len, string pad)    | 左边添加 pad 参数输入的字符使字符串长度为 len，然后返回该字符串。    | lpad('abc',10,'td')                      |
| ltrim(string A)                          | 返回从 A 的开头（左手边）删除空白字符后的字符串。例如，ltrim(' foobar ') 结果为 'foobar'。 | ltrim('foobar')                          |
| regexp_extract(string subject, string pattern, int index) | 返回使用模式提取的字符串。例如，regexp_extract('foothebar', 'foo(.*?)(bar)', 2) 返回 'bar'。注意，使用预定义字符类型有一些必要的关注：使用 '\s' 作为第二个参数将匹配字母 s；匹配空白字符 '\\s' 是必须的。'index' 参数是 Java 正则 Matcher group() 方法索引。 | regexp_extract('foothebar', 'foo(.*?)(bar)', 2) |
| regexp_replace(string INITIAL_STRING, string PATTERN, string REPLACEMENT) | 返回用 REPLACEMENT 的实例替换 INITIAL_STRING 中所有 PATTERN 内定义的与 java 正则表达式的语法匹配的所有子串。 | regexp_replace('foobar', 'oo\ar', '')    |
| repeat(string str, int n)                | 重复 `str` n 次。                            | repeat('abc', 3)                         |
| reverse(string A)                        | 返回反转后的字符串。                               | reverse('abc')                           |
| rpad(string str, int len, string pad)    | 右边添加 pad 参数输入的字符使字符串长度为 len，然后返回该字符串。    | rpad('abc',10,'td')                      |
| rtrim(string A)                          | 返回从 A 的末尾（右手边）删除空白字符后的字符串。例如，rtrim(' foobar ') 返回结果 'foobar'。 | rtrim('foobar')                          |
| sentences(string str, string lang, string locale) | 将一个自然语言文本字符串标记为单词和句子，每个句子在适当的句子边界被拆分并且作为一个单词数组返回。'lang' 和 'locale' 是可选参数。例如，sentences('Hello there! How are you?') 返回 ( (“Hello”, “there”), (“How”, “are”, “you”))。 | sentences('Hello there! How are you?')   |
| space(int n)                             | 返回 n 个空格的字符串。                            | space(3)                                 |
| split(string str, string pat)            | 从 pat 左右分解 str（ pat 是一个正则表达式）返回分解后的数据。           | split('abtcdtef','t')                    |
| substr(string/binary A, int start) substring(string/binary A, int start) | 返回从 start 位置到末尾的字符串 A 的子字符串或字节数组的部分。例如，substr('foobar', 4) 返回结果为 'bar'。 | substr('foobar', 4)                      |
| substr(string/binary A, int start, int len) substring(string/binary A, int start, int len) | 返回从 start 位置开始长度为 len 的 A 的字符串或字节数组的部分。例如，substr('foobar', 4, 1) 返回结果为 'b'。 | substr('foobar', 4, 1)                   |
| substring_index(string A, string delim, int count) | 返回字符串 A 中 delim 分隔符第 count 次匹配前的子字符串。如果 count 是正数，会返回所有到左边最后分隔符（从左边计算）的值。如果 count 是负数，会返回所有到右边最后分隔符（从右边计算）。当搜索 delim 时，Substring_index 是大小写敏感的。示例：substring_index('www.apache.org', '.', 2) = 'www.apache'。 | substring_index('www.apache.org', '.', 2) |
| trim(string A)                           | 返回从 A 两端去除空白字符后的字符串。例如，trim(' foobar ') 返回的结果为 'foobar'。 | trim('foobar')                           |
| upper(string A) ucase(string A)          | 返回转换字符串 A 中所有字符为大写后的字符串。例如，upper('fOoBaR') 返回的结果为 'FOOBAR'。 | upper('fOoBaR')                          |
| levenshtein(string A, string B)          | 返回两个字符串之间的 Levenshtein 距离。例如，levenshtein('kitten', 'sitting') 返回结果 3。 | levenshtein('kitten', 'sitting')         |
| soundex(string A)                        | 返回字符串的 soundex 码。例如，soundex('Miller') 结果为 M460。 | soundex('Miller')                        |


### 限制

1. MapR 6.1.0 以上版本，使用的 Hive 版本为 2.3，可计算列不支持返回类型为数组的函数定义为字符串类型

- `sentences(string str, string lang, string locale)`，返回类型为 `array<array<string>>`
- `split(string str, string pat)`，返回类型为 `array<string>`

> 可以选取字符串数组的元素定义为字符串类型的可计算列, 或者是将函数通过其他方式将返回值转成字符串来定义可计算列

2. 如果在构建过程中使用 SparkSQL，需要注意有些函数在 SparkSQL 中是不被支持的，比如 `field` 函数