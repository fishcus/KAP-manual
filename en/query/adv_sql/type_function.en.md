## Type Functions

| Syntax                | Description                                                        | Example                                                        |
| ------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| CAST(value AS type) | Converts a value to a given type. | Example 1: Converts `time` to `string`<br />`CAST(CURRENT_DATE as varchar)`<br /> = 2018-10-10 |
| DATE \<string\>     | Converts a string to DATE type,<br />equaling to CAST(string AS date) | Example 1:<br />`DATE'2018-10-10'`<br /> = 2018-10-10<br /><br />Example 2: Gets the corresponding month of the string (use with time function, MONTH() )<br />`MONTH(DATE'2018-10-10')`<br /> = 10 |
| TIMESTAMP \<string\> | Converts a string to TIMESTAMP type,<br />equaling to CAST(string AS timestamp) | Example 1:<br />`TIMESTAMP'2018-10-10 15:57:07`<br /> = 2018-10-10 15:57:07<br /><br />Example 2: Gets the corresponding second of the string (use with time function, SECOND() )<br />`SECOND(TIMESTAMP'2018-10-10 15:57:07')`<br /> = 7 |

