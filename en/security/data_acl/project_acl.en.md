## Project ACL

Project ACLs determines whether a user/user group can access a certain project in Kyligence Enterprise. Kyligence Enterprise has four built-in project level permissions, *Admin*, *Management*, *Operation* and *Query*. *Admin* includes the other three permissions, *Management* includes *Operation* and *Query* permissions, *Operation* includes *Query* permissions.

- **QUERY**: Permission to query tables/cubes in the project. If pushdown is enabled, user/group can query tables loaded to the project when there's no ready cube to answer the query.
- **OPERATION**: Permission to build a cube in the project, including rebuild a segment, resume or discard jobs. 
- **MANAGEMENT**: Permission to edit/delete models and cubes in the project. 
- **ADMIN**: Permission to manage data sources, models and cubes in the project.

> **Note:** After the system administrator assigns project access permission to a group, users in the group will inherit the access permission on data source, models and cubes accordingly.



### Role Access Control List

| Functionality                                                | SYSTEM ADMIN | PROJECT ADMIN | MANAGEMENT | OPERATION | QUERY |
| ------------------------------------------------------------ | ------------ | ------------- | ---------- | --------- | ----- |
| Add/Delete  project                                          | Yes          | No            | No         | No        | No    |
| Edit/Back up  project                                        | Yes          | Yes           | No         | No        | No    |
| View project  Detail                                         | Yes          | Yes           | Yes        | Yes       | Yes   |
| Add, edit,  Delete project access                            | Yes          | Yes           | No         | No        | No    |
| View System  Dashboard                                       | Yes          | Yes           | Yes        | Yes       | Yes   |
| View Studio                                                  | Yes          | Yes           | Yes        | Yes       | Yes   |
| View Data  Source page                                       | Yes          | Yes           | Yes        | No        | No    |
| Load, unload,reload data source                              | Yes          | Yes           | No         | No        | No    |
| View table,  row, and column-level access control            | Yes          | Yes           | Yes        | No        | No    |
| Add, modify,  delete table, row and column-level access control | Yes          | Yes           | No         | No        | No    |
| View Model  page                                             | Yes          | Yes           | Yes        | Yes       | Yes   |
| view models                                                  | Yes          | Yes           | Yes        | Yes       | Yes   |
| add, edit, clone, delete model. perform model health check   | Yes          | Yes           | Yes        | No        | No    |
| View cube page                                               | Yes          | Yes           | Yes        | Yes       | Yes   |
| view cube detail                                             | Yes          | Yes           | Yes        | Yes       | Yes   |
| Edit Cube  Description                                       | Yes          | Yes           | Yes        | No        | No    |
| Add,  enable/disable, clone, purge cube                      | Yes          | Yes           | Yes        | No        | No    |
| Build, manage  Cube                                          | Yes          | Yes           | Yes        | Yes       | No    |
| Add, edit,  delete Cube                                      | Yes          | Yes           | Yes        | No        | No    |
| Export TDS file of Cube                                      | Yes          | Yes           | Yes        | Yes       | Yes   |
| View, edit and  delete Cube draft                            | Yes          | Yes           | Yes        | No        | No    |
| View Insight  page                                           | Yes          | Yes           | Yes        | Yes       | Yes   |
| Query Insight  page                                          | Yes          | Yes           | Yes        | Yes       | Yes   |
| View Monitor  page                                           | Yes          | Yes           | Yes        | Yes       | No    |
| View System  page                                            | Yes          | No            | No         | No        | No    |
| Manage system                                                | Yes          | No            | No         | No        | No    |
| Manage user/group                                            | Yes          | No            | No         | No        | No    |

### Grant Project ACL

1. Click **Dashboard**->**Projects** to go to the project management page.
2. Expand a project on the project list.
3. Click **Access**->**+Grant** to grant access for a user/user group.
4. Select the user/user group and access permission to be granted, and click **Submit**. 


### Modify Project ACL

1. Click **Dashboard**->**Projects** to go to the project management page.
2. Expand a project on the project list.
3. Click **Access**->**Edit** 
4. Modify user/user group's access permission and click **Submit**. 

### Revoke Project ACL

1. Click **Dashboard**->**Projects** to go to the project management page.
2. Expand a project on the project list.
3. Click **Access**  tab.
4. Select a user/user group, then click **Delete**.

> **Caution**: When user/user group's project access permission has been revoked, all access permission on this project including table-level, row-level and column-level will be revoked subsequently.

###  Data ACL Grant Control

Setting the system level configuration parameter ` kylin.security.allow-project-admin-grant-acl=false ` and the project administrator can't grant table/row/column access to user/user group, but can still view user/user group's table/row/column level access permission.

