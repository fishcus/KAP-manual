# Linux下安装与配置Kyligence ODBC驱动

在本文中，我们将向您介绍如何在Linux系统下安装和配置Kyligence ODBC驱动（Linux版本)

### 安装库的依赖

我们建议您使用unixODBC(http://www.unixodbc.org/) 作为驱动管理器来管理ODBC连接信息。

对于不同的Linux系统：

1. Redhat和CentOS环境, 可参考如下命令安装

      `sudo yum install unixODBC-devel -y` 	

2. Ubuntu环境，可参考如下命令安装

   `sudo apt-get install unixODBC-devel`



### 下载ODBC驱动程序

用户可以在 [Kyligence Account](http://account.kyligence.io) 申请下载 Kyligence ODBC Driver (Linux版本）安装包



### 安装ODBC驱动程序

1. 解压下载的压缩包

   `tar -zxf KyligenceODBC_linux.tar.gz`

   > 注意：请不要将 ODBC 安装文件放在 root 目录下，否则会因为读写权限问题可能导致BI Server访问失败。

2. 检查库的依赖

   `cd ODBCDriver/`

   `ldd libKyligenceODBC64.so`

   如果检查成功，您将会看到如下输出：

   ```
   linux-vdso.so.1 =>  (0x00007fffca9eb000)
   librt.so.1 => /lib64/librt.so.1 (0x00007fe826b3f000)
   libdl.so.2 => /lib64/libdl.so.2 (0x00007fe82693b000)
   libm.so.6 => /lib64/libm.so.6 (0x00007fe8266b6000)
   libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fe826499000)
   libc.so.6 => /lib64/libc.so.6 (0x00007fe826105000)
   lib64/ld-linux-x86-64.so.2 (0x00007fe829aac000)
   ```

   如果检查失败，依赖库不存在，您将看到如下输出：

   ```
   linux-vdso.so.1 =>  not found
   librt.so.1 => /lib64/librt.so.1 (0x00007fe826b3f000)
   libdl.so.2 => /lib64/libdl.so.2 (0x00007fe82693b000)
   libm.so.6 => /lib64/libm.so.6 (0x00007fe8266b6000)
   libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fe826499000)
   libc.so.6 => /lib64/libc.so.6 (0x00007fe826105000)
   lib64/ld-linux-x86-64.so.2 (0x00007fe829aac000)
   ```


### 设置ODBC DSN 

1. 将 Kyligence ODBC 添加入配置文件

   > **注意：**一些BI工具需要ODBC配置文件放置在自己的安装目录下，如[样例说明](#样例说明)中的**MicroStrategy**。因此请您根据所使用的BI工具进行配置。

   **ODBC驱动配置文件** – /etc/odbcinst.ini 

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

   **DSN配置文件** – /etc/odbc.ini 

   ```
   [{DSName}]
   Driver = {DriverName}
   PORT = {KE_Port}
   PROJECT = {KE_Project}
   SERVER = {KE_Url}
   ```

   样例配置： 

   **/etc/odbcinst.ini**

   ```
   [KyligenceODBC]
   APILevel=1
   ConnectFunctions=YYY
   Description=Sample 64-bit Kyligence ODBC Driver
   Driver=/home/kylin/KyligenceODBC/ODBC_DRIVER/libKyligenceODBC64.so
   Setup=/home/kylin/KyligenceODBC/ODBC_DRIVER/libKyligenceODBC64.so
   DriverODBCVer=03.80
   SQLLevel=1
   Locale=en-US
   ```

   **/etc/odbc.ini**

   ```
   [KyligenceDataSource]
   Driver = KyligenceODBC
   PORT = 80
   PROJECT = learn_kylin
   SERVER = http://kapdemo.chinaeast.cloudapp.chinacloudapi.cn
   ```

   > **注意：**请确认 odbc.ini 文件中的 DSN 名称和 BI桌面环境下配置的DSN名称完全一致，保证BI应用由桌面客户端发布至服务器端时连接正常

2. 使用命令行工具"isql DSN [UID '[PWD]']测试连接

   `isql KyligenceDataSource ADMIN 'KYLIN'`

3. 发送查询测试 

   `SQL> select count(*) from kylin_sales;`
   如果连接成功，则会返回如下结果

   ```
   +---------------------+
   | EXPR$0              |
   +---------------------+
   | 4957                |
   +---------------------+
   SQLRowCount returns 1
   1 rows fetched
   ```

### 样例说明

这里我们以 **MicroStrategy Linux Intelligence Server** 为例，介绍如何创建DSN。

1. 在Linux shell下，浏览至Microstrategy的**安装目录**。

2. 打开文件ODBC.ini，按如下格式添加DSN配置信息。

   ```
   [DSN_Name]
   ConnectionType=Direct
   Driver=<ODBC_HOME>/libKyligenceODBC64.so
   PORT=<PORT_NUMBER>
   PROJECT=<PROJECT_NAME>
   SERVER=<SERVER_NAME>
   ```

3. 添加如下配置信息，映射DSN至ODBC。 

   ```
   [ODBC Data Sources]
   <DSN_Name>=KyligenceODBC
   ```

   以下就是一个名为“EAT1_WH"的DSN配置样例：

   ```
   [ODBC Data Sources]
   KyligenceDataSource=KyligenceODBC
   
   [EAT_WH1]
   ConnectionType=Direct
   Driver=/home/kylin/ODBCDriver/libKyligenceODBC64.so
   PORT=57070
   PROJECT=mstr
   SERVER=http://106.75.137.52
   ```

4. 完成DSN配置后，我们建议您重启Microstrategy Intelligence Server，确保刚创建的DSN已经生效。 

5. 现在您就可以在MicroStrategy Linux I-Server上使用该DSN创建新的数据库连接了。


### FAQ

**Q: isql测试连接失败**   

请检查ODBC配置文件和DSN配置文件是否正确

**Q: 报错提示：(11560) Unable to locate SQLGetPrivateProfileString function.**

请您运行以下命令：  

`export LD_PRELOAD=/usr/lib/libodbcinst.so`
