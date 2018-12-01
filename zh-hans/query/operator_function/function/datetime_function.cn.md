## 日期函数

| 语法                                         | 描述                                                         | 示例                                                         |
| -------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| LOCALTIME                                    | 返回当前时区的时间。<br />返回类型为 TIME 格式               | ` LOCALTIME`<br />= 14:34:06                                 |
| LOCALTIMESTAMP                               | 返回当前时区的日期时间。<br />返回类型为 TIMESTAMP 格式      | ` LOCALTIMESTAMP`<br /> = 2018-10-10 11:47:16                |
| CURRENT_TIME                                 | 返回当前时区的时间。<br />返回类型为 TIMESTAMP 格式          | ` CURRENT_TIME`<br /> = 11:47:41                             |
| CURRENT_DATE                                 | DATE 返回当前时区的日期。<br />返回类型为 DATE 格式          | ` CURRENT_DATE`<br /> = 2018-10-10                           |
| CURRENT_TIMESTAMP                            | 返回当前时区的日期时间。<br />返回类型为 TIMESTAMP 格式      | ` CURRENT_TIMESTAMP`<br /> = 2018-10-10 11:48:19             |
| EXTRACT(timeUnit FROM datetime)              | 提取返回日期中的指定项。 <br />`timeunit` 可以为：<br /> `year`、`month`、`day`、<br />`hour`、`minute`、`second` | `EXTRACT(minute FROM timestamp'2018-10-10 11:47:16')`<br /> = 47 |
| FLOOR(datetime TO timeUnit)                  | 以 `timeUnit` 为单位对 `datetime` 向下取整。<br />`timeunit` 可以为：<br /> `year`、`month`、`day`、<br />`hour`、`minute`、`second` | 示例 1：<br />` FLOOR(timestamp'2018-10-10 11:47:16' TO year)`<br /> = 2018-01-01 00:00:00<br /><br />示例 2：<br />`FLOOR(timestamp'2018-10-10 11:47:16' TO minute)`<br /> = 2018-10-10 11:47:00 |
| CEIL(datetime TO timeUnit)                   | 以 `timeUnit` 为单位对 `datetime` 向上取整。<br />`timeunit` 可以为：<br /> `year`、`month`、`day`、<br />`hour`、`minute`、`second` | 示例 1：<br />`CEIL(timestamp'2018-10-10 11:47:16' TO year)`<br /> = 2019-01-01 00:00:00<br /><br />示例 2：<br />`CEIL(timestamp'2018-10-10 11:47:16' TO minute)`<br /> = 2018-10-10 11:48:00 |
| YEAR(date)                                   | 返回日期中的年份，<br />等同于`EXTRACT(YEAR FROM date)`。    | ` YEAR(CURRENT_DATE)`<br /> = 2018                           |
| QUARTER(date)                                | 返回日期中的季度，<br /><br />等同于`EXTRACT(QUARTER FROM date)`。返回值为 1 到 4 的整数 | ` QUARTER(CURRENT_DATE)` <br /> = 4                          |
| MONTH(date)                                  | 返回日期中的月份，<br />等同于 `EXTRACT(MONTH FROM date)`。<br />返回值为 1 到 12 的整数 | ` MONTH(CURRENT_DATE)`<br /> = 10                            |
| WEEK(date)                                   | 返回日期中对应的星期，<br />等同于 `EXTRACT(WEEK FROM date)`。<br />返回值为 1 到 53 的整数 | ` WEEK(CURRENT_DATE)`<br /> = 41                             |
| DAYOFYEAR(date)                              | 返回日期对应年的天数，<br />等同于 `EXTRACT(DOY FROM date)`。<br />返回值为 1 到 366 的整数 | `DAYOFYEAR(CURRENT_DATE)`<br /> = 283                        |
| DAYOFMONTH(date)                             | 返回日期对应月的天数，<br />等同于`EXTRACT(DAY FROM date)`。<br />返回值为 1 到 31 | ` DAYOFMONTH(CURRENT_DATE)`<br /> = 10                       |
| DAYOFWEEK(date)                              | 返回日期对应的星期几，<br />等同于 `EXTRACT(DOW FROM date)`。<br />返回值为 1 到 7 的整数 | ` DAYOFWEEK(CURRENT_DATE)`<br /> = 4                         |
| HOUR(date)                                   | 返回日期中的小时数，<br />等同于 `EXTRACT(HOUR FROM date)`。返回值为 0 到 23 的整数 | ` HOUR(CURRENT_TIME)`<br /> = 19                             |
| MINUTE(date)                                 | 返回日期中的分钟数，<br />等同于 `EXTRACT(MINUTE FROM date)`。<br />返回结果为 0 到 59 的整数 | ` MINUTE(CURRENT_TIME)`<br /> = 8                            |
| SECOND(date)                                 | 返回日期中的秒数，<br />等同于 `EXTRACT(SECOND FROM date)`。<br />返回结果为 0 到 59 的整数 | ` SECOND(CURRENT_TIME)`<br /> = 49                           |
| TIMESTAMPADD(timeUnit, integer, datetime)    | 返回添加了  `timeUnit` 为单位的时间 `integer` 后的日期 `datetime`，<br />等同于 `datetime + INTERVAL 'integer' timeUnit` 。<br />返回类型为 `datetime` | 示例 1：获取一个月后的日期时间` TIMESTAMPADD(month, 1, CURRENT_DATE)`<br /> = 2018-11-10<br /><br />示例 2：获取本月最后一天<br />`TIMESTAMPADD(day, -(extract(day from CURRENT_DATE)), timestampadd(month,1,CURRENT_DATE))`<br /> = 2018-10-31 |
| TIMESTAMPDIFF(timeUnit, datetime, datetime2) | 以 `timeUnit` 为单位返回 `datetime` 和 `datetime2` 的时间差，<br />等同于 `(datetime2 - datetime)/timeUnit` | ` TIMESTAMPDIFF(day, date'2018-01-01', date '2018-10-10')`<br /> = 282 |

