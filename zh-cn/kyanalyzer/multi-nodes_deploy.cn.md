## 多节点部署

本节介绍如何将 KyAnalyzer 部署到多个 Linux 服务器（本文用 node1, node2, …, 表示）以及如何配置多节点可共同访问的 mysql。KyAnalyzer 多节点部署的基本架构如图所示：

![多节点部署架构图](images/multi-node_deploy.cn.png)

多节点部署的基本操作如下：

首先，修改每个 KyAnalyzer 节点的 conf/kyanalyzer.properties 配置文件，将其中的
"kap.host" 和 "kap.port" 两个配置项分别设置为同一个 Kyligence Enterprise 服务器的地址和端口（或者配置为同一个 Kyligence Enterprise 集群上的多个 Query Server）。

第二，按以下步骤修改 node1 的 KyAnalyzer 安装目录下的 repository/configuration.xml 文件：

- 在 < Repository > 域下添加使用 mysql 的 DataSource 配置，例如：

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

  其中 node0 为各节点都可访问的 mysql 的主机名，jackrabbit 为该 mysql 下的数据库名。

- 在 < Repository > 域下添加使用 mysql 数据库的 FileSystem，例如：

  ```
  <FileSystem class="org.apache.jackrabbit.core.fs.db.DbFileSystem"> 
    <param name="dataSourceName" value="ds1"/>  
    <param name="schemaObjectPrefix" value="repository_"/> 
  </FileSystem>
  ```

- 在 < Repository > 域下添加使用 mysql 数据库的 DataStore，例如：

  ```
  <DataStore class="org.apache.jackrabbit.core.data.db.DbDataStore"> 
    <param name="dataSourceName" value="ds1"/>  
    <param name="minRecordLength" value="1024"/>  
    <param name="copyWhenReading" value="true"/>  
    <param name="tablePrefix" value=""/>  
    <param name="schemaObjectPrefix" value=""/> 
   </DataStore>
  ```

- 在 < Repository > 的 < Workspace > 域下，按之前的 DataSource 配置将 FileSystem 修改为：

  ```
  <FileSystem class="org.apache.jackrabbit.core.fs.db.DbFileSystem"> 
    <param name="dataSourceName" value="ds1"/>  
    <param name="schemaObjectPrefix" value="${wsp.name}_"/> 
  </FileSystem>
  ```

- 在 < Repository >  的 < Workspace > 域下，按之前的 DataSource 配置将 PersistenceManager 修改为：

  ```
  <PersistenceManager class="org.apache.jackrabbit.core.persistence.pool.MySqlPersistenceManager"> 
    <param name="dataSourceName" value="ds1"/>  
    <param name="schemaObjectPrefix" value="${wsp.name}_"/> 
  </PersistenceManager>
  ```

- 在 < Repository > 的 < Versioning > 域下，按之前的 DataSource 配置将 FileSystem 修改为：

  ```
  <FileSystem class="org.apache.jackrabbit.core.fs.db.DbFileSystem"> 
    <param name="dataSourceName" value="ds1"/>  
    <param name="schemaObjectPrefix" value="version_"/> 
  </FileSystem>
  ```

- 在 < Repository > 的 < Versioning > 域下，按之前的 DataSource 配置将 PersistenceManager 修改为：

  ```
  <PersistenceManager class="org.apache.jackrabbit.core.persistence.pool.MySqlPersistenceManager"> 
    <param name="dataSourceName" value="ds1"/>  
    <param name="schemaObjectPrefix" value="version_"/> 
  </PersistenceManager>

  ```

- 修改 < Repository >  的 < Cluster > 域，将 ID 设置为 node1，并按之前的 DataSource 配置将 Cluster 修改为：

  ```
  <Cluster id="node1" syncDelay="5"> 
    <Journal class="org.apache.jackrabbit.core.journal.DatabaseJournal"> 
      <param name="dataSourceName" value="ds1"/> 
    </Journal> 
  </Cluster>
  ```


第三，将 node1 的 repository/configuration.xml 文件拷贝至其他节点，并替换各节点的 KyAnalyzer 安装目录下的 repository/configuration.xml 文件，修改该文件，将 < Repository > 中 < Cluster > 域的 ID 设置为 node2, node3, 等。

第四，如果 KyAnalyzer 不是新安装的并且之前启动过，则需要修改 repository/data/workspaces/default/workspace.xml 文件，将其中的 < FileSystem > 和 < PersistenceManager > 按上述第二步中 < Repository > 的 < Workspace > 域下的配置进行修改。如果 KyAnalyzer 从未启动过，可跳过此步骤。

至此，多节点部署完成，您可以启动各节点下的 KyAnalyzer，各节点中的元数据为同一份元数据。





