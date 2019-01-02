## Cluster Migration

Kyligence Enterprise supports cross-Hadoop-Cluster migration, which includes the whole instance migration and single Cube migration.


### Prerequisite

The two clusters can communicate to each other and command `hadoop distcp` is available. In the below context, we will use SHC to represent Source Hadoop Cluster, while DHC to represent Destination Hadoop Cluster.


### Whole Instance Migration

1. Kyligence Enterprise instance has been deployed to both of SHC and DHC with the same `kylin.metadata.url` and `kylin.env.hdfs-working-dir`. Make sure Kyligence Enterprise in SHC is stopped.
2. In SHC, run `$KYLIN_HOME/bin/cluster-migration.sh backup`
3. In DHC, run `$KYLIN_HOME/bin/cluster-migration.sh restore hdfs://SHC-namenode/kylin_working_dir`



### Single Cube Migration
 
1. In SHC, run `$KYLIN_HOME/bin/cluster-migration.sh backup-cube --cubeName someCube --onlyMetadata true`
2. In DHC, run `$KYLIN_HOME/bin/cluster-migration.sh restore-cube --cubeName someCube --project someProject --namenode hdfs://someip [--overwrite true]`

> Note: If there is already a cube with same name in the target project, the command will throw an exception. You can overwrite the cube by setting ```--overwrite true```.