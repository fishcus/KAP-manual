## Impala 数据源配置

本产品从 3.2 版本开始支Impala作为数据源。

### 准备工作

连接 Impala 数据源，需要先完成相关驱动程序下载准备工作:

- 下载官方 [Impala JDBC 驱动程序](https://www.cloudera.com/downloads/connectors/impala/jdbc/2-6-4.html)。
- 下载 Kyligence 特定的数据源适配器 (下载链接：[Kyligence Account](http://download.kyligence.io/#/addons))。
- 拷贝相关 jar 包放置在`$KYLIN_HOME/ext`目录下。
- 拷贝相关 jar 包放置 sqoop 安装目录的 lib 目录下, 并检查全局参数。在`kylin.properties`中添加 kylin.source.jdbc.sqoop-home=&lt;sqoop_path&gt;，其中sqoop_path为sqoop命令所在的文件。


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

1. 登录本产品的Web UI。
2. 主界面顶端左侧的项目管理工具栏中，点击加号 **“＋” ** 以新建项目。
3. 在弹出的窗口中，输入**项目名称** （必选）和 **项目描述**, 点击 **确定** 按钮，完成项目创建。
4. 进入具体项目**建模** 功能，选择 **数据源** 选项卡。
5. 点击蓝色的**数据源**按钮。
6. 在弹出窗口中，选择 **RDBMS**作为数据源类型。
7. 在项目配置中添加数据源参数配置(可参考连接参数配置)。
8. 点击**下一步**按钮，进入**加载表元数据**窗口，用户可按需在左侧表清单中，单击选中需要建模的表。
9. 点击右下方**同步**按钮进行加载。
