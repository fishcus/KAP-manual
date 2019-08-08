## Supported Functions

The following are functions applicable to computed column, using Hive as an example.

**Note: The functions supported by computed column depend on the data source system you use.** This is because Kyligence Enterprise evaluates the computed columns by submitting SQL to the data source system, and it is the data source system that does the actual calculation.

- For Hive data source, please note the function support varies by Hive version. For example, function `factorial` and function `shiftleft` are only supported since Hive 1.2.0. Function `substring_index` are only supported since Hive 1.3.0. Please contact your Hadoop administrator to confirm your Hive version and the official list of supported functions.
- For RDBMS data source, please consult the official document provided by the RDBMS vendor to confirm supported functions.
- For Kafka data source, computed column is not supported at the moment.

Table of Contents

- [Mathematical Functions](#mathematical-functions)
- [Date Functions](#date-functions)
- [Type Conversion Functions](#type-conversion-functions)
- [Conditional Functions](#conditional-functions)
- [String Functions](#string-functions)



### Mathematical Functions {#mathematical-functions}

| Function Syntax                          | Description                              | Example                                  |
| ---------------------------------------- | ---------------------------------------- | ---------------------------------------- |
| round(DOUBLE a)                          | Returns the rounded `BIGINT` value of `a`. | round(10.5)                              |
| round(DOUBLE a, INT d)                   | Returns `a` rounded to `d` decimal places. | round(10.156, 2)                         |
| floor(DOUBLE a)                          | Returns the maximum `BIGINT` value that is equal to or less than `a`. | floor(10.15)                             |
| ceil(DOUBLE a), ceiling(DOUBLE a)        | Returns the minimum BIGINT value that is equal to or greater than `a`. | ceil(10.6), ceiling(10.6)                |
| factorial(INT a)                         | Returns the factorial of `a`. Valid `a` is [0..20]. | factorial(10)                            |
| unhex(STRING a)                          | Inverse of hex. Interprets each pair of characters as a hexadecimal number and converts to the byte representation of the number. | unhex(616263)                            |
| ln(DOUBLE a), ln(DECIMAL a)              | Returns the natural logarithm of theargument a. Decimal version added in [Hive 0.13.0](https://issues.apache.org/jira/browse/HIVE-6327). | ln(10.15), ln(10.5)                      |
| hex(BIGINT a), hex(STRING a), hex(BINARY a) | If the argument is an `INT` or `binary`, `hex` returns the number as a `STRING` in hexadecimal format. Otherwise if the number is a `STRING`,it converts each character into its hexadecimal representation and returns theresulting `STRING`. | hex('abc'), hex(255)                     |
| rand(), rand(INT seed)                   | Returns a random number (that changes from row to row) that is distributed uniformly from 0 to 1. Specifying the seed will make sure the generated random number sequence is deterministic. | rand(), rand(1)                          |
| exp(DOUBLE a), exp(DECIMAL a)            | Returns `e`[^a] where `e` is the base of the natural logarithm. | exp(10.15), exp(10.5)                    |
| log10(DOUBLE a), log10(DECIMAL a)        | Returns the base-10 logarithm of the argument `a`. | log10(10.15), log10(2.5)                 |
| log2(DOUBLE a), log2(DECIMAL a)          | Returns the base-2 logarithm of the argument `a`. | log2(2.15), log2(2.5)                    |
| log(DOUBLE base, DOUBLE a), log(DECIMAL base, DECIMAL a) | Returns the base-`base` logarithm of the argument `a`. | log(10.15, 2.15), log(10.5, 2.5)         |
| pow(DOUBLE a, DOUBLE p), power(DOUBLE a, DOUBLE p) | Returns `a`[^p].                         | pow(10.15, 2.15), power(10.15, 2.15)     |
| sqrt(DOUBLE a), sqrt(DECIMAL a)          | Returns the square root of `a`.          | sqrt(2.15), sqrt(2.5)                    |
| abs(DOUBLE a)                            | Returns the absolute value.              | abs(2.15)                                |
| sin(DOUBLE a), sin(DECIMAL a)            | Returns the sine of `a` (`a` is in radians). | sin(2.15), sin(2.5)                      |
| asin(DOUBLE a), asin(DECIMAL a)          | Returns the arc sin of `a` if -1<=a<=1 or NULL otherwise. | asin(0.15), asin(0.5)                    |
| cos(DOUBLE a), cos(DECIMAL a)            | Returns the cosine of `a` (`a` is in radians). | cos(1.15), cos(1.5)                      |
| acos(DOUBLE a), acos(DECIMAL a)          | Returns the arccosine of `a` if -1<=a<=1 or NULL otherwise. | acos(0.15), acos(0.5)                    |
| tan(DOUBLE a), tan(DECIMAL a)            | Returns the tangent of `a` (`a` is in radians). | tan(1.15), tan(1.5)                      |
| atan(DOUBLE a), atan(DECIMAL a)          | Returns the arctangent of `a`.           | atan(1.15), atan(1.5)                    |
| degrees(DOUBLE a), degrees(DECIMAL a)    | Converts value of `a` from radians to degrees. | degrees(10.15), degrees(10.5)            |
| radians(DOUBLE a), radians(DECIMAL a)    | Converts value of `a` from degrees to radians. | radians(10.15), radians(10.5)            |
| e()                                      | Returns the value of `e`.                | e()                                      |
| pi()                                     | Returns the value of `pi`.               | pi()                                     |
| cbrt(DOUBLE a)                           | Returns the cube root of `a` double value. | cbrt(10.15)                              |
| sign(DOUBLE a), sign(DECIMAL a)          | Returns the sign of `a` as '1.0' (if `a` is positive) or '-1.0' (if `a` is negative), '0.0' otherwise. The decimal version returns INT instead of DOUBLE. | sign(10.15), sign(10.5)                  |
| pmod(INT a, INT b), pmod(DOUBLE a, DOUBLE b) | Returns the positive value of `a mod b`. | pmod(10, 7), pmod(10.15, 5.15)           |
| positive(INT a), positive(DOUBLE a)      | Returns `a`.                             | positive(10), positive(10.15)            |
| negative(INT a), negative(DOUBLE a)      | Returns `-a`.                            | negative(10), negative(10.15)            |
| shiftleft(TINYINT/SMALLINT/INT a, INT b), shiftleft(BIGINT a, INT b) | Bitwise left shift. Shifts `a` `b` positions to the left. Returns int for tinyint, smallint and int `a`. Returns bigint for bigint `a`. | shiftleft(10, 5), shiftleft(20, 5)       |
| shiftright(TINYINT/SMALLINT/INT a, INT b), shiftright(BIGINT a, INT b) | Bitwise right shift. Shifts `a` `b` positions to the right. Returns int for tinyint, smallint and int `a`. Returns bigint for bigint `a`. | shiftright(10, 5), shiftright(20, 5)     |
| shiftrightunsigned(TINYINT/SMALLINT/INTa, INT b),shiftrightunsigned(BIGINT a, INT b) | Bitwise unsigned right shift. Shifts `a` `b` positions to the right. Returns int for tinyint, smallint and int `a`. Returns bigint for bigint `a`. | shiftrightunsigned(10, 5), shiftrightunsigned(20, 5) |
| bin(BIGINT a)                            | Returns the number in binary format.     | bin(10)                                  |
| conv(BIGINT num, INT from_base, INT to_base) | Converts a number from a given base to another | conv(-17,10,-18)                         |
| greatest(T v1, T v2, ...)                | Returns the greatest value of the list of values. | greatest(5,10,15)                        |
| least(T v1, T v2, ...)                   | Returns the least value of the list of values | least(5,10,15)                           |



### Date Functions {#date-functions}

| Function Syntax                          | Description                              | Example                                  |
| :--------------------------------------- | ---------------------------------------- | ---------------------------------------- |
| from_unixtime(bigint unixtime[, string format]) | Converts the number of seconds from unix epoch (1970-01-01 00:00:00 UTC) to a string representing the timestamp of that moment in the current system time zone in the format of "1970-01-01 00:00:00". | from_unixtime(1514719868)                |
| unix_timestamp()                         | Gets current Unix timestamp in secons. This function is not deterministic and its value is not fixed for the scope of a query execution, therefore prevents proper optimization of queries - this has been deprecated in favour of CURRENT_TIMESTAMP constant. | unix_timestamp()                         |
| unix_timestamp(string date)              | Converts time string in format `yyyy-MM-dd HH:mm:ss` to Unix timestamp (in seconds), using the default timezone and the default locale, return 0 if fail. | unix_timestamp('2009-03-20 11:30:01')    |
| unix_timestamp(string date, string pattern) | Convert time string with given pattern to Unix time stamp (in seconds), return 0 if fail: unix_timestamp('2009-03-20', 'yyyy-MM-dd') = 1237532400. | unix_timestamp('2009-03-20', 'yyyy-MM-dd') |
| to_date(string timestamp)                | Returns the date part of  a timestamp string (pre-Hive 2.1.0): to_date('1970-01-01 00:00:00')  = '1970-01-01'. As of Hive 2.1.0, returns a date object. | to_date('2012-01-01  00:00:00')          |
| year(string date)                        | Returns the year part of a date or a timestamp string: year('1970-01-01 00:00:00') = 1970. | year('2012-01-01 00:00:00')              |
| month(string date)                       | Returns the month part of a date or a timestamp string: month('1970-11-01 00:00:00') = 11. | month('2012-11-01 00:00:00')             |
| hour(string date)                        | Returns the hour of the timestamp: hour('2009-07-30 12:58:59') = 12. | hour('2009-07-30 12:58:59')              |
| minute(string date)                      | Returns the minute of the timestamp.     | minute('2009-07-30 12:58:59')            |
| second(string date)                      | Returns the second of the timestamp.     | second('2009-07-30 12:58:59')            |
| weekofyear(string date)                  | Returns the week number of a timestamp string: weekofyear('1970-11-01 00:00:00') = 44. | weekofyear('1970-11-01 00:00:00')        |
| datediff(string enddate, string startdate) | Returns the number of days from startdate to enddate: datediff('2009-03-01', '2009-02-27') = 2. | datediff('2009-03-01', '2009-02-27')     |
| date_add(date/timestamp/string startdate, tinyint/smallint/int days) | Adds a number of days to startdate: date_add('2008-12-31', 1) = '2009-01-01'. | date_add('2008-12-31', 1)                |
| date_sub(date/timestamp/string startdate, tinyint/smallint/int days) | Subtracts a number of days to startdate: date_sub('2008-12-31', 1) = '2008-12-30'. | date_sub('2008-12-31', 1)                |
| from_utc_timestamp({any primitive type}*, string timezone) | Coverts a timestamp* in UTC to a given timezone. * timestamp is a primitive type, including timestamp/date, tinyint/smallint/int/bigint, float/double and decimal. Fractional values are considered as seconds. Integer values are considered as milliseconds.. E.g from_utc_timestamp(2592000.0,'PST'), from_utc_timestamp(2592000000,'PST') and from_utc_timestamp(timestamp '1970-01-30 16:00:00','PST') all return the timestamp 1970-01-30 08:00:00 | from_utc_timestamp(2592000.0,'PST')      |
| to_utc_timestamp({any primitive type} ts, string timezone) | Coverts a timestamp* in a given timezone to UTC. * timestamp is a primitive type, including timestamp/date, tinyint/smallint/int/bigint, float/double and decimal. Fractional values are considered as seconds. Integer values are considered as milliseconds.. E.g to_utc_timestamp(2592000.0,'PST'), to_utc_timestamp(2592000000,'PST') and to_utc_timestamp(timestamp '1970-01-30 16:00:00','PST') all return the timestamp 1970-01-31 00:00:00 | to_utc_timestamp(2592000.0,'PST')        |
| current_date                             | Returns the current date at the start of query evaluation. All calls of current_date within the same query return the same value. | current_date()                           |
| current_timestamp                        | Returns the current timestamp at the start of query evaluation. All calls of current_timestamp within the same query return the same value. | current_timestamp()                      |
| add_months(string start_date, int num_months) | Returns the date that is num_months after start_date. start_date is a string, date or timestamp. num_months is an integer. The time part of start_date is ignored. If start_date is the last day of the month or if the resulting month has fewer days than the day component of start_date, then the result is the last day of the resulting month. Otherwise, the result has the same day component as start_date. | add_months('2015-01-14', 5)              |
| last_day(string date)                    | Returns the last day of the month which the date belongs to. date is a string in the format 'yyyy-MM-dd HH:mm:ss' or 'yyyy-MM-dd'. The time part of date is ignored. | last_day('2009-07-30 12:58:59')          |
| next_day(string start_date, string day_of_week) | Returns the first date which is later than start_date and named as day_of_week. start_date is a string/date/timestamp. day_of_week is 2 letters, 3 letters or full name of the day of the week (e.g. Mo, tue, FRIDAY). The time part of start_date is ignored. Example: next_day('2015-01-14', 'TU') = 2015-01-20. | next_day('2015-01-14', 'TU')             |
| trunc(string date, string format)        | Returns date truncated to the unit specified by the format. Supported formats: MONTH/MON/MM, YEAR/YYYY/YY. Example: trunc('2015-03-17', 'MM') = 2015-03-01. | trunc('2015-03-17', 'MM')                |
| months_between(date1, date2)             | Returns number of months between dates date1 and date2. If date1 is later than date2, then the result is positive. If date1 is earlier than date2, then the result is negative. If date1 and date2 are either the same days of the month or both last days of months, then the result is always an integer. Otherwise the UDF calculates the fractional portion of the result based on a 31-day month and considers the difference in time components date1 and date2. date1 and date2 type can be date, timestamp or string in the format 'yyyy-MM-dd' or 'yyyy-MM-dd HH:mm:ss'. The result is rounded to 8 decimal places. Example: months_between('1997-02-28 10:30:00', '1996-10-30') = 3.94959677 | months_between('2013-02-28 10:30:00', '2012-10-30') |
| date_format(date/timestamp/string ts, string fmt) | Converts a date/timestamp/string to a value of string in the format specified by the date format fmt. Supported formats are Java SimpleDateFormat formats –  The second argument fmt should be constant. Example: date_format('2015-04-08', 'y') = '2015'. | date_format('2015-04-08', 'y')           |



### Type Conversion Functions {#type-conversion-functions}

| Function Syntax      | Description                              | Example             |
| -------------------- | ---------------------------------------- | ------------------- |
| cast(expr as <type>) | Converts the results of the expression expr to <type>. For example, cast('1' as BIGINT) will convert the string '1' to its integral representation. A null is returned if the conversion does not succeed. If cast(expr as boolean) Hive returns true for a non-empty string. | cast('1' as BIGINT) |



### Conditional Functions {#conditional-functions}

| Function Syntax                | Description                              | Example           |
| ------------------------------ | ---------------------------------------- | ----------------- |
| isnull( a )                    | Returns true if a is NULL and false otherwise. | isnull(NULL)      |
| isnotnull ( a )                | Returns true if a is not  NULL and false otherwise. | isnotnull(1)      |
| nvl(T value, T default_value)  | Returns default value if value is null else returns value. | nvl(null, 30)     |
| COALESCE(T v1, T v2, ...)      | Returns the first v that is not NULL, or NULL if all v's are NULL. | COALESCE(null,30) |
| assert_true(boolean condition) | Throw an exception if 'condition' is not true, otherwise return null. For example, select assert_true (2<1). | assert_true (2<1) |



### String Functions {#string-functions}

| Function Syntax                          | Description                              | Example                                  |
| ---------------------------------------- | ---------------------------------------- | ---------------------------------------- |
| ascii(string str)                        | Returns the numeric value of the first character of str. | ascii('abcde')                           |
| concat(string/binary A, string/binary B…) | Returns the string or bytes resulting from concatenating the strings or bytes passed in as parameters in order. | concat('foo', 'bar')                     |
| concat_ws(string SEP, string A, string B...) | Like concat() above, but with custom separator SEP. | concat_ws(',','abc','def','gh')          |
| elt(N int,str1 string,str2 string,str3 string,...) | Return string at index number. For example elt(2,'hello','world') returns 'world'. Returns NULL if N is less than 1 or greater than the number of arguments. | elt(2,'hello','world')                   |
| field(val T,val1 T,val2 T,val3 T,...)    | Returns the index of val in the val1,val2,val3,... list or 0 if not found. For example field('world','say','hello','world') returns 3.All primitive types are supported, arguments are compared using str.equals(x). If val is NULL, the return value is 0. | field('world','say','hello','world')     |
| find_in_set(string str, string strList)  | Returns the first occurance of str in strList where strList is a comma-delimited string. Returns null if either argument is null. Returns 0 if the first argument contains any commas. For example, find_in_set('ab', 'abc,b,ab,c,def') returns 3. | find_in_set('ab', 'abc,b,ab,c,def')      |
| format_number(number x, int d)           | Formats the number X to a format like '#,###,###.##', rounded to D decimal places, and returns the result as a string. If D is 0, the result has no decimal point or fractional part. | format_number(12.35, 1)                  |
| instr(string str, string substr)         | Returns the position of the first occurrence of `substr` in `str`. Returns `null` if either of the arguments are `null` and returns `0` if `substr` could not be found in `str`. Be aware that this is not zero based. The first character in `str` has index 1. | instr('I like this game', 'like')        |
| length(string A)                         | Returns the length of the string.        | length('abcdef')                         |
| locate(string substr, string str[, int pos]) | Returns the position of the first occurrence of substr in str after position pos. | locate('I like this game', 'like')       |
| lower(string A) lcase(string A)          | Returns the string resulting from converting all characters of B to lower case. For example, lower('fOoBaR') results in 'foobar'. | lower('fOoBaR')                          |
| lpad(string str, int len, string pad)    | Returns str, left-padded with pad to a length of len. If str is longer than len, the return value is shortened to len characters. In case of empty pad string, the return value is null. | lpad('abc',10,'td')                      |
| ltrim(string A)                          | Returns the string resulting from trimming spaces from the beginning(left hand side) of A. For example, ltrim(' foobar ') results in 'foobar '. | ltrim('foobar')                          |
| regexp_extract(string subject, string pattern, int index) | Returns the string extracted using the pattern. For example, regexp_extract('foothebar', 'foo(.*?)(bar)', 2) returns 'bar.' Note that some care is necessary in using predefined character classes: using '\s' as the second argument will match the letter s; '\\s' is necessary to match whitespace, etc. The 'index' parameter is the Java regex Matcher group() method index. | regexp_extract('foothebar', 'foo(.*?)(bar)', 2) |
| regexp_replace(string INITIAL_STRING, string PATTERN, string REPLACEMENT) | Returns the string resulting from replacing all substrings in INITIAL_STRING that match the java regular expression syntax defined in PATTERN with instances of REPLACEMENT. | regexp_replace('foobar', 'oo\ar', '')    |
| repeat(string str, int n)                | Repeats str n times.                     | repeat('abc', 3)                         |
| reverse(string A)                        | Returns the reversed string.             | reverse('abc')                           |
| rpad(string str, int len, string pad)    | Returns str, right-padded with pad to a length of len. If str is longer than len, the return value is shortened to len characters. In case of empty pad string, the return value is null. | rpad('abc',10,'td')                      |
| rtrim(string A)                          | Returns the string resulting from trimming spaces from the end(right hand side) of A. For example, rtrim(' foobar ') results in ' foobar'. | rtrim('foobar')                          |
| sentences(string str, string lang, string locale) | Tokenizes a string of natural language text into words and sentences, where each sentence is broken at the appropriate sentence boundary and returned as an array of words. The 'lang' and 'locale' are optional arguments. For example, sentences('Hello there! How are you?') returns ( ("Hello", "there"), ("How", "are", "you") ). | sentences('Hello there! How are you?')   |
| space(int n)                             | Returns a string of n spaces.            | space(3)                                 |
| split(string str, string pat)            | Splits str around pat (pat is a regular expression). | split('abtcdtef','t')                    |
| substr(string/binary A, int start) substring(string/binary A, int start) | Returns the substring or slice of the byte array of A starting from start position till the end of string A. | substr('foobar', 4)                      |
| substr(string/binary A, int start, int len) substring(string/binary A, int start, int len) | Returns the substring or slice of the byte array of A starting from start position with length len. | substr('foobar', 4, 1)                   |
| substring_index(string A, string delim, int count) | Returns the substring from string A before count occurrences of the delimiter delim. If count is positive, everything to the left of the final delimiter (counting from the left) is returned. If count is negative, everything to the right of the final delimiter (counting from the right) is returned. Substring_index performs a case-sensitive match when searching for delim. | substring_index('www.apache.org', '.', 2) |
| trim(string A)                           | Returns the string resulting from trimming spaces from both ends of A. For example, trim(' foobar ') results in 'foobar' | trim('foobar')                           |
| upper(string A) ucase(string A)          | Returns the string resulting from converting all characters of A to upper case. For example, upper('fOoBaR') results in 'FOOBAR'. | upper('fOoBaR')                          |
| levenshtein(string A, string B)          | Returns the Levenshtein distance between two strings. For example, levenshtein('kitten', 'sitting') results in 3. | levenshtein('kitten', 'sitting')         |
| soundex(string A)                        | Returns soundex code of the string. For example, soundex('Miller') results in M460. | soundex('Miller')                        |

