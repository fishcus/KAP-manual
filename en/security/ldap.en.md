## LDAP Authentication

Kyligence Enterprise supports integration with LDAP servers for user authentication. This validation is achieved through the Spring Security framework, so it has a good versatility. Before enabling LDAP authentication, please contact your LDAP administrator for required information.

### Setup LDAP Server

Before enabling LDAP authentication, you need a running LDAP service. If you already have it, contact your LDAP administrator to get the necessary information including connectivity inforamtion, organization structure, etc..

If you don't have a LDAP server, you need to install one for Kyligence Enterprise. The recommended LDAP server tool is OpenLDAP Server 2.4, as it is an open source implementation under OpenLDAP Public License and is one of the most popular LDAP server implementations. It has been packaged in some Linux distributions like Red Hat Enterprise Linux. Tt can also be downloaded from http://www.openldap.org/

The installation may vary with different platforms. You may need check different documents or tutorials. Here we take CentOS 6.4 as an example:  

* Check installation

```shell
sudo find / -name openldap*
```

If it is not installed, install with yum command:

```shell
sudo yum install -y openldap openldap-servers openldap-clients
```

* Configure after installation

```shell
cp /usr/share/openldap-servers/slapd.conf.obsolete /etc/openldap/slapd.conf
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
mv /etc/openldap/slapd.d{,.bak}
```

Edit slapd.conf, take *example.com* as example, as follows：

1．Set the directory suffix

Find this line:

```
suffix "dc=my-domain,dc=com"
```

Change it to:

```
suffix "dc=example,dc=com"
```

2．Set DN for LDAP Administrator:

Find this line:

```
rootdn "cn=Manager,dc=my-domain,dc=com"
```

Change it to:

```
rootdn "cn=Manager,dc=example,dc=com"
```

3．Set password for LDAP administrator

Find this line:

```
rootpw secret
```

Replace the default value with an encrypted password string. To create an encrypted password string, type the following command:


```
slappasswd
```

When prompted, type and then re-type a password. The program prints the calculated encrypted password to the shell prompt.

Next, copy the newly created encrypted password into `/etc/openldap/slapd.conf` on one of the rootpw lines and remove the hash mark (#). When finished, the line should look similar to the following example:

```
rootpw {SSHA}vv2y+i6V6esazrIv70xSSnNAJE18bb2u
```

4．Change the owner for these configuration files

```shell
chown ldap.ldap /etc/openldap/*
chown ldap.ldap /var/lib/ldap/*
```

5．Create a new directory:

```shell
mkdir /etc/openldap/cacerts
```

6．Reboot the system, and then start the service:

```shell
sudo service slapd start
```

After the service is started, you can import some sample data.

7．Create new file example.ldif (three users and two groups are listed in this file)

```properties
# example.com
dn: dc=example,dc=com
objectClass: dcObject
objectClass: organization
o: Example, Inc.
dc: example

# Manager, example.com
dn: cn=Manager,dc=example,dc=com
cn: Manager
objectClass: organizationalRole

# People, example.com
dn: ou=People,dc=example,dc=com
ou: People
cn: People
objectClass: organizationalRole
objectClass: top

# johnny, People, example.com
dn: cn=johnny,ou=People,dc=example,dc=com
mail: johnny@example.io
ou: Manager
cn: johnny
sn: johnny wang
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
objectClass: top
userPassword:: ZXhhbXBsZTEyMw==

# jenny, People, example.com
dn: cn=jenny,ou=People,dc=example,dc=com
mail: jenny@example.io
ou: Analyst
cn: jenny
sn: jenny liu
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
objectClass: top
userPassword:: ZXhhbXBsZTEyMw==

# oliver, People, example.com
dn: cn=oliver,ou=People,dc=example,dc=com
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
objectClass: top
cn: oliver
sn: oliver wang
mail: oliver@example.io
ou: Modeler
userPassword:: ZXhhbXBsZTEyMw==

# Groups, example.com
dn: ou=Groups,dc=example,dc=com
ou: Groups
objectClass: organizationalUnit
objectClass: top

# itpeople, Groups, example.com
dn: cn=itpeople,ou=Groups,dc=example,dc=com
cn: itpeople
objectClass: groupOfNames
objectClass: top
member: cn=johnny,ou=People,dc=example,dc=com
member: cn=oliver,ou=People,dc=example,dc=com

# admin, Groups, example.com
dn: cn=admin,ou=Groups,dc=example,dc=com
cn: admin
member: cn=jenny,ou=People,dc=example,dc=com
objectClass: groupOfNames
objectClass: top
```

8．Import it with command:

```shell
/usr/bin/ldapadd -x -W -D "cn=Manager,dc=example,dc=com" -f example.ldif
```

When prompted a password, enter the password of LDAP administrator. Then the import will succeed.

9．Change password

```shell
For example:
Change passwd for: dn: cn=jenny,ou=People,dc=example,dc=com
ldappasswd -xWD cn=Manager,dc=example,dc=com -S cn=jenny,ou=People,dc=example,dc=com
It will show like:
Input New Password
Verify New Password
LDAP Administrator password
```


### Configure LDAP Information in Kyligence Enterprise

First, in `conf/kylin.properties`, configure the URL of the LDAP server and the username and password (if the LDAP server is not anonymous). For security reason, the password here need be encrypted with AES, you can run the below command to get the encrypted password:

```shell
${KYLIN_HOME}/bin/kylin.sh io.kyligence.kap.tool.general.CryptTool AES *your_password*
# ${crypted_password}
```

Then update `kylin.properties`:

```properties
# kylin.security.ldap.connection-server=ldap://<your_ldap_host>:<port>
# kylin.security.ldap.connection-username=<your_user_name>
# kylin.security.ldap.connection-password=<your_password_hash>

kylin.security.ldap.connection-server=ldap://127.0.0.1:389
kylin.security.ldap.connection-username=cn=Manager,dc=example,dc=com
kylin.security.ldap.connection-password=${crypted_password}
```

Second, provide user retrieval pattern, such as starting organization unit, filtering conditions etc.. The following is an example for reference:

```properties
#Define the range of user to sync to Kyligence Enterprise
kylin.security.ldap.user-search-base=ou=People,dc=example,dc=com
#Define the user name to login and validate
kylin.security.ldap.user-search-pattern=(&(cn={0}))
#Define the range of user group to sync to Kyligence Enterprise
kylin.security.ldap.user-group-search-base=ou=Groups,dc=example,dc=com

#Define the type of user to sync to Kyligence Enterprise
kylin.security.ldap.user-search-filter=(objectClass=person)
#Define the type of user group to sync to Kyligence Enterprise
kylin.security.ldap.group-search-filter=(|(objectClass=groupOfNames)(objectClass=group))
#Define users to sync to user group
kylin.security.ldap.group-member-search-filter=(&(cn={0})(objectClass=groupOfNames))
```

If you need service accounts (for system integration) to access Kyligence Enterprise, follow the example below to configure `ldap.service. *`, otherwise leave them blank.

```properties
# LDAP service account directory
kylin.security.ldap.service-search-base=ou=People,dc=example,dc=com
kylin.security.ldap.service-search-pattern=(&(cn={0}))
kylin.security.ldap.service-group-search-base=ou=Groups,dc=example,dc=com
```

### Configure Administrator Groups and Default Roles

Kyligence Enterprise allows mapping an LDAP group to the administrator role: In kylin.properties, set "kylin.security.acl.admin-role" to the LDAP group name (case sensitive). In this example, you would like to use the group "admin" to manage all Kyligence Enterprise administrators, then this property should be set as:

```
kylin.security.acl.admin-role=admin
```

When upgrading from KAP 2.5.4 or prior to 2.5.4 or later, please remove the `ROLE_` in this setting that is required in the 2.5.4 or prior versions and the LDAP group name is now case sensitive and shall not be all capitalized any more.

### Enable LDAP

In 	`conf/kylin.properties`, set "kylin.security.profile=ldap"，and then restart Kyligence Enterprise.

If we login Kyligence Enterprise with `jenny` who belongs to group `admin`, `System` menu will be displayed in the navigation bar:

![Login as user in Admin group](images/ldap/w_1.png)

Otherwise, if `johnny` who belongs to group `itpeople`, `System` menu won't be displayed in the navigation bar since the group `itpoeple` is not an admin group.

![Login as user in Normal User group](images/ldap/w_2.png)

Once LDAP is enabled, the user/group is read-only and cannot be added, edited, dropped, modified or grouped.

### LDAP user information cache

After users login to Kyligence Enterprise by LDAP authentication, their information will be cached to reduce overhead of accessing LDAP server. You can set configuration of cache time (seconds) and max cache entries in kylin.properties. Default values are shown below: 

```properties
kylin.server.auth-user-cache.expire-seconds=300
kylin.server.auth-user-cache.max-entries=100
```

