## Cluster Migration

Kyligence Enterprise supports cross-Hadoop-Cluster migration, which includes the whole instance migration and single Cube migration.


### Prerequisite

The two clusters can communicate to each other and command `hadoop distcp` is available. In the below context, we will use SHC to represent Source Hadoop Cluster, while DHC to represent Destination Hadoop Cluster.


### Whole Instance Migration

1. Kyligence Enterprise instance has been deployed to both of SHC and DHC with the same `kylin.metadata.url` and `kylin.env.hdfs-working-dir`. Make sure Kyligence Enterprise in SHC is stopped.
2. In SHC, run `$KYLIN_HOME/bin/cluster-migration.sh backup`
3. In DHC, run `$KYLIN_HOME/bin/cluster-migration.sh restore hdfs://SHC-namenode/kylin_working_dir`



