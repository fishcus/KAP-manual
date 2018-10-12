## Integration with Tableau

Tableau is one of the most popular business intelligence application. It is very easy to utilize by draging and droping feature which user can simply  interactive data visualization and generate story or reports. 

This section will introduct  two methods available to connect Tableau with Kyligence Enterprise.

- Quick Sync up model by using  import/export function
- Manually build mapping model 

### Prerequises

- Install the Kyligence ODBC driver. For installation instructions, please refer to [Kyligence ODBC Driver](../driver/kyligence_odbc.en.md).


- To support detail data query, you need configure table index or push down.

### Method 1: Quick Sync Up Model by Using TDS Import/Export Function

After modeling and creating cube, user can export tableau model definition file.

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


### Method 2: Manually Build Mapping Model

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

### Other Remarks

When you connect Tableau to Kyligence Enterprise, it will send a query which triggers full table scan. This will take a relatively long time to process the query when the dataset is extremely large. There are two ways to avoid this situation

**Method 1**: You can download **Kyligence Tableau Datasource Customization (TDC)** file from Kyligence download center and apply it to your Tableau. This is a Kyligence specific connection configuration file with some capability customizations   which helps Tableau connect to Kyligence . 

Tableau provides a way to customize TDC profiles, hence to meet Kyligence Enterprise's specific query specifications. Below are some advantages:

- Effectively reduce ODBC connection time by reducing the times of probing ODBC connection.
- Provides query specification customization support for Tableau connections and enhance system robustness.


Step 1: Download file named Tableau Datasource Customization on [Kyligence Download](http://download.kyligence.io/#/addons).

Step 2: Copy the file into the required Tableau directory. 

- For Tableau Desktop, the default location is:

  `Documents\My Tableau Repository\Datasources`

- For Tableau Server，the default location is： 

  Windows enviroment

  `Program Files\Tableau\Tableau Server\<version>\bin`

  Or

  `ProgramData\Tableau\Tableau Server\data\tabsvc\vizqlserver\Datasources`

  Linux enviroment

  `/var/opt/tableau/tableau_server/data/tabsvc/vizqlserver/Datasources/`



**Method 2:** You can set the parameter `kylin.query.force-limit` in `kylin.properties` to limit returned records, such as 1000.
