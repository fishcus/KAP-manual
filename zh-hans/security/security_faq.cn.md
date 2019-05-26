## 安全问题 FAQ

安全相关的常见问题汇总如下。如以下问题仍无法解答您的问题，请联系 Kyligence 销售人员或通过 [Kyligence Support](https://support.kyligence.io/) 创建相应工单。



**Q: 是否支持 Kerberos 用户认证？**

A: 是的，系统可以集成 Kerberos 用户认证。了解更多 [Kerberos 用户认证集成](kerberos.cn.md)。



**Q: 是否支持 MapR Ticket 用户认证？**

A: 是的，系统可以集成 MapR Ticket 用户认证。对于 MapR 文件系统而言，Kyligence Enterprise 只是一个普通的客户端应用，无需特殊配置。作为长时间运行的服务，我们建议选用 MapR Service Ticket 来运行 Kyligence Enterprise，以延长 MapR Ticket 的有效时长。请咨询您的 MapR 集群管理员了解更多信息，比如如何使用 `maprlogin` 工具创建 MapR Ticket 以及如何使用它。



**Q: 是否支持 LDAP/AD 用户认证？**

A: 是的，系统可以集成 LDAP/AD 用户认证。了解更多 [LDAP 用户认证集成](ldap.cn.md).



**Q: 系统如何管理用户和用户组？**

A: 如果您希望 Kyligence Enterprise 复用公司已有的用户管理系统，请参考 [LDAP 用户认证集成](ldap.cn.md) 或者 [第三方用户认证系统集成](integrate_with_3rd_um.cn.md)。或者您也可以使用 Kyligence Enterprise [缺省自带的用户管理功能](data_acl/user_management.cn.md)。



**Q: 是否可以复用公司已有的用户认证系统？**

A: 是的，Kyligence Enterprise 能与公司已有的用户认证系统集成，请参考 [LDAP 用户认证集成](ldap.cn.md) 或者 [第三方用户认证系统集成](integrate_with_3rd_um.cn.md)。



**Q: 是否可以复用公司已有的权限管理系统，比如 Apache Ranger 或者 Apache Sentry？**

A: 是的，Kyligence Enterprise 能与公司已有的权限管理系统集成，比如 Apache Ranger 和 Apache Sentry。启用之后，所有的数据访问验权都将转发至公司已有的权限管理系统。详情请参考[第三方用户认证系统集成](integrate_with_3rd_um.cn.md)。



**Q: 系统支持哪些数据访问权限？**

A: Kyligence Enterprise 有丰富的数据访问权限控制，包括项目级、表级、列级、和行级的数据访问权限。了解更多[数据访问权限](data_acl/README.md).



**Q: 是否支持 Hadoop Impersonation 功能？**

A: 不支持，系统还不支持 Hadoop Impersonation 功能。但是，您可以配置 Kyligence Enterprise 与公司已有的用户认证系统和权限管理系统集成，来达到同样的集中化安全管理的目的。



**Q: 是否支持单点登录 Single Sign-On 功能？**

A: 通过 [Spring Security](https://spring.io/projects/spring-security) 技术，Kyligence Enterprise 可以被定制，并与您公司已有的单点登录 Single Sign-On 系统集成。然而这样的集成通常需要良好的技术规划和定制开发，请与 Kyligence 销售人员联系了解更多信息。



**Q: 是否支持敏感信息混淆？**

A: 不支持，Kyligence Enterprise 暂不支持敏感数据混淆。



**Q: 是否支持存储状态的数据加密？**

A: 不支持，Kyligence Enterprise 不会在数据存储时作特殊加密。当然，存储数据也不是明文的，二进制编码和压缩可以保证存储态的数据人眼不可读。要实现存储态的数据加密，您可以启用存储层的一些加密功能，比如 HDFS Encryption。



**Q: 是否支持传输过程中的数据加密？**

A: 支持，您可以在 Web 服务层启用 TLS/SSL 来加密传输过程中的数据。Kyligence Enterprise 使用 Tomcat 作为 Web 服务器。

- 与客户端通信

  Kyligence Enterprise 使用 HTTP 传输协议与客户端通信，在其上可以启用 TLS/SSL 加密。这适用于所有客户端类型，包括 Rest API、ODBC、和 JDBC。

- 与其他 Kyligence Enterprise 服务通信

  Kyligence Enterprise 是一个分布式系统。服务进程之间也使用 HTTP 传输协议通信，在其上可以启用 TLS/SSL 加密。

- 与 Hadoop 通信

  TLS/SSL 也可以在 HDFS、YARN、和 MapReduce 上启用。请联系您的 Hadoop 集群管理员了解更多 Hadoop 系统相关的加密能力。



**Q: 系统支持哪些加密算法？**

A: Kyligence Enterprise 本身不提供任何加密算法。TLS/SSL 通常使用 JDK 提供的加密算法。作为参考，JDK 7 要求所有 Java 平台都支持下面这些 [Cipher](https://docs.oracle.com/javase/7/docs/api/javax/crypto/Cipher.html) ：

- `AES/CBC/NoPadding` (128)
- `AES/CBC/PKCS5Padding` (128)
- `AES/ECB/NoPadding` (128)
- `AES/ECB/PKCS5Padding` (128)
- `DES/CBC/NoPadding` (56)
- `DES/CBC/PKCS5Padding` (56)
- `DES/ECB/NoPadding` (56)
- `DES/ECB/PKCS5Padding` (56)
- `DESede/CBC/NoPadding` (168)
- `DESede/CBC/PKCS5Padding` (168)
- `DESede/ECB/NoPadding` (168)
- `DESede/ECB/PKCS5Padding` (168)
- `RSA/ECB/PKCS1Padding` (1024, 2048)
- `RSA/ECB/OAEPWithSHA-1AndMGF1Padding` (1024, 2048)
- `RSA/ECB/OAEPWithSHA-256AndMGF1Padding` (1024, 2048)

