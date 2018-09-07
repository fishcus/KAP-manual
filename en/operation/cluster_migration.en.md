## **Kyligence Enterprise Across-Hadoop-Cluster Migration**

KAP Across-Hadoop-Cluster Migration includes whole KAP instance migration and single Cube migration.

###Whole Kyligence Enterprise Instance Migration

Whole Kyligence Enterprise instance migration job contains two tasks

+ Dump metadata from Source Hadoop Cluster (SHC) and migrate it to HDFS.
+ ```Distcp``` KAP instance data from SHC to Destination Hadoop Cluster (DHC).

It leverages script `cluster-migration.sh` to complete these two tasks.

**Pre-requisite:**

The two clusters can communicate to each other and command ```hadoop distcp``` is available.

**Usage:**

1. KAP instance has been deployed to both of SHC and DHC with the same `kylin.metadata.url` and `kylin.env.hdfs-working-dir`. Make sure KAP in SHC is stopped.
2. In SHC, run `bin/cluster-migration.sh backup`
3. In DHC, run `bin/cluster-migration.sh restore hdfs://SHC-namenode/kylin_working_dir`

### Single Cube Migration

Single Cube migration job also contains two tasks

- Dump Cube related metadata and its cubing data, and migrate them to ```/tmp``` folder on HDFS.
- ```distcp``` Cube related metadata and its cubing data to DHC.

It leverages script `bin/cluster-migration.sh` to complete these two tasks.

**Pre-requisite:**

The two clusters can communicate to each other and command ```hadoop distcp``` is available. 

**Usages:**

1. In SHC, run `bin/cluster-migration.sh backup-cube --cubeName someCube --onlyMetadata true`
2. In DHC, run `bin/cluster-migration.sh restore-cube --cubeName someCube --project someProject --namenode hdfs://someip [--overwrite true]`

If there is already a cube with same name in the target project, the command will throw an exception. You can overwrite the cube by setting ```--overwrite true```.