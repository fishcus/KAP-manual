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

> *Notice：please donot uncompress Kyligence ODBC Driver under root folder, otherwise BI servers might not be able to access necessary files because of authoriztaion.*

2. Setup environment param of third-party libs

`cd ODBC_DRIVER/`

`source setenv.sh`

3. Check library dependency

`ldd libKyligenceODBC64.so`
Expect output shall be:

```
linux-vdso.so.1 =>  (0x00007ffd773f5000)
libz.so.1 => /lib64/libz.so.1 (0x00007f15a5c38000)
libdl.so.2 => /lib64/libdl.so.2 (0x00007f15a5a34000)
libcrypto.so.10 => /usr/local/ODBCDriver/ThirdParty/libcrypto.so.10 (0x00007f15a564f000)
libssl.so.10 => /usr/local/ODBCDriver/ThirdParty/libssl.so.10 (0x00007f15a53e2000)
libm.so.6 => /lib64/libm.so.6 (0x00007f15a50e0000)
libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f15a4ec3000)
libc.so.6 => /lib64/libc.so.6 (0x00007f15a4b02000)
/lib64/ld-linux-x86-64.so.2 (0x00007f15a8800000)
libgssapi_krb5.so.2 => /lib64/libgssapi_krb5.so.2 (0x00007f15a48b6000)
libkrb5.so.3 => /lib64/libkrb5.so.3 (0x00007f15a45d0000)
libcom_err.so.2 => /lib64/libcom_err.so.2 (0x00007f15a43cc000)
libk5crypto.so.3 => /lib64/libk5crypto.so.3 (0x00007f15a419a000)
libkrb5support.so.0 => /lib64/libkrb5support.so.0 (0x00007f15a3f8a000)
libkeyutils.so.1 => /lib64/libkeyutils.so.1 (0x00007f15a3d86000)
libresolv.so.2 => /lib64/libresolv.so.2 (0x00007f15a3b6c000)
libselinux.so.1 => /lib64/libselinux.so.1 (0x00007f15a3946000)
libpcre.so.1 => /lib64/libpcre.so.1 (0x00007f15a36e5000)
liblzma.so.5 => /lib64/liblzma.so.5 (0x00007f15a34c0000)
```

Bad output, which has "not found" libraries:

```
linux-vdso.so.1 =>  (0x00007ffd773f5000)
libz.so.1 => /lib64/libz.so.1 (0x00007f15a5c38000)
libdl.so.2 => /lib64/libdl.so.2 (0x00007f15a5a34000)
libcrypto.so.10 => not found
libssl.so.10 => not found
libm.so.6 => /lib64/libm.so.6 (0x00007f15a50e0000)
libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f15a4ec3000)
libc.so.6 => /lib64/libc.so.6 (0x00007f15a4b02000)
/lib64/ld-linux-x86-64.so.2 (0x00007f15a8800000)
libgssapi_krb5.so.2 => /lib64/libgssapi_krb5.so.2 (0x00007f15a48b6000)
libkrb5.so.3 => /lib64/libkrb5.so.3 (0x00007f15a45d0000)
libcom_err.so.2 => /lib64/libcom_err.so.2 (0x00007f15a43cc000)
libk5crypto.so.3 => /lib64/libk5crypto.so.3 (0x00007f15a419a000)
libkrb5support.so.0 => /lib64/libkrb5support.so.0 (0x00007f15a3f8a000)
libkeyutils.so.1 => /lib64/libkeyutils.so.1 (0x00007f15a3d86000)
libresolv.so.2 => /lib64/libresolv.so.2 (0x00007f15a3b6c000)
libselinux.so.1 => /lib64/libselinux.so.1 (0x00007f15a3946000)
libpcre.so.1 => /lib64/libpcre.so.1 (0x00007f15a36e5000)
liblzma.so.5 => /lib64/liblzma.so.5 (0x00007f15a34c0000)
```

​

### Create DSN (Linux 64bit) using unixODBC

1. Add Kyligence ODBC to config files

   **Driver configuration** – /etc/odbcinst.ini (or /usr/local/etc/odbcinst.ini)

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

   **DSN configuration** – /etc/odbc.ini (or /usr/local/etc/odbc.ini)

   ```
   [{DSName}]
   Driver = {DriverName}
   PORT = {KapPort}
   PROJECT = {KapProject}
   SERVER = {KapUrl}
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



### Trouble shooting

1. SQL cannot connect       

   a. check the configurations are correct including odbc.ini and odbcinst.ini
   b. make sure execute source setenv.sh

2. (11560) Unable to locate SQLGetPrivateProfileString function.

   This can be solved by following command:   

   `export LD_PRELOAD=/usr/lib/libodbcinst.so`

### Sample:

#### Create DSN in MicroStrategy Linux Intelligence Server

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
3. To Map the DSN with ODBC, add below setting on the top of your ODBC.ini file. 

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
4. After you finished configuring the DSN, it is recommended that you restart your MSTR Intelligence Server so that the new created DSN will be taked into effective in MicroStrategy. 
5. You can then connect to your MicroStrategy Linux I-Server and create a new database instance based on the DSN.



