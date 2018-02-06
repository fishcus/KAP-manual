## Pushdown to 3rd Party SparkSQL

Spark is a fast and general engine for big data processing, with built-in modules for streaming, SQL, machine learning and graph processing.

Spark Thrift support Hive JDBC driver, through which applications with JDBC interface can access Spark to query data.

If you need pushdown to 3rd Party SparkSQL, you must have a Spark Thrift Server.
####Download Hive JDBC Driver

1. According to the hive version of hadoop cluster download [hive-jdbc-version.jar](hive-jdbc.jarhttps://mvnrepository.com/artifact/org.apache.hive/hive-jdbc). Be sure to use the JDBC version not to be higher than the hive version of the cluster.
2. Download [httpclient-version.jar](https://mvnrepository.com/artifact/org.apache.httpcomponents/httpclient) and [httpcore-version.jar](https://mvnrepository.com/artifact/org.apache.httpcomponents/httpcore) .

####Install Hive JDBC

Put the downloaded jar package into `$KAP_HOME/ext`, so that KAP can load the JDBC driver at startup.

#### Modify Kylin.properties

Modify `$KAP_HOME/conf/kylin.properties`, add Hive JDBC configuration.

- Configure Hive JDBC driver and Pushdown Runner:


``kylin.query.pushdown.runner-class-name=org.apache.kylin.query.adhoc.PushDownRunnerJdbcImpl``
``kylin.query.pushdown.jdbc.driver=org.apache.hive.jdbc.HiveDriver``

- Configure JDBC URL
  - With JDBC Url, spark_hs2_port is Spark Thrift port and spark_host is Spark Thrift hostname

  - Access Spark Thrift without kerberos security certification: ``kylin.query.pushdown.jdbc.url=jdbc:hive2://spark_host:spark_hs2_port/default``

  - Access Spark Thrift with kerberos security certification:To configure JDBC Clients for Kerberos Authentication with HiveServer2, they must include the principal of HiveServer2 (principal=<HiveServer2-Kerberos-Principal>) in the JDBC connection string. For example: ``kylin.query.pushdown.jdbc.url=jdbc:hive2://spark_host:spark_hs2_port/default;principal=Spark-Kerberos-Principal``

    - The Hive JDBC server is configured with Kerberos authentication if the hive.server2.authentication property is set to `kerberos` in the hive-site.xml file:

      ```xml
      <property>
           <name>hive.server2.authentication</name>
           <value>kerberos</value>
      </property>
      ```

      The **KAP must have a valid Kerberos ticket before you initiate a connection to HiveServer2** (use kinit) .

####Verify Thrift

 - Start beeline: ``${HIVE_HOME}/bin/beeline or ${SPARK_HOME}/bin/beeline``

 - Enter ``!connect ${kylin.query.pushdown.jdbc.url}``

 - Test some SQL to ensure its works fine

####Verify Query Pushdown

Start KAP to query loaded tables in the insight page.

If queries working track can be found in the Spark web page, it means KAP has been integrated with Spark normally.

![](images/query_pushdown_spark.png)



