## 在 HDP 集群上安装


在安装前，请确认您已阅读[**安装前置条件**](../installation_conditions.cn.md)。

为使您可以尽快体验到 Kyligence Enterprise 的强大功能，我们推荐您将 Kyligence Enterprise 与 All-in-one Sandbox VM 等沙箱软件一起配合使用。在本节中，我们将引导您在 HDP 沙箱中快速安装 Kyligence Enterprise。

### 准备运行环境

首先**请确保您为沙箱分配了充足的资源**，Kyligence Enterprise 对沙箱的资源要求请参阅[安装前置条件](../installation_conditions.cn.md)。

在配置沙箱时，我们推荐您使用 Bridged Adapter 模型替代 NAT 模型。Bridged Adapter 模型将为您的沙箱分配一个独立的 IP 地址，使您可以任意选择通过本地或远程访问 Kyligence Enterprise GUI。

为了避免权限问题，我们推荐您使用 HDP 的 `root` 账户访问 HDP 沙箱。HDP 2.2 的默认密码是`hadoop`， HDP 2.3+ 请您参考[Hortonworks文档](http://zh.hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)了解关于账号和密码的详细信息。本节中均以`root`账户为例。

如果您需要在 HDP 2.2 的环境下运行 Kyligence Enterprise，请选择 HBase 0.98 对应的发行版；如果您需要在 HDP2.3+ 的环境下运行 Kyligence Enterprise，请选择 HBase 1.x 对应的发行版。

请运行下述命令以启动 Ambari：

```shell
ambari-agent start
ambari-server start
```

请您访问 Ambari 管理页面（默认地址：`http://<host_name>:8080/`，默认账户和密码：`admin`）。由于 HBase 不在默认的启动项中，需要您手动启动 HBase，如果所示：

 ![](quick_installation_images/quick_installation_for_hdp_hbase.png)

启动成功后，请确保`HDFS`、`Yarn`、`Hive`、`HBase`、`Zookeeper`等组件处于正常状态并且没有任何警告信息，如图所示：

![](quick_installation_images/quick_installation_for_hdp.jpg)

> 如果您在安装 Kyligence Enterprise 的过程中遇到如下信息：
>
> ```java
> org.apache.hadoop.hbase.security.AccessDeniedException: Insufficient permissions for user 'root (auth:SIMPLE)'
> ```
>
> 则表明您缺少HBase写入权限。如果您需要关闭 HBase 的权限检查，请将`hbase.coprocessor.region.classes`和`hbase.coprocessor.master.classes`配置项的值设为`empty`，将`hbase.security.authentication`配置项的值设为`simple`。

### 快速安装 Kyligence Enterprise

准备好了环境之后，安装 Kyligence Enterprise 十分简单。

详细步骤请看[在单节点上快速安装 Kyligence Enterprise](quick_installation_for_single_node.cn.md)。