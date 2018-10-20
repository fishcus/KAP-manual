## Multi-node Deployment

This section introduces how to deploy KyAnalyzer to multiple Linux servers (indicated by node1, node2,…, in this article) and how to configure mysql which multiple nodes may access. The architecture diagram of multi-node deployment is as below: 

![KyAnalyzer Multi-node Deployment Architecture](images/multi-node_deploy.en.png)

To deploy KyAnalyzer to multiple nodes, do the following: 

Firstly, modify the configuration file *conf/kyanalyzer.properties* for each KyAnalyzer node and respectively set "kap.host" and "kap.port" to the IP address and port of the same Kyligence Enterprise server (or configure to multiple Query Servers in one Kyligence Enterprise cluster).

Secondly, do the following steps to modify the *repository/configuration.xml* file under KyAnalyzer installation directory of node1:

- Under < Repository > domain, add DataSource configuration which uses mysql, for example:

  ```
  <DataSources>
    <DataSource name="ds1">
      <param name="driver" value="com.mysql.jdbc.Driver"/>
      <param name="url" value="jdbc:mysql://node0:3306/jackrabbit?autoReconnect=true"/>
      <param name="user" value="root"/>
      <param name="password" value=""/>
      <param name="databaseType" value="mysql"/>
      <param name="validationQuery" value="select 1"/>
      <param name="maxPoolSize" value="10"/>
    </DataSource>
  </DataSources>
  ```

  Where, node0 is the host of mysql which each node can access, and jackrabbit is the database name under this mysql.

- Under < Repository > domain, add FileSystem which uses mysql database, for example:

  ```
  <FileSystem class="org.apache.jackrabbit.core.fs.db.DbFileSystem"> 
    <param name="dataSourceName" value="ds1"/>  
    <param name="schemaObjectPrefix" value="repository_"/> 
  </FileSystem>
  ```

- Under < Repository > domain, add DataStore which uses mysql database, for example:

  ```
  <DataStore class="org.apache.jackrabbit.core.data.db.DbDataStore"> 
    <param name="dataSourceName" value="ds1"/>  
    <param name="minRecordLength" value="1024"/>  
    <param name="copyWhenReading" value="true"/>  
    <param name="tablePrefix" value=""/>  
    <param name="schemaObjectPrefix" value=""/> 
   </DataStore>
  ```

- Under < Workspace > of < Repository > domain, modify FileSystem to the following based on previous DataSource configuration: 

  ```
  <FileSystem class="org.apache.jackrabbit.core.fs.db.DbFileSystem"> 
    <param name="dataSourceName" value="ds1"/>  
    <param name="schemaObjectPrefix" value="${wsp.name}_"/> 
  </FileSystem>
  ```

- Under < Workspace > of < Repository > domain, modify PersistenceManager to the following based on previous DataSource configuration: 

  ```
  <PersistenceManager class="org.apache.jackrabbit.core.persistence.pool.MySqlPersistenceManager"> 
    <param name="dataSourceName" value="ds1"/>  
    <param name="schemaObjectPrefix" value="${wsp.name}_"/> 
  </PersistenceManager>
  ```

- Under < Versioning > of < Repository > domain, modify FileSystem to the following based on previous DataSource configuration: 

  ```
  <FileSystem class="org.apache.jackrabbit.core.fs.db.DbFileSystem"> 
    <param name="dataSourceName" value="ds1"/>  
    <param name="schemaObjectPrefix" value="version_"/> 
  </FileSystem>
  ```

- Under < Versioning > of < Repository > domain, modify PersistenceManager to the following based on previous DataSource configuration: 

  ```
  <PersistenceManager class="org.apache.jackrabbit.core.persistence.pool.MySqlPersistenceManager"> 
    <param name="dataSourceName" value="ds1"/>  
    <param name="schemaObjectPrefix" value="version_"/> 
  </PersistenceManager>

  ```

- Modify < Cluster > of < Repository > domain, set ID to node1, and modify Cluster to the following based on previous DataSource configuration: 

  ```
  <Cluster id="node1" syncDelay="5"> 
    <Journal class="org.apache.jackrabbit.core.journal.DatabaseJournal"> 
      <param name="dataSourceName" value="ds1"/> 
    </Journal> 
  </Cluster>
  ```


Thirdly, copy the file *repository/configuration.xml* under node1 to other node, replace the file *repository/configuration.xml* under KyAnalyzer installation directory of each node, modify this file, and set the ID of < Cluster > in < Repository > domain to node2, node3 and etc.

Fourthly, if you have installed KyAnalyzer and started it, you need to modify the file *repository/data/workspaces/default/workspace.xml* and change < FileSystem > and < PersistenceManager > in it based on the configuration under < Workspace > of < Repository > domain in the above second step. If KyAnalyzer has not been started before, you may ignore this step.

So far, you have completed KyAnalyzer multi-node deployment. You may start KyAnalyzer under each node. Each node shares the same metadata.





