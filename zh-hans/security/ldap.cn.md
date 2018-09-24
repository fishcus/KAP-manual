## LDAP 验证

Kyligence Enterprise 支持与 LDAP 服务器集成完成用户验证。这种验证是通过 Spring Security 框架实现的，所以具有良好的通用性。在启用 LDAP 验证之前，建议您联系 LDAP 管理员，以获取必要的信息。

### LDAP 服务器的安装
启用 LDAP 验证之前，需要一个运行的 LDAP 服务器。如果已经有，联系 LDAP 管理员，以获取必要的信息，如服务器连接信息、人员和组织结构等。

如果没有可用的 LDAP 服务器，需要额外安装。推荐使用 OpenLDAP Server 2.4，它是一个开源的基于 OpenLDAP Public License 的实现，并且也是最流行的 LDAP 服务器之一。很多企业 Linux 发行版已经内置了 OpenLDAP 服务器，如果没有，可以从官网下载：http://www.openldap.org/。

OpenLDAP 服务器的安装，依系统不同而略有区别。这里以 CentOS 6.4 为例进行介绍:  

* 安装之前检查

```shell
sudo find / -name openldap*
```
如果没有安装，使用 yum 安装：

```shell
sudo yum install -y openldap openldap-servers openldap-clients
```

* 安装以后进行配置

```shell
cp /usr/share/openldap-servers/slapd.conf.obsolete /etc/openldap/slapd.conf
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
mv /etc/openldap/slapd.d{,.bak}
```

修改 slapd.conf，以给 example.com 公司配置为例，步骤如下：

1．设置目录树的后缀

找到语句：

```
suffix "dc=my-domain,dc=com"
```
将其改为：

```
suffix "dc=example,dc=com"
```

2．该语句设置 LDAP 管理员的 DN

找到语句：

```
rootdn "cn=Manager,dc=my-domain,dc=com"
```
将其改为：

```
rootdn "cn=Manager,dc=example,dc=com"
```

3．设置 LDAP 管理员的口令

找到语句：

```
rootpw secret
```

要创建一个新的加密密码，使用下面的命令：

```
slappasswd
```
输入要设置的密码，加密值会被输出在 shell 界面。然后将此值拷贝在 rootpw 这一行，如：

```
rootpw {SSHA}vv2y+i6V6esazrIv70xSSnNAJE18bb2u
```

4．为配置文件修改权限

```shell
chown ldap.ldap /etc/openldap/*
chown ldap.ldap /var/lib/ldap/*
```

5．新建目录 /etc/openldap/cacerts

```shell
mkdir /etc/openldap/cacerts
```

6．重启系统，然后开启服务

```shell
sudo service slapd start
```

7．新建文件 example.ldif（包括三个用户，两个组）

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

8．通过命令导入

```shell
/usr/bin/ldapadd -x -W -D "cn=Manager,dc=example,dc=com" -f example.ldif
```
提示输入密码，输入管理员的密码，导入成功。

9．修改密码

管理员可以使用如下命令强制修改用户密码，过程中需要输入新密码、确认新密码、输入管理员密码

```shell
ldappasswd -xWD cn=Manager,dc=example,dc=com -S cn=jenny,ou=People,dc=example,dc=com
```

### 在 Kyligence Enterprise 中配置 LDAP 服务器的信息

首先，在 conf/kylin.properties 中，需要配置 LDAP 服务器的 URL，必要的用户名和密码（如果 LDAP Server 不是匿名访问）。为安全起见，这里的密码是需要加密（加密算法 AES），您可以运行下面的命令来获得加密后的密码：

```shell
${KYLIN_HOME}/bin/kylin.sh io.kyligence.kap.tool.general.CryptTool AES *your_password*
# ${crypted_password}
```

然后填写在 kylin.properties 中（*请注意此处“=”后所指的用户名、服务器、密码都不需要用双引号*），如下：


```properties
# kylin.security.ldap.connection-server=ldap://<your_ldap_host>:<port>
# kylin.security.ldap.connection-username=<your_user_name>
# kylin.security.ldap.connection-password=<your_password_hash>

kylin.security.ldap.connection-server=ldap://127.0.0.1:389
kylin.security.ldap.connection-username=cn=Manager,dc=example,dc=com
kylin.security.ldap.connection-password=${crypted_password}
```

其次，提供检索用户信息的模式, 例如从某个节点开始查询，需要满足哪些条件等。下面是一个例子，供参考:

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

如果您需要服务账户（供系统集成）可以访问 Kyligence Enterprise，那么依照下面的例子配置 `ldap.service.*`，否则请将它们留空。

```properties
# LDAP service account directory
kylin.security.ldap.service-search-base=ou=People,dc=example,dc=com
kylin.security.ldap.service-search-pattern=(&(cn={0}))
kylin.security.ldap.service-group-search-base=ou=Groups,dc=example,dc=com
```

### 配置管理员群组和默认角色

在 Kyligence Enterprise 中，可将一个 LDAP 群组映射成管理员角色：在 kylin.properties 中，将 `properties
kylin.security.acl.admin-role` 设置为 LDAP 组名（组名大小写保留原样）。在当前例子中，将 LDAP 中组 `admin` 定义为 Kyligence Enterprise 管理员，那么这里应该设置为:

```properties
kylin.security.acl.admin-role=admin
```

在从 2.5.4 以下的版本升级至 2.5.4 及以上的版本时，应修改该配置中的 LDAP 组名，原先为大写则保留大写，原先为小写则保留小写，并删除 2.5.4 以下版本配置所需的 `ROLE_`。

### 启用 LDAP

在 conf/kylin.properties 中，设置 `kylin.security.profile=ldap`，然后重启 Kyligence Enterprise。

当使用 `admin` 组的 `jenny` 用户登录时，会显示 `系统` 菜单项。
![使用管理员组的用户登录](images/ldap/w_1.png)

当使用 `itpeople` 组的 `johnny` 登录时，因为该组并不是`管理员`组，则不会显示 `系统` 菜单项。

![使用普通用户组的用户登录](images/ldap/w_2.png)

在启用 LDAP 后，用户和用户组只能为只读，不可添加、编辑、删除、修改用户组或为用户组分配用户。

### LDAP 用户信息缓存

用户通过 LDAP 验证登录 Kyligence Enterprise 后，其信息会被 Kyligence Enterprise 缓存以减轻访问 LDAP 服务器的开销。用户可以在 kylin.properties 中对用户信息缓存时间（秒）和最大缓存用户数目进行配置，默认值如下：

```properties
kylin.server.auth-user-cache.expire-seconds=300
kylin.server.auth-user-cache.max-entries=100
```

