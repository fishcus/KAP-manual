## Build Cube

After cube is created, data has to be built into this cube to serve queries. We will use Kyligence Enterprise sample data to show the process of cube building.

Same as the definition in data model, data can be loaded into cube via following ways:

- full build
- incremental build by date/time
- incremental build by file
- customized build
- streaming build



### FAQ

**Q: Is there concurrency limit of cube building jobs in Kyligence Enterprise? What if submiting a new job when number of running jobs already reaches the upper limit.** 

Kyligence Enterprise has a default concurrency limit of **10** for cube building jobs. You can change parameter  `kylin.job.max-concurrent-jobs` in`kylin.properties` to modify this limit.

If there are already too many running jobs reaching the limit, the new submitted job will be added into job queue. Once one running job finishes, jobs in the queue will be scheduled using FIFO mechanism.

**Q: What if you encounter "killed by admin" error?**

This is mainly because in a sandbox environment, there're not enough resource (memory) available requested by the MR job and hence rejected by YARN. You can configure `conf/kylin_job_conf_inmem.xml`  like below.

```properties
<property>
<name>mapreduce.map.memory.mb</name>
<value>1072</value>
<description></description>
</property>
<property>
<name>mapreduce.map.java.opts</name>
<value>-Xmx800m</value>
<description></description>
</property>
```