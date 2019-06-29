## How to Solve Query Issues

Solving query issues usually involves generating a Diagnosis Package and contacting our [Technical Support](https://support.kyligence.io/) for help.



### Dealing with Functional Query Issues

For functional issues, like a SQL cannot run or hit exceptions, please follow the steps below.

1. Check the correctness of the SQL again according to the error message given by the system.

2. Rerun the SQL again to reproduce the error.

   If the error cannot be reproduced stably, you could continue using the system until it reoccurs, then generate a diagnosis package immediately.

3. **Immediately** generate a **basic diagnosis package**. Select "one hour" or an even shorter time range, just make sure the error event is included.

   Learn more about how to [generate a diagnosis package](../operation/monitor_diagnosis/diag.en.md).

4. Contact our [Technical Support](https://support.kyligence.io/), open a ticket and upload the diagnosis package to get help.

   Learn more about how to [get technical support](../operation/monitor_diagnosis/get_support.en.md).



### Dealing with Query Performance Issues

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
