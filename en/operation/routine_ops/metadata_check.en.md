## Metadata Check

We suggest you backup the metadata regularly so that you may recover it quickly when it is corrupted. Nevertheless, there are still some unexpected situations which may cause metadata inconsistency. Fortunately, now you can use the Metadata Check tool in Kyligence Enterprise to check these inconsistencies and recover part of them.

### Check Scope

We summarize some scenarios which might cause metadata inconsistency in Kyligence Enterprise as follows:

1. Cube against Model (consistency check of Cube and Model)
2. Cube against Table Index
3. Cube against Scheduler Job
4. Job's metadata against output information
5. Kyligence Enterprise runtime loaded metadata against resource store's metadata

### Usage
Run the Metadata Check tool to identify inconsistent metadata:

```
bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker check
```

If there is any inconsistent metadata detected, run the following command to recover the metadata:

> Notes: this step will delete the isolated metadata detected in Kyligence Enterprise.

```
bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker recovery
```