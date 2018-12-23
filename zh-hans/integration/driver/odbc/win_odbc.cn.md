## Kyligence ODBC 驱动（Windows 版本）


在本文中，我们以 Windows 7 为例，介绍 Kyligence ODBC 驱动程序（Windows版本）的安装和使用步骤。

## 前提条件

1. Microsoft Visual C++ 2015 Redistributable

   在安装 Kyligence ODBC 驱动程序的过程中，系统会首先自行安装 Microsoft Visual C++ 2015 Redistributable。如果操作系统中已经安装了 Microsoft Visual C++ 2015 Redistributable，安装步骤会跳过此步。

2. 一个运行的Kyligence Enterprise服务器（仅在配置DSN时）

   Kyligence ODBC 驱动程序安装成功后，在配置DSN时会连接 Kyligence Enterprise 服务器，请务必先确保 Kyligence Enterprise 服务已正常运行。

## 安装

1. 如果机器上已经安装过 Kyligence ODBC 驱动程序，首先卸载已有 Kyligence ODBC 驱动程序。
2. 在 [Kyligence Account 页面](http://account.kyligence.io)申请下载 Kyligence ODBC 驱动程序，并运行安装。

   - 32 位应用程序：请安装使用 kyligence_odbc.x86.exe

   - 64 位应用程序：请安装使用 kyligence_odbc.x64.exe


## 配置 DSN

1. 打开 ODBC 数据源管理器：

   32 位 ODBC 驱动：单击**开始 -> 运行**，并打开 C:\Windows\SysWOW64\odbcad32.exe

   64 位 ODBC 驱动：单击**控制面板 ->管理工具**，找到并打开**数据源(ODBC)**

2. 切换至**系统 DSN** 选项卡，单击**添加**，在弹出的驱动程序选择框中选择 **KyligenceODBCDriver**，然后单击**完成**按钮。

   ![ODBC 数据源管理器](../images/01.png)

3. 在弹出的对话框中输入 Kyligence Enterprise 服务器信息，如图所示：

   ![DSN 设置](../images/02.png)

   其中，各项参数介绍如下：

   * Data Source Name：数据源名称
   * Description：数据源描述
   * Host：本产品 服务器地址
   * Port：本产品 服务器端口号
   * Username：本产品 服务登录用户名
   * Password：本产品 服务登录密码
   * Project：查询所使用的 本产品 项目名称
   * Disable catalog：是否关闭catalog层，默认为**开启**状态，如果勾选Disable catalog则为关闭状态

4. 单击 **Test** 按钮，连接成功后，将显示如下对话框。

   ![连接成功](../images/03.png)

## 是否需要开启catalog层

   需要**关闭**catalog层的BI工具有：Cognos

   需要**开启**catalog层的BI工具有：OBIEE

## 连接字符串

有一些BI工具支持不使用DSN而直接配置ODBC连接字符串的形式访问数据源。在这种场景下，用户可以使用下面的字符串格式进行配置：

```
DRIVER={KyligenceODBCDriver};SERVER=locahost;PORT=7070;PROJECT=learn_kylin
```

<!--请将SERVER，PORT及PROJECT中的信息替换成您所使用的本产品的信息。-->

## 特别提醒

如果用户希望在其他应用程序中使用 Kyligence ODBC 驱动程序连接 本产品，可访问本手册[ 与BI 工具连接](../../bi/README.md)章节，了解相关信息。

