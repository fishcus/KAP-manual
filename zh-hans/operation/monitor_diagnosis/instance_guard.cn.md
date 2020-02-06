## 进程守护脚本

为了保障Kyligence Enterprise实例持续可用，我们提供了一个脚本来守护Kyligence Enterprise进程。

该脚本可以单独使用：

```bash
sh ${KYLIN_HOME}/bin/ke-instance-guard.sh ${KYLIN_HOME_TO_GUARD}
```

但我们推荐您配合crontab进行使用，使用方法如下：

在Kyligence Enterprise所在的节点上运行`cron -e`，编辑cron脚本，复制如下内容并保存。
```bash
*/2 * * * * sh ${KYLIN_HOME}/bin/ke-instance-guard.sh ${KYLIN_HOME_TO_GUARD} >> ${KYLIN_HOME}/logs/guard.log 2>&1
```
该cron脚本的含义为：每隔2分钟检查一下${KYLIN_HOME_TO_GUARD}的状态，如果对应的Kyligence Enterprise进程不是被人为(通过调用`${KYLIN_HOME}/bin/kylin.sh stop`)停止的，则会运行`${KYLIN_HOME_TO_GUARD}/bin/kylin.sh start`来启动相应的Kyligence Enterprise实例。
相应的日志信息记录在`${KYLIN_HOME}/logs/guard.log`中。

注意：
> 为了防止变量被污染(无论单独使用还是配合crontab使用时)，${KYLIN_HOME}和${KYLIN_HOME_TO_GUARD}必须为Kyligence Enterprise所在目录的**绝对路径**。


