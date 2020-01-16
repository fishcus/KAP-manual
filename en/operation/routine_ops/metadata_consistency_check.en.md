## Check Metadata Consistency with Metastore

We suggest you backup the metadata regularly so that you may recover it quickly when it is corrupted. Nevertheless, there are still some unexpected situations which may cause metadata inconsistency. Fortunately, now you can use the Metadata Consistency Check tool in Kyligence Enterprise to check these inconsistencies.

### Usage

Metadata Check tool arguments introduction:

```sh
usage: io.kyligence.kap.tool.check.MetastoreIntegrityCheck
-h,--help                     print help message.
-p,--project <arg>            check special project metasdata integrity
```

> Notes:
> 1. Check tool supports the standard short argument and standard long argument
> 2. Check tool only supports to check the consistency, but won't to recover them

Run the Metadata Consistency Check tool to show help information:


```sh
bin/kylin.sh io.kyligence.kap.tool.check.MetastoreIntegrityCheck -h
```

or

```sh
bin/kylin.sh io.kyligence.kap.tool.check.MetastoreIntegrityCheck --help
```

Run the Metadata Consistency Check tool to check specify project's consistency:

```sh
bin/kylin.sh io.kyligence.kap.tool.check.MetastoreIntegrityCheck -p learn_kylin
```

or

```sh
bin/kylin.sh io.kyligence.kap.tool.check.MetastoreIntegrityCheck --project=learn_kylin
```

Run the Metadata Consistency Check tool to check multi projects's consistency:

```sh
bin/kylin.sh io.kyligence.kap.tool.check.MetastoreIntegrityCheck -p=learn_kylin,learn_kylin_streaming
```

Run the Metadata Consistency Check tool to check all projects's consistency:

```sh
bin/kylin.sh io.kyligence.kap.tool.check.MetastoreIntegrityCheck
```

tips:
If there are too many missing files, you can use the tee command to display the output to the console and redirect to the file

```sh
bin/kylin.sh io.kyligence.kap.tool.check.MetastoreIntegrityCheck -p learn_kylin | tee check_result_output.log
```
