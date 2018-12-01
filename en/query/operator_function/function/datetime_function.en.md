## Date and Time Functions

| Syntax                                       | Description                                                  | Example                                                      |
| -------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| LOCALTIME                                    | Returns the current date and time in the session time zone in a value of datatype TIME | ` LOCALTIME`<br />= 14:34:06                                 |
| LOCALTIMESTAMP                               | Returns the current date and time in the session time zone in a value of datatype TIMESTAMP | ` LOCALTIMESTAMP`<br /> = 2018-10-10 11:47:16                |
| CURRENT_TIME                                 | Returns the current time in the session time zone, in a value of datatype TIMESTAMP WITH TIME ZONE | ` CURRENT_TIME`<br /> = 11:47:41                             |
| CURRENT_DATE                                 | Returns the current date in the session time zone, in a value of datatype DATE | ` CURRENT_DATE`<br /> = 2018-10-10                           |
| CURRENT_TIMESTAMP                            | Returns the current date and time in the session time zone, in a value of datatype TIMESTAMP WITH TIME ZONE | ` CURRENT_TIMESTAMP`<br /> = 2018-10-10 11:48:19             |
| EXTRACT(timeUnit FROM datetime)              | Extracts and returns the value of a specified datetime field from a datetime value expression | `EXTRACT(minute FROM timestamp'2018-10-10 11:47:16')`<br /> = 47 |
| FLOOR(datetime TO timeUnit)                  | Rounds *datetime* down to *timeUnit*                         | Example 1:<br />` FLOOR(timestamp'2018-10-10 11:47:16' TO year)`<br /> = 2018-01-01 00:00:00<br /><br />Example 2:<br />`FLOOR(timestamp'2018-10-10 11:47:16' TO minute)`<br /> = 2018-10-10 11:47:00 |
| CEIL(datetime TO timeUnit)                   | Rounds *datetime* up to *timeUnit*                           | Example 1:<br />`CEIL(timestamp'2018-10-10 11:47:16' TO year)`<br /> = 2019-01-01 00:00:00<br /><br />Example 2:<br />`CEIL(timestamp'2018-10-10 11:47:16' TO minute)`<br /> = 2018-10-10 11:48:00 |
| YEAR(date)                                   | Equivalent to `EXTRACT(YEAR FROM date)`. Returns an integer. | ` YEAR(CURRENT_DATE)`<br /> = 2018                           |
| QUARTER(date)                                | Equivalent to `EXTRACT(QUARTER FROM date)`. Returns an integer between 1 and 4. | ` QUARTER(CURRENT_DATE)` <br /> = 4                          |
| MONTH(date)                                  | Equivalent to `EXTRACT(MONTH FROM date)`. Returns an integer between 1 and 12. | ` MONTH(CURRENT_DATE)`<br /> = 10                            |
| WEEK(date)                                   | Equivalent to `EXTRACT(WEEK FROM date)`. Returns an integer between 1 and 53. | ` WEEK(CURRENT_DATE)`<br /> = 41                             |
| DAYOFYEAR(date)                              | Equivalent to `EXTRACT(DOY FROM date)`. Returns an integer between 1 and 366. | `DAYOFYEAR(CURRENT_DATE)`<br /> = 283                        |
| DAYOFMONTH(date)                             | Equivalent to `EXTRACT(DAY FROM date)`. Returns an integer between 1 and 31. | ` DAYOFMONTH(CURRENT_DATE)`<br /> = 10                       |
| DAYOFWEEK(date)                              | Equivalent to `EXTRACT(DOW FROM date)`. Returns an integer between 1 and 7. | ` DAYOFWEEK(CURRENT_DATE)`<br /> = 4                         |
| HOUR(date)                                   | Equivalent to `EXTRACT(HOUR FROM date)`. Returns an integer between 0 and 23. | ` HOUR(CURRENT_TIME)`<br /> = 19                             |
| MINUTE(date)                                 | Equivalent to `EXTRACT(MINUTE FROM date)`. Returns an integer between 0 and 59. | ` MINUTE(CURRENT_TIME)`<br /> = 8                            |
| SECOND(date)                                 | Equivalent to `EXTRACT(SECOND FROM date)`. Returns an integer between 0 and 59. | ` SECOND(CURRENT_TIME)`<br /> = 49                           |
| TIMESTAMPADD(timeUnit, integer, datetime)    | Returns *datetime* with an interval of (signed) *integer* *timeUnit*s added. Equivalent to `datetime + INTERVAL 'integer' timeUnit` | Example 1: to get the next month<br />` TIMESTAMPADD(month, 1, CURRENT_DATE)`<br /> = 2018-11-10<br /><br />Example 2: to get the last day of this month<br />`TIMESTAMPADD(day, -(extract(day from CURRENT_DATE)), timestampadd(month,1,CURRENT_DATE))`<br /> = 2018-10-31 |
| TIMESTAMPDIFF(timeUnit, datetime, datetime2) | 以 `timeUnit` 为单位返回 `datetime` 和 `datetime2` 的时间差，<br />等同于 `(datetime2 - datetime)/timeUnit` | ` TIMESTAMPDIFF(day, date'2018-01-01', date '2018-10-10')`<br /> = 282 |

