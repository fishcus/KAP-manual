## 使用 Beeline 连接 Hive

如果您使用 Beeline 连接 Hive，需要如下修改 `$KYLIN_HOME/conf/kylin.properties`，确保 Beeline 使用正确的账户执行命令：

```properties
kylin.source.hive.client=beeline
kylin.source.hive.beeline-params=-n root -u 'jdbc:hive2://host:port' --hiveconf hive.exec.compress.output=true --hiveconf dfs.replication=2  --hiveconf hive.security.authorization.sqlstd.confwhitelist.append='mapreduce.job.*|dfs.*'
```

- 请留意替换 `-n root` 为您运行 Kyligence Enterprise 的 Linux 账户
- 请留意替换 `jdbc:hive2://localhost:10000` 为您环境中的 Beeline 服务地址

> **提示**：若您使用 **HDP** 环境，请确保您的安全配置方案为 `SQLStdAuth` 并且设置为 `true`。并将如下参数写入环境中的 `hive-site.xml`，赋予 Kyligence Enterprise 调整 Hive 执行参数的一定权限：
>
> ```properties
> hive.security.authorization.sqlstd.confwhitelist=dfs.replication|hive.exec.compress.output|hive.auto.convert.join|hive.auto.convert.join.noconditionaltask.*|mapreduce.map.output.compress.codec|mapreduce.output.fileoutputformat.compress.*|mapreduce.job.split.metainfo.maxsize|hive.stats.autogather|hive.merge.*|hive.security.authorization.sqlstd.confwhitelist.*|fs.defaultFS|mapreduce.job.reduces
> ```

更多 Beeline 介绍请查看 [Beeline命令说明](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-BeelineCommandOptions)。



### FAQ

**Q：使用 Beeline 连接 Hive时，连接失败，出现如下报错： Cannot modify xxx at runtime. It is not in list of params that are allowed to be modified at runtime**

请在 `$KYLIN_HOME/conf/hive-site.xml` 文件中，找到 `hive.security.authorization.sqlstd.confwhitelist` 参数，并根据报错提示追加该参数值。