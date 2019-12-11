## Kafka 与 Kerberos 集成

本章介绍如何将 Kyligence Enterprise中的Kafka 与 Kerberos 集成。

### 准备工作

配置之前请确保已经与 Kyligence Enterprise 与 Kerberos 集成（集成方法可参考：[与 Kerberos 集成](./kerberos.cn.md)）

### 配置方法

1、配置 keytab 认证，新建 `jaas-kafka.conf` 文件包括以下内容，放置在 `$KYLIN_HOME/conf/` 目录下。

```
KafkaClient {
    com.sun.security.auth.module.Krb5LoginModule required
    useKeyTab=true
    keyTab="{your_keytab_name}"
    principal="{your_principal_name}"
    useTicketCache=false
    storeKey=true
    debug=true;
};
```



2、配置 Kafka Consumer的认证信息，在 `$KYLIN_HOME/conf/` 目录下`kylin-kafka-consumer.xml`与`kylin-kafka-admin.xml`文件中添加以下配置及其对应内容

```
<property>
    <name>sasl.kerberos.service.name</name>
    <value>kafka</value>
</property>
<property>
    <name>kerberos.domain.name</name>
    <value>hadoop.kylin.com</value>
</property>
<property>
    <name>security.protocol</name>
    <value>SASL_PLAINTEXT</value>
</property>
```

3、将JAAS配置文件作为JVM参数传递给每个客户端。在 `$KYLIN_HOME/conf/` 目录下`kylin_job_conf.xml` 文件中修改以下内容。即将 `-Djava.security.auth.login.config=jaas-kafka.conf`  配置到 `mapreduce.map.java.opts` 和  `mapreduce.reduce.java.opts` 中。

```
<property>
    <name>mapreduce.map.java.opts</name>
    <value>-Djava.security.auth.login.config=jaas-kafka.conf -Xmx1280m -XX:MaxDirectMemorySize=512M -XX:OnOutOfMemoryError='kill -9 %p'</value>
    <description></description>
</property>

<property>
    <name>mapreduce.reduce.java.opts</name>
    <value>-Djava.security.auth.login.config=jaas-kafka.conf -Xmx1280m -XX:MaxDirectMemorySize=512M -XX:OnOutOfMemoryError='kill -9 %p'</value>
    <description></description>
</property>
```

4、将认证加到jvm环境中。在 `$KYLIN_HOME/conf/` 目录下`setenv.sh` 文件中。即将 `-Djava.security.auth.login.config=jaas-kafka.conf`  配置到 `KYLIN_JVM_SETTINGS` 中。

```shell
export KYLIN_JVM_SETTINGS="-Djava.security.auth.login.config=jaas-kafka.conf -server -XX:+UseG1GC -Xms24g -Xmx24g -XX:MaxGCPauseMillis=200 -XX:G1HeapRegionSize=32m -XX:MetaspaceSize=256m -XX:+PrintFlagsFinal -XX:+PrintReferenceGC -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintAdaptiveSizePolicy -XX:+UnlockDiagnosticVMOptions -XX:+G1SummarizeConcMark  -Xloggc:$KYLIN_HOME/logs/kylin.gc.$$  -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=64M -XX:-OmitStackTraceInFastThrow"
```

