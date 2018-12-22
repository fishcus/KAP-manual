## Install & Configure Kyligence ODBC Driver on Windows

In this chapter, we will take Windows 7 as an example to introduce how to install Kyligence ODBC driver (windows version) and do follow-up configuration steps. 

## Prerequisites

1. Microsoft Visual C++ 2015

   During the installation of Kyligence ODBC Driver, Microsoft VC++ will be installed first and redistributable is already embedded in the installation package. If Microsoft Visual C++ 2015 is already installed on your machine, this step will be skipped.

2. A running Kyligence Enterprise server

   Kyligence ODBC Driver will connect to a Kyligence Enterprise server to verify whether the connection works, so make sure the Kyligence Enterprise is running properly.

## Installation

1. If you have previously installed Kyligence ODBC driver, please uninstall it first.

2. Apply and [Download](http://account.kyligence.io) Kyligence ODBC driver, and install it.

   - For 32-bit application, please install and use kyligence_odbc.x86.exe

   - For 64-bit application, Please install and use kyligence_odbc.x64.exe

## Configure the DSN

1. Open ODBC Data Source Manager:

   32-bit ODBC driver: click **start -> operation** to open C:\Windows\SysWOW64\odbcad32.exe

   64-bit ODBC driver: select **Control Panel -> Administrative Tools** to open **ODBC Data Source Administrator**

2. Switch to **System DSN** tab, click **Add** and select **KyligenceODBCDriver** in the pop-up driver selection box, then click **Finish**.

   ![Add Kyligence ODBC Driver](../images/01.png)

3. In the pop-up window, input the Kyligence Enterprise server information, as shown in the figure:

    ![DSN setting](../images/02.png)

   Where, the parameters are described as below: 

   * Data Source Name: name of data source
   * Description：Description of data source
   * Host: Kyligence Enterprise server address
   * Port: Kyligence Enterprise server port number
   * Username: username to login Kyligence Enterprise
   * Password: password to login Kyligence Enterprise 
   * Project: the name of the Kyligence Enterprise project to use for the query
   * Disable catalog：Whether to disable the catalog layer, the default is **enable** state, If you choose to disable catalog, check this option.

4. Click **Test**

   Once it connects to the data source successfully, the following dialog will appear.

   ![Connect Successfully](../images/03.png)

## Enabling the catalog layer

   the BI tool which need to **diable** the catalog layer：Cognos

   the BI tool which need to **Enable** the catalog layer：OBIEE

## ODBC Connection String

Some BI tools support connect data source with ODBC connection string. In that case, you may use below connection string as reference:

```
DRIVER={KyligenceODBCDriver};SERVER=locahost;PORT=7070;PROJECT=learn_kylin
```

Please replace SERVER, PORT and PROJECT with your Kyligence Enterprise settings.

## Special Reminder

If you want to use Kyligence ODBC driver to connect to Kyligence Enterprise in other client applications, the configuration is similar to this example. For more information, please see [Connect with BI tools](../../bi/README.md) chapter of Kyligence Enterprise Manual.
