## 基本运维

Kyligence Enterprise 服务器每天会接受不同用户提交的多个 Cube 构建任务，因为 Cube 设计不当或集群环境异常等原因，导致 Kyligence Enterprise Cube 构建失败或时间过长，需要运维人员提高警惕；此外，Kyligence Enterprise 服务运行一段时间之后，一些存在于 HBase 或 HDFS 上的数据会成为无用数据，需要定时对存储器进行垃圾清理。

## 运维任务

作为 Kyligence Enterprise 的运维人员，工作中需要明确：
* 确保 Kyligence Enterprise 服务运行正常
* 确保 Kyligence Enterprise 对集群资源的利用正常
* 确保 Cube 构建任务正常
* 灾难备份和恢复
* ……

以上列出了一些 Kyligence Enterprise 的基本运维职责和工作，常言道“工欲善其事，必先利其器”。运维人员需要熟练地运用本章提到的各种工具，一方面对 Kyligence Enterprise 服务的每日运行状况进行监控，另一方面在遇到问题时能够找到合理的解决途径。

为了保障 Kyligence Enterprise 服务的正常运行，运维人员可以对 Kyligence Enterprise 的日志进行监控，确保 Kyligence Enterprise 进程的稳定运行。为了确保 Kyligence Enterprise 对集群资源的正常利用，运维人员需要经常查看 YARN 上 MapReduce 任务队列的闲忙程度，以及 HBase 存储的利用率（如 HTable 数量、Region 数量等）。为了确保 Cube 构建任务的正常，也可以使用邮件通知或 Web UI 的监控页面对任务进行监控。