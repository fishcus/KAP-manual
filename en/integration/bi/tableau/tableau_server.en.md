## Integrate with Tableau Server

### Prerequisite

- Install Kyligence ODBC Driver. For installation information, please refer to [Kyligence ODBC Driver introduction](../../driver/odbc/README.md).
- Install Tableau Server. For installation information, please refer to [Tableau Server Download](https://www.tableau.com/support/releases/server).

### Configure connection to Kyligence

If your Tableau version is 2019.4 and above, please configure Kyligence Connector:

1. Download the Kyligence Connector file (.taco) file from [Kyligence Download](http://download.kyligence.io/#/download).

2. Copy the .taco file to the Tableau Server directory. The Tableau installation directory is. If the directory does not exist, create a folder manually.

   ```
   Windows: My Documents/My Tableau Repository/Connectors
   Linux: {custome path}/tableau_connectors
   ```

   > **Note**：In Tableau 2019.4 to 2020.3.1, Tableau cannot identify a .taco file if your "My Tableau Repository" is in non-English. As a walkaround, You need to place the .taco file in a full English directory and set native_api.connect_plugins_path in your Tableau shortcut to let Tableau be able to identify .taco file. Such walkaround is not needed if you are using Tableau 2020.3.2 and above as Tableau fixed this issue in Tableau 2020.3.2

3. Set the native_api.connect_plugins_path option.

   ```
   tsm configuration set -k native_api.connect_plugins_path -v {custome path}/tableau_connectors
   If you get a configuration error during this step, try adding the --force-keys option to the end of the command.
   ```

4. Restart Tableau Server

   

If your Tableau version is 2019.4 below, please configure the Tableau Datasource Customization (TDC) file, the steps are as follows:

- Configure Tableau Datasource Customization (TDC). Similar to Desktop, the configuration steps are as follows:

  1. Download file named Tableau Datasource Customization on [Kyligence Download](http://download.kyligence.io/#/download).

  2. Copy the file to the required Tableau directory. The default location is below:

     * Windows environment
       `Program Files\Tableau\Tableau Server\<version>\bin` or `ProgramData\Tableau\Tableau Server\data\tabsvc\vizqlserver\Datasources`   
     * Linux environment  
       `/var/opt/tableau/tableau_server/data/tabsvc/vizqlserver/Datasources/`

> **Note**：
>
> 1. When using Tableau Linux Server, make sure that the ODBC configuration {DriverName} is **KyligenceODBCDriver**, refer to the [Linux ODBC Chapter](../../driver/odbc/linux_odbc.en.md).
>
> 2. When a published workbook is connected to Kyligence Enterprise by DSN, please configure a DSN with the same name as the local one in Tableau Server

### Login to Tableau Server

On the top of the Tableau Desktop interface, click **Server** -> **login**, enter the Tableau Server address in the pop-up window and enter Tableau account password to log in.

![Login to Tableau Server](../../images/tableau_server/1.png)

### Publish Workbook to Tableau Server

After successful login, please click **Publish Workbook**.

![Login to Tableau Server](../../images/tableau_server/2.png)

Tableau supports two types of data source authentication: **Embedded in workbook** or **Prompt user** or **Impersonate via embedded password** When **Embedded in workbook** is selected, Tableau effectively embeds the connection rights of its publisher, and allows anyone who can view the workbook to view the data . When you select **Prompt user**, the user who views the workbook from Tableau Server will be prompted to enter his/her own credentials for Kyligence. For more information, please refer to [Tableau Permission](https://help.tableau.com/current/online/en-us/permissions.htm).

If you need to implement user delegation for Tableau Server and Kyligence Enterprise, should select **Impersonate via embedded password**, please refer to [User Delegation with Tableau Server](user_delegation_with_tableau_server.en.md).

![Login to Tableau Server](../../images/tableau_server/3.png)

### View Workbook in Tableau Server

After successfully publishing, you can enter the Tableau Server, log in with your Tableau account, enter the path where the workbook is located and view workbook.

For the first time, you need to enter the user name and password of Kyligence Enterprise. After verification, you can view the data you have access to
1. Enter the publishing path

   ![](../../images/tableau_server/4.png)

2. Enter Kyligence Enterprise account and password

   ![](../../images/tableau_server/5.png)

3. View report

   ![](../../images/tableau_server/6.png)

### Important Notes

- When configuring ODBC drivers in Tableau Server, please make sure that the DSN name is the same as the local.

- Tableau Server and Kyligence Enterprise are currently unable to achieve single sign-on. The accounts of the two systems are independent of each other. The workbook can be published in Desktop through the **Prompt user** mode, and the Kyligence Enterprise account password can be input in Tableau Server to realize the integration of privileges.

- Tableau Server supports saving Kyligence Enterprise account passwords by **Settings** -> **General** -> **Saving Credentials**.
