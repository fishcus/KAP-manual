### RDBMS数据源配置

本产品从3.0版本开始支持RDBMS作为数据源。

### 准备工作

连接RDBMS数据源，需要先完成相关驱动程序下载准备工作:

- 下载各RDBMS官方JDBC驱动程序jar包
- 下载Kyligence特定的SDK jar包（如果有特殊RDBMS支持，需要下载SDK jar包，请联系Kyligence Support）
- 拷贝相关jar包放置在`$KYLIN_HOME/ext`目录下
- 拷贝相关jar包放置sqoop安装目录的lib目录下, 并检查全局参数。在`kylin.properties`中添加kylin.source.jdbc.sqoop-home=&lt;sqoop_path&gt;，其中sqoop_path为sqoop命令所在的文件。



### 连接参数配置

用户通过**项目配置**或**全局配置**进行参数设置：

| 参数名                           | 解释                                      |
| -------------------------------- | ----------------------------------------- |
| kylin.source.jdbc.driver         | JDBC驱动类名                              |
| kylin.source.jdbc.connection-url | JDBC连接字符串                            |
| kylin.source.jdbc.user           | JDBC连接用户名                            |
| kylin.source.jdbc.pass           | JDBC连接密码                              |
| kylin.source.jdbc.dialect        | JDBC方言                                  |
| kylin.source.default             | JDBC使用的数据源种类（RDBMS种类代码为16） |
| kylin.source.jdbc.adaptor        | JDBC连接的数据源对应的适配器              |

如果需要开启查询下压，还需要配置以下参数：

```properties
kylin.query.pushdown.runner-class-name=io.kyligence.kap.query.pushdown.PushdownRunnerSDKImpl
```



### 创建基于RDBMS数据源的项目

使用 JDBC Driver来连接，步骤如下：

1. 登录本产品的Web UI；
2. 主界面顶端左侧的项目管理工具栏中，点击加号 **“＋” ** 以新建项目；
3. 在弹出的窗口中，输入**项目名称** （必选）和 **项目描述**, 点击 **确定** 按钮，完成项目创建；
4. 进入具体项目**建模** 功能，选择 **数据源** 选项卡；
5. 点击蓝色的**数据源**按钮；
6. 在弹出窗口中，选择 **RDBMS**作为数据源类型；
7. 在项目配置中添加数据源参数配置(可参考相关受支持的RDBMS参数项目配置参考)
8. 点击**下一步**按钮，进入**加载表元数据**窗口，用户可按需在左侧表清单中，单击选中需要建模的表。
9. 点击右下方**同步**按钮进行加载。



### 已支持的RDBMS说明

目前产品默认支持GreenPlum, MySQL. 

### 支持的RDBMS连接参数项目配置参考

- 基本参数

```properties
kylin.source.jdbc.connection-url=jdbc:<sqlserver>://<HOST>:<PORT>;database=<DATABASE_NAME>
kylin.source.jdbc.user=<username>
kylin.source.jdbc.pass=<password>
```

- Greenplum数据源

```properties
kylin.source.jdbc.driver=com.pivotal.jdbc.GreenplumDriver
kylin.source.jdbc.dialect=greenplum
```

- MySQL 数据源

```properties
kylin.source.jdbc.driver=com.mysql.jdbc.Driver
kylin.source.jdbc.dialect=mysql
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.MysqlAdaptor
```

- SQL Server数据源

该数据源非Kyligence原生支持的数据源， 可以通过需要额外的SDK，您可以从官网下载最新的SQL Server 2008 版本的SDK, 拷贝至安装目录的lib后，再进行配置

```properties
kylin.source.jdbc.driver=com.microsoft.sqlserver.jdbc.SQLServerDriver
kylin.source.jdbc.dialect=mssql
kylin.source.jdbc.adaptor=io.kyligence.kap.sdk.datasource.adaptor.Mssql08Adaptor
```

> 提示：SQL SERVER数据源支持存在已知限制
>
> - 不支持含limit子查询
> - 不支持空间查询 如'geometric','geography'
> - 不支持 INITCAP, MEDIAN, STDDEV_POP, FIRST_VALUE 等高阶统计函数
> - 不支持开窗函数，如 avg/count/max/min/sum over() 等语法
