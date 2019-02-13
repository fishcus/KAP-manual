## 与 LDAP 集成

Kyligence Enterprise 支持与 LDAP 服务集成用于实现用户验证，本章节将以 OpenLDAP 和 Microsoft Azure Active Directory 为例，描述如何配置  Kyligence Enterprise 与 LDAP 服务集成 。

本章的目录结构如下：

- [LDAP 环境准备](#pre)
  - [安装 OpenLDAP](#open-ldap)
  - [配置 Microsoft Azure Active Directory 服务](#azure-ad)
- [在 Kyligence Enterprise 中进行配置](#config)


### LDAP 环境准备 {#pre}

启用 LDAP 验证之前，需要一个运行的 LDAP 服务器，请联系您的 LDAP 管理员以获取必要的信息，如服务器连接信息、人员和组织结构等。

#### 安装 OpenLDAP {#open-ldap}

如果您环境中没有可用的 LDAP 服务器，则需要额外安装，推荐使用 OpenLDAP Server 2.4，它是一个开源的、基于 OpenLDAP Public License 的实现，并且也是最流行的 LDAP 服务器之一，可以从官网下载：http://www.openldap.org/ 。

OpenLDAP 服务器的安装，依系统不同而略有区别。这里以 CentOS 6.4 为例进行介绍：

- 检查是否已经安装
  ```sh
  sudo find / -name openldap*
  ```

- 如果没有安装，使用 yum 安装：
  ```sh
  sudo yum install -y openldap openldap-servers openldap-clients
  ```

- 配置 LDAP
  ```sh
  cp /usr/share/openldap-servers/slapd.conf.obsolete /etc/openldap/slapd.conf
  cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
  mv /etc/openldap/slapd.d{,.bak}
  ```
  - 修改 `slapd.conf`，以给 example.com 公司配置为例，步骤如下：

    - 设置目录树的后缀
      将 `suffix "dc=my-domain,dc=com"` 修改为：`suffix "dc=example,dc=com"`   

    - 设置 LDAP 管理员的 DN
      将 `rootdn "cn=Manager,dc=my-domain,dc=com"` 修改为：`rootdn "cn=Manager,dc=example,dc=com"`

    - 设置 LDAP 管理员的密码
      修改 `rootpw secret`，将 `secret` 使用明文密码代替；
      如果要创建一个新的加密密码，请使用下面的命令：
      ```sh
      slappasswd
      ```
      输入要设置的密码，加密值会被输出在终端界面，请将此值拷贝在 `rootpw` 这一行，如：
      ```
      rootpw	{SSHA}vv2y+i6V6esazrIv70xSSnNAJE18bb2u
      ```
  - 为配置文件修改权限
      ```sh
      chown ldap.ldap /etc/openldap/*
      chown ldap.ldap /var/lib/ldap/*
      ```

- 新建目录 `/etc/openldap/cacerts`
    ```sh
    mkdir /etc/openldap/cacerts
    ```

- 重启服务
    ```sh
    sudo service slapd start
    ```
- 新建文件 `example.ldif`（包括三个用户，两个组）
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

- 通过命令导入用户信息
  ```sh
  /usr/bin/ldapadd -x -W -D "cn=Manager,dc=example,dc=com" -f example.ldif
  ```
  提示输入密码，输入管理员的密码，导入成功。

- 修改用户密码

  管理员可以使用如下命令强制修改用户密码，过程中需要输入新密码、确认新密码、输入管理员密码

  ```sh
  ldappasswd -xWD cn=Manager,dc=example,dc=com -S   cn=jenny,ou=People,dc=example,dc=com
  ```


#### 配置 Microsoft Azure Active Directory 服务 {#azure-ad}

除了使用本地 LDAP 服务器，Kyligence Enterprise 也支持通过云端 Active Directory 服务进行 LDAP 的验证，以 Microsoft Azure Active Directory 服务为验证场景，认证前需要进行以下的前置工作：

- 您需要进行 Azure Active Directory（简称 AD）的订阅以及创建（提示：您也可以使用已有的 Azure AD），您可以参考[ Azure Active Directory 配置文档](https://docs.microsoft.com/zh-cn/azure/active-directory/fundamentals/active-directory-access-create-new-tenant) 完成创建和配置。
- 安装 Azure AD 域服务。域服务提供托管域服务，例如域加入和 LDAP 服务，您可以参考 [Azure AD 域服务配置文档](https://docs.microsoft.com/zh-cn/azure/active-directory-domain-services/active-directory-ds-overview)中的步骤来进行 Azure AD 域服务的创建和相关的配置。
- 配置好 Microsoft Azure AD 域服务后，在 Azure AD UI 上进行组和用户的配置以调整组织架构。您也可以参考 [Azure AD 在托管域上创建 OU](https://docs.microsoft.com/zh-cn/azure/active-directory-domain-services/active-directory-ds-admin-guide-create-ou) 进行用户的调整。


### 在 Kyligence Enterprise 中进行配置 {#config}

- 配置 LDAP 服务器的信息

  在 `$KYLIN_HOME/conf/kylin.properties` 中配置 LDAP 服务器的 URL，提供必要的用户名和密码。为安全起见，这里的密码需要通过加密算法 AES 进行加密，您可以运行下面的命令来获得加密后的密码：
  ```sh
  ${KYLIN_HOME}/bin/kylin.sh io.kyligence.kap.tool.general.CryptTool AES your_password
  ```
  具体配置如下：
  ```properties
  kylin.security.ldap.connection-server=ldap://<your_ldap_host>:<port>
  kylin.security.ldap.connection-username=<your_user_name>
  kylin.security.ldap.connection-password=<your_password_hash>
  ```
  样例配置如下：
  ```
  kylin.security.ldap.connection-server=ldap://127.0.0.1:389
  kylin.security.ldap.connection-username=cn=Manager,dc=example,dc=com
  kylin.security.ldap.connection-password=${crypted_password}
  ```

- 提供检索用户信息的模式
  例如从某个节点开始查询，需要满足哪些条件等。样例配置如下：
  ```properties
  #定义同步到 Kyligence Enterprise 的用户的范围
  kylin.security.ldap.user-search-base=ou=People,dc=example,dc=com
  #定义登录验证匹配的用户名
  kylin.security.ldap.user-search-pattern=(&(cn={0}))
  #定义同步到 Kyligence Enterprise 的用户组的范围
  kylin.security.ldap.user-group-search-base=ou=Groups,dc=example,dc=com

  #定义同步到 Kyligence Enterprise 的用户的类型
  kylin.security.ldap.user-search-filter=(objectClass=person)
  #定义同步到 Kyligence Enterprise 的用户组的类型
  kylin.security.ldap.group-search-filter=(|(objectClass=groupOfNames)(objectClass=group))
  #定义同步到用户组下的用户
  kylin.security.ldap.group-member-search-filter=(&(cn={0})(objectClass=groupOfNames))
  ```

- 配置供系统集成的服务账户
  样例配置如下：
  ```properties
  # LDAP service account directory
  kylin.security.ldap.service-search-base=ou=People,dc=example,dc=com
  kylin.security.ldap.service-search-pattern=(&(cn={0}))
  kylin.security.ldap.service-group-search-base=ou=Groups,dc=example,dc=com
  ```

- 配置管理员群组

  在 Kyligence Enterprise 中，可将一个 LDAP 群组映射成管理员角色，需要修改配置文件`$KYLIN_HOME/conf/kylin.properties` 中的配置项 `kylin.security.acl.admin-role` 为 LDAP 组名（大小写敏感）。在当前例子中，将 LDAP 中组 `admin` 定义为 Kyligence Enterprise 管理员，那么这里应该设置为：
  ```properties
  kylin.security.acl.admin-role=admin
  ```

- 启用 LDAP

  在 `$KYLIN_HOME/conf/kylin.properties` 中设置 `kylin.security.profile=ldap`，然后重启 Kyligence Enterprise。


-  LDAP 用户信息缓存

  用户通过 LDAP 验证登录 Kyligence Enterprise 后，其信息会被 Kyligence Enterprise 缓存以减轻访问 LDAP 服务器的开销。用户可以在 `kylin.properties` 中对用户信息缓存时间（秒）和最大缓存用户数目进行配置，默认值如下：

  ```properties
  kylin.server.auth-user-cache.expire-seconds=300
  kylin.server.auth-user-cache.max-entries=100
  ```

