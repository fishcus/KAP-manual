



## KyAnalyzer 配置项

本节介绍 KyAnalyzer 的常用配置项。KyAnalyzer 通过安装路径下*conf* 文件夹中的 kyanalyzer.properties 和 mondrian.properties 进行配置。下面详细介绍这两个配置文件中的配置项。

> 注意：以下配置项修改后，必需重启 KyAnalyzer 服务器才能使更改生效。

###kyanalyzer.properties 的配置项

**kyanalyzer.olap.nonempty**

该参数指定是否隐藏查询中为空的结果，默认进行隐藏，默认值为 `true`。

**kyanalyzer.web.export.csv.name**

该参数指定导出查询结果为 csv 文件的文件名，默认值为 `kyanalyzer-export`。

**kyanalyzer.web.export.excel.name**

该参数指定导出查询结果为 excel 文件的文件名，默认值为 `kyanalyzer-export`。

**kyanalyzer.web.export.excel.format**

该参数指定导出查询结果为 excel 文件的文件格式（xls 或 xlsx），默认值为 `xlsx`。

**kyanalyzer.web.export.excel.numberformat**

该参数指定导出查询结果为 excel 文件的数据格式，默认值为 `#,##0.00`，保留两位小数。

**kyanalyzer.format.numberformat**

该参数指定查询数据的格式，默认值为 `#,##0.00`，保留两位小数。

**kap.host**

该参数指定 Kyligence Enterprise 的 IP 地址或域名，默认值为 `localhost`。

**kap.port**

该参数指定 Kyligence Enterprise 的端口，默认值为 `7070`。

###mondrian.properties 的配置项

**mondrian.result.limit**

该参数指定生成结果的最大行数，默认值为 `50000`。

**mondrian.olap.case.sensitive**

该参数指定查询是否对大小写敏感，默认为敏感，默认值为 `true`。

 **mondrian.rolap.cellBatchSize**

该参数指定单次查询的最大数据量，默认值为 `100000`。

 **mondrian.rolap.generate.formatted.sql**

该参数指定是否对产生的 sql 格式化，默认进行格式化，默认值为 `true`。

**mondrian.rolap.star.disableCaching**

该参数指定是否禁用缓存，默认值为 `false`。



