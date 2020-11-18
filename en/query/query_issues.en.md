## Query FAQ

**Q: How to get help from Technical Support about query problems?**

A: Solving query issues usually involves generating a Diagnosis Package and contacting our [Technical Support](https://support.kyligence.io/) for help.

- Dealing with Functional Query Issues

  For functional issues, like a SQL cannot run or hit exceptions, please follow the steps below.

  1. Check the correctness of the SQL again according to the error message given by the system.

  2. Rerun the SQL again to reproduce the error.

     If the error cannot be reproduced stably, you could continue using the system until it reoccurs, then generate a diagnosis package immediately.

  3. **Immediately** generate a **basic diagnosis package**. Select "one hour" or an even shorter time range, just make sure the error event is included.

     Learn more about how to [generate a diagnosis package](../operation/monitor_diagnosis/diag.en.md).

  4. Contact our [Technical Support](https://support.kyligence.io/), open a ticket and upload the diagnosis package to get help.

     Learn more about how to [get technical support](../operation/monitor_diagnosis/get_support.en.md).

- Dealing with Query Performance Issues

  For performance issues, like a fast SQL becoming slow unexpectedly, please follow the steps below.

  1. First check for environment issues.

     Most performance issues are more or less related to environment incidents. Please consult your Hadoop administrator to see if the cluster is in an uncommon busy state. If resource shortage causes the slowness, then increasing cluster resource should be the solution.

  2. Reproduce the performance issue, by running the SQL two or three times when the cluster is relatively free.

     Please run the SQL multiple times in order to capture enough information for future analysis.

     If the slowness is not stable, it is often an indicator of unstable environment. In that case, recommend sorting out the environment issue first.

  3. **Immediately** generate a **full diagnosis package**. To keep the package small, select a time range as short as possible, to just include the time of slow query executions.

     Using a full diagnosis package is critical as it contains additional information for performance troubleshooting, although the full package is much bigger than the basic diagnosis package.

     Learn more about how to [generate a diagnosis package](../operation/monitor_diagnosis/diag.en.md).

  4. Contact our [Technical Support](https://support.kyligence.io/), open a ticket and upload the diagnosis package to get help.

     Learn more about how to [get technical support](../operation/monitor_diagnosis/get_support.en.md).



**Q: How the system compares strings with trailing spaces?**

A: The system works slightly different from what ANSI/ISO SQL-92 requires.

- Specification Behavior: According to ANSI/ISO SQL-92 specification (Section 8.2, Comparison Predicate, General rules #3), strings must be padded with blanks in comparisons so that their lengths match before comparing them. In other words, the trailing spaces are ignored when comparing strings.
- System Behavior: However the system currently only ignores trailing spaces when comparing strings of type CHAR within its length capacity. For example, assume column A is of type CHAR(2) and has a value of 'Y', the system behaves like below:
  - `A='Y'` returns true, same as specification.
  - `A='Y '` (one extra trailing space) returns true, same as specification.
  - `A='Y  '` (two extra trailing spaces) returns false, NOT same as specification.



**Q: How does the system support queries that include division by null?**

A: The current system does not support the query divided by null. You need to configure the corresponding parameters to enable this function.

- Modify the corresponding configuration: If the configuration file has contained item `kylin.query.system-transformers`, please add `io.kyligence.kap.query.util.ConvertNullType` to the end of it's value and separate them with comma; If not, please add item `kylin.query.system-transformers` and set it's value to `io.kyligence.kap.query.util.ConvertToComputedColumn, io.kyligence.kap.query.util.EscapeTransformer, org.apache.kylin.query.util.DefaultQueryTransformer, org.apache.kylin. query.util.KeywordDefaultDirtyHack, io.kyligence.kap.query.security.RowFilter, io.kyligence.kap.query.security.HackSelectStarWithColumnACL, io.kyligence.kap.query.util.ReplaceStringWithVarchar, io.kyligence. kap.query.util.ConvertNullType`



**Q: How does the system support queries without schema?**

A: When query pushdown is used, the system will automatically try to complete the schema in sql. Which schema is used as default? If there is a schema named `default` in the project data source, use it; if not, The schema with most tables will be used as default. How to complete schema? Calcite is used as default parser for completion, if some exception occurs, try to use Spark parser.

Related configuration items are:
-`kylin.query.pushdown.permissive-enabled` whether to tolerate calcite parsing failures, the default value is `false`. when it is `false`, spark parser will not be used.
-`kylin.query.pushdown.fix-schema-with-spark` whether to try spark parser when calcite parser fails, the default value is `true`. this parameter works only when `kylin.query.pushdown.permissive-enabled` is set to `true`.

