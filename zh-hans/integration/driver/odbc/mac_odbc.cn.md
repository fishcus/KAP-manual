## Kyligence ODBC 驱动（Mac 版本）

在本文中，我们将向您介绍如何在 Mac 系统下通过 ODBC Manager 或 unixODBC 安装和配置 Kyligence ODBC 驱动（Mac 版本)。

您可以使用 ODBC Manager，通过界面创建 "驱动程序" 与 "DSN" 。也可以直接编辑 `odbcinst.ini` 和 `odbc.ini` 文件。

### 安装 Kyligence ODBC Driver 

1. 您可以在 [Kyligence Account](http://account.kyligence.io) 申请下载 Kyligence ODBC Driver 安装包。

2. 使用安装包安装，依照指引进行安装，驱动文件会自动安装至 /Library/ODBC/KyligenceODBCDriver/ 目录下。

    > **注意：** 安装过程中会要求用户输入密码，用于安装驱动文件、配置 odbcinst.ini 和 odbc.ini 文件，以及赋予登陆用户读写权限。对于从旧版本更新到新版本的用户，可能需要手动删除旧驱动文件以及配置，详情见 FAQ 。

### 使用 ODBC Manager 配置 Kyligence ODBC Driver
   
   您可以在 [ODBC Manager](http://www.odbcmanager.net) 页面下载 ODBC Manager安装包，并运行安装。

- #### 配置 Driver

1. 打开ODBC Manger，进入 "驱动程序" 页面​，点击 "添加" 新建。

    > **注意：** Driver Name 可自定义，推荐使用 Kyligence ODBC Driver 等关键字来命名。手册中以 KyligenceODBCDriver 为例。

    ![ADD Drivers](../images/mac_odbc/1.png)

2. 输入驱动名 "KyligenceODBCDriver"，驱动文件选择 Kyligence ODBC Driver 本地文件，点击 "好" 即可。

    ![Add Drivers](../images/mac_odbc/2.png)

- #### 配置 DSN

1. 进入 "系统 DSN" 或 "用户 DSN" 页面，点击 "添加" 新建。

    ![Add Drivers](../images/mac_odbc/3.png)

2. 选择 "KyligenceODBCDriver"。

    ![Add Drivers](../images/mac_odbc/4.png)

3. 确认后，输入 Host、Port、Project 等信息，点击 "好" 即可。

    - Host：本产品服务器地址
    - Port：本产品服务器端口号
    - Username：本产品服务登录用户名
    - Password：本产品服务登录密码
    - Project：查询所使用的本产品项目名称

    ![Add Drivers](../images/mac_odbc/5.png)

4. 配置好后您就可以直接在 BI 工具中使用了，可以跳过其余章节。

### 手动配置 Kyligence ODBC Driver 

您也可以通过直接修改配置文件，手动配置 Kyligence ODBC Driver 。

> **ODBC 驱动配置文件** –  /Library/ODBC/odbcinst.ini
>
> ```
> [ODBC Drivers]
> [{DriverName}] = Installed
> 
> [{DriverName}]
> Driver={DriverPath}
> ```
>
> **DSN 配置文件** – /Library/ODBC/odbc.ini 
>
> ```
> [ODBC Data Sources]
> {DSNName} = {DriverName}
> 
> [{DSNName}]
> Driver = {DriverPath}
> Host = {KE_Url}
> Port = {KE_Port}
> Project = {KE_Project}
> ```
>
> 样例配置： 
>
>   /Library/ODBC/odbcinst.ini
>
> ```
> [ODBC Drivers]
> KyligenceODBCDriver  = Installed
> 
> [KyligenceODBCDriver]
> Driver = /Library/ODBC/KyligenceODBCDriver/libKyligenceODBC64.dylib
> ```
>
>   /Library/ODBC/odbc.ini
>
> ```
> [ODBC Data Sources]
> KyligenceDataSource = KyligenceODBCDriver
> 
> [KyligenceDataSource]
> Driver = /Library/ODBC/KyligenceODBCDriver/libKyligenceODBC64.dylib
> Host = http://kapdemo.chinaeast.cloudapp.chinacloudapi.cn
> Port = 7070
> Project = learn_kylin
> ```
>
>   配置好后，您就可以直接在 BI 工具中使用了。

### 使用 UnixODBC 安装

- #### 安装 unixODBC 

1. 我们建议您使用 unixODBC(http://www.unixodbc.org/) 作为驱动管理器来管理 ODBC 连接信息​ 

    ```
    brew install unixODBC
    ```

2. 安装完成后，执行下述命令，确认结果是否为 /usr/local/bin/isql 。

    ```
    which isql 
    ```

3. 执行下述命令，确认 DRIVERS 路径是否是 /usr/local/etc/odbcinst.ini， 确认 SYSTEM DATA SOURCES 路径是否是 /usr/local/etc/odbc.ini 。

    ```
    odbcinst -j
    ```

- #### 配置 Kyligence ODBC Driver

    将 Kyligence ODBC 添加入配置文件 。

  **ODBC 驱动配置文件** –  /usr/local/etc/odbcinst.ini 

  ```
  [{DriverName}]
  APILevel=1
  ConnectFunctions=YYY
  Description={Description}
  Driver={DriverPath}
  Setup={DriverPath}
  DriverODBCVer=03.80
  SQLLevel=1
  Locale=en-US
  ```

- #### 配置 DSN

  **DSN 配置文件** – /usr/local/etc/odbc.ini 

  ```
  [{DSName}]
  Driver = {DriverName}
  SERVER = {KE_Url}
  PORT = {KE_Port}
  PROJECT = {KE_Project}
  ```

  样例配置： 

  **/etc/odbcinst.ini**

  ```
  [KyligenceODBCDriver]
  APILevel=1
  ConnectFunctions=YYY
  Description=Sample 64-bit Kyligence ODBC Driver
  Driver=/Library/ODBC/KyligenceODBCDriver/libKyligenceODBC64.dylib
  Setup=/Library/ODBC/KyligenceODBCDriver/libKyligenceODBC64.dylib
  DriverODBCVer=03.80
  SQLLevel=1
  Locale=en-US
  ```

  **/etc/odbc.ini**

  ```
  [KyligenceDataSource]
  Driver = KyligenceODBCDriver
  SERVER = http://kapdemo.chinaeast.cloudapp.chinacloudapi.cn
  PORT = 7070
  PROJECT = learn_kylin
  ```

- #### 查询验证

1. 使用命令行工具`isql DSN [UID '[PWD]']`测试连接：

   ```
   isql KyligenceDataSource ADMIN 'KYLIN'
   ```

2. 发送查询测试：

   ```
   SQL> select count(*) from kylin_sales;
   ```

   如果连接成功，则会返回如下结果：

   ```
   +---------------------+
   | EXPR$0              |
   +---------------------+
   | 10000               |
   +---------------------+
   SQLRowCount returns 1
   1 rows fetched
   ```

### FAQ

**Q: 如何卸载 unixODBC**

输入命令`brew uninstall unixodbc `，您可以看到以下信息：

```
Uninstalling /usr/local/Cellar/unixodbc/2.3.7... (46 files, 1.8MB)
```

**Q: 如何卸载 Kyligence ODBC Driver**

1. 打开 ODBC Manger，进入“System DSN”或“User DSN”页面​ ，选中 Kyligence ODBC 的 DSN 配置，点击“Remove”删除。
2. 进入“Drivers”页面​ ，查看 Kyligence ODBC Driver 的安装包路径，删除安装包。
3. 在“Drivers”页面​，选中 Kyligence ODBC Driver，点击“Remove”删除。
