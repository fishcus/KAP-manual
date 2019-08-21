## 服务发现及任务引擎高可用

### 服务发现
Kyligence Enterprise 从 2.0 版本开始支持服务发现，即在多个 Kyligence Enterprise 实例组成的集群中，当一个 Kyligence Enterprise 实例启动、停止或意外中断通讯时，集群中的其他实例能够自动发现并更新状态。

Kyligence Enterprise 使用 Zookeeper 管理集群。如果您并非使用 HBase 作为 元数据库，那么您应当在 `$KYLIN_HOME/conf/kylin.properties` 文件中配置 Zookeeper 的地址，例如：

```properties
kylin.env.zookeeper-connect-string=host1:2181,host2:2181,host3:2181
```
> **提示**：您可以运行下述命令观察结果是否以 `@hbase` 结尾，以判断使用的元数据库是否为 HBase：
>
> ```shell
> $KYLIN_HOME/bin/get-properties.sh kylin.metadata.url
> ```

配置完成后，请重新启动 Kyligence Enterprise。在重新启动时，每个 Kyligence Enterprise 实例会在 Zookeeper 上进行注册，配置了相同元数据库的 Kyligence Enterprise 实例将会自动发现彼此，并自动组成集群。

Kyligence Enterprise 在 Zookeeper 上进行注册时，默认使用 hostname 作为节点名，使用`$KYLIN_HOME/tomcat/conf/server.xml`文件中配置的 HTTP 端口作为服务端口，如`slave1:7070`。如果您运行 Kyligence Enterprise 的集群无法通过 DNS 等服务自动将主机名解析为对应的 IP 地址，您应当在启动 Kyligence Enterprise 之前显示指定 Kyligence Enterprise 的 REST 地址，以避免 Kyligence Enterprise 实例之间通信错误，例如：

```shell
export KYLIN_REST_ADDRESS=10.0.0.100:7070
$KYLIN_HOME/bin/kylin.sh start
```

### 任务引擎多活

Kyligence Enterprise 任务引擎负责调度和执行 Cube 构建任务，并在构建任务完成时通知用户并更新 Cube 状态。通常由用户所指定的集群中的一个或多个节点担当此角色。

要指定一个节点为任务引擎，请在 `$KYLIN_HOME/conf/kylin.properties` 中设置：

```properties
kylin.server.mode=job
```

> **提示**：在资源不足时，也可以设置 `kylin.server.mode=all` 让一个节点同时扮演构建引擎和查询引擎。但对于生产环境，我们不推荐这样做。

在 Kyligence Enterprise 3.4.0 及之后的版本中，多个任务节点以"多活"模式工作，即每个处于健康状态的任务构建节点都有执行构建任务的能力。如果某个充当任务引擎的实例发生故障退出，集群中的其他的任务引擎节点会接管发生故障节点上面运行的任务并继续运行。

这种部署模式在保证高可用的同时，增加了任务构建并发量，去掉了单个任务构建节点的瓶颈。

> **注意**：
>
> 1. 在多活模式下，对每个任务进行任务节点分配采用一致性 Hash 算法，不能保证任务分配完全均匀，只能保证基本均匀。
> 2. 任务的调度不能保证全局的 FIFO，只能保证在每个任务构建节点内的任务调度的 FIFO。

如果您不希望某些 Kyligence Enterprise 实例充当任务引擎，那么只需要在`$KYLIN_HOME/conf/kylin.properties`配置文件中进行下述配置，使该实例仅充当查询引擎即可：

```properties
kylin.server.mode=query
```

每一个 Kyligence Enterprise 节点都可以接收用户的 Cube 构建请求，请求会被首先放入系统统一的构建排队队列中，等待被构建节点发现并开始真正的构建。


