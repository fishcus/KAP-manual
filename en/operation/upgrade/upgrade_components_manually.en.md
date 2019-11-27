## Manually upgrade built-in components

The Kyligence Enterprise installation package comes with the components Spark and Tomcat. When upgrading, the newer version of the installation package may carry a higher version of Spark or Tomcat, and their configuration files are not compatible with the old version. As a result, the upgrade script cannot automatically complete the upgrade of the built-in components. It needs to be upgraded manually.

### Manually upgrade Spark

- In general, the upgrade script `upgrade.sh` has completed the upgrade of the Spark components except the configuration file. You only need to upgrade` $ KYLIN_HOME/spark/conf`. You can modify the configuration in the old version and reconfigure to the new version as needed. If the Spark configuration has not been modified in the old version, you can use the new version default configuration.
- If you have integrated Kyligence Enterprise with Kerberos, please refer to [Integrate with Kerberos](../../security/kerberos.en.md) for related operations.

### Manually upgrade Tomcat
- In general, the upgrade script `upgrade.sh` has completed the upgrade of the Tomcat components except the configuration file. You only need to upgrade` $ KYLIN_HOME/tomcat/conf`. You can modify the configuration in the old version and reconfigure to the new version as needed. If the Tomcat configuration has not been modified in the old version, you can use the new version default configuration.
- If you have performed configuration related to cluster deployment and load balancing, please refer to [Cluster Deployment and Load Balancing](../../installation/deploy/cluster_lb.en.md) for operations.