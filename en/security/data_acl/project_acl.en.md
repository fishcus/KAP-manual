## Project ACL

Project ACLs determines whether a user/user group can access a certain project in Kyligence Enterprise. Kyligence Enterprise has four built-in project level permissions, *Admin*, *Management*, *Operation* and *Query*. *Admin* includes the other three permissions, *Management* includes *Operation* and *Query* permissions, *Operation* includes *Query* permissions.

- *QUERY*: Permission to query tables/cubes in the project. If pushdown is enabled, user/group can query tables loaded to the project when there's no ready cube to answer the query.
- *OPERATION*: Permission to build a cube in the project, including rebuild a segment, resume or discard jobs. 
- *MANAGEMENT*: Permission to edit/delete models and cubes in the project. 
- *ADMIN*: Permission to manage data sources, models and cubes in the project.

> **Note:** After the system administrator assigns project access permission to a group, users in the group will inherit the access permission on data source, models and cubes accordingly.


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

