## Integrate with LDAP

Kyligence Enterprise supports integration with LDAP servers for user authentication.

The structure of this chapter is as follows:

- [Prepare a LDAP server](#pre)
  - [Install OpenLDAP](#open-ldap)
  - [Configure LDAP Service With Microsoft Azure Active Directory Service](#azure-ad)
- [Configure in Kyligence Enterprise](#config)


### Prepare a LDAP server {#pre}

Before enabling LDAP authentication, you need a running LDAP service. If you already have it, contact your LDAP administrator to get the necessary information including connectivity information, organization structure, etc..

#### Install OpenLDAP {#open-ldap}

If you don't have a LDAP server, you need to install one for Kyligence Enterprise. The recommended LDAP server tool is OpenLDAP Server 2.4, as it is an open source implementation under OpenLDAP Public License and is one of the most popular LDAP server implementations. It has been packaged in some Linux distributions like Red Hat Enterprise Linux. It can also be downloaded from http://www.openldap.org/

The installation may vary with different platforms. You may need check different documents or tutorials. Here we take CentOS 6.4 as an example: 

- Check installation
  ```sh
  sudo find / -name openldap*
  ```

- If it is not installed, install with yum command:
  ```sh
  sudo yum install -y openldap openldap-servers openldap-clients
  ```

- Config LDAP
  ```sh
  cp /usr/share/openldap-servers/slapd.conf.obsolete /etc/openldap/slapd.conf
  cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
  mv /etc/openldap/slapd.d{,.bak}
  ```
  - Modify `slapd.conf`, take `example.com` as an example, follow the below steps,

    - Set directory tress suffix
      Modify `suffix "dc=my-domain,dc=com"` to `suffix "dc=example,dc=com"`  
    - Set DN for LDAP Administrator
      Modify `rootdn "cn=Manager,dc=my-domain,dc=com"` to `rootdn "cn=Manager,dc=example,dc=com"`
    - Set password for LDAP administrator
      Modify `rootpw secret`, replace `secret` with clear text.
      If you want to create an encrypted password, please execute the following commands,

      ```sh
      slappasswd
      ```
      Type in the password, and the encrypted password will be printed out in console, please copy that to the `rootpw` as below,
      ```
      rootpw	{SSHA}vv2y+i6V6esazrIv70xSSnNAJE18bb2u
      ```
  - Change access permission
      ```sh
      chown ldap.ldap /etc/openldap/*
      chown ldap.ldap /var/lib/ldap/*
      ```

- Create a new directory `/etc/openldap/cacerts`
    ```sh
    mkdir /etc/openldap/cacerts
    ```

- Restart LDAP service
    ```sh
    sudo service slapd start
    ```
- Create a new file `example.ldif`, including 3 users and 2 groups
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

- Import user using shell script,
  ```sh
  /usr/bin/ldapadd -x -W -D "cn=Manager,dc=example,dc=com" -f example.ldif
  ```

- Change user password

  The administrator can change user's password by the following shell script,
  ```sh
  ldappasswd -xWD cn=Manager,dc=example,dc=com -S   cn=jenny,ou=People,dc=example,dc=com
  ```


#### Configure LDAP Service With Microsoft Azure Active Directory Service {#azure_ad}

In addition to using a local LDAP server, Kyligence Enterprise also supports LDAP validation through the Active Directory service. For example you can achieve the LDAP validation through Microsoft Azure Active Directory Service which requires the following pre-work before authentication:

- You can subscribe and create a Azure Active Directory (referred to as AD).The installation and configuration information, please refer to following link for details: [ Azure Active Directory Setup](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-access-create-new-tenant)
- After the Azure AD Service configuration is complete, you can setup the Azure AD domain service, which provides the managed domains service, you can refer this guide [Azure AD Domain Configuration](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/active-directory-ds-overview) for Configuration.
- After finished the Azure AD Service configuration, you can configure users and groups on Azure AD UI page, also you can configure the Organizational Unit(OU) through the Azure AD Domain Services managed domain, you can refer this guide [Azure AD domain service create ou](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/active-directory-ds-admin-guide-create-ou) for configuration.


### Configure in Kyligence Enterprise {#config}

- Configure LDAP server information

  Config LDAP server url in `$KYLIN_HOME/conf/kylin.properties`, providing necessary user name and password. For security's sake, please encrypt the password with AES algorithm, you can obtain the encrypted password by the below shell scripts,
  ```sh
  ${KYLIN_HOME}/bin/kylin.sh io.kyligence.kap.tool.general.CryptTool AES your_password
  ```
  Configuration is as below,
  ```properties
  kylin.security.ldap.connection-server=ldap://<your_ldap_host>:<port>
  kylin.security.ldap.connection-username=<your_user_name>
  kylin.security.ldap.connection-password=<your_password_hash>
  ```
  Sample configuration is as below,
  ```
  kylin.security.ldap.connection-server=ldap://127.0.0.1:389
  kylin.security.ldap.connection-username=cn=Manager,dc=example,dc=com
  kylin.security.ldap.connection-password=${crypted_password}
  ```

- Provide user retrieval pattern
  Such as starting organization unit, filtering conditions etc.. The following is an example for reference,
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
  kylin.security.ldap.group-member-search-filter=(&(cn={0})  (objectClass=groupOfNames))
  ```

- Configure service accounts for system integration
  If you need service accounts to access Kyligence Enterprise, sample configuration is as below, otherwise leave them blank.

  ```properties
  # LDAP service account directory
  kylin.security.ldap.service-search-base=ou=People,dc=example,dc=com
  kylin.security.ldap.service-search-pattern=(&(cn={0}))
  kylin.security.ldap.service-group-search-base=ou=Groups,dc=example,dc=com
  ```

- Configure administrator groups

  Kyligence Enterprise allows mapping an LDAP group to the administrator role: in `kylin.properties`, set `kylin.security.acl.admin-role` to the LDAP group name (case sensitive). In this example, you would like to use the group `admin` to manage all Kyligence Enterprise administrators, then this property should be set as:
  ```properties
  kylin.security.acl.admin-role=admin
  ```

- Enable LDAP

  Set `kylin.security.profile=ldap` in `$KYLIN_HOME/conf/kylin.properties`, and restart Kyligence Enterprise.


- LDAP user information cache

  After users login to Kyligence Enterprise by LDAP authentication, their information will be cached to reduce overhead of accessing LDAP server. You can set configuration of cache time (seconds) and max cache entries in kylin.properties. Default values are shown below: 

  ```properties
  kylin.server.auth-user-cache.expire-seconds=300
  kylin.server.auth-user-cache.max-entries=100
  ```
