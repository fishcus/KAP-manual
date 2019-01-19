## 构建 Cube

在创建好模型与 Cube 之后，需要对 Cube 进行构建，向 Cube 中成功加载数据后，才能利用它执行 SQL 查询。本章以本产品自带样例数据为例，介绍 Cube 的各种构建方式和过程。

与模型定义一致，本产品共提供了以下几种 Cube 构建方式：
- 全量构建
- 按日期/时间增量构建
- 按文件增量构建
- 流式构建
- 自定义增量构建

### 常见问题

**问：Kyligence Enterprise 有没有构建任务并发数限制？如果提交构建任务时，超出了系统允许的并发数怎么办？**

Kyligence Enterprise 有构建任务并发数限制，默认为**10**，可以通过修改系统配置文件`kylin.properties`中的参数`kylin.job.max-concurrent-jobs` 来更改。

提交新构建任务时，如果超出了系统允许的任务并发数限制，那么该提交的构建任务会进入任务队列。当有运行的任务完成时， Kyligence Enterprise 会以先进先出 (FIFO) 的方式调度队列中的任务执行。

**问：在构建Cube时，如果遇到 "killed by admin" 错误。**

这个问题主要是由于使用 Sandbox 时，MR 任务请求的内存过多，从而被 YARN 拒绝导致的。您可以通过修改 `conf/kylin_job_conf_inmem.xml`配置，调低请求的内存大小来解决这个问题。

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