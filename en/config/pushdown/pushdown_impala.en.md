## Pushdown to Impala

Impala raises the bar for SQL query performance on Apache Hadoop while retaining a familiar user experience. With Impala, you can query data, whether stored in HDFS or Apache HBase – including SELECT, JOIN, and aggregate functions – in real time. Furthermore, Impala uses the same metadata, SQL syntax (Hive SQL), ODBC driver, and user interface (Hue Beeswax) as Apache Hive, providing a familiar and unified platform for batch-oriented or real-time queries. (For that reason, Hive users can utilize Impala with little setup overhead.)

Impala supports Hive JDBC driver, through which applications with JDBC interface can access Impala to query data.

If you need pushdown to Impala, you must have a Impala Thrift Server.

#### Download Hive JDBC Driver

1. According to the Hive version of Hadoop cluster download [hive-jdbc-version.jar](hive-jdbc.jarhttps://mvnrepository.com/artifact/org.apache.hive/hive-jdbc). Be sure the JDBC version is not higher than the Hive version of the cluster.
2. Download [httpclient-version.jar](https://mvnrepository.com/artifact/org.apache.httpcomponents/httpclient) and [httpcore-version.jar](https://mvnrepository.com/artifact/org.apache.httpcomponents/httpcore)

####Install Hive JDBC

Put the downloaded jar package into `$KAP_HOME/ext`, so that KAP can be loaded at startup JDBC Driver

#### Modify kylin.properties

Modify `$KAP_HOME/conf/kylin.properties`, add Hive JDBC configuration

- Configure Hive JDBC driver and Pushdown Runner:

  ```properties
  kylin.query.pushdown.runner-class-name=org.apache.kylin.query.adhoc.PushDownRunnerJdbcImpl
  kylin.query.pushdown.jdbc.driver=org.apache.hive.jdbc.HiveDriver
  ```


- Configure JDBC Url
  - With JDBC Url, impala_hs2_port is Impala Thrift port(default thrift port is 21050) and impala_host is Impala Thrift hostname(the hostname where Impala Daemon component node)

  - Access Impala Thrift without kerberos security certification:

    ```properties
    kylin.query.pushdown.jdbc.url=jdbc:hive2://impala_host:impala_hs2_port/default;auth=noSasl
    ```

  - Access Impala with kerberos security certification:To configure JDBC Clients for Kerberos Authentication with HiveServer2, they must include the principle of HiveServer2 (principal=<HiveServer2-Kerberos-Principal>) in the JDBC connection string. For example:

    ```properties
    kylin.query.pushdown.jdbc.url=jdbc:hive2://impala_host:impala_hs2_port/default;principal=Impala-Kerberos-Principal
    ```

    - The Hive JDBC server is configured with Kerberos authentication if the hive.server2.authentication property is set to `kerberos` in the hive-site.xml file:

      ```xml
      <property>
           <name>hive.server2.authentication</name>
           <value>kerberos</value>
      </property>
      ```

      The **KAP must have a valid Kerberos ticket before you initiate a connection to HiveServer2** (use kinit).

####Verify thrift

 - Start beeline:  ``${HIVE_HOME}/bin/beeline or ${SPARK_HOME}/bin/beeline``

 - Enter ``!connect ${kylin.query.pushdown.jdbc.url}``

- Test some SQL queries and ensure they work correctly

####Verify Query Pushdown

- Start KAP to query loaded tables in the insight page


- If queries working track can be found in the Impala web page, it means KAP has been integrated with Impala normally
- ![](images/query_pushdown_impala.png)




