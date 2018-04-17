## Integration with Power BI Desktop

Microsoft Power BI Desktop is a professional business intelligence analysis tool providing rich functionality and experience for data visualization and processing to user. This article will guide you to connect KAP with Power BI Desktop. 

### Install Kyligence ODBC Driver
For the installation information, please refer to [Kyligence ODBC Driver tutorial](../driver/kyligence_odbc.en.md).

### Install Power BI DirectQuery plugin
1.  Download KAP Power BI DirectQuery plugin from [Kyligence Account Page](http://account.kyligence.io).

2.  Copy the plugin file (.mez) of DirectQuery to the folder *C:\Users\\(user_name)\Documents\Microsoft Power BI Desktop\Custom Connectors*. If this folder does not exist, please create one.

3.  In Power BI Desktop, open **Options** under **Options and settings**.

4.  Click **Preview features** and then check the box **Custom data connectors**.

    ![Check the box Custom data connectors](images/powerbi/Picture11.png)

5.  Restart Power BI Desktop.

### Connect KAP through Power BI Desktop

1.  Start the installed Power BI Desktop, click **Get data -> more**, and then click **Database -> Kyligence Analytics Platform**.

     ![Select Kyligence Analytics Platform](images/powerbi/Picture5.png)

2.  In the pop-up window, type the required database information, and select **DirectQuery** as Data Connectivity mode.

     > Note: If your KAP is deployed on Azure, please add **https://** in server url and input 443 as PORT number

     ![Data Connectivity mode: DirectQuery](images/powerbi/Picture6.png)

3.  Type user name and password to connect KAP

     ![Input account information to connect KAP](images/powerbi/Picture7.png)

4.  After connecting successfully, Power BI will list all the tables in the project. You may select the tables based on your requirements.
     ![Select tables as required](images/powerbi/Picture8.png)

5.  Model the tables which need to be connected.

     ![Model the tables to be connected](images/powerbi/Picture9.png)

6.  Return to the report page and start visualization analysis.


![Model the tables to be connected](images/powerbi/Picture10.png)