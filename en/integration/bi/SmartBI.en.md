## Integrate with SmartBI (Under Construction)

SmartBI Insight is an enterprise-class business intelligence analytic platform.

### Install SmartBI

For installation instructions for SmartBI Insight, please visit the [SmartBI Insight Download Page](http://www.SmartBI.com.cn/download)

### Install Kyligence JDBC Driver

- SmartBI Insight connects to Kyligence Enterprise via JDBC, so you firstly need to install the Kyligence JDBC driver on SmartBI Insight. If you would like to get the Kyligence JDBC driver, please refer to [Kyligence JDBC Driver Description](../driver/jdbc.en.md)
- Add a JDBC driver to SmartBI Insight:

   Steps are as follows:
   - Stop SmartBI
   - Put the jdbc driver in the **SmartBI installation directory\Tomcat\webapps\eagle\WEB-INF\lib**
   - Restart SmartBI

### Establishing a Kyligence Enterprise data source connection

- **Login SmartBI**

   Open the new relational data source under **Customization**->**Data Management**->**Data Source** node, and select **RDBS Data Source** to open Data source connection window.
   
   ![Login SmartBI](../images/smartbi/01.png)

+ **Create a new data source**

  Select the **Kylin** driver type and fill in the connection string with the server IP address and other information (the string format is: ```jdbc:kylin://<hostname>:<port>/<project_name>``` ), then **Save** data source connection.

  Here, the default user authentication type is **Static Authentication**, and the Kyligence Enterprise username and password are entered for connection.

  ![Create data source](../images/smartbi/02.png)

+ **Manage data sources**

  After clicking Save, you will see your previously created Kyligence data source under **Customization**->**Data Management**->**Data Source**.
