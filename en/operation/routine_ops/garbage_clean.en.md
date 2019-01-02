## Garbage Cleanup

After Kyligence Enterprise running for a period of time, there could be garbage data leftover. Garbage data occupies disk and HDFS spaces and could downgrade overall system performance to some extent.


**Caution:**

1. **Data cannot be restored once deleted.** It is essential to back up metadata and check the target resources carefully before deletion.

2. **Please try arrange cleanup at when there is no running jobs in the system**, for better overall stability and performance.


Kyligence Enterprise provides a command line tool to clean garbage data, this tool searches and prints garbage in the system which can be cleaned as follows,

- Unusable cube data files on HDFS, e.g., leftover cube data after cube is purged
- Leftover segment data after segment is merged
- Hive intermediate tables, HDFS temporary files which were created during cube build but were not cleaned properly
- Unused dictionary, lookup table snapshot and cube statistics
- Job history

```sh
$KYLIN_HOME/bin/kylin.sh io.kyligence.kap.tool.storage.KapGarbageCleanupCLI [--delete true]
```

It is recommended to always dry run this tool first without the `--delete true` parameter, to list all garbage resources. The output of Console is as follows,

```
Retrieving Hive dependency...
Retrieving HBase dependency...
Running io.kyligence.kap.tool.storage.KapGarbageCleanupCLI
Kyligence Enterprise garbage report: (delete=false, force=false, jobOutdatedDays=30)
  Hive Table: kylin_intermediate_kylin_sales_cube_7fc67947_96a9_4184_9c26_5ebf362aad46
  Hive Table: kylin_intermediate_kylin_sales_cube_d0c13857_b08c_4ae4_8e9a_89d5c75d075b
  Storage File: hdfs://sandbox.hortonworks.com:8020/kylin/kylin_default_instance/learn_kylin/kylin-250c4553-b282-4920-9b77-ae40cc59ba23
  Storage File: hdfs://sandbox.hortonworks.com:8020/kylin/kylin_default_instance/learn_kylin/
  Storage File(s) Bytes: 5389334
Dry run mode, no data is deleted.
Garbage cleanup finished in 18417 ms.
```

Verify the target resources list before actual deletion with `--delete true` parameter.