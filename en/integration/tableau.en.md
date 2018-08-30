## Integration with Tableau

Tableau is one of the most popular business intelligence application. It is very easy to utilize by draging and droping feature which user can simply  interactive data visualization and generate story or reports. 

This section will introduct  two methods available to connect Tableau with Kyligence Enterprise.

- Quick Sync up model by using  import/export function
- Manually build mapping model 

### Prerequises

- Install the Kyligence ODBC driver

> Tips: Instructions refer to [Kyligence ODBC Driver tutorial](../driver/kyligence_odbc.en.md).

- To support detail data query, you need config table index or push down.

### Method 1: Quick sync up model by using  TDS import/export function

After modeling and creating cube, user can export tableau model definition file,

> Remark: Supported from Kyligence Enterprise 3.0.1 version

The following detail steps required :

1. Export Tableau Data source(TDS) file from Kyligence Enterprise

   - Under **Model** >**Cube** module
   - Select a **Ready** Cube
   - Click **More Action** icon, Select **Export TDS** option

2. Import TDS file into Tableau

   - Copy the TDS file to the enviroment which tableau installed, and double click on it
   - In the pop-up window, enter authorization information.
   - Click **OK** 

3. In Tableau, check  model import, such as dimension, meseaure etc.

   

### Method 2: Manually build mapping model

User can connect Kyligence Enterprise through ODBC Driver, and manually mapping model in Tableau

The following detail steps required for mapping data model :

1. Start Tableau, under **Data**>**Connect**>**Other Databases(ODBC)**
2. In the pop-up window, select Driver **Kyligence ODBCDriver**, and click **Connect**
3. In **Connection Attributes**, config the connection information as following, and click **OK** 
   - Host
   - Port
   - Username
   - Password
   - Project
4. (Or) In the pop-up window, select the existing DSN to connect
5. In Tableau, you need rebuild data model refer to Kyligence Enterprise. How to create model in Tableau please refer to Tableau official website.

### Other remarks

When you connect  Tableau to Kyligence Enterprise, it will send a query which trigger full table scan. This will take a relatively long time to process the query when the dataset is extremely large. There are two ways to avoid this situation

**Method 1**: You can download Kyligence Tableau Datasource Customization(TDC) file from account website and config it. This file is a Kyligence specific connection setting file  which help tableau connect better to Kyligence. 

If Tableau is installed, you can just copy it into the required Tableau directory. 

If Tableau is installed, you  can copy this Kyligence specific connection setting for Tableau copy it into the required Tableau directory

- For Tableau Desktop, the default location is:

  `Documents\My Tableau Repository\Datasources`

- For Tableau Server，the default location is： 

  Windows enviroment

  `Program Files\Tableau\Tableau Server\<version>\bin`

  Or

  `ProgramData\Tableau\Tableau Server\data\tabsvc\vizqlserver\Datasources`

  Linux enviroment

  `/var/opt/tableau/tableau_server/data/tabsvc/vizqlserver/Datasources/`

**Method 2:** You can set up the parameter `kylin.query.force-limit` to limit records return. Set the value as integer to enable this configuration, such as 1000.

 There are two ways to avoid this situation:

Method 1: You can download Kyligence Tableau Datasource Customization(TDC) file from Kyligence account site and config with.

This file allow If Tableau is installed, Jethro will need a jethro specific connection settings for Tableau, to be copied into the required Tableau directory. 

Method 2: you can set up paremeter  `kylin.query.force-limit` to limite the records return.