
## Kyligence Enterprise 概览

Kyligence Enterprise是Kyligence提供的基于Apache Kylin的企业级大数据智能分析平台，在PB级数据集上提供亚秒级标准SQL查询响应，支持互联网级的高并发访问，赋能分析师以行业标准的数据仓库和商业智能方法论架构DW on Hadoop解决方案。Kyligence Enterprise为商业用户、分析师和工程师提供了统一的分析平台，支持自助式建模，无需编程，并与主流BI工具实现无缝集成，在开源Apache Kylin核心功能之外，在企业用户所关注的实施效率、安全控制、性能优化、自助式敏捷BI、系统监控和管理等方面进行了全面创新和增强。作为Hadoop上的原生OLAP解决方案，Kyligence Enterprise基于Hadoop标准接口与集群交互，兼容主流Hadoop发行版，支持私有数据中心及云端部署安装。

**KyStorage：高效的列式存储引擎，支持明细数据查询**

*KyStorage*是Kyligence研发的基于HDFS的列式存储引擎，支持多路复合索引，针对超高基数维度、复杂过滤条件等的场景进行了专门优化，相对*Apache Kylin*，查询性能有几倍到几十倍的提升，在存储空间上也有超过50％的节省。

基于*KyStorage*列式存储引擎，及倒排索引等多种索引技术，突破了传统OLAP引擎仅能查询聚合数据的局限，全面地支持了明细数据的查询，优化了对宽表的支持，降低了数据建模的难度，更好地服务数据探索式分析场景。

**KyStudio：交互式建模平台**

*KyStudio*以model为中心，支持直观的拖拽式建模流程，支持增强的语义层建模，简化与BI工具的模型对接。支持多种辅助建模和优化算法，不断提升建模效率和效果。

**KyAnalyzer：敏捷BI自助多维分析工具**

内置敏捷BI平台*KyAnalyzer*，用户仅需浏览器，以熟悉的可拖拽方式交互地探复杂数据源，支持钻取，上卷，切片，切块，旋转等多维分析方法，支持数十种可视化报表技术，简易地多格式数据分享，极大地提高了业务人员分析大数据的效率。

**更多企业级功能**

支持开箱即用的用户管理及单元格级别的访问控制方式，可与用户已有访问认证体系深度集成，保证数据访问的可管理性、可追溯性。

**兼容主流Hadoop发行版**

Kyligence Enterprise兼容开源Hadoop及主流商业Hadoop发行版，可运行在*Apache Hadoop*，*Hortonworks HDP*，*Microsoft HDInsight*，*AWS EMR*，*华为FusionInsight*等发行版和平台，并与*Cloudera CDH* 实现了产品相互认证。



![Kyligence Enterprise Portofilio](images/kap_portofilio.png)



### Kyligence Enterprise与Apache Kylin比较

![Kyligence Enterprise Portofilio](images/compare.png)