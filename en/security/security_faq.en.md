## Security FAQ

Frequently asked questions about security are consolidated and answered here.



**Q: Is Kerberos authentication supported?**

A: Yes, Kerberos authentication is supported. Read more about [Kerberos integration](kerberos.en.md).



**Q: Is MapR ticket authentication supported?**

A: Yes, MapR ticket authentication is supported. Kyligence Enterprise is just a normal client to MapR file system. As a long running service, it is best to use MapR service ticket for Kyligence Enterprise to allow long ticket duration. Please consult your MapR cluster administrator about how to generate a MapR ticket using the `maprlogin` utility and how to use it.



**Q: Is authentication with LDAP/AD supported?**

A: Yes, authentication with LDAP/AD is supported. Read more about [LDAP integration](ldap.en.md).



**Q: How is user and user group managed?**

A: If you want Kyligence Enterprise to reuse an existing user repository, please refer to [LDAP integration](ldap.en.md) or [3rd-party authentication integration](integrate_with_3rd_um.en.md). Or you can also use [the default user management feature](data_acl/user_management.en.md) provided by Kyligence Enterprise.



**Q: Is it possible to reuse company's existing authentication system?**

A: Yes, Kyligence Enterprise can integrate with an existing user repository, please refer to [LDAP integration](ldap.en.md) or [3rd-party authentication integration](integrate_with_3rd_um.en.md).



**Q: How data access control works?**

A: Kyligence Enterprise supports managing data access control at different granularity, including project-level, table-level, column-level and row-level ACL. Read more about [Data ACL](data_acl/README.md).



**Q: Is it possible to reuse company's existing authorization system, like Apache Ranger or Apache Sentry?**

A: Yes, Kyligence Enterprise can integrate with an existing authorization system, including Apache Ranger and Apache Sentry. Once integrated, all data ACL check will be delegated to the existing system.



**Q: Is Hadoop impersonation supported?**

A: No, Hadoop impersonation is not supported. However, Kyligence Enterprise can integrate with company's existing authentication and authorization system, allowing for centralized security management.



**Q: Is Single Sign-On (SSO) supported?**

A: Using [Spring Security](https://spring.io/projects/spring-security) technology, Kyligence Enterprise can be customized to integrate with your Single Sign-On system. However such integration often requires technical consulting and/or custom development, please contact Kyligence sales for more information.



**Q: Is data masking supported?**

A: No, Kyligence Enterprise does not provide data masking feature.



**Q: Is encryption supported for data at rest?**

A: No special encryption is applied to data at rest by Kyligence Enterprise. However, data is not in plain text either. Binary encoding and compression ensures data is not understandable by human eyes. Storage level encryption, like HDFS encryption, could be enabled to secure data at rest, but that's beyond the scope of Kyligence Enterprise.



**Q: Is encryption supported for data in motion?**

A: Yes, TLS/SSL can be enabled at web service layer to secure data in motion. Kyligence Enterprise uses Tomcat as web server.

- Communicate with clients

  Kyligence Enterprise communicates with its client using HTTP protocol on which TLS/SSL can be enabled. This applies to all client protocols including Rest API, ODBC, and JDBC. 

- Communicate with peers

  Kyligence Enterprise is a distributed system and service processes talk to each other using HTTP protocol, on which TLS/SSL can be enabled.

- Communicate with hadoop

  TLS/SSL for HDFS, YARN and MapReduce can be enabled to secure intra cluster data transmission. Please consult your Hadoop administrator for more information about Hadoop encryption.



**Q: What encryption algorithm is supported?**

A: Kyligence Enterprise does not provide any encryption algorithm. TLS/SSL would leverage what is provided by JDK typically. For reference, JDK 7 requires following [Cipher](https://docs.oracle.com/javase/7/docs/api/javax/crypto/Cipher.html) be implemented by every Java platform:

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

