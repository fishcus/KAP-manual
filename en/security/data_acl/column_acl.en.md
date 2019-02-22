## Column ACL

Column ACLs restrict the columns that user/group can access on the table. If the column access is restricted for one user/user group, the user/user group cannot query this column no matter through a cube, a table index, pushdown to underline query engines.  User/user group can use a cube that references a restricted column, provided that the queries do not have restricted columns.

### Grant Column ACL

1. Click **Studio** on the left-side navigation bar.
2. Go to **Data Source**, click on a loaded table.
3. Click **Access**->**column**.
4. Click **+ Restrict** to restrict access. 
5. On the pop-up window, choose a user/group. 
6. Multipe-select columns and then click the right arrow to move the column to be restricted. 
7. Click **Submit**.

### Modify Column ACL

1. Click **Studio** on the left-side navigation bar.
2. Go to **Data Source**, click on a loaded table.
3. For that table, click **Access** tab, choose column.
4. Under **Action**, click **Modify** button. 
5. On the pop-up window, modify restricted column as you wish.
6. Click **Submit**.

### Revoke Column ACL

1. Click **Studio** on the left-side navigation bar.
2. Go to **Data Source**, click on a loaded table.
3. For that table, click **Access** tab, choose column.
4. Under **Action**, click **Delete** button. 



>**Note:**
>
>1. When a user/group sends `select * from table` query on the table that contains restricted column, the query will return the result without the restricted column. 
>2. When a table is loaded into a project for the first time or Kyligence Enterprise is upgraded from a lower version without column ACL, every user/group has access to all columns by default.
>3. Column ACL needs to be set separately in different project which the same table is loaded into.
>4. Please make sure the user/group has the project ACL before setting column ACL.
>5. Column ACL might be impacted by BI frontend cache, which is to say, if two users with different ACL browse the same report in BI, it's possible that BI uses the cache to render the result and thus bypass the access control.  

