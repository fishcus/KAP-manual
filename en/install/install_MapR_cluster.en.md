## KAP Quick Start on MapR cluster

MapR cluster provides more calculation and storage resources than MapR sandbox. In the meantime, there are some differences in configuration. 

## Prepare Environment

Prepare a MapR cluster environment. In this paper, MapR Converged Community Edition 6.0a1 found in AWS marketplace is used, refer to [MapR cluster installation in AWS](https://aws.amazon.com/marketplace/pp/B010GJS5WO?qid=1522845995210&sr=0-4&ref_=srh_res_product_title).

We suggest you to assign public IP for every node in MapR cluster when you install it with MapR cloudFormation. After installation, it's supposed to open some access ports (like 7070 for kylin, 8090 for resource manager)in AWS security group.

To access a MapR cluster Node, you nedd to ssh login into a MapR installer node as stepping stones first. And the ssh private keys of MapR cluster nodes is saved in /opt/mapr/installer/data.

To access MapRFS in MapR cluster node, you need to use command [maprlogin password] to generate a MapR ticket. If you don't know the password of linux user, you can type [passwd {user}] to reset password.

### Install KAP

To obtain KAP package, please refer to [KAP release notes]((../release/README.md)). Note that KAP and KAP Plus are different on storage, yet you don't need to worry about installation difference of them.

Copy KAP binary package into the server mentioned above, and decompress it to `/usr/local`.

```shell
cd /usr/local
tar -zxvf kap-{version}-{hbase}.tar.gz 
```

Set environment variable `KYLIN_HOME` to KAP home directory.

```shell
export KYLIN_HOME=/usr/local/kap-{version}-{hbase}
```

Create KAP working directory on HDFS and grant read/write permission to KAP.

```shell
hadoop fs -mkdir /kylin
hadoop fs -chown root /kylin
```

To use MapR FileSystem, KAP needs to point to MapR-FS(maprfs:///) rather than the default HDFS. Update kylin.properties

```
kylin.env.hdfs-working-dir=maprfs:///kylin
```

### Environment Check

KAP will retrieve Hadoop dependency from environment by reading environment variables. The variables include: HADOOP_CONF_DIR, HIVE_LIB, HIVE_CONF, and HCAT_HOME. The example configuration:

```shell
export HIVE_CONF=/opt/mapr/hive/hive-2.1/conf
export SPARK_HOME=/opt/mapr/spark/spark-2.1.0
```

**Note：in MapR, the file operating command is`hadoop fs`，not`hdfs`，this may block the environment check. You need to modify the shell file`$KYLIN_HOME/bin/check-os-command.sh`and comment out this line：**

```shell
#command -v hdfs                         || quit "ERROR: Command 'hdfs' is not accessible. Please check Hadoop client setup."
```

``bin/check-env.sh`` will check if all environment meet the KAP requirements.

**If HBase shell is not available to create table, you can change MySQL as metadata storage, refer to [use jdbc source as KAP metadata storage](http://docs.kyligence.io/v2.5/zh-cn/config/metadata_jdbc.cn.html)**

**If spark-context job in yarn runs failed with error message [requestedVirtualCores > maxVirtualCores] when starting KAP, you can change [yarn.scheduler.maximum-allocation-vcores] in yarn-site.xml 
``` shell
vi {hadoop_conf_dir}/yarn-site.xml
```
```
<property>
	<name>yarn.scheduler.maximum-allocation-vcores</name>
	<value>24</value>
</property>
```
or you can change current profile to min profile
```shell
rm -f $KYLIN_HOME/conf/profile
ln -sfn $KYLIN_HOME/conf/profile_min $KYLIN_HOME/conf/profile
```
**If kafka is used, please check the zookeeper port. Generally, port 5181 is used as default zookeeper port in MapR cluster, but port 2181 is used in kafka.  
```shell
netstat -ntl | grep 5181(2181)
```

## Import Sample Data and Cube

Run`$KYLIN_HOME/bin/sample.sh`, it will create three hive tables as a sample and import sample data to KAP. Then the sample project metadata will be imported as well, which includes model and cube definiton. 

```shell
cd kap-{version}-{hbase}
bin/sample.sh
```

If execution succeed, the log would be:

> Sample cube is created successfully in project 'learn_kylin'.
> Restart Kylin server or reload the metadata from web UI to see the change.

### Start KAP

Execute command `bin/kylin.sh start`, KAP will start in background. You can track starting progress by watching file `logs/kylin.log` with `tail` command.

```shell
${KYLIN_HOME}/bin/kylin.sh start
tail ${KYLIN_HOME}/logs/kylin.log
```

To confirm KAP is running, check the process by `ps -ef | grep kylin`.

> If hit problem, please confirm all KAP processes are stopped before restart. See "Stop KAP" section for details.

### Open KAP GUI

After initializing KAP, open browser and visit KAP website `http://<host_name>:7070/kylin`. KAP login page shows if everything is good. 

Please replace `host_name` to machine name, ip address or domain name. The default KAP website port is 7070, default username is ADMIN, and password is KYLIN.

Once login to KAP successfully, you can validate the installation by building a sample cube. Please continue to [Install Validation](install_validate.en.md).

### Stop KAP
Execute command `bin/kylin.sh stop` to stop KAP service.

Confirm KAP process is stopped, `ps -ef | grep kylin` should return nothing.