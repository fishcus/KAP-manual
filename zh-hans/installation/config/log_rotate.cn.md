## 日志滚动配置

Kyligence Enterprise 的日志目录 `$KYLIN_HOME/log/` 下面的 `shell.stderr`、 `shell.stdout`、 `kylin.out`三个日志文件，默认情况下仅在 Kyligence Enterprise 启动时会触发日志滚动检查。若 Kyligence Enterprise 长时间运行，则可能存在日志文件过大的情况。在实际的生产环境中需要更灵活的滚动策略来对日志进行控制。

> **注意**：所有下述配置需要重启后方能生效。

| 配置项                                   | 描述                             | 默认值         | 可选值    |
| -----------------------------------------| --------------------------------| -------------- | ---------|
| kap.env.max-keep-log-file-number         | 日志滚动保留的最大文件数量        | 10             |          |
| kap.env.max-keep-log-file-threshold-mb   | 触发日志滚动的文件大小            | 256，单位为MB   |          |
| kap.env.log-rotate-check-cron            | 日志滚动检查的`crontab`时间设置     | 33 \* \* \* \*     |          |
| kap.env.log-rotate-check-cron            | 日志滚动检查的`crontab`时间设置     | * 33 * * *     |          |
| kap.env.log-rotate-enabled               | 是否启用`crontab`检查日志滚动       | false          | true     |

### 使用默认滚动策略

使用默认滚动策略需要设置参数 `kap.env.log-rotate-enabled=false`, 此时 Kyligence Enterprise 将忽略 `kap.env.log-rotate-check-cron` 参数。每次执行`kylin.sh start`命令时，根据参数`kap.env.max-keep-log-file-number` 和 `kap.env.max-keep-log-file-threshold-mb` 来进行日志滚动。 

### 使用定时滚动策略

使用定时滚动策略需要设置参数 `kap.env.log-rotate-enabled=true`, 同时也需要确保运行KE的用户可以使用 `logrotate` 和 `crontab`命令。若上述条件不满足，Kyligence Enterprise会使用默认滚动策略。

使用定时滚动策略时，Kyligence Enterprise会在启动或重启时根据`kap.env.log-rotate-check-cron`参数添加或更新`crontab`任务，会在退出时移除添加的`crontab`任务。

### 已知限制

使用`crontab`控制日志滚动时，滚动操作由`logrotate`命令实现，若日志文件过大，则在滚动期间可能会发生日志的丢失。
