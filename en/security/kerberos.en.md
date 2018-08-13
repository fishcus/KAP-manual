## Kerberos Integration ##

Kerberos is a computer network authentication protocol that works on the basis of tickets. If the Hadoop platform where KAP is installed enables this protocol, some configurations need to be changed to support that. This mainly includes two parts: KAP configurations & Hadoop platform configurations.

### Kerberos Configuration ###

There are some parameters about Kerberos worth mentioning in `$KYLIN_HOME/conf/kylin.properties` file.

Mandatory parameters：

   - kap.kerberos.enabled: whether Kerberos needs to be implemented from KAP end. The value can be set to ßeither `true` or `false` (`false` as default)
   - kap.kerberos.platform: kind of Hadoop platform KAP is installed on. The value can be set to either `Standard` or `FI` (`Standard` as default)
   - kap.kerberos.principal: the principal to be used
   - kap.kerberos.keytab: the name of keytab file

Optional parameters：

   - kap.kerberos.ticket.refresh.interval.minutes: the refresh interval of tickets. The unit is minute and the default value is 720 minutes
   - kap.kerberos.krb5.conf: the config file name of Kerberos. Default value is `krb5.conf`
   - kap.kerberos.cache: the name of ticket cache file. Default value is `kap_kerberos.cache`

### Hadoop Platform Configurations

Cloudera/Hortonworks Hadoop distribution configuration:

1. On the node where YARN NodeManager is installed, the OS user which Kerberos uses needs to be created. For example, if Kerberos user `kylin` needs to be used to run KAP, this user should exist in the OS of YARN NodeManager node

2. Copy the keytab file to `$KYLIN_HOME/conf` directory

3. Configure below parameters about Kerberos:

   - kap.kerberos.enabled=true
   - kap.kerberos.platform=Standard
   - kap.kerberos.principal={your principal name}
   - kap.kerberos.keytab={your keytab name} 