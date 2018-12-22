## Integrate with Cognos 10.X

### Install Kyligence ODBC Driver

Please refer to this guide [Kyligence ODBC Driver Tutorial](../driver/odbc/README.md) for installation.

The Kyligence ODBC driver needs to be installed in the machine or virtual environment where your Cognos Server is installed.

### Prerequisite

- The version of Cognos Framework manager needs to be consistent with Cognos server.

- **The version of 32-bit ODBC Driver needs to be consistent** in Framework manager and Cognos server.

  > If you installed 64-bit ODBC Driver before, please uninstall it at first

- The name of DSN needs to be consistent in both Framework manager and Cognos server.

### Create a Data Source in Cognos

Depending on your business scenario, you may need to create a new project or simply use an existing project to create the data source for Kyligence Enterprise. In the example, we will start with a new project. 

1. Create a new project.![](../images/cognos/1.png)

2. Use `Metadata Wizard` create a new `Data Source`.![](../images/cognos/2.png)

3. In the `New Data Source Wizard`, first fill in data source name, this could be any name you prefer.![](../images/cognos/3.png)

4. Choose `ODBC` as the connection type. For Isolation Level, choose `Use the default object gateway` ![](../images/cognos/4.png)

5. In ODBC data source, fill in the DSN name that you created in the previous step. Check `Unicode ODBC`. For Sign-on `choose no authorization`. Then Click `Test the connection`.![](../images/cognos/5.png)![](../images/cognos/6.png)If everything is set up properly, test the connection will finish successfully.![](../images/cognos/7.png)![](../images/cognos/8.png)

   Now you have the data source created.

   > **Note**: When you connect Cognos to Kyligence Enterprise, it will send a query which triggers full table scan. This will take a relatively long time to process the query when the dataset is extremely large. You can adjust parameter `kylin.query.force-limit` in `kylin.properties` to 1000, which indicates that the total records queried by statement `select *` from the data source is limited to 1000.

6. Click `Next`, you may test the connection in the`Metadata Wizard`.![](../images/cognos/9.png)


### Cognos & Kyligence Enterprise ACL Integration

In order to reflect Kyligence Enterprise Access Control in Cognos, it is necessary to allow Cognos users to query Kyligence Enterprise with their corresponding credentials. This following will introduce how to integrate the access permission of Cognos with Kyligence Enterprise by using a custom Java example, on the assumption that Cognos's authentication has been configured. For the details, please refer to the AuthenticationProvider document corresponding to Cognos SDK. The following diagram is a typical Cognos external authentication space using Java program:

![](../images/cognos/cognos_acl_1.png)

In the database of Cognos authentication, add usename and password for Kyligence Enterprise:

![](../images/cognos/cognos_acl_2.png)


Next, create a Cognos data source. You may refer to the 1st - 4th steps above. And select `An external namespace` in the 5th step as shown in below diagram:

![](../images/cognos/cognos_acl_3.png)

Click `Test the connection…` . If everything is set up properly, the connection testing will finish successfully, which means Cognos has been connected to Kyligence Enterprise's server through Kyligence Enterprise's ODBC. 

![](../images/cognos/8.png)

###Test Connection

Next, you may test the connection with tables.

Click next to finish metadata wizard.

![](../images/cognos/10.png)

![](../images/cognos/11.png)

Now, this new data source has been imported into the project. You can right click on a table to test the connection.

![](../images/cognos/12.png)

On the pop-up window, click `test sample` to test connection against this table. If the connection is correct, test results may return as shown in the screenshot below.

![](../images/cognos/13.png)

### Publish Package

In the project viewer, right click on Packages->Create ->Package to publish data source as a package.

![](../images/cognos/14.png)

Name the package.

![](../images/cognos/15.png)

Choose the table and column that you want to publish.

![](../images/cognos/16.png)

Leave the functions lists as default.

![](../images/cognos/17.png)

Now you have successfully created a new package. Next, open the `publish package wizard`. 

You may leave the rest of the below settings as default, and finish the wizard.

![](../images/cognos/18.png)

![](../images/cognos/19.png)

![](../images/cognos/20.png)

![](../images/cognos/21.png)

![](../images/cognos/22.png)

Now you have published the package.

###Create a Simple Chart

Now you can create a simple chart with newly the published package.

Go to your IBM Cognos Web. Launch Report Studio.

![](../images/cognos/23.png)

Choose the package you just created in the previous step.

![](../images/cognos/32.png)

In Cognos Report Studio, click `Create New`.

![](../images/cognos/24.png)

Click `Chart` to create a new chart with the new package.

![](../images/cognos/25.png)

Choose a chart type.

![](../images/cognos/26.png)

Drag PRICE from Kylin_sales table to Measure, and drag LSTG_FORMAT_NAME to series. 

Then click the `Play` button on the top menu to run this report. 

![](../images/cognos/27.png)

Now you have successfully created a new chart with Kyligence Enterprise as the data source.

![](../images/cognos/28.png)

### 



