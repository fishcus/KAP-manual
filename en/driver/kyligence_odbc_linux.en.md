# Install & Configure Kyligence ODBC Driver on Linux

In this section, we will introduce how to install Kyligence ODBC driver (linux version) and configure DSN under Linux environment. 

### Install Dependency

We suggest using unixODBC(http://www.unixodbc.org/) as driver manager to manage ODBC connection info.

For different Linux systems:

1. For Redhat and CentOS, run following scripts to install

   `sudo yum install unixODBC-devel -y` 

2. For Ubuntu, install with below scripts

   `sudo apt-get install unixODBC-devel`

### Install ODBC Driver

Users can download Kyligence ODBC driver (Linux version) from [Kyligence Account Center](http://account.kyligence.io).

### Install ODBC Driver

1. Uncompress package

   `tar zxf KyligenceODBC_linux.tar.gz`

   > Notice：please donot uncompress Kyligence ODBC Driver under root folder, otherwise BI servers might not be able to access necessary files because of authoriztaion.

2. Check library dependency

   `cd ODBCDriver/`

   `ldd libKyligenceODBC64.so`
   Expect output shall be:

	```
    linux-vdso.so.1 =>  (0x00007fffca9eb000)
    librt.so.1 => /lib64/librt.so.1 (0x00007fe826b3f000)
    libdl.so.2 => /lib64/libdl.so.2 (0x00007fe82693b000)
    libm.so.6 => /lib64/libm.so.6 (0x00007fe8266b6000)
    libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fe826499000)
    libc.so.6 => /lib64/libc.so.6 (0x00007fe826105000)
    lib64/ld-linux-x86-64.so.2 (0x00007fe829aac000)
   ```

    Bad output, which has "not found" libraries:

    ```
    linux-vdso.so.1 =>  not found
    librt.so.1 => /lib64/librt.so.1 (0x00007fe826b3f000)
    libdl.so.2 => /lib64/libdl.so.2 (0x00007fe82693b000)
    libm.so.6 => /lib64/libm.so.6 (0x00007fe8266b6000)
    libpthread.so.0 => /lib64/libpthread.so.0 (0x00007fe826499000)
    libc.so.6 => /lib64/libc.so.6 (0x00007fe826105000)
    lib64/ld-linux-x86-64.so.2 (0x00007fe829aac000)
	 ```

### Create DSN (Linux 64bit) using unixODBC

1. Add Kyligence ODBC to config files

   > Notice: some BI tools also require the ODBC config files located in their own installation directory, such as **MicroStrategy** in [example section](#Example). Therefore, please set the configurations according to your BI tools.

   **Driver configuration** – /etc/odbcinst.ini

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

   **DSN configuration** – /etc/odbc.ini 

   ```
   [{DSName}]
   Driver = {DriverName}
   PORT = {KE_Port}
   PROJECT = {KE_Project}
   SERVER = {KE_Url}
   ```

   Sample config: 

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

   **/etc/dobc.ini**

   ```
   [KyligenceDataSource]
   Driver = KyligenceODBC
   PORT = 80
   PROJECT = learn_kylin
   SERVER = http://kapdemo.chinaeast.cloudapp.chinacloudapi.cn
   ```

   > *Note: please ensure DSN name in odbc.ini is consistent with DSN name in BI client tools, otherwise BI reports/applications cannot connect to data source when it's published to BI server.*

2. Test connection with cmd tool "isql DSN [UID '[PWD]']

   `isql KyligenceDataSource ADMIN 'KYLIN'`

3. Send a query to test 

   `SQL> select count(*) from kylin_sales;`
   expect the results

   ```
   +---------------------+
   | EXPR$0              |
   +---------------------+
   | 4957                |
   +---------------------+
   SQLRowCount returns 1
   1 rows fetched
   ```

### Example

Here we use **MicroStrategy Linux Intelligence Server** as an example to illustrate how to create DSN.

1. From a Linux console window, browse to HOME_PATH, where HOME_PATH is the MicroStrategy Installation directory.
2. Open the ODBC.ini file to add new DSN to connect. 

    ```
    [DSN_Name]
    ConnectionType=Direct
    Driver=<ODBC_HOME>/libKyligenceODBC64.so
    PORT=<PORT_NUMBER>
    PROJECT=<PROJECT_NAME>
    SERVER=<SERVER_NAME>
    ```

1. To Map the DSN with ODBC, add below setting on the top of your ODBC.ini file. 

    ```
    [ODBC Data Sources]
    <DSN_Name>=KyligenceODBC
    ```

    For example, you may configure your connection to DSN name "EAT1_WH" as below.

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

1. After you finished configuring the DSN, it is recommended that you restart your MSTR Intelligence Server so that the new created DSN will be taked into effective in MicroStrategy. 
2. You can then connect to your MicroStrategy Linux I-Server and create a new database instance based on the DSN.

### FAQ

**Q: If isql test failed, what should I do?**

Please check the configurations are correct including odbc.ini and odbcinst.ini

**Q: Error message with (11560) Unable to locate SQLGetPrivateProfileString function.**

Please run the following command to resolve this problem:   

`export LD_PRELOAD=/usr/lib/libodbcinst.so`



