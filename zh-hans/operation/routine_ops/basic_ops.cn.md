## 基本运维

作为 Kyligence Enterprise 的运维人员，有以下基本运维职责和工作：
* 确保 Kyligence Enterprise 服务运行正常
* 确保 Cube 构建任务正常
* 确保 Kyligence Enterprise 使用集群资源正常
* 灾难备份和恢复
* ……


为了保障 Kyligence Enterprise 服务的正常运行，运维人员可以对 Kyligence Enterprise 的日志进行监控，确保进程的稳定运行。
为了确保 Cube 构建任务的正常，运维人员可以使用**邮件通知**或 **Web UI 的监控页面**对任务进行监控。
为了确保 Kyligence Enterprise 对集群资源的正常使用，运维人员需要经常查看 YARN 上 MapReduce 任务队列的闲忙程度，以及 HBase 存储的利用率（如 HTable 数量、Region 数量等）。