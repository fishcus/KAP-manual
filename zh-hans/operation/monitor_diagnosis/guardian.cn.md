## Kyligence Enterprise 守护进程

为了保持 Kyligence Enterprise 始终健康活跃，从 Kyligence Enterprise 3.4.5.x 开始，系统增加了守护进程的功能，这个守护进程会监控 Kyligence Enterprise 是否处于健康状态，如果检测到 Kyligence Enterprise 处于不健康状态，则会执行重启操作。这个功能叫做 Kyligence Guardian Process，以下简称 KG。

### 使用说明

#### 开启
KG 这个功能默认是关闭的，如果要开启它，需要在全局配置文件`KYLIN_HOME/conf/kylin.properties`中，增加配置`kap.guardian.enabled=true`。
> **注意**：以下的所有配置生效的前提是 `kap.guardian.enabled=true`

如果开启了 KG，则在启动 Kyligence Enterprise 后会自动启动一个守护进程，这个进程是和 KYLIN_HOME 绑定的，也就是说每个 Kyligence Enterprise 实例有且只有一个 KG 进程与之对应。

KG 进程说明：
 - 进程号会被记录在`KYLIN_HOME/kgid`这个文件中。
 
 - 进程的日志输出在`KYLIN_HOME/logs/guardian.log`这个文件中。
 
 - 进程的 JVM 配置可以在`KYLIN_HOME/conf/setenv-tool.sh`中，由`KE_GUARDIAN_PROCESS_OPTS`这个配置项设置。

 - KG 会定时去检查 Kyligence Enterprise 的健康状态，第一次检查的时间延迟是由参数`kap.guardian.check-init-delay` 配置，默认为 5 分钟，然后检查的时间间隔是由参数`kap.guardian.check-interval`配置，默认是 1 分钟检查一次。
   > **注意**：如果您的 Kyligence Enterprise 实例启动时间超过 5 分钟的话，请调大配置 `kap.guardian.check-init-delay` 以避免 Kyligence Enterprise 不必要的重启行为。

#### 检查项
KG 目前会去检查 Kyligence Enterprise 4 个方面的健康状况。

- Kyligence Enterprise 进程状态

  KG 通过 Kyligence Enterprise 的进程号判断它是否处于健康状态，如果进程号文件`KYLIN_HOME/pid`存在，而对应的进程不存在，说明此时 Kyligence Enterprise 处于异常宕机状态，则 KG 会去重新启动它。
  
- Spark Context 重启失败检查

  用于查询的 Spark Context 如果重启失败次数 >= 阀值，则 KG 会去重启 Kyligence Enterprise。这个功能默认打开，如果要关闭它，可以在`KYLIN_HOME/conf/kylin.properties`中，增加配置`kap.guardian.restart-spark-fail-restart-enabled=false`，失败次数阀值由参数`kap.guardian.restart-spark-fail-threshold`配置，默认值为 3。
  
- Bad Query 被取消失败检查

  由于某些原因，Bad Query 可能杀不死，如果一直杀不死的话，可能会长期占用资源，如果 KG 检查到有 Bad Query 被取消次数 >= 阀值，则 KG 会去重启 Kyligence Enterprise。这个功能默认打开，如果要关闭它，可以在`KYLIN_HOME/conf/kylin.properties`中，增加配置`kap.guardian.kill-bad-query-fail-restart-enabled=false`，取消次数阀值由参数`kap.guardian.kill-bad-query-fail-threshold`配置，默认值为 3。
  
- Full GC 时长占比检查
  
  KG 检测 Kyligence Enterprise 的 JVM 在最近一段时间内(`kap.guardian.full-gc-check-factor * kap.guardian.check-interval`)Full GC 时长占比，如果占比超过参数`kap.guardian.full-gc-duration-ratio-threshold`配置的阀值(默认60%)，则 KG 会去重启 Kyligence Enterprise，这个功能默认关闭，如果想要打开它，可以在`KYLIN_HOME/conf/kylin.properties`中，增加配置`kap.guardian.full-gc-duration-ratio-restart-enabled=true`.


#### KG 高可用
为了保证 KG 的高可用，Kyligence Enterprise 也会周期性的去检查 KG 的状态，如果发现 KG 进程不存在了，则自动把它启动起来。这个功能默认打开，如果想要关闭它，可以在`KYLIN_HOME/conf/kylin.properties`中，增加配置`kap.guardian.ha-enabled=false`。第一次检查的时间延迟是由参数`kap.guardian.ha-check-init-delay`配置，默认为 5 分钟，然后检查的时间间隔是由参数`kap.guardian.ha-check-interval`配置，默认是 1 分钟检查一次。


#### Kyligence Enterprise OOM 自动重启
KG 支持在 Kyligence Enterprise 的 JVM 出现 OOM 时重启 Kyligence Enterprise，这个功能默认关闭，如果想要打开它，可以在`KYLIN_HOME/conf/kylin.properties`中，增加配置`kap.server.kill-when-oom=true`.                                                                                            