### RDBMS数据源配置

本产品从3.0版本开始支持RDBMS作为数据源。

### 准备工作

连接RDBMS数据源，需要先完成相关驱动程序下载准备工作

- 下载各RDBMS官方JDBC驱动程序jar包
- 下载Kyligence特定的SDK jar包（如果有特殊RDBMS支持，需要下载SDK jar包，请联系Kyligence Support）
- 拷贝相关jar包放置在`$KYLIN_HOME/ext`目录下
- 拷贝相关jar包放置sqoop安装目录的lib目录下

> 注释：因为Cube构建过程需要使用**sqoop**，所以需要自行配置JDBC至sqoop安装路径/lib目录下。



### 连接参数配置

用户通过**项目配置**或**全局配置** 进行参数设置：

> 说明：全局配置文件默认在安装路径下/conf目录的`kylin.properties`配置文件

| 参数名                           | 解释                                             |
| -------------------------------- | ------------------------------------------------ |
| kylin.source.jdbc.driver         | JDBC驱动类名                                     |
| kylin.source.jdbc.connection-url | JDBC连接字符串                                   |
| kylin.source.jdbc.user           | JDBC连接用户名                                   |
| kylin.source.jdbc.pass           | JDBC连接密码                                     |
| kylin.source.jdbc.dialect        | JDBC方言（目前仅支持default、greenplum两种方言） |
| kylin.source.default             | JDBC使用的数据源种类（RDBMS种类代码为16）        |
| kylin.source.jdbc.adaptor        | JDBC连接的数据源对应的适配器                     |

如果需要开启查询下压，还需要配置以下参数：

`kylin.query.pushdown.runner-class-name=io.kyligence.kap.query.pushdown.PushdownRunnerSDKImpl`

> 注：除以上项目配置项外，还需要在`kylin.properties`中添加kylin.source.jdbc.sqoop-home=<sqoop_path>，其中sqoop_path为sqoop命令所在的文件。

### 创建基于RDBMS数据源的项目

以Greenplum数据源为例，我们使用 JDBC Driver来连接，步骤如下：

1. 登录本产品的Web UI
2. 主界面顶端左侧的项目管理工具栏中，点击加号 **“＋” ** 以新建项目
3. 在弹出的窗口中，输入**项目名称** （必选）和 **项目描述**, 点击 **确定** 按钮，完成项目创建。
4. 进入具体项目**建模** 功能， 选择 **数据源** 选项卡
5. 点击蓝色的**数据源**按钮
6. 在弹出窗口中， 选择 **RDBMS**类型作为数据源类型， 如下图所示

![选择RDBMS数据源](images/rdbms_import2.cn.png)

4. 在项目配置中添加以下配置：

```
kylin.source.jdbc.driver=com.pivotal.jdbc.GreenplumDriver
kylin.source.jdbc.connection-url=jdbc:sqlserver://<HOST>:<PORT>;database=<DATABASE_NAME>
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
kylin.query.pushdown.runner-class-name=io.kyligence.kap.query.pushdown.PushdownRunnerSDKImpl
kylin.source.jdbc.dialect=mssql
kylin.source.default=16
kylin.source.jdbc.sqoop-home=/usr/hdp/current/sqoop-client/bin
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.MssqlAdapter
```

5. 点击 **下一步** 按钮，进入 **加载表元数据** 窗口， 用户可按需在左侧表清单中， 单击选中需要建模的表。
6. 点击右下方 **同步** 按钮进行加载

