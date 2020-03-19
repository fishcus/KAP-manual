## Integrate with Tableau Desktop

Tableau is one of the most popular business intelligence applications. It is very easy for users to generate visualized diagrams, stories, and reports on huge amount of data via drag and drop.

Kyligence Enterprise supports integration with Tableau 8.X, 9.X, 10.X, 2018.X, 2019.X, 2020.1 We will use Tableau 2019.2 as an example to introduce how to integrate Kyligence Enterprise with Tableau Desktop.

### Prerequisite

- Install Kyligence ODBC Driver. For the installation information, please refer to [Kyligence ODBC Driver introduction](../../driver/odbc/README.md).

- Install  Tableau Desktop. For the installation information, please refer to [Tableau Desktop Download](https://www.tableau.com/support/releases).

- Configure Tableau Datasource Customization (TDC) 

  Tableau supports configuring TDC files to customize ODBC connections. Therefore, Kyligence provides a TDC file to fit some special rules in Kyligence.

  The configuration steps are as below:

  1. Download the file named Tableau Datasource Customization on [Kyligence Download](http://download.kyligence.io/#/addons).

  2. Copy the file to the required Tableau directory. The default location is: `Documents\My Tableau Repository\Datasources`

### Connect to Kyligence Enterprise

Open Tableau Desktop, click **Other Database (ODBC)** in the left panel, enter connection authentication information (host port, project, username, password) in the pop-up window, or drop-down to select t the existing DSN, and click **Connection**. After verification, you can get the tables and data with access rights.

> **Note：**When you use **DSN** on Tableau Desktop to connect to Kyligence Enterprise and need to publish the workbook to Tableau Server, you should create a DSN with the same name as the local one on Tableau Server. DSN type must be **System DSN**. If you use the  **Driver**  to connect, you do not need to create a DSN in Tableau Server.

![Connect to Kyligence Enterprise](../../images/tableau_desktop/5_ODBC.png)

### Mapping Data Model

In the left panel of Tableau Desktop, select **default** as the database and click on the **Search** icon in the search box. All tables will be listed. You can drag and drop the tables to the right panel to create the connection between tables and tables.

![Mapping Data Model](../../images/tableau_desktop/6_MODEL.png)

### Live Connection

Two types of data source connection are provided in Tableau. In large data scenarios, please choose **Live** connection.

![Live Connection](../../images/tableau_desktop/7_LIVE.png)

### Custom SQL

If you want to interact through custom SQL, they can click on **New Custom SQL** in the bottom left corner of the model interface, and enter SQL in the pop-up box.

![Custom SQL](../../images/tableau_desktop/8_Custom_SQL.png)

### Visualization

Now you can start to enjoy analyzing with Tableau Desktop.

![Visualization](../../images/tableau_desktop/4_Charts.png)
