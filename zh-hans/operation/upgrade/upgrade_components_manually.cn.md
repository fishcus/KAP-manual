## 手动升级内置组件

Kyligence Enterprise 安装包中内置组件 Spark 和 Tomcat 。升级时，新版本安装包中可能携带了更高版本的 Spark 或 Tomcat，且它们的配置文件与旧版本并不兼容，使升级脚本不能自动完成组件的升级，需用户单独手动升级。

### 手动升级 Spark

- 通常情况下，升级脚本 `upgrade.sh` 已完成了 Spark 组件除配置文件外其他部分的升级，用户只需升级 `$KYLIN_HOME/spark/conf` 即可。您可根据需要将旧版本中的配置修改，重新配置到新版本。如果旧版本中未修改过 Spark 配置，可以使用新版本默认配置。
- 如果您曾将 Kyligence Enterprise 与 Kerberos 集成，请参考 [与 Kerberos 集成](../../security/kerberos.cn.md) 章节进行相关操作。

### 手动升级 Tomcat
- 通常情况下，升级脚本 `upgrade.sh` 已完成了 Tomcat 组件除配置文件外其他部分的升级，用户只需升级 `$KYLIN_HOME/tomcat/conf` 即可。您可根据需要将旧版本中的配置修改，重新配置到新版本。如果旧版本中未修改过 Tomcat 配置，可以使用新版本默认配置。
- 如果您进行过集群部署与负载均衡相关配置，请参考 [集群部署与负载均衡](../../installation/deploy/cluster_lb.cn.md) 章节进行操作。


