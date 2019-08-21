## Service Discovery and Job Engine HA

### Service Discovery

Kyligence Enterprise supports service discovery from 2.0. Multiple Kyligence Enterprise instances can work together as a cluster. When a Kyligence Enterprise instance is started, stopped or lost, other instances in the cluster will notice and then update automatically. 

Kyligence Enterprise uses Zookeeper for cluster management. If you are not using HBase as metastore, please additionally configure zookeeper address in `$KYLIN_HOME/conf/kylin.properties`:

```properties
kylin.env.zookeeper-connect-string=host1:2181,host2:2181,host3:2181
```
> **Note**: You can confirm your metastore by the command below, checking if the metadata URL ends with `@hbase`.
>
> ```shell
> $KYLIN_HOME/bin/get-properties.sh kylin.metadata.url
> ```

After the configuration, restart Kyligence Enterprise. Each Kyligence Enterprise instance will register itself in Zookeeper, instances having the same metadata URL will discover each other and form a Kyligence Enterprise cluster automatically.

By default, Kyligence Enterprise will use hostname as the node name and the HTTP port in `$KYLIN_HOME/tomcat/conf/server.xml` as the service port, such as `slave1:7070`. If the cluster that you run Kyligence Enterprise can't parse the host name to IP address through DNS and other services, you should display the REST address of the specified Kyligence Enterprise before you start Kyligence Enterprise. This can avoid communication errors between Kyligence Enterprise servers. For example:

```shell
export KYLIN_REST_ADDRESS=10.0.0.100:7070
$KYLIN_HOME/bin/kylin.sh start
```

### Multi-Active Job Engines

Kyligence job engine executes cube building tasks and notifies user and update cube status when jobs finished. One or more nodes can be specified as job engine in the cluster. 

To set a node as job engine, please configure `$KYLIN_HOME/conf/kylin.properties`:

```properties
kylin.server.mode=job
```

> **Tips**: When resource is limited, you can set `kylin.server.mode=all` to let a node as job engine and query engine at the same time. However this is not recommended for production environment.

Since Kyligence Enterprise 3.4.0, Kyligence Enterprise works "Multi-Active" mode, which meanings every healthy job engine can execute cube building tasks. When one job engine is stopped, the other job engines will take over
the running task on it. That will ensure the high availability of Kyligence Enterprise services and improve the concurrency building capabilities.

> **Note**：
>
> 1. The distribution of jobs among multiple job nodes are done by consistent hash algorithm. The distribution is mostly uniform but not completely.
> 2. The task scheduling is mostly FIFO, however not strict FIFO globally. Once a task is assigned to a node, it is FIFO in the job queue managed by that job node.

If you don't expect job engine be executed on some Kyligence Enterprise instances, just configure in `$KYLIN_HOME/conf/kylin.properties`as below to make the instance run as *query* node:

```properties
kylin.server.mode=query
```

Each of the Kyligence Enterprise nodes can accept the cube build requests, and all requests are first appended to a global waiting queue, waiting for job node to pick up and process.


