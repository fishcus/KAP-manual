## User Group Management

## User Group Management

This section provides an overview of what a user group is and how a user group can be managed. 

###About User Group

User group is a collection of users. Users in a user group share the same permissions through the group. In a large organization/enterprise, user's permissions are usually granted on a user group basis, so that users who have the same permissions can be set in bulk. This will greatly improve the productivity in such scenario.

The group `All Users` is a default user group. A user will enter into this group once being created. That means the group `All Users` includes all users created. This group cannot be modified or deleted. The system administrator can bulk add or delete users to/from a group except for `All Users`, and add a user to multiple groups except for `All Users`. The name of a user group shall be unique in Kyligence Enterprise.

### About User Group Permissions

The system administrator can grant the project-level/row-level/table-level/column-level access permissions to a user group. When a user group has been granted the project-level/row-level/table-level/column-level permissions, users in this group will inherit the corresponding permissions from the group.

When a user group and a user in the user group have been set the project-level access permissions at the same time, the user's permission will take the highest permission. For example, if User A is granted *Query* permission in a project, while the user group which User A belongs to is set *Management* permission in this project, then User A has *Management* permission in this project.

If row-level/table-level/column-level access permissions of a user group have been revoked, users in this group will lost the corresponding permissions. If a user group is forbidden to access a table/row/column, while a user in this group is allowed to access the table/row/column, then the user is prohibited from accessing the table/row/column, and vice versa.

The permissions set for user and user group the user belongs to will work for the user simultaneously. For instance, a user group is forbidden to access Table A, a user in this group is prohibited to access Table B, then the user is not allowed to access Table A and Table B.

When a user belongs to multiple groups, the user will inherit the project-level permissions from the groups he/she belongs to. The row-level or column-level permissions the user inherits from different groups will be combined with logical operator AND.

For example, if user A belongs to two groups, North_Region and East_Region, and the two groups have been restricted row-level permission Region='North' and Region='East' respectively, then user A will inherit the two row-level permissions and the logical relation between them is AND, i.e. Region='North' AND Region ='East'. 

If user A belongs to two groups, North_Region and East_Region, and the two groups have been limited column-level permission, that is, group North_Region cannot access column East_sales and group East_Region cannot access column North_sales, then user A cannot access both columns.

### Manage User Group

#### Manage user group a user belongs to

In a real scenario, an employee may belong to different departments. That means in the information system, a user can be in multiple user groups in the enterprise. For example, a user can not only be in a development group, but also be in a product group which the developed product belongs to.

The system administrator can manage user groups by adding a user to different groups in bulk, and deleting a user from multiple groups except for the group `All Users`. When a user group is deleted, users in this group will not be deleted, but all permissions granted to this group will be deleted.

#### Manage users in a user group

The system administrator can add or delete users in a user group except for the group All Users in bulk. A user can be added to multiple groups.

### Action Steps

#### Enter User Group Page

Login to Kyligence Enterprise and click `System` button on the navigation bar. The system management page will then show. Next, click `Group` bar on the left side to enter the group management page. Only system admin could get access to the group management page. There are four default user groups in Kyligence Enterprise: ALL_USERS, ROLE_ADMIN, ROLE_ANALYST and ROLE_MODELER.

Once a user group is created, the system admin can add, delete, modify and assign users on the group management page. 

![User group page](images/group/group_w1.png)


#### Create User Group
Under group management page, click `+ Group` button to create a new group. In the pop-up window, type in a group name and click `Save`. 

![Create user group](images/group/group_w2.png)

#### Assign User to User Group

To assign a user to a user group, do the following:

1. Under group management page, select a group to assign a user to.
2. Click `…` under `Action`, and choose `Assign Users`. 
3. Select a user to assign to the group under `Unassigned Users`, and then click the right arrow. The user will enter `Assigned Users`. 
4. Click `Save` and the user will be assigned to the group.

![Assign user to user group](images/group/group_w3.png)

#### Modify User's Group

Please refer to [User Management](user.en.md) in this chapter.

#### Grant Access for Group

Please refer to [Manage Access Permission](acl.en.md) in this chapter.

#### User Group Management when LDAP Enabled

Once LDAP is enabled, user group is read-only and cannot be added, edited, dropped, modified.

![User group management when LDAP enabled](images/group/group_w4.png)

For more information on LDAP, please see [LDAP Authentication](ldap.en.md) in this chapter.