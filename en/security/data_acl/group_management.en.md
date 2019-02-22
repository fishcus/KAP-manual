## User Group Management

This chapter provides an overview of what a user group is and how a user group can be managed. 

### About User Group

A user group is a collection of users, and users in a user group share the same ACL. By default, Kyligence Enterprise initializes four user groups, namely *ALL_USERS*, *ROLE_ADMIN*, *ROLE_ANALYST*, and *ROLE_MODELER*, and the *ALL_USERS* group is a default user group, all users are included in the *ALL_USERS* user group. The *ALL_USERS* user group cannot be modified or deleted. System administrators can add or remove users in user groups except *ALL_USERS*, or add a user to multiple groups except ALL_USERS. User groups cannot be renamed throughout the Kyligence Enterprise instance.


### About User Group Permissions

The system administrator can grant the project-level/row-level/table-level/column-level access permissions to a user group. When a user group has been granted the project-level/row-level/table-level/column-level permissions, users in this group will inherit the corresponding permissions from the group.

When a user group and a user in the user group have been set the project-level access permissions at the same time, the user's permission will take the highest permission. For example, if User A is granted *Query* permission in a project, while the user group which User A belongs to is set *Management* permission in this project, then User A has *Management* permission in this project.

If row-level/table-level/column-level access permissions of a user group have been revoked, users in this group will lost the corresponding permissions. If a user group is forbidden to access a table/row/column, while a user in this group is allowed to access the table/row/column, then the user is prohibited from accessing the table/row/column, and vice versa.

The permissions set for user and user group the user belongs to will work for the user simultaneously. For instance, a user group is forbidden to access Table A, a user in this group is prohibited to access Table B, then the user is not allowed to access Table A and Table B.

When a user belongs to multiple groups, the user will inherit the project-level permissions from the groups he/she belongs to. The row-level or column-level permissions the user inherits from different groups will be combined with logical operator AND.

For example, if user A belongs to two groups, North_Region and East_Region, and the two groups have been restricted row-level permission Region='North' and Region='East' respectively, then user A will inherit the two row-level permissions and the logical relation between them is AND, i.e. Region='North' AND Region ='East'. 

If user A belongs to two groups, North_Region and East_Region, and the two groups have been limited column-level permission, that is, group North_Region cannot access column East_sales and group East_Region cannot access column North_sales, then user A cannot access both columns.

### Manage user groups

Click *System* --> *Group* in the navigation bar to enter the User Group Management page.

### Create a user group

On the User Group Management page,  click *+ Group* button to create a new group. In the pop-up window, the system administrator can fill in the group name and click *Save* to save a new user group. 

### Delete a user group

On the User Group Management page, click *Action* --> *Delete*. In the pop-up window, the system administrator can confirm to delete a user group, once a user group is deleted, users in this user group will not be deleted and permission grant to this user group will be removed.

### Assign users to a user group

1. On the User Group Management page, select the user group to be assigned users to.
2. Click *Action* --> *Assign Users*.
3. In the pop-up window, check the users who need to be assigned to the group, click the *right arrow ( > )*, the user will be assigned to the *Assigned User*
4. Click *Save* and the user will be assigned to this group.

### Modify user's user group

Please refer to [User Management](user_management.en.md) 


### User Group Management when LDAP Enabled

Once LDAP is enabled, user group is read-only and cannot be added, edited, dropped, modified.

For more information on LDAP, please refer to [LDAP Authentication](ldap.en.md).