## 查询 FAQ

**Q: 关于查询故障，如何向售后支持寻求帮助？**

A: 查询相关的问题一般通过创建诊断包，然后联系我们的[售后支持](https://support.kyligence.io/)解决。下面详细说明。

- 处理查询相关的功能问题

  如果您遇到查询功能故障，比如某条 SQL 无法执行，出现异常，可以如下处理。

  1. 根据出错提示，先检查一下 SQL 本身是否正确。

  2. 重新执行一次出错 SQL，复现错误。

     如果错误无法稳定重现，建议等下次同样出错出现时，立即创建诊断包，以确保诊断包包含错误日志。

  3. **立即**创建一个**基础诊断包**，时间跨度为“最近一小时”甚至更短，只要包括复现的时间段即可。

     了解[创建诊断包](../operation/monitor_diagnosis/diag.cn.md)的具体方法。

  4. 联系我们的[售后支持](https://support.kyligence.io/#/)，并提交诊断包，获取技术支持。

     了解[获取技术支持](../operation/monitor_diagnosis/get_support.cn.md)的具体方法。

- 处理查询相关的性能问题

  如果您遇到查询性能故障，比如某条曾经很快的 SQL 突然变慢了，可以如下处理。

  1. 先排除环境问题。

     大多数性能问题都与环境因素有关。请咨询一下您的 Hadoop 管理员，了解集群是否处于偶然的繁忙状态。如果是由于集群资源不足造成了查询缓慢，则需要通过补充集群资源解决。

  2. 在集群相对空闲时，连续执行 SQL 两到三次，复现错误。

     请务必多次执行 SQL，建议三次，以便捕捉足够多的信息分析问题。

     如果 SQL 忽快忽慢，则通常是由于环境不稳定造成，建议联系集群管理员先排除环境问题。

  3. **立即**创建一个**全量诊断包**。为缩小体积，时间跨度越短越好，只要包括复现的时间段即可。

     请务必创建全量诊断包。虽然体积较大，但它包含了性能诊断必要的额外信息。了解[创建诊断包](../operation/monitor_diagnosis/diag.cn.md)的具体方法。

  4. 联系我们的[售后支持](https://support.kyligence.io/#/)，并提交诊断包，获取技术支持。

     了解[获取技术支持](../operation/monitor_diagnosis/get_support.cn.md)的具体方法。



**Q: 系统如何比较尾部带空格的字符串？**

A: 系统当前的行为与 ANSI/ISO SQL-92 规范略有不同。

- 规范行为：根据 ANSI/ISO SQL-92 规范 (Section 8.2, Comparison Predicate, General rules #3)，在比较字符串之前必须先通过添加尾部空格的方式对齐字符串长度，然后再加以比较。或者说，字符串比较必须忽略尾部的空格。
- 系统行为：系统当前只对 CHAR 类型的字符串比较忽略尾部空格，并且只在类型长度范围内忽略。比如，假设列 A 类型是 CHAR(2) 且值是 'Y'，那么系统行为如下：
  - `A='Y'`，返回 true，与规范相同。
  - `A='Y '`，（一个多余的尾部空格）返回 true，与规范相同。
  - `A='Y  '`，（两个多余的尾部空格）返回 false，与规范**不同**。



**Q: 系统如何支持除以null的查询？**

A: 当前的系统默认不支持除以null的查询，需要配置相应的参数开启该功能。

- 修改相应的配置：若配置文件中已存在配置项 `kylin.query.transformers` ，请直接在参数值后面追加 `io.kyligence.kap.query.util.ConvertNullType`，以逗号间隔；若不存在, 请添加该配置项，并设置为 `kylin.query.transformers=io.kyligence.kap.query.util.ConvertNullType`



**Q: 系统如何处理schema缺失的查询？**

A: 在下压查询中，系统会自动尝试补全 schema. 补全的逻辑为：如果项目数据源中存在名为 `default` 的数据库，将直接使用 `default` 作为默认库名；如果不存在，将使用项目数据源中表数量最多的数据库作为默认库名。补全的方式为：首先尝试使用 calcite 解析 sql 进行补全，如果发生异常，尝试使用 spark 解析 sql 进行补全。

相关的配置项有：
- `kylin.query.pushdown.permissive-enabled` 是否容忍 calcite 解析失败，默认值为 `false` ,关闭的情况下不会尝试使用 spark 解析 sql 语句。
- `kylin.query.pushdown.fix-schema-with-spark` 是否在 calcite 解析失败的情况下尝试 spark 解析，默认值为 `true` ,该参数仅在开关 `kylin.query.pushdown.permissive-enabled` 打开时生效。