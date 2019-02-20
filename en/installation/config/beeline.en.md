## Use Beeline to Connect Hive

If you use Beeline to connect Hive, you need to modify `$KYLIN_HOME/conf/kylin.properties ` as below to ensure it uses the correct account to execute Hive commands:

```properties
kylin.source.hive.client=beeline
kylin.source.hive.beeline-params=-n root -u 'jdbc:hive2://host:port' --hiveconf hive.exec.compress.output=true --hiveconf dfs.replication=2  --hiveconf hive.security.authorization.sqlstd.confwhitelist.append='mapreduce.job.*|dfs.*'
```

- Replace `-n root` with your Linux account.
- Replace `jdbc:hive2://localhost:10000` with the Beeline service address in your enviroment.

> **Note**: If your Hadoop platform is **HDP**, please ensure the security authorization is `SQLStdAuth` with `true` status. Then add the following to your `hive-site.xml` to give Kyligence Enterprise some permission to adjust the Hive execution parameters at runtime:
>
> ```properties
> hive.security.authorization.sqlstd.confwhitelist=dfs.replication|hive.exec.compress.output|hive.auto.convert.join|hive.auto.convert.join.noconditionaltask.*|mapreduce.map.output.compress.codec|mapreduce.output.fileoutputformat.compress.*|mapreduce.job.split.metainfo.maxsize|hive.stats.autogather|hive.merge.*|hive.security.authorization.sqlstd.confwhitelist.*|fs.defaultFS|mapreduce.job.reduces
> ```

For more information, please refer to [Beeline command options](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-BeelineCommandOptions).



### FAQ

**Q: When I use Beeline to connect Hive, it was failed with the following error message:  Cannot modify xxx at runtime. It is not in list of params that are allowed to be modified at runtime.**

Please find `hive.security.authorization.sqlstd.confwhitelist` property in `hive-site.xml` file and add the values according to the error messages. 