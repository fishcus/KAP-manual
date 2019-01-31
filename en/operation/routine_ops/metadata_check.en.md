## Metadata Check (Deprecated)

We suggest you backup the metadata regularly so that you may recover it quickly when it is corrupted. Nevertheless, there are still some unexpected situations which may cause metadata inconsistency. Fortunately, now you can use the Metadata Check tool in Kyligence Enterprise to check these inconsistencies and recover part of them.

### Usage

Metadata Check tool arguments introduction:

```sh
usage: io.kyligence.kap.tool.metadata.MetadataChecker
-c,--check                     Check metadata. 
-d,--withDict                  Check metadata including dictionaries
-e,--excludeThreshold <arg>    Specify how many days of metadata to be
excluded from cleanup. Default 2 days
-g,--copyGroupSize <arg>       Specify parallel copy group size when
checking metadata. Default is 200
-o,--outdatedThreshold <arg>   Specify how many days of job metadata
keeping. Default 30 days
-r,--recovery                  Check and Cleanup metadata
-s,--withSnapshot              Check metadata including snapshots
```

> Notes:
> 1. Check tool supports the standard short argument and standard long argument
> 2. Check tool backward compatible with argument "check" and argument "recovery"
> 3. Check tool doesn't check and recover dictionary and snapshot, please add arguments if needed when executing the Check tool
> 4. If choose to check the table snaposhot, please make sure that tables in data source can be accessed via Kyligence Enterprise
> 5. If choose to recover snapshot, please make sure that Kyligence Enterprise job node is online
> 6. Check tool only supports to check the dictionary, but won't to recover them

Run the Metadata Check tool to identify inconsistent metadata:


```sh
bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker -c
```

or

```sh
bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker check
```


If there is any inconsistent metadata detected, run the following command to recover the metadata:

> Notes:
> 1. This step will recover the metadata detected in Kyligence Enterprise.
> 2. Recovery step will backup metadata to folder "$KYLIN_HOME/meta_backups/", backup folder name follows pattern "cleaned_meta_\${timestamp}"

```sh
bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker -r
```

or

```sh
bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker recovery
```

Run Metadata Check tool on background example:

```sh
nohup bin/kylin.sh io.kyligence.kap.tool.metadata.MetadataChecker recovery >> /path/to/check.log 2>&1 &
```

