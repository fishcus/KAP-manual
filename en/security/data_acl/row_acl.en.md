## Row ACL

Row ACLs restrict the rows that user/user group can't access on the table. If the row access is restricted for one user/user group, the user/user group cannot query this row no matter through a cube, a table index, pushdown to underline query engines. User/user group can use a cube that references a restricted row, provided that the queries do not have restricted rows.

### Grant Row ACL

Row ACL will transform into a where clause that append on user/user group's query. If there are multiple values/groups filtered for the same column, the logical operator between these values are *OR*.  You may also set multiple row-level restriction at the same time for a user/user group, the logical operator between row-level restriction on two columns will be *AND*.

The where clause for row ACL can be previewed by clicking on the **Preview** hyperlink on the pop-up window. 

1. Click **Studio** on the left-side navigation bar.
2. Go to **Data Source**, click on a loaded table.
3. For that table, click **Access** tab, choose **Row**. 
4. Click **+Restrict** to restrict access to user/group. 
5. On the pop-up window, choose the user/user group.
6. Choose the column and fill in the filtering value.
7. (Optional) Click on **+** to add another column to filter. 
8. Click **Submit**.


#### Modify Row ACL

1. Click **Studio** on the left-side navigation bar.
2. Go to **Data Source**, click on a loaded table.
3. For that table, click **Access**->**Row**. 
4. Click **Action**->**Modify** button.
5. Add or Remove row ACL as you want.
6. Click **Submit**.

#### Revoke Row ACL

1. Click **Studio** on the left-side navigation bar.
2. Go to **Data Source**, click on a loaded table.
3. For that table, click **Access**->**Row**. 
4. Click **Action**->**Delete** button.



> **Note:**
>
> 1. When a table is loaded into a project for the first time or Kyligence Enterprise is upgraded from a lower version without row ACL, every user/user group has access to all rows by default.
> 2. Row ACL needs to be set separately in different project which the same table is loaded into.
> 3. Please make sure the user/user group has the project ACL before setting Row ACL.
> 4. Row ACL might be impacted by BI frontend cache, which is to say, if two users with different ACL browse the same report in BI, it's possible that BI uses the cache to render the result and thus bypass the access control.  

