## 按日期/时间构建


### 初次构建

打开本产品的 Web UI，并选择 learn_kylin 项目，然后跳转到建模页面，找到 Cube 列表。在 Cube 列表中找到 **Kylin_Sales_Cube**。单击右侧的 **Action** 按钮，在弹出的菜单中选择**构建**。

![](images/buildcube_0.png)

第二步，在弹出的 Cube 构建确认对话框中确认 Cube 的时间分区列是 `DEFAULT.KYLIN_SALES.PART_DT`。在 Kyligence Enterprise 中，一次构建会为 Cube 产生一个新的 Segment，请选择需要构建进入 Cube 的数据时间区间。在这个例子中，我们输入起始和结束日期分别为2013-01-01 00:00:00和2013-01-01 00:00:00，设置完成后单击**提交**按钮。

> **注意：** 当对历史数据进行初始构建时，如果一次构建的数据量过大，可能导致构建时间过长，或出现内存溢出等异常，请务必根据您的数据量、模型复杂度和硬件资源来调整合理的时间区间，必要时可以分批构建。

![](images/buildcube_1.png)

当任务成功提交之后，切换到**监控**页面，这里会列出所有的任务列表。我们找到列表最上面的一个任务（名称是：**Kylin_sales_cube** - 20120101000000_20130101000000），这就是我们刚刚提交的任务。在这一行单击或点击左侧的箭头图标，页面右侧会显示当前任务的详细信息。
待构建任务完成，可以在**监控**页面看到该任务状态已被置为**Finished（完成）**。前往 Cube 列表中查看，会发现该 Cube 的状态已被置为**Ready（就绪）**了。

![](images/buildcube_2.png)



### 增量构建

在初始构建完成之后，我们可以开始构建第二个 Segment，从而实现不断地向 Cube 中增量构建新的数据，但需要保证 Segment 之间的时间区间不能有重叠。

在建模页面的 Cube 列表中找到该 Cube，单击右侧的 **Action** 按钮，然后选择**构建**，打开 Cube 构建确认对话框。在这个对话框中，首先确认起始时间（Start Date）是2013-01-01 00:00:00，因为这是上次构建的结束日期，为保障所构建数据的连续性，Kyligence Enterprise 自动将新一次构建的起始时间更新为上次构建的结束日期。同样的，在结束时间（End Date）里输入2014-01-01 00:00:00，然后单击提交按钮，开始构建下一年的 Segment。

> **提示**： 通常情况下，按日期/时间的增量构建以周或天为单位，请根据您的数据更新频率和业务需求，合理设置增量构建的时间周期。

待构建完成，我们可以在 Cube 的 Segment 界面中查看，发现 Cube 的两个 Segment 都已就绪。

![](images/buildcube_3.png)



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

