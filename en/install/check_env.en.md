## Environment Check

Kyligence Enterprise runs on Hadoop cluster, which has requirements for the versions, access rights and CLASSPATH of each component. Therefore, Kyligence Enterprise provides the function of environmental detection in order to avoid encountering various environmental problems at runtime.

```shell
cd $KYLIN_HOME
bin/check-env.sh
```

When Kyligence Enterprise is first activated,` check-env.sh` will run automatically.

### Detailed Description of the Inspection Steps

- Checking Kerberos

  If Kerberos is enabled, check `Kinit ` to log on properly.

- Checking Hadoop Configuration

  Check Hadoop configuration file directory (HADOOP_CONF_DIR).

- Checking Permission of HBase's Table

  Check whether the current user has read and write permissions on the table of HBase.

- Checking Permission of HBase's Root Dir

  Check whether the user can access the HBase root directory.

- Checking Permission of HDFS Working Dir

  Check whether the user has read and write permissions on the Kyligence Enterprise working directory (`kylin.env.hdfs-working-dir`).

- Checking Hive Classpath

  Check Hive Classpath, especially the HCatalog class library.

- Checking Hive Usages

  Check whether the user has read and write permissions on Hive, including the creation, insertion and deletion of Hive tables. At the same time, check whether Hive data can be read through HCatalog.

- Checking Java Version

  Check the Java version and ensure it is higher than 1.8.

- Checking JDBC Usages

  If JDBC is configured for metadata storage, check whether the JDBC database in the current environment is available.

- Checking Legacy Sample Cubes

  Check whether the old version of Sample Cube needs updating.

- Checking ACL Migration Status

  Check whether the old version of ACL metadata needs to be migrated, and give the migration method when needed.

- Checking OS Commands

  Check whether the current environment supports the required system commands.

- Checking Ports Availability

  Check whether the service port needed by Kyligence Enterprise is available in the current environment. If it is occupied, you need to release the occupied port or modify the service port used by Kyligence Enterprise.

- Checking Snappy Availability

  Check whether the current environment supports Snappy compression and

   whether Snappy is available in MapRecude tasks.

- Checking Spark Availablity

  Check whether Spark is available. At the same time, we read the resource information of YARN in the environment, check whether the resource configuration of Spark Executor in `kylin.properties`is reasonable, and give some suggestions.

- Checking Metadata Accessibility

  Check the metadata to read and write normally.
