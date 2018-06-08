## Garbage Cleanup

After KAP running for a period of time, there could be garbage data leftover. Garbage data occupies disk and metadata spaces and could downgrade overall system performance to some extent.  The garbage data mainly includes: 

- Leftover cube data after cube is purged
- Leftover segment data after segment is merged
- Temporary job files from error jobs
- Cube build logs and job history that no need to keep forever

> **Notice:** Data cannot be restored once deleted. It is essential to back up metadata and check the target resources carefully before deletion.

### Garbage Cleanup Command Tool

KAP provides a command line tool to clean garbage data.

```$KYLIN_HOME/bin/kylin.sh  io.kyligence.kap.tool.storage.KapGarbageCleanupCLI  [--delete true] ```

The tool searches and prints below garbage in the system, and optional delete them.

- Unused cube data files on HDFS
- Hive intermediate tables, HDFS temporary files which were created during cube build but were not cleaned properly
- Unused dictionary, lookup table mirror, and cube statistics
- Cube build logs and job history

Parameters:

- `--delete true`: By default, the tool only does a dry run and prints out garbage resources without delete them. Specify this option for real deletion.

It is recommended to always dry run this tool first, without the `--delete true` parameter, to list all garbage resources. Verify the list before actual deletion. Also perform a metadata backup before running this tool is a good practice.

