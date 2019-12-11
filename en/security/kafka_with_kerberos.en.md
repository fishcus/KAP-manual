## Integrate Kafka with Kerberos

This chapter introduces how to integrate Kafka with Kerberos.

### Prerequisites

Make sure you have integrated  Kyligence Enterprise with Kerberos before configuring. (Integration method can refer to：[Integrate with Kerberos](./kerberos.en.md))

### Configuration

1、Create `jaas-kafka.conf` file with the following content in `$KYLIN_HOME/conf/`.

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



2、Set the following configurations in `$KYLIN_HOME/conf/kylin-kafka-consumer.xml` and `$KYLIN_HOME/conf/kylin-kafka-admin.xml` to configure kafka consumer authentication information.

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

3、Modify the `kylin_job_conf.xml`  file in the` $KYLIN_HOME/conf/`.

Configure `-Djava.security.auth.login.config=jaas-kafka.conf` into `mapreduce.map.java.opts` and `mapreduce.reduce.java.opts`.

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

4、Add authentication to the JVM environment.Modify the `setenv.sh`  file in the `$KYLIN_HOME/conf/` . Configure  `-Djava.security.auth.login.config=jaas-kafka.conf`  and `-Djava.security.krb5.conf={krb5.conf_path}`   into `KYLIN_JVM_SETTINGS` .

```shell
export KYLIN_JVM_SETTINGS="-Djava.security.krb5.conf={krb5.conf_path} -Djava.security.auth.login.config=jaas-kafka.conf  -server -XX:+UseG1GC -Xms24g -Xmx24g -XX:MaxGCPauseMillis=200 -XX:G1HeapRegionSize=32m -XX:MetaspaceSize=256m -XX:+PrintFlagsFinal -XX:+PrintReferenceGC -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintAdaptiveSizePolicy -XX:+UnlockDiagnosticVMOptions -XX:+G1SummarizeConcMark  -Xloggc:$KYLIN_HOME/logs/kylin.gc.$$  -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=64M -XX:-OmitStackTraceInFastThrow"
```

