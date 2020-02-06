## Instance Guard Script

To avoid Kyligence Enterprise exiting by accident or being killed by system calls, we provide a script to guard the Kyligence Enterprise instance.

This script can be used standalone by invoking it directly. However, we recommend you to use this script with crontab, set the time interval as 2 minutes.

#### Usage:
```bash
sh ${KYLIN_HOME}/bin/ke-instance-guard.sh ${KYLIN_HOME_TO_GUARD}
```

#### Example of Crontab:
run `crontab -e`, then copy the following content, replacing the variables to the corresponding value, then save.

```bash
*/2 * * * * sh ${KYLIN_HOME}/bin/ke-instance-guard.sh ${KYLIN_HOME_TO_GUARD} >> ${KYLIN_HOME}/logs/guard.log 2>&1
```

The cron script above will check the status of Kyligence Enterprise instance every 2 minutes, 
if Kyligence Enterprise wasn't stopped manually (by invoking `${KYLIN_HOME}/bin/kylin.sh stop`), then `${KYLIN_HOME_TO_GUARD}/bin/kylin.sh start` will be invoked to start the Kyligence Enterprise instance.
The log path is `${KYLIN_HOME}/logs/guard.log`.

> Please note that ${KYLIN_HOME} and ${KYLIN_HOME_TO_GUARD} should be an absolute path.