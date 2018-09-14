## Garbage Cleanup

After KAP running for a period of time, there could be garbage data leftover. Garbage data occupies disk and metadata spaces and could downgrade overall system performance to some extent. The garbage data mainly includes: 

- Leftover cube data after cube is purged
- Leftover segment data after segment is merged
- Temporary files from error jobs
- Job history that no need to keep forever

**Notice: **

1. **Data cannot be restored once deleted.** It is essential to back up metadata and check the target resources carefully before deletion.

2. **Please try arrange cleanup at when there is no (or less) running jobs in the system**, for better overall stability and perofrmance.

### Garbage Cleanup Command Tool

KAP provides a command line tool to clean garbage data.

```shell
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.storage.KapGarbageCleanupCLI [--delete true]
```

The tool searches and prints garbage in the system which can be cleaned

- Unusable cube data files on HDFS
- Hive intermediate tables, HDFS temporary files which were created during cube build but were not cleaned properly
- Unused dictionary, lookup table mirror, and cube statistics
- Job history that no need to keep forever

Parameters:

- `--delete true`: Specify this option for garbage deletion.

It is recommended to always dry run this tool first without the `--delete true` parameter, to list all garbage resources. Verify the list before actual deletion. Also perform a metadata backup before running this tool is a good practice.
