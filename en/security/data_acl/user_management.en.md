## User Management

This chapter introduces what a user is and how a user can be managed. 

### About Users

To use Kyligence Enterprise, a user must log in to the system using a user name and corresponding password. Every user is unique in a Kyligence Enterprise instance, which is to say, it is not necessary to create the same user for every project in a single instance. 
By default, Kyligence Enterprise initializes three users, namely `ADMIN`, `MODELER` and `ANALYST`. The user `ADMIN` is a built-in system administrator, and the system administrator has all the permissions of the entire system.


### Manage Users

After the system administrator logs in to Kyligence Enterprise, click the *System* button in the navigation bar to enter the system management page, and click the *User* field to enter the User Management page.

*Caution*:
1. Except for the system administrator, simply creating a user does not give the user access to any project.
2. Except for  the system administrator, other users need to be given access at the project level.


### Add a user

On the User Management page, the system administrator can click the *+Users* button to add new users. In the pop-up window, please fill in the user name, password,  confirm new password, select whether the user role is a system administrator or a normal user, and click *Ok*.


#### Edit a user role

On the User Management page, click *Action* --> *...* -->*Edit Role*.In the pop-up window,  the system administrator can modify user role. 

### Delete a user

On the User Management page,  click *Action* --> *...* -->*Drop*. The system administrator can confirm to delete a user in the prompted window. User can not be restored after deleting, and user's access permission on all projects will be removed.

### Enable/Disable a user

On the User Management page,  click *Action* --> *...* -->*Enable/Disable*. The system administrator can enable or disable a user, and disabled users cannot login to the system. 

### Reset password for ADMIN

On the User Management page,  click *Action* -->*Reset Password*.
In the pop-up window, the system administrator can change the password and need to enter the new password twice.
The initial ADMIN account password needs to be modified after the first login. To restore the initial password, you can execute the following command:
```sh
$KYLIN_HOME/bin/kylin.sh admin-password-reset
```

### Reset password for non-admin

Click  *<username\>*-->*Setup* on the top right corner of the navigation bar. In the pop-up window,  user can reset the password, need to provide the old password and repeat the new password twice.


### Assign a user to a group

To assign a user to a group, please do the followings:
1. On the User Management page,  select a user to be grouped.
2. Click *Action* --> *...* --> *Group Membership*.
3. Select a group to assign the user to under *Group to be selected*, and then click the right arrow. The group will enter *Checked Groups*.
4. Click *Save* and the user will be in the selected group.


### Modify user's group membership

To modify user's group, please do the followings:
1. On the User Management page,  select the user to modify the group membership.
2.  Click *Action* --> *...* --> *Group Membership*.
3. Select the group to be modified under *Checked Group*, and then click the left arrow. The group will enter into *Group to be selected*.
4. Click *Save* and the user's group membership will be modified.


###  User Management when LDAP Enabled

Once LDAP is enabled, user is read-only and cannot be added, edited, dropped, modified or grouped.

For more information on LDAP, please refer to  [LDAP Authentication](../ldap.en.md).