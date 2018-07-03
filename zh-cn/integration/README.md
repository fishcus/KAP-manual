## BI常见工具连接Kyligence Enterprise

本章将介绍如何使用第三方BI工具与Kyligence Enterprise连接。

继续阅读：

[Tableau](tableau.cn.md)

[Excel ](excel_2016.cn.md)

[Power BI](powerbi.cn.md)

[Apache Zeppelin](zeppelin.cn.md)

[Cognos](cognos.cn.md)

[MicroStrategy](microstrategy_10_4.cn.md)

[Qlik Sense](qlik.cn.md)

[Smartbi](smartbi.cn.md)

[Fanruan](fanruan.cn.md)

[SAP BO](sap_bo.cn.md)

[OBIEE](obiee.cn.md)



> 注意：当您连接BI工具时，部分BI工具会发送全表查询语句如下： 
>
> ```sql
> select * from fact_table;
> ```
>
> 如果表数据量较大，会造成查询返回时间过长， 建议您根据自身需求配置项目参数进行优化。比如通过调整`kylin.query.force-limit ` 以限制返回记录数。