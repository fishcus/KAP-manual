## Kyligence Enterprise Guardian Process

Since Kyligence Enterprise 3.4.5.x, the system added a function of a daemon process for monitoring the health state of Kyligence Enterprise. This function is called Kyligence Guardian Process, hereafter referred to as 'KG'. If the KG process detects Kyligence Enterprise is in an unhealthy state, it will restart Kyligence Enterprise server.

### Usage

#### Turn On
KG is disabled by default. If you want to enable it, you need to add the configuration `kap.guardian.enabled = true` in the global configuration file `KYLIN_HOME/conf/kylin.properties`.
> **Note**: All the following configurations take effect if `kap.guardian.enabled = true`

If KG is enabled, a daemon process will be automatically started after starting Kyligence Enterprise. This process is bound to KYLIN_HOME, which means each Kyligence Enterprise instance has only one KG process corresponding to it.

KG process description:
 - The process ID is recorded in `KYLIN_HOME/kgid`.
 
 - The log of the process is output in `KYLIN_HOME/logs/guardian.log`.
 
 - The JVM configuration of the process can be set in `KYLIN_HOME/conf/setenv-tool.sh` by the configuration item` KE_GUARDIAN_PROCESS_OPTS`.

 - KG will periodically check the health status of Kyligence Enterprise. The time delay of the first check is configured by the parameter `kap.guardian.check-init-delay`, the default is 5 minutes, and the check interval is set by the parameter `kap.guardian.check-interval`, the default is 1 minute.


#### Check Items
KG currently checks the following 4 aspects of Kyligence Enterprise instance's health.

- Kyligence Enterprise process status

  If the process number file `KYLIN_HOME/pid` exists and the corresponding process does not exist, it means Kyligence Enterprise server is in an abnormal down state, and KG will restart it.
  
- Spark Context restart failure check
  
  If the number of Spark context restart failure times are greater than or equals to the value of configuration `kap.guardian.restart-spark-fail-threshold` which is 3 times by default, KG will restart Kyligence Enterprise. This function is enabled by default. If you want to disable it, you can add the configuration `kap.guardian.restart-spark-fail-restart-enabled=false` in `KYLIN_HOME/conf/kylin.properties`.
  
- Bad Query canceled failed check
  
  If KG detects the number of Bad Query cancellation times are greater than or equals to the value of configuration `kap.guardian.kill-bad-query-fail-threshold` which is 3 times by default, KG will restart Kyligence Enterprise. This feature is enabled by default. If you want to disable it, you can add the configuration `kap.guardian.kill-bad-query-fail-restart-enabled=false` in `KYLIN_HOME/conf/kylin.properties`.
  
- Full GC duration check
  
  If the Full GC duration ratio in most recent period (default is values of `kap.guardian.full-gc-check-factor` * value of `kap.guardian.check-interval`) is greater than or equals to the value of configuration `kap.guardian.full-gc-duration-ratio-threshold` which is 60% by default, KG will restart Kyligence Enterprise. This feature is disabled by default. If you want to enable it, you can add the configuration `kap.guardian.full-gc-duration-ratio-restart-enabled=true` in `KYLIN_HOME/conf/kylin.properties`.
   

#### KG Highly Available
To ensure the high availability of KG, Kyligence Enterprise will also periodically check the status of KG. If theff Kyligence Enterprise detects the KG process does not exist, it will automatically start KG. This feature is enabled by default. If you want to disable it, you can add the configuration `kap.guardian.ha-enabled=false` in `KYLIN_HOME/conf/kylin.properties`. The time delay of the first check is configured by the parameter `kap.guardian.ha-check-init-delay` which is 5 minutes by default, and the check interval is set by the parameter `kap.guardian.ha-check-interval` which is 1 minute by default.


#### Kyligence Enterprise OOM restarts automatically
KG supports restarting kyligence enterprise when the JVM of Kyligence Enterprise appears oom. This function is disabled by default. If you want to enable it, you can add the configuration `kap.server.kill-when-oom=true` in `KYLIN_HOME/conf/kylin.properties`.