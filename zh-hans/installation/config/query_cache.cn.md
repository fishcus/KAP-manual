## 查询缓存配置

为了提升执行相同查询的效率，Kyligence Enterprise 系统自带查询缓存并默认开启，同时也支持使用外部 Redis 集群作为分布式查询缓存，更好的提升在集群部署环境下的查询效率。

### 使用系统默认缓存

Kyligence Enterprise 系统自带查询缓存并默认开启，具体的缓存配置参数如下。您可以在 Kyligence Enterprise 安装目录下的 `$KYLIN_HOME/conf/kylin.properties` 中进行修改。

> **注意**：所有下述配置需要重启后方能生效。

| 配置项                                          | 描述                                             | 默认值         | 可选值    |
| ----------------------------------------------- | ------------------------------------------------ | -------------- | --------- |
| kylin.query.cache-enabled                       | 是否开启查询缓存，当该参数开启，下述参数才生效。 | true           | false     |
| kylin.query.pushdown.cache-enabled              | 进行下压查询时，是否开启缓存                     | true           | false     |
| kylin.cache.ehcache.max-mb-local-heap           | 查询缓存使用堆大小                               | 1024，单位为MB |           |
| kylin.cache.ehcache.max-entries-local-heap      | 查询缓存堆内对象数量                             | 0，即不限制    |           |
| kylin.cache.ehcache.memory-store-eviction-polcy | 查询缓存内存策略                                 | LRU            | FIFO，LFU |

### 使用 Redis 集群进行分布式缓存 (Beta)

由于 Kyligence Enteprise 自带的查询缓存是进程级的，在不同进程或不同节点之间并不共享，因此在集群部署模式下，当后续相同查询路由至不同 Kyligence Enterprise 节点时，第一次查询执行结果的缓存由于在另一个进程中而无法生效。因此，我们支持使用 Redis 集群作为分布式查询缓存，在所有 Kyligence Enterprise 节点间共享。具体的参数和配置方法如下：

| 配置项                             | 描述                                                         | 默认值         | 可选值 |
| ---------------------------------- | ------------------------------------------------------------ | -------------- | ------ |
| kylin.query.cache-enabled          | 是否开启查询缓存，当该参数开启，下述参数才生效。             | true           | false  |
| kylin.cache.redis.enabled          | 是否开启 Redis 集群用于查询缓存                              | false          | true   |
| kylin.cache.redis.cluster-enabled  | 是否开启 Redis 集群模式                                      | false          | true   |
| kylin.cache.redis.hosts             | Redis 主机地址，当您需要连接 Redis 集群时，请使用逗号进行分割。如 kylin.cache.redis.hosts=localhost:6379,localhost:6380 | localhost:6379 |        |
| kylin.cache.redis.expire-time-unit | Redis 缓存保留单位，EX为秒，PX为毫秒                         | EX             | PX     |
| kylin.cache.redis.expire-time      | Redis 缓存保留时间                                           | 86400          |        |

###查询被缓存的条件
Kyligence Enterprise 不会默认缓存每条查询的结果，因为内存资源可能是有限的。目前 Kyligence Enterprise 会有选择性的对那些性能较慢且结果集不是特别大的查询进行缓存。一条查询是否会被缓存，由以下几个参数影响：

| 配置项                             | 描述                                                         | 默认值         | 可选值 |
| ---------------------------------- | ------------------------------------------------------------ | -------------- | ------ |
| kylin.query.cache-threshold-duration          | 查询延迟小于该值的不会被缓存 | 2000，单位毫秒.           |   |
| kylin.query.cache-threshold-scan-count          | 查询扫描的行数小于该值的不会被缓存 | 10240，单位是行           |   |
| kylin.query.cache-threshold-scan-bytes          | 查询扫描的数据量小于该值的不会被缓存 | 1048576，单位是字节           |   |
| kylin.query.large-query-threshold          | 查询结果集大于该值的不会被缓存 | 1000000，单位是行           |   |
