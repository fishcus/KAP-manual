## 系统配置

本章将介绍Kyligence Enterprise配置文件，详细配置项，推荐配置以及配置重写等内容。

Kyligence Enterprise在集群结点上安装完毕后，还需要对Kyligence Enterprise的参数进行配置，以便将Kyligence Enterprise接入现有的Apache Hadoop、Apache HBase、Apache Hive环境中，并根据实际环境条件对Kyligence Enterprise进行性能优化。

### Kyligence Enterprise配置文件一览表

|组件名|文件名|描述|
|---|---|---|
|Kylingence Enterprise|kylin.properties|该文件是Kyligence Enterprise使用的全局配置文件，和Kyligence Enterprise有关的配置项都在此文件中。具体配置项在下文中详述。|
|Kylingence Enterprise|kylin\_hive\_conf.xml|该文件包含了Hive任务的配置项。在构建Cube的第一步通过Hive生成中间表时，会根据该文件的设置调整Hive的配置参数。|
|Kylingence Enterprise|kylin\_job\_conf\_inmem.xml|该文件包含了Map Reduce任务的配置项。当Cube构建算法是Fast Cubing时，会根据该文件的设置调整构建任务中的Map Reduce参数。|
|Kylingence Enterprise|kylin\_job\_conf.xml|该文件包含了Map Reduce任务的配置项。当kylin\_job\_conf\_inmem.xml不存在，或Cube构建算法是Layer Cubing时，会根据该文件的设置调整构建任务中的Map Reduce参数。|
|Hadoop|core-site.xml|该文件是Hadoop使用的全局配置文件，用于定义系统级别的参数，如HDFS URL、Hadoop临时目录等。|
|Hadoop|hdfs-site.xml|该文件用于配置HDFS参数，如NameNode与DataNode存放位置、文件副本个数、文件读取权限等。|
|Hadoop|yarn-site.xml|该文件用于配置Hadoop集群资源管理系统参数，如ResourceManader与NodeManager的通信端口，web监控端口等。|
|Hadoop|mapred-site.xml|该文件用于配置Map Reduce参数，如reduce任务的默认个数，任务所能够使用内存的默认上下限等。|
|Hbase|hbase-site.xml|该文件用于配置Hbase运行参数，如master机器名与端口号，根数据存放位置等。|
|Hive|hive-site.xml|该文件用于配置Hive运行参数，如hive数据存放目录，数据库地址等。|

>注意：
>+ 若无特殊说明，本手册中出现的配置文件如`kylin.properties`均指代一览表中相应的配置文件。
>+ 您可以在系统启动后从`$KYLIN_HOME/logs/kylin.log`文件中获取一览表中各配置文件路径，日志格式如`/kylin/conf/kylin.properties is used as kylin.properties`。
