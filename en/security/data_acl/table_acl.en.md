## Table ACL

Table ACLs determines whether a user/user group can access a certain table loaded into Kyligence Enterprise. When a user/group is restricted to a table, the user/user group cannot query the table no matter through a cube, a table index, pushdown to other engines. User/group can use a cube that references a restricted accessing table, provided that the queries do not have restricted tables.


### Grant Table ACL

Normally, if a user has project ACL, the user will be automatically granted with the ACLs on all tables loaded into the project. 

Setting the project level configuration `kap.acl.project-internal-default-permission-granted=false` and new users will not be granted with table ACLs in the project automatically, manually granting table ACLs is needed.

Follow the below steps to grant table ACLs:

1. Click **Studio** on the left-side navigation bar.
2. Go to **Data Source**, click on a loaded table.
3. Click **Access**->**Table** tab.
4. Click **+Grant** to grant table ACL to user/user group. 

### Revoke Table ACL

Follow the below steps to revoke table ACLs:

1. Click **Studio** on the left-side navigation bar.
2. Go to **Data Source**, click on a loaded table.
3. Click **Access**->**Table** tab.
4. Choose a user/user group, and click **Action**->**Delete**.



> **Note**:
>
> 1. When a table is loaded into a project for the first time or Kyligence Enterprise is upgraded from a lower version > without table ACL, every user/user group has access to all tables that have been loaded into the project by default.
> 2. Table ACL needs to be set separately in different project which the same table is loaded into.
> 3. Please make sure the user/user group has the project ACL before setting table ACL.
> 4. Table ACL might be impacted by BI frontend cache, which is to say, if two users with different ACL browse the same report in BI, it's possible that BI uses the cache to render the result and thus bypass the access control.  
> 5. If user does not have permissions to tables or columns referenced by a model or cube in the project, the corresponding model or cube will be locked. User can hover over the lock icon and click more details to view the table-level and column-level permissions that the user does not have.