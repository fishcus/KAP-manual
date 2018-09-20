## KyAnalyzer Configurations

This section introduces KyAnalyzer's configurations. KyAnalyzer is configurable through the file of kyanalyzer.properties and mondrian.properties under the KyAnalyzer installation directory of *conf*. In the following, we will describe the two configuration files in details:

> Tips: Once you modify any of the following configurations, you shall restart KyAnalyzer server to make the modification effect.

###Configurations of kyanalyzer.properties

**kyanalyzer.olap.nonempty**

Specify if the empty result is hidden in the query. The default value is  `true`.

**kyanalyzer.web.export.csv.name**

Specify the name of csv file exported from the query result. The default value is  `kyanalyzer-export`.

**kyanalyzer.web.export.excel.name**

Specify the name of excel file exported from the query result. The default value is `kyanalyzer-export`.

**kyanalyzer.web.export.excel.format**

Specify the format of excel file (xls or xlsx) exported from the query result. The default value is `xlsx`.

**kyanalyzer.web.export.excel.numberformat**

Specify the number format in the excel file exported from query result. The default value is `#,##0.00`. The value is rounded to two decimal places.

**kyanalyzer.format.numberformat**

Specify the number format in the query. The default value is  `#,##0.00`. The value is rounded to two decimal places.

**kap.host**

Specify IP address or domain of Kyligence Enterprise. The default value is  `localhost`.

**kap.port**

Specify the port of Kyligence Enterprise. The default value is `7070`.

###Configurations of mondrian.properties

**mondrian.result.limit**

Specify the maximum number of rows in the generated result. The default value is  `50000`.

**mondrian.olap.case.sensitive**

Specify if the query is case sensitive. The default value is  `true`.

 **mondrian.rolap.cellBatchSize**

Specify the maximum amount of data in one query. The default value is `100000`.

 **mondrian.rolap.generate.formatted.sql**

Specify if the generated sql is formatted or not. The default value is  `true`.

**mondrian.rolap.star.disableCaching**

Specify if the query cache is disabled. The default value is `false`.

