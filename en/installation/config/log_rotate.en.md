## Log Rotate Configuration

Some log files under `$KYLIN_HOME/log/`, including `shell.stderr`, `shell.stdout` and `kylin.out`, only can be related when Kyligence Enterprise is starting. If Kyligence Enterprise is running for a long time, the log file may be too large. In production environment, a more flexible log rotate strategy is needed.

> **Caution:** Any change of configurations below requires a restart to take effect. 

| Properties                               | Descript                        | Default        | Options   |
| -----------------------------------------| --------------------------------| -------------- | ---------|
| kap.env.max-keep-log-file-number         | Log files are rotated count times before being removed | 10             |          |
| kap.env.max-keep-log-file-threshold-mb   | Log files are rotated when they grow bigger than this  | 256，whose unit is MB   |          |
| kap.env.log-rotate-check-cron            | The `crontab` time configuration                         | * 33 * * *     |          |
| kap.env.log-rotate-enabled               | Whether to use scheduled rotate strategy               | false          | true     |

### Use Default Rotate Strategy 

To use default rotate strategy, the property `kap.env.log-rotate-enabled=false` needs to be setted. Then property `kap.env.log-rotate-check-cron` will be ignored by Kyligence Enterprise. Each time when command `kylin.sh start` is callled, Kyligence Enterprise will try to rotate log files with propeties `kap.env.max-keep-log-file-number` and `kap.env.max-keep-log-file-threshold-mb`.

### Use Scheduled Rotate Strategy

To use scheduled rotate strategy, the property `kap.env.log-rotate-enabled=true` needs to be setted. At the same time, the user, who is running Kyligence Enterprise must be allowed to use commands `logrotate` and `crontab`. If not, the default rotate strategy will be used.

Under scheduled rotate strategy, Kyligence Enterprise will creat or upgrade crontab task with peoperty `kap.env.log-rotate-check-cron` when `kylin.sh start` or `kylin.sh restart` is called, and will remove the crontab task added by Kyligence Enterprise when `kylin.sh stop` is called.

### Limitation

Under scheduled rotate strategy, `logrotate` tool is used for log rotate. If a log file is too large, log loss may occur during rotate.
