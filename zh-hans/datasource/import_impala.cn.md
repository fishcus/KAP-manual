## 导入 Impala 数据源

本产品从 3.2 版本开始支持 Impala 作为数据源。



### 准备工作

连接 Impala 数据源，需要先完成相关驱动程序下载准备工作:

- 下载官方 [Impala JDBC 驱动程序](https://www.cloudera.com/downloads/connectors/impala/jdbc/2-6-4.html)。
- 下载 Kyligence 特定的数据源适配器 (下载链接：[Kyligence Account](http://download.kyligence.io/#/addons))。
- 拷贝相关 jar 包放置在`$KYLIN_HOME/ext`目录下。
- 拷贝相关 jar 包放置 sqoop 安装目录的 lib 目录下, 并检查全局参数。在`kylin.properties`中添加 `kylin.source.jdbc.sqoop-home=<sqoop_path>`，其中 sqoop_path 为 sqoop 命令所在的文件。




### 连接参数配置

用户通过**项目配置**或**全局配置**进行参数设置：

| 参数名                            | 值                                              |
| -------------------------------- | ----------------------------------------------  |
| kylin.source.jdbc.driver         | io.kyligence.kap.impala.jdbc41.WrappedDriver    |
| kylin.source.jdbc.connection-url | jdbc:impala-wrapped://&lt;HOST&gt;:&lt;PORT&gt;/&lt;DATABASE&gt;|
| kylin.source.jdbc.user           | &lt;Impala 连接用户名&gt;                            |
| kylin.source.jdbc.pass           | &lt;Impala 连接密码&gt;                              |
| kylin.source.jdbc.dialect        | impala                                          |
| kylin.source.default             | 16                                              |
| kylin.source.jdbc.adaptor        | io.kyligence.kap.impala.jdbc41.WrappedDriver    |

如果需要开启查询下压，还需要配置以下参数：

```properties
kylin.query.pushdown.runner-class-name=io.kyligence.kap.query.pushdown.PushdownRunnerSDKImpl
```



### 为项目设置 Impala 数据源

Kyligence Enterprise 可以通过如下步骤，为特定项目设置 Impala 数据源：

**步骤一**：打开 Kyligence Enterprise 的 Web UI，在主界面的顶端是项目的管理工具栏，点击“＋”即可如下图所示创建一个新的项目。

![新建项目](images/create_project.png)

**步骤二**：进入具体项目**建模**功能，选择**数据源**选项卡；点击蓝色的**数据源**按钮，在弹出窗口中，选择 **RDBMS **作为数据源类型；    ![选择RDBMS数据源](images/rdbms_import_select_source.png)

**步骤三**：在项目配置中添加数据源参数配置(可参考连接参数配置)。

```properties
kylin.source.jdbc.sqoop-home=/usr/hdp/current/sqoop-client
kylin.source.jdbc.driver=io.kyligence.kap.impala.jdbc41.WrappedDriver
kylin.source.jdbc.connection-url=jdbc:impala-wrapped://HOST:PORT/DATABASE
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
kylin.source.jdbc.dialect=impala
kylin.source.default=16
kylin.source.jdbc.adaptor=io.kyligence.kap.impala.jdbc41.WrappedDriver
```

**步骤四**：配置完成之后，就可以通过 Kyligence Enterprise 界面连接 Impala 数据源了。

**步骤五**：进入**加载表元数据**窗口，用户可按需在左侧表清单中，单击选中需要建模的表，也支持输入关键字进行搜索。点击右下方**同步**按钮进行加载。
