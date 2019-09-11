## Manage Access Control

Kyligence Enterprise provides a rich set of access control features for big enterprise. Start from Kyligence Enterprise 3.3.2, every action from user must satisfy both **Operation Permission** and **Data Access Permission**, before the action can perform.

- Operation Permission: Defined at project level, specifies what operations a user can perform within a project. User can have one of the four permissions, from weak to powerful:

  - *QUERY*: Allows to run query in a project.
  - *OPERATION*: Allows to operate cubes, like build, refresh, and manage segments. Implies the QUERY permission.
  - *MANAGEMENT*: Allows to manage models and cubes, like create and edit. Implies the OPERATION permission.
  - *ADMIN*: Project level administrator permission, allows to manage source tables, and all other operations in a project.

  Read more about [Project ACL](project_acl.en.md).

- Data Access Permission: Defined on data, specifies which tables, columns, and rows a user can access.

  - Table ACL: Defines a user can access which tables. Read more about [Table ACL](table_acl.en.md).
  - Column ACL: Defines a user can access which columns in a table. Read more about [Column ACL](column_acl.en.md).
  - Row ACL: Defines a user can access which rows in a table. Read more about [Row ACL](row_acl.en.md).



### Examples of Permission Check

To perform an action, user must have both operation permission and data access permission. Below are a few examples.

- To manage source tables, user needs the ADMIN permission, and only the tables user can access can be seen and acted. (Column and row ACLs does not impact the source table management.)
- To edit a model, user must have the MANAGEMENT permission and have access to all the tables and columns in the model. (Row ACL does not impact the model access check.) If user does not have access to some tables or columns in the model, he/she can still see the model but cannot open or edit it.
- To edit a cube, the check is similar to model.
- Running queries is mostly about data access control, since all users in a project have at least QUERY permission. First user must have access to all the tables and columns in the query, or the system will prompt permission error and refuse to execute. Second the system will only return rows that are accessible to a user. If different row ACLs are set for users, they may see different results from a same query.



### Other Notes

- Kyligence Enterprise also supports delegating data access checks to a 3rd-party system. By doing so, you can use an existing system (like Hive) to control the data access in Kyligence Enterprise, saving the effort of repeated security settings. Read more about [Integrate with 3rd-party Authorization System](../integrate_with_3rd_acl.en.md).

- The system administrator is not restricted by the data access controls by default, he/she has access to all data. If you want the system administrator be restricted too, please add the below in `conf/kylin.properties`:

  ```properties
  kylin.security.allow-admin-read-all=false
  ```

- For broken models, only the system administrator and the model creator can open and edit the model, since the table and column information in the model maybe lost. Broken cubes are similar.

- For calculated columns, data access check does not consider the columns it refers to.

- The system does not provide operation permissions at model or cube level yet.
